# Team Brief: Backend Team

**Feature**: Prompt-Centric Gen AI Playground UI (002-playground-prompt-ui)  
**Your Role**: **API Support** (No Changes Required)  
**Timeline**: 6 weeks from kickoff  
**Date**: January 7, 2026

---

## Your Responsibilities

**Good News**: **No backend changes required** for this feature.

Your role is **support only**: ensure existing APIs remain stable and available, assist with troubleshooting if issues arise.

**Key Deliverables**:
- ✅ Maintain existing `/api/model/inference` endpoint availability
- ✅ Maintain existing `/api/models` endpoint availability
- ✅ Respond to troubleshooting requests if Frontend encounters issues
- ✅ Communicate any planned maintenance or changes that could impact Playground

---

## What Frontend Will Do

Dashboard team will integrate with your **existing APIs only**:

### Model Inference API
```
POST /api/model/inference
Body: {
  model: string,
  messages: [{role, content}],  // Full conversation history
  parameters: {temperature, top_p, max_tokens, repetition_penalty}
}
```

**Frontend Behavior**:
- Will send **full conversation history** (never truncated)
- Will switch models mid-conversation (same request format, different model ID)
- Expects **context window handling** from your side (truncate or error if too large)

### Model Listing API
```
GET /api/models
Response: { models: [...] }
```

**Frontend Behavior**:
- Called once on page load
- Caches response for session duration

**Full Contract Details**: See [contracts/existing-apis.md](../../contracts/existing-apis.md)

---

## What We Need From You

### 1. API Stability
- Keep existing endpoints available during feature development (Weeks 1-6)
- No breaking changes to request/response formats
- Maintain current performance SLAs (P95 <10s for inference)

### 2. Context Window Handling
When conversation history exceeds model context window:
- **Option A**: Truncate oldest messages (preferred)
- **Option B**: Return error with clear message: "Conversation exceeds context limit"

**Current Behavior**: [Please confirm which option your API implements]

### 3. Error Message Quality
Ensure error responses include:
- `code`: Machine-readable error code (e.g., "rate_limit")
- `message`: Human-readable description
- `actionable`: Suggested user action (e.g., "Wait 60 seconds and try again")

**Current Behavior**: [Please confirm error format matches contract]

### 4. Rate Limiting Communication
When 429 responses occur:
- Include `Retry-After` header (seconds to wait)
- Provide clear error message

**Current Behavior**: [Please confirm rate limit handling]

---

## Dependencies From You

| What | Status | Notes |
|------|--------|-------|
| Inference API availability | ✅ Ready | Existing, stable |
| Models API availability | ✅ Ready | Existing, stable |
| Context window handling | ❓ Confirm | Truncate vs. error approach? |
| Error message format | ❓ Confirm | Matches contract? |
| Rate limit headers | ❓ Confirm | Retry-After included? |

**Action Required**: Please confirm the "❓ Confirm" items by replying to this brief or in #backend-team.

---

## Timeline

| Week | Backend Involvement |
|------|---------------------|
| 1 | **Contract Review**: Confirm APIs match frontend expectations |
| 2-4 | **Monitoring**: No action unless frontend reports issues |
| 5 | **Testing Support**: Available for troubleshooting during QA |
| 6 | **Launch Support**: Monitor API performance during rollout |

**Estimated Effort**: <2 hours total (contract review + monitoring)

---

## Risks

### Risk 1: Increased API Load (Low Likelihood)
**Scenario**: New chat interface drives higher API request volume

**Mitigation**:
- Frontend implements client-side throttling (prevent spam)
- Existing rate limiting should handle normal usage
- Monitor API metrics during beta testing

**Your Action**: Alert #crimson-dashboard if you see unusual load patterns

### Risk 2: Long Conversation Context (Medium Likelihood)
**Scenario**: Users create very long conversations that exceed context windows

**Mitigation**:
- Frontend warns users about token counts
- Backend handles gracefully (truncate or error)

**Your Action**: Confirm context window handling approach

---

## Communication

### Contact Points
- **Primary**: #backend-team Slack channel
- **Issues**: File ticket in backend repository
- **Urgent**: Page on-call if API outage impacts Playground

### Updates Needed
- Planned maintenance affecting `/api/model/inference` or `/api/models`
- API performance degradation
- Rate limit policy changes

**Notify**: #crimson-dashboard channel

---

## Success Criteria

You're successful when:
- ✅ APIs remain stable throughout feature development
- ✅ No Playground-related API outages or incidents
- ✅ Frontend team has no blocked issues due to API behavior
- ✅ Contract confirmation completed (Week 1)

---

## Resources

- [API Contracts](../../contracts/existing-apis.md) - Expected request/response formats
- [Epic Plan](../../plan.md) - Full feature context

---

## Next Steps

1. **Review [API Contracts](../../contracts/existing-apis.md)** - confirm your APIs match
2. **Respond with confirmations** for the "❓ Confirm" items above
3. **Attend kickoff meeting** (optional, Week 1) - or send confirmation via Slack
4. **Monitor** - stay available for troubleshooting during Weeks 2-6

**Questions?** Reach out in #backend-team or #crimson-dashboard.

---

**Summary**: No work required from you! Just keep APIs stable and confirm contract details. Thanks for your support! 🙏

