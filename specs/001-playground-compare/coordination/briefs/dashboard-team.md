# Team Brief: Dashboard Team

**Feature**: Playground Multi-Pane Comparison  
**Epic**: 1 — Multi-Pane UI Experience  
**Priority**: P1 (Critical Path)  
**Full Plan**: [plan.md](../../plan.md)

---

## Primary Persona: Alex the AI Engineer (THE BUILDER)

> *"50% of our SW engineering effort is spent custom fitting evaluation to our needs."*

**Who is Alex?** Develops and deploys AI-infused applications. Driven by urgency and practicality — seeks the quickest path to integrate an LLM. His pain points: manual evaluation, time-consuming prompt testing, deployment complexity.

**What Alex needs from us**: A fast, intuitive UI that lets him compare model outputs without repetitive manual testing. Every click we save him accelerates his evaluation workflow.

**Secondary Personas**: Deena (Data Scientist) may use for experiments; Maude (ML Ops) needs clean export data.

---

## Your Mission

Build the multi-pane comparison UI that enables **Alex** to compare AI model outputs side-by-side — reducing his model evaluation time by 50%. You own the entire frontend experience.

---

## Requirements (12 Total)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| UI-001 | Multi-pane layout (2-4 panes) | Users can add/remove panes; layout adjusts responsively |
| UI-002 | Per-pane configuration UI | Each pane has independent model, MCP, guardrail, knowledge source selection |
| UI-003 | Synchronized prompt mode | Single input broadcasts to all enabled panes |
| UI-004 | Independent prompt mode | Each pane has own input field |
| UI-005 | Pane enable/disable toggle | Disabled panes excluded from sync; visual indicator shown |
| UI-006 | Streaming response display | Real-time token streaming in each pane |
| UI-007 | Runtime metrics display | Latency, tokens, cost shown per response |
| UI-008 | Export functionality | JSON/CSV export of session data |
| UI-009 | Clear All action | Reset all pane conversations simultaneously |
| UI-010 | First-use data banner | One-time informational banner about data processing |
| UI-011 | WCAG 2.1 AA compliance | Keyboard nav, screen reader support, color contrast |
| UI-012 | Error isolation | One pane failing doesn't affect others |

---

## What You Need From Other Teams

| Team | API | What You'll Use It For |
|------|-----|----------------------|
| **Model Serving** | `GET /api/v1/models` | Populate model dropdown |
| **Model Serving** | `POST /api/v1/chat/completions` | Send prompts, receive streaming responses |
| **MCP Platform** | `GET /api/v1/mcp-servers` | Populate MCP server selector |
| **Guardrails** | `GET /api/v1/guardrails` | Populate guardrail toggles |
| **Knowledge/RAG** | `GET /api/v1/knowledge-sources` | Populate knowledge source selector |

**Note**: All integrations should be via request parameters, not session-global config.

---

## Key Integration Points

### Model Serving Integration
```yaml
# Your request will include:
POST /api/v1/chat/completions
{
  modelId: "granite-3.0-8b",        # Per-pane selection
  messages: [...],
  stream: true,
  mcpServerIds: ["github-mcp"],     # Per-pane selection
  guardrailIds: ["safety-filter"],  # Per-pane selection
  knowledgeSourceIds: ["doc-a"]     # Per-pane selection
}

# You'll receive streaming tokens + metrics:
{
  tokens: "...",
  metrics: {
    latencyMs: 342,
    inputTokens: 15,
    outputTokens: 487
  }
}
```

---

## Pitfalls to Avoid

⚠️ **Don't assume all models support streaming** — Model Serving API may return non-streaming for some models. Handle both cases.

⚠️ **Don't hardcode pane count** — Design for N panes even if initial limit is 4. Future requirement may expand.

⚠️ **Don't block UI on slow panes** — Each pane must be independently responsive. One slow model shouldn't freeze others.

⚠️ **Don't wait for complete APIs** — Start with mocks/stubs. APIs will be stubbed by M2.

---

## Timeline

| Milestone | Date | Your Deliverable |
|-----------|------|------------------|
| **M1** | Week 1 | Attend contract review; confirm API needs |
| **M2** | Week 3 | Begin integration with stubbed APIs |
| **M3** | Week 5 | MVP: 2-pane model comparison demo |
| **M4** | Week 7 | Full feature integration |
| **M5** | Week 9 | All tests pass, release ready |

---

## Questions to Raise at M1

1. What's the streaming protocol? WebSocket or SSE?
2. How are rate limit errors structured? Need to display per-pane.
3. Is there a model pricing endpoint or is it part of model list response?
4. Can we get stub APIs by Week 2 to unblock integration?

---

## Constitution Reminders

- **PatternFly-First**: All components must use PatternFly; no custom CSS
- **Accessibility**: WCAG 2.1 AA is required (FR-014)
- **Testing**: Jest unit tests + Cypress E2E required before merge

---

*Your implementation decisions are yours to make. This brief defines WHAT, not HOW.*

