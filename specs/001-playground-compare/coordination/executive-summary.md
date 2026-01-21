# Playground Multi-Pane Comparison — Executive Summary

**Feature**: Multi-pane AI model comparison in Playground  
**Status**: Planning Complete — Ready for M1 Contract Review  
**Date**: 2026-01-07  
**Full Plan**: [plan.md](../plan.md) | **Spec**: [spec.md](../spec.md)

---

## Who We're Building For

> Reference: [Constitution — Target Personas](../../../.specify/memory/constitution.md#target-personas)

| Persona | Role | Why They Need This |
|---------|------|-------------------|
| **Alex the AI Engineer** | THE BUILDER | **Primary user**. *"50% of our SW engineering effort is spent custom fitting evaluation."* Needs to compare models quickly without repetitive manual testing. |
| **Deena the Data Scientist** | THE INNOVATOR | **Secondary user**. May use for model evaluation experiments alongside notebook work. |
| **Maude the ML Ops Engineer** | THE AUTOMATOR | **Occasional user**. Reviews exported metrics for production deployment decisions. |

**Pain Points Addressed**:
- 🔴 Alex's **Evaluation Bottleneck** → Multi-pane comparison speeds up model selection
- 🟡 Alex's **Prompt Management** → Synchronized prompts enable rapid A/B testing
- 🟡 **The Collaboration Chasm** → Export enables sharing with Maude/Deena

---

## What We're Building

A side-by-side comparison experience in Playground where **Alex the AI Engineer** can:
- Open 2-4 chat panes simultaneously
- Configure each pane with different models, MCP servers, guardrails, and knowledge sources
- Send synchronized or independent prompts
- Compare outputs, latency, token usage, and estimated costs

**Primary Use Case**: Model benchmarking — Alex compares Granite vs Llama vs Claude on identical prompts to quickly select the best model for his application.

---

## Team Involvement

| Team | Epic | Priority | Serves Persona |
|------|------|----------|----------------|
| **Dashboard** | Multi-pane UI | P1 | Alex (primary), Deena |
| **Model Serving** | Model registry + streaming API | P1 | Alex |
| **MCP Platform** | Per-request MCP attachment | P2 | Alex |
| **Guardrails** | Per-request guardrail toggle | P2 | Alex |
| **Knowledge/RAG** | Per-request source selection | P2 | Alex, Deena |
| **QE** | E2E validation | P1 | All (quality gate) |

---

## Critical Dependencies

```
Model Serving API  ──►  Dashboard UI  ──►  QE Integration
       ▲
   MCP / Guardrails / Knowledge (parallel, feed into Dashboard)
```

**Blocking**: Dashboard cannot begin integration until Model Serving provides API contract.

---

## Key Milestones

| Milestone | Target | What's Due | Persona Gate |
|-----------|--------|------------|--------------|
| **M1: Contract Review** | Week 1 | All API contracts finalized | — |
| **M2: APIs Stubbed** | Week 3 | Mock/stub APIs available | — |
| **M3: MVP Demo** | Week 5 | 2-pane model comparison | Alex can demo core workflow |
| **M4: Full Integration** | Week 7 | All features integrated | Alex can use full feature set |
| **M5: Release Candidate** | Week 9 | All tests pass | Ready for all personas |

---

## Top Risks

| Risk | Impact | Persona Affected | Mitigation |
|------|--------|------------------|------------|
| Rate limits with 4 concurrent requests | High | Alex | Coordinate quota policy at M1 |
| MCP/Guardrails don't support per-request config | Medium | Alex | Validate at M1; define fallback |
| Streaming performance with 4 panes | High | Alex | Early perf testing at M2 |
| Export format not useful for production decisions | Low | Maude | Review format with ML Ops at M1 |

---

## Open Questions for M1

1. What's the rate limit policy for 4 concurrent model requests from same user?
2. Can MCP servers be attached per-request (not just per-session)?
3. Are guardrails toggleable per-request today?
4. Is model pricing data exposed via API?
5. Who owns WebSocket infrastructure for streaming?

---

## Success Metrics (Persona-Focused)

| Metric | Target | Persona |
|--------|--------|---------|
| Time to complete 2-model comparison | < 60 seconds | Alex |
| Model evaluation time reduction | 50%+ vs single-pane | Alex |
| First-use success rate | 90% | Alex, Deena |
| Export data completeness | 100% match | Maude |

---

## Action Items

| Owner | Action | Due |
|-------|--------|-----|
| **Project Lead** | Schedule M1 meeting with all teams | This week |
| **All Team Leads** | Review plan.md and confirm requirements | Before M1 |
| **Model Serving** | Confirm streaming API supports concurrent same-user requests | Before M1 |
| **Dashboard** | Begin UX design work (focus on Alex's workflow) | Parallel with M1 |

---

## Links

- **Full Plan**: `specs/001-playground-compare/plan.md`
- **Feature Spec**: `specs/001-playground-compare/spec.md`
- **Team Briefs**: `specs/001-playground-compare/coordination/briefs/`
- **Constitution Personas**: `.specify/memory/constitution.md#target-personas`

---

*Questions? Contact the Dashboard Team or your assigned Epic owner.*
