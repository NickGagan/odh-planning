# M1 Contract Review — Discussion Items

**Feature**: Playground Multi-Pane Comparison  
**Meeting Purpose**: Finalize API contracts, answer open questions, confirm dependencies  
**Attendees**: All team leads (Dashboard, Model Serving, MCP, Guardrails, Knowledge/RAG, QE)

---

## Who We're Building For

| Persona | Role | Why This Matters |
|---------|------|------------------|
| **Alex the AI Engineer** | THE BUILDER (Primary) | *"50% of our effort is spent on evaluation."* Every API decision affects his workflow speed. |
| **Deena the Data Scientist** | THE INNOVATOR | May use for model experiments; needs reliable results. |
| **Maude the ML Ops Engineer** | THE AUTOMATOR | Reviews export data for production decisions; needs accurate metrics. |

**Success = Alex can complete a 2-model comparison in < 60 seconds**

---

## Pre-Meeting Checklist

- [ ] All teams have reviewed their briefs
- [ ] All teams have reviewed the executive summary
- [ ] Each team prepared answers to their Key Questions

---

## Open Questions Requiring Answers

### 🔴 Critical (Block MVP)

| # | Question | Owning Team | Why It Matters |
|---|----------|-------------|----------------|
| 1 | **Can the same user have 4 concurrent streaming requests to different models?** | Model Serving | Core feature requires simultaneous streams |
| 2 | **What's the rate limit policy for multi-pane requests?** Per-model? Per-user? Per-session? | Model Serving | Affects error handling design; users could hit limits with 4 panes |
| 3 | **What streaming protocol is used?** WebSocket or Server-Sent Events? | Model Serving | Dashboard needs to know for integration |
| 4 | **Who owns the WebSocket/streaming infrastructure?** | Platform / Model Serving | Determines where to direct integration questions |

### 🟡 Important (Block Full Feature)

| # | Question | Owning Team | Why It Matters |
|---|----------|-------------|----------------|
| 5 | **Can MCP servers be attached per-request, or only per-session/globally?** | MCP Platform | Pane-level MCP selection requires per-request support |
| 6 | **Are guardrails toggleable per-request, or only at account/session level?** | Guardrails | Comparing "with guardrail" vs "without" requires per-request |
| 7 | **Can knowledge sources be scoped per-request, or only at project/session level?** | Knowledge/RAG | Comparing "Doc A" vs "Doc B" requires per-request |
| 8 | **Is model pricing data currently exposed via API?** | Model Serving | Cost estimation display requires pricing info |

### 🟢 Good to Know (Optimize Implementation)

| # | Question | Owning Team | Why It Matters |
|---|----------|-------------|----------------|
| 9 | **How are rate limit errors structured?** | Model Serving | Dashboard needs to display per-pane error with retry info |
| 10 | **Can we get stub/mock APIs by Week 2?** | All Backend Teams | Unblocks Dashboard integration before real APIs ready |
| 11 | **Do all models support streaming?** | Model Serving | Dashboard may need to handle non-streaming fallback |

---

## Technical Dependencies to Confirm

### Dashboard Needs From Other Teams

| Dependency | Provider | Status | Notes |
|------------|----------|--------|-------|
| Model list API (`GET /api/v1/models`) | Model Serving | ❓ Confirm | Must include pricing data |
| Streaming completion API | Model Serving | ❓ Confirm | Must support concurrent requests |
| Rate limit error format | Model Serving | ❓ Confirm | Need `retryAfterMs` field |
| MCP server list API | MCP Platform | ❓ Confirm | |
| Per-request MCP attachment | MCP Platform | ❓ Confirm | May need new capability |
| Guardrail list API | Guardrails | ❓ Confirm | |
| Per-request guardrail toggle | Guardrails | ❓ Confirm | May need new capability |
| Knowledge source list API | Knowledge/RAG | ❓ Confirm | |
| Per-request source selection | Knowledge/RAG | ❓ Confirm | May need new capability |

### Model Serving Coordination Points

| Dependency | With Team | Status | Notes |
|------------|-----------|--------|-------|
| MCP invocation during completion | MCP Platform | ❓ Define | Model Serving calls MCP, returns results |
| Guardrail application during completion | Guardrails | ❓ Define | Model Serving calls Guardrails, returns results |
| RAG query during completion | Knowledge/RAG | ❓ Define | Model Serving calls RAG, returns results |

---

## API Contract Decisions Needed

### 1. Completion Request Shape

**Proposed**:
```yaml
POST /api/v1/chat/completions
{
  "modelId": "granite-3.0-8b",
  "messages": [...],
  "stream": true,
  "mcpServerIds": ["github-mcp"],         # MCP to confirm
  "guardrailIds": ["safety-filter"],      # Guardrails to confirm  
  "knowledgeSourceIds": ["product-docs"]  # RAG to confirm
}
```

**Questions**:
- Is this the right endpoint, or should there be a new `/playground/compare` endpoint?
- Should pass-through params go here or in separate API calls?

### 2. Completion Response Shape

**Proposed**:
```yaml
# Streaming chunks
{ "type": "token", "data": "..." }

# Final chunk
{
  "type": "complete",
  "metrics": {
    "latencyMs": 342,
    "inputTokens": 15,
    "outputTokens": 487,
    "modelId": "granite-3.0-8b"
  },
  "mcpInvocations": [...],      # From MCP team
  "guardrailsApplied": [...],   # From Guardrails team
  "knowledgeSourcesUsed": [...]  # From RAG team
}
```

**Questions**:
- Does this shape work for all backend teams?
- Should metrics include cost, or does Dashboard calculate from pricing?

### 3. Rate Limit Error Shape

**Proposed**:
```yaml
# Response 429
{
  "error": {
    "code": "RATE_LIMITED",
    "message": "Too many requests",
    "retryAfterMs": 5000
  }
}
```

**Questions**:
- Is `retryAfterMs` available, or just HTTP Retry-After header?
- Is rate limiting per-model or per-user?

---

## Capability Gaps to Identify

Each team should confirm if these capabilities exist today:

| Capability | Team | Exists Today? | Effort to Add |
|------------|------|---------------|---------------|
| Concurrent streams (same user, multiple models) | Model Serving | ❓ | |
| Per-request MCP server selection | MCP Platform | ❓ | |
| Per-request guardrail override | Guardrails | ❓ | |
| Per-request knowledge source scope | Knowledge/RAG | ❓ | |
| Model pricing in API response | Model Serving | ❓ | |

---

## Risk Decisions Needed

### Rate Limiting Strategy

**Options**:
| Option | Behavior | Pros | Cons |
|--------|----------|------|------|
| A | Block all panes when user hits limit | Simple | Poor UX |
| B | Per-model limits; one model limited, others continue | Best UX | More complex tracking |
| C | Per-session limit across all models | Predictable | May hit quickly with 4 panes |

**Recommendation**: Option B (per-model limits) — aligns with error isolation requirement.

**Decision needed at M1**: _______________

### Stub API Timeline

**Options**:
| Option | Timeline | Risk |
|--------|----------|------|
| A | All stubs ready by Week 2 | Low risk; Dashboard can integrate early |
| B | Stubs ready by Week 3 (M2) | Medium risk; compressed integration |
| C | No stubs; wait for real APIs | High risk; late integration |

**Recommendation**: Option A — enables parallel development.

**Decision needed at M1**: _______________

---

## Action Items Template

Use this to capture decisions during M1:

| # | Decision/Action | Owner | Due |
|---|-----------------|-------|-----|
| 1 | | | |
| 2 | | | |
| 3 | | | |
| 4 | | | |
| 5 | | | |

---

## Meeting Agenda Suggestion

| Time | Topic | Lead |
|------|-------|------|
| 0:00 | Intro & goals | Project Lead |
| 0:05 | Review critical questions (#1-4) | Model Serving |
| 0:15 | Review per-request capabilities (#5-7) | MCP, Guardrails, RAG |
| 0:25 | API contract decisions | All |
| 0:40 | Capability gaps & effort estimates | All |
| 0:50 | Risk decisions (rate limiting, stubs) | All |
| 0:55 | Action items & next steps | Project Lead |

---

*Bring answers to your team's questions. Leave with decisions documented.*

