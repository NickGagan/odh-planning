# Team Brief: Model Serving Team

**Feature**: Playground Multi-Pane Comparison  
**Epic**: 2 — Multi-Model API Support  
**Priority**: P1 (Critical Path — Foundational)  
**Full Plan**: [plan.md](../../plan.md)

---

## Primary Persona: Alex the AI Engineer (THE BUILDER)

> *"People always underestimate the time and effort to develop strong evaluation frameworks to ensure an application is enterprise production ready."*

**Who is Alex?** Develops and deploys AI-infused applications. Needs to rapidly compare models (Granite vs Llama vs Claude) to select the best for his use case. His evaluation work is currently manual and repetitive.

**What Alex needs from us**: Fast, concurrent model responses with clear metrics (latency, tokens, cost) so he can make informed decisions quickly.

---

## Your Mission

Provide the API infrastructure that enables **Alex** to send concurrent model requests and see streaming responses with metrics side-by-side.

**You are on the critical path** — Dashboard cannot begin integration until your API contracts are finalized.

---

## Requirements (7 Total)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| MS-001 | Model registry API | Returns available models with id, name, provider, pricing info |
| MS-002 | Streaming completion API | Supports concurrent requests from same user session |
| MS-003 | Per-request model selection | Model specified per request (not session-global) |
| MS-004 | Rate limit handling | Returns structured rate limit errors with retry-after |
| MS-005 | Token counting | Response includes input/output token counts |
| MS-006 | Latency metrics | Response includes time-to-first-token, total duration |
| MS-007 | Pricing data | Model pricing available for cost estimation |

---

## API Contract (Required Output)

### Model List Endpoint

```yaml
GET /api/v1/models

Response 200:
{
  "models": [
    {
      "id": "granite-3.0-8b",
      "name": "Granite 3.0 8B",
      "provider": "granite",
      "contextWindow": 8192,
      "maxOutputTokens": 4096,
      "pricing": {
        "inputPer1kTokens": 0.0001,
        "outputPer1kTokens": 0.0002
      },
      "status": "available",
      "capabilities": ["chat", "streaming"]
    }
  ]
}
```

### Completion Endpoint

```yaml
POST /api/v1/chat/completions

Request:
{
  "modelId": "granite-3.0-8b",
  "messages": [
    {"role": "user", "content": "Explain quantum computing"}
  ],
  "stream": true,
  "mcpServerIds": ["github-mcp"],        # Passed through to MCP
  "guardrailIds": ["safety-filter"],     # Passed through to Guardrails
  "knowledgeSourceIds": ["doc-a"]        # Passed through to RAG
}

Response (streaming):
# Each chunk:
{
  "type": "token",
  "data": "Quantum"
}

# Final chunk:
{
  "type": "complete",
  "metrics": {
    "latencyMs": 342,
    "totalDurationMs": 2150,
    "inputTokens": 15,
    "outputTokens": 487,
    "modelId": "granite-3.0-8b"
  }
}
```

### Rate Limit Error

```yaml
Response 429:
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests",
    "retryAfterMs": 5000
  }
}
```

---

## Key Questions for You

1. **Concurrent Requests**: Can the same user session have 4 simultaneous streaming requests to different models?
2. **Rate Limits**: What's the quota policy? Per-model? Per-user? Per-session?
3. **Pricing Data**: Is this already exposed somewhere, or does it need to be added?
4. **Streaming Protocol**: WebSocket or Server-Sent Events?

---

## Pitfalls to Avoid

⚠️ **Don't share state between concurrent requests** — Each pane's request must be independent. No session-level caching that mixes responses.

⚠️ **Don't aggregate rate limits silently** — If one model is rate-limited, return the error. Don't block all models.

⚠️ **Don't assume single model per session** — Users will switch models per-request. Model selection is per-pane, not per-session.

⚠️ **Don't forget metrics in streaming mode** — Final chunk must include latency/token metrics even when streaming.

---

## What Other Teams Send You

Dashboard will pass through parameters for other services. You coordinate with:

| Parameter | Passed To | Notes |
|-----------|-----------|-------|
| `mcpServerIds` | MCP Platform | You invoke MCP; return invocation results |
| `guardrailIds` | Guardrails | You apply guardrails; return which were applied |
| `knowledgeSourceIds` | Knowledge/RAG | You query sources; return which were used |

---

## Timeline

| Milestone | Date | Your Deliverable |
|-----------|------|------------------|
| **M1** | Week 1 | Finalized API contract; answer questions above |
| **M2** | Week 3 | Stubbed/mocked API for Dashboard integration |
| **M3** | Week 5 | Working API for MVP (2-model comparison) |
| **M4** | Week 7 | Full API with all features |
| **M5** | Week 9 | Production ready |

---

## Contact

Questions about this brief? Reach out to Dashboard Team lead or attend M1 contract review.

---

*Your implementation decisions are yours to make. This brief defines WHAT, not HOW.*

