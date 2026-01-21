# API Contracts: Existing Backend APIs

**Feature**: Prompt-Centric Gen AI Playground UI  
**Date**: 2026-01-07  
**Status**: Using existing backend APIs - **no changes required**

---

## Contract Overview

This feature integrates with **existing backend APIs only**. No new endpoints are required, and no modifications to existing APIs are necessary. This document defines the integration contracts that frontend implementation must satisfy.

---

## Contract 1: Model Inference

### Endpoint
```
POST /api/model/inference
```

### Purpose
Submit a prompt or full conversation history to a model and receive a generated response.

### Request Contract

```json
{
  "model": "string",              // Required: Model identifier
  "messages": [                    // Required: Conversation history
    {
      "role": "user | assistant",  // Required: Message sender
      "content": "string"          // Required: Message text
    }
  ],
  "parameters": {                  // Required: Inference parameters
    "temperature": "number",       // Range: 0.0-2.0
    "top_p": "number",            // Range: 0.0-1.0
    "max_tokens": "number",       // Range: Model-specific
    "repetition_penalty": "number" // Range: 0.0-2.0
  }
}
```

**Frontend Requirements**:
- Must send **full conversation history** in messages array (not truncated)
- Must validate parameter ranges before submission
- Must include all required fields

### Response Contract (Success)

```json
{
  "id": "string",                  // Response identifier
  "model": "string",               // Model that generated response
  "content": "string",             // Generated text
  "metadata": {
    "tokens_used": "number",       // Total tokens consumed
    "processing_time_ms": "number",// Processing duration
    "model_version": "string"      // Model version identifier
  }
}
```

**Frontend Requirements**:
- Must display content to user
- Must surface metadata (tokens, time) for user visibility
- Must handle model version information

### Response Contract (Error)

```json
{
  "error": {
    "code": "string",              // Error code (e.g., "rate_limit")
    "message": "string",           // Human-readable error
    "actionable": "string"         // Suggested user action
  }
}
```

**Known Error Codes**:
- `rate_limit` - Too many requests; user should wait
- `model_unavailable` - Selected model is offline
- `invalid_request` - Request validation failed
- `context_exceeded` - Conversation exceeds model context window
- `server_error` - Backend processing error

**Frontend Requirements**:
- Must display `message` to user
- Must show `actionable` guidance
- Must provide retry mechanism where appropriate

### HTTP Status Codes

| Code | Scenario | Frontend Handling |
|------|----------|-------------------|
| 200 | Success | Display response |
| 400 | Bad Request | Show error, allow editing |
| 429 | Rate Limited | Show wait message, disable send temporarily |
| 503 | Service Unavailable | Show error, suggest alternative model |
| 500 | Server Error | Show error, provide retry option |

### Performance SLA

| Metric | Target | Notes |
|--------|--------|-------|
| P50 latency | < 2s | Most requests complete quickly |
| P95 latency | < 10s | Some models are slower |
| P99 latency | < 30s | Timeout threshold |

**Frontend Requirements**:
- Display loading state immediately
- Show "still processing" message after 5 seconds
- Timeout and show error after 30 seconds

---

## Contract 2: List Available Models

### Endpoint
```
GET /api/models
```

### Purpose
Retrieve list of models available for inference, including capabilities and default parameters.

### Query Parameters (Optional)
- `filter` - Filter by capability (e.g., `?filter=chat`)

### Response Contract

```json
{
  "models": [
    {
      "id": "string",               // Model identifier (used in inference requests)
      "name": "string",             // Display name for UI
      "description": "string",      // Model description
      "capabilities": ["string"],   // E.g., ["chat", "completion"]
      "contextWindow": "number",    // Maximum context in tokens
      "maxTokens": "number",        // Maximum output tokens
      "defaultParameters": {
        "temperature": "number",
        "top_p": "number",
        "max_tokens": "number",
        "repetition_penalty": "number"
      }
    }
  ]
}
```

**Frontend Requirements**:
- Must use `id` field for API calls (not display name)
- Must display `name` to users (not id)
- Must respect `maxTokens` limit when setting parameters
- Should use `defaultParameters` as initial parameter values
- May use `description` for tooltips or help text

### HTTP Status Codes

| Code | Scenario | Frontend Handling |
|------|----------|-------------------|
| 200 | Success | Populate model selector |
| 401 | Unauthorized | Redirect to login |
| 500 | Server Error | Show error, use cached list if available |

### Performance SLA

| Metric | Target | Notes |
|--------|--------|-------|
| P50 latency | < 50ms | Fast, cacheable response |
| P95 latency | < 200ms | |
| P99 latency | < 500ms | |

**Frontend Requirements**:
- Call once on application load (or page mount)
- Cache response for session duration
- Retry once on failure, then show error

---

## Integration Requirements

### Authentication
- **Method**: Existing Red Hat SSO / OAuth flow
- **Frontend Requirement**: API client must include auth cookies automatically
- **Error Handling**: 401 responses redirect to login page

### Authorization
- **Method**: Existing role-based access control (RBAC)
- **Frontend Requirement**: Handle 403 responses with "Access Denied" message
- **Assumption**: Users with Playground access have inference permissions

### Rate Limiting
- **Backend Limit**: ~60 requests per minute per user
- **Header**: `Retry-After` in 429 responses (seconds to wait)
- **Frontend Requirement**: Display countdown timer, disable send button until retry allowed

### CORS & Security
- **CORS**: Same-origin or properly configured CORS headers
- **CSRF**: Existing middleware handles CSRF protection
- **Input Sanitization**: Backend responsibility (no changes)

---

## Error Handling Strategy

### Temporary Errors (Retry)
- 429 Rate Limited → Wait period indicated in `Retry-After` header
- 503 Service Unavailable → Retry after 5 seconds (max 3 retries)
- 500 Server Error → User-triggered retry (no automatic retry)

### Permanent Errors (No Retry)
- 400 Bad Request → User must correct input
- 401 Unauthorized → Redirect to login
- 403 Forbidden → Show access denied message

### Degraded Experience
- Model list fails → Allow manual model ID entry (advanced users)
- Inference fails → Preserve user's message, clear retry path
- Multiple failures → Suggest checking network/cluster status

---

## Context Window Management

### Backend Responsibility
Backend is responsible for:
- Determining model-specific context window limits
- Truncating conversation history if needed
- Returning clear error if truncation not possible

### Frontend Responsibility
Frontend must:
- Send **full conversation history** (never truncate client-side)
- Display token count indicators to warn users
- Show clear error messages from backend about context limits
- Offer user options (clear conversation, switch to model with larger context)

**Rationale**: Frontend doesn't know model-specific context limits. Backend has authoritative knowledge.

---

## Streaming Support (Future)

### Current Status
Not implemented. All responses are complete (non-streaming).

### If Backend Adds Streaming
- Response `Content-Type: text/event-stream`
- Event format: `data: {"type": "token", "content": "text"}`
- Final event: `data: {"type": "done", "metadata": {...}}`

**Frontend Requirement**: Gracefully handle both streaming and non-streaming responses.

---

## Monitoring & Observability

### Frontend Metrics to Track
- Inference request success rate
- Average inference latency (P50, P95, P99)
- Error rate by error code
- Model popularity (which models users select)
- Parameter distribution (temperature, max_tokens usage)

### Backend Metrics (Provided by Backend Team)
- API availability (uptime %)
- Request rate and throughput
- Model-specific performance
- Error rates by endpoint

---

## Backward Compatibility

### API Versioning
Current APIs are unversioned. If backend introduces breaking changes:
- Must version API (e.g., `/api/v2/model/inference`)
- Must support v1 for transition period
- Must communicate deprecation timeline

### Contract Stability
- **Existing fields**: Guaranteed to remain stable
- **New fields**: May be added (frontend should ignore unknown fields)
- **Removed fields**: Requires major version bump

---

## Testing Contracts

### Contract Testing Requirements

Frontend must verify:
- ✅ Request conforms to contract schema
- ✅ Required fields are present
- ✅ Parameter ranges are validated
- ✅ Response handling works for all status codes
- ✅ Error messages are displayed appropriately

### Integration Testing

- Mock API responses for E2E tests (Cypress intercepts)
- Test happy path (200 success)
- Test error paths (400, 429, 500, 503)
- Test edge cases (empty messages, long conversations)

---

## Contact & Support

### API Questions
- **Team**: Backend API Team
- **Channel**: #backend-team Slack
- **Documentation**: [Backend API Docs Link]

### API Issues
- **Bugs**: File issue in backend repository
- **Outages**: Check #incidents channel
- **Rate Limit Increases**: Contact backend team with justification

---

## Related Documentation

- [Feature Specification](../spec.md)
- [Epic Plan](../plan.md)
- Backend API Documentation: [Link]
- Authentication Guide: [Link]

---

**Contract Status**: ✅ Existing APIs fully satisfy feature requirements - no changes needed
