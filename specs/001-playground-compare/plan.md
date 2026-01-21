# Cross-Team Implementation Plan: Playground Multi-Pane Comparison

**Branch**: `001-playground-compare` | **Date**: 2026-01-07 | **Spec**: [spec.md](./spec.md)  
**Plan Type**: Cross-Team Coordination (Epic-Level Requirements)

> ⚠️ **Note**: Per Constitution VIII, this plan defines requirements and contracts only. Each team owns their implementation decisions.

---

## Target Personas

> Reference: [Constitution — Target Personas](../../.specify/memory/constitution.md#target-personas)

| Persona | Archetype | How They Use This Feature |
|---------|-----------|---------------------------|
| **Alex the AI Engineer** | THE BUILDER | **Primary user**. Compares models quickly to select the best for his applications. Addresses his pain: *"50% of our SW engineering effort is spent custom fitting evaluation."* |
| **Deena the Data Scientist** | THE INNOVATOR | **Secondary user**. Uses for model evaluation experiments alongside notebook work. |
| **Maude the ML Ops Engineer** | THE AUTOMATOR | **Occasional user**. Reviews exported metrics for production deployment decisions. |

**Key Pain Points Addressed**:
- 🔴 **The Evaluation Bottleneck**: Manual, repetitive model comparison → Automated side-by-side with metrics
- 🟡 **Prompt Management**: Time-consuming prompt testing → Synchronized A/B testing
- 🟡 **Fragmented Tooling**: Context switching between tools → Single unified comparison UI

---

## Executive Summary

Enable **Alex the AI Engineer** to compare model outputs across multiple configurations simultaneously — cutting model evaluation time by 50%. Secondary users (Deena, Maude) benefit from exports and metrics.

**Target Release**: TBD  
**Total Epics**: 6  
**Critical Path**: Model Serving API → Dashboard UI → Integration Testing
**Primary Persona**: Alex the AI Engineer (THE BUILDER)

---

## Team Epic Assignments

### Epic 1: Dashboard UI — Multi-Pane Experience

**Owner**: Dashboard Team  
**Priority**: P1 (Critical Path)  
**Dependencies**: Epics 2, 3, 4, 5 (API contracts only)

#### Requirements (What to Deliver)

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

#### Integration Contracts Required From Other Teams

- **From Model Serving**: Model list API, streaming completion API
- **From MCP Platform**: MCP server list API, per-request MCP attachment
- **From Guardrails**: Guardrail list API, per-request guardrail toggle
- **From Knowledge/RAG**: Knowledge source list API, per-request source selection

---

### Epic 2: Model Serving — Multi-Model API Support

**Owner**: Model Serving Team  
**Priority**: P1 (Critical Path)  
**Dependencies**: None (foundational)

#### Requirements (What to Deliver)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| MS-001 | Model registry API | Returns available models with id, name, provider, pricing info |
| MS-002 | Streaming completion API | Supports concurrent requests from same user session |
| MS-003 | Per-request model selection | Model specified per request (not session-global) |
| MS-004 | Rate limit handling | Returns structured rate limit errors with retry-after |
| MS-005 | Token counting | Response includes input/output token counts |
| MS-006 | Latency metrics | Response includes time-to-first-token, total duration |
| MS-007 | Pricing data | Model pricing available for cost estimation |

#### API Contract (Required Output)

```yaml
# Model List Endpoint
GET /api/v1/models
Response:
  models:
    - id: string
      name: string
      provider: string (granite|llama|claude|...)
      pricing:
        inputPer1kTokens: number
        outputPer1kTokens: number
      status: available|unavailable

# Completion Endpoint  
POST /api/v1/chat/completions
Request:
  modelId: string
  messages: array
  stream: boolean
Response (streaming):
  tokens: string (chunked)
  metrics:
    latencyMs: number
    inputTokens: number
    outputTokens: number
```

---

### Epic 3: MCP Platform — Per-Request MCP Support

**Owner**: MCP Team  
**Priority**: P2  
**Dependencies**: None

#### Requirements (What to Deliver)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| MCP-001 | MCP server registry API | Returns available MCP servers with status |
| MCP-002 | Per-request MCP attachment | MCP servers specified per request, not globally |
| MCP-003 | MCP invocation reporting | Response includes which MCPs were invoked and duration |
| MCP-004 | Graceful MCP failures | MCP errors don't fail the entire request |

#### API Contract (Required Output)

```yaml
# MCP Server List
GET /api/v1/mcp-servers
Response:
  servers:
    - id: string
      name: string
      description: string
      status: available|unavailable

# Integration with Completion (Model Serving owns endpoint)
POST /api/v1/chat/completions
Request additions:
  mcpServerIds: string[] (optional)
Response additions:
  mcpInvocations:
    - serverId: string
      toolName: string
      durationMs: number
      status: success|error
```

---

### Epic 4: Guardrails — Per-Request Guardrail Toggle

**Owner**: Guardrails/Safety Team  
**Priority**: P2  
**Dependencies**: None

#### Requirements (What to Deliver)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| GR-001 | Guardrail registry API | Returns available guardrails with metadata |
| GR-002 | Per-request guardrail toggle | Guardrails enabled/disabled per request |
| GR-003 | Guardrail application reporting | Response indicates which guardrails were applied |
| GR-004 | Guardrail block handling | Clear indication when guardrail blocks content |

#### API Contract (Required Output)

```yaml
# Guardrail List
GET /api/v1/guardrails
Response:
  guardrails:
    - id: string
      name: string
      description: string
      category: safety|compliance|custom
      enabledByDefault: boolean

# Integration with Completion
POST /api/v1/chat/completions
Request additions:
  guardrailIds: string[] (optional, overrides defaults)
Response additions:
  guardrailsApplied: string[]
  guardrailBlocked: boolean (if content was blocked)
```

---

### Epic 5: Knowledge/RAG — Per-Request Source Selection

**Owner**: Knowledge/RAG Team  
**Priority**: P2  
**Dependencies**: None

#### Requirements (What to Deliver)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| KS-001 | Knowledge source registry API | Returns available knowledge sources |
| KS-002 | Per-request source selection | Knowledge sources specified per request |
| KS-003 | Source attribution | Response indicates which sources contributed |

#### API Contract (Required Output)

```yaml
# Knowledge Source List
GET /api/v1/knowledge-sources
Response:
  sources:
    - id: string
      name: string
      type: document|database|api
      description: string

# Integration with Completion
POST /api/v1/chat/completions
Request additions:
  knowledgeSourceIds: string[] (optional)
Response additions:
  knowledgeSourcesUsed: string[]
```

---

### Epic 6: Integration & QE — End-to-End Validation

**Owner**: QE Team + Dashboard Team  
**Priority**: P1  
**Dependencies**: All above epics

#### Requirements (What to Deliver)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| QE-001 | Multi-pane E2E tests | Full user flows tested with real backend |
| QE-002 | Concurrent stream testing | 4 simultaneous streams don't cause issues |
| QE-003 | Error isolation testing | Failures in one pane don't cascade |
| QE-004 | Accessibility testing | WCAG 2.1 AA validation |
| QE-005 | Performance testing | No visible lag with 4 concurrent streams |

---

## Dependency Graph

```
                    ┌─────────────────┐
                    │  Model Serving  │
                    │    (Epic 2)     │
                    │   [Critical]    │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│  MCP Platform │   │  Guardrails   │   │ Knowledge/RAG │
│   (Epic 3)    │   │   (Epic 4)    │   │   (Epic 5)    │
└───────┬───────┘   └───────┬───────┘   └───────┬───────┘
        │                   │                   │
        └───────────────────┼───────────────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │   Dashboard UI  │
                   │    (Epic 1)     │
                   │   [Critical]    │
                   └────────┬────────┘
                            │
                            ▼
                   ┌─────────────────┐
                   │  Integration/QE │
                   │    (Epic 6)     │
                   └─────────────────┘
```

---

## Synchronization Points

| Milestone | Date | Teams | Deliverable | Gate |
|-----------|------|-------|-------------|------|
| **M1: Contract Review** | Week 1 | All | API contracts finalized | All contracts approved |
| **M2: API Ready** | Week 3 | MS, MCP, GR, KS | Stubbed/mocked APIs available | Dashboard can integrate |
| **M3: MVP Integration** | Week 5 | Dashboard + MS | 2-pane model comparison working | Demo-able |
| **M4: Full Integration** | Week 7 | All | All features integrated | E2E tests pass |
| **M5: Release Candidate** | Week 9 | All + QE | All tests pass, stakeholder sign-off | Ready for release |

---

## Risk Register & Pitfalls

### 🔴 High Risk

| Risk | Impact | Owner | Mitigation |
|------|--------|-------|------------|
| **Rate limits hit with 4 concurrent requests** | Users blocked from core functionality | Model Serving | Implement per-pane rate limit handling; coordinate on quota policy |
| **Streaming performance with 4 panes** | Poor UX, dropped frames | Dashboard | Early performance testing at M2; consider connection pooling |
| **API contract changes mid-development** | Rework across teams | All | Freeze contracts at M1; version all APIs |

### 🟡 Medium Risk

| Risk | Impact | Owner | Mitigation |
|------|--------|-------|------------|
| **MCP/Guardrail APIs not supporting per-request config** | Feature scope reduction | MCP, Guardrails | Validate API capability at M1; define fallback behavior |
| **Cost estimation accuracy** | User trust issues | Model Serving | Agree on pricing data format at M1; document estimation caveats |
| **Accessibility in multi-pane streaming UI** | Compliance failure | Dashboard | Involve a11y expert at M2; early testing |

### 🟢 Low Risk

| Risk | Impact | Owner | Mitigation |
|------|--------|-------|------------|
| **Export format disagreements** | Minor rework | Dashboard | Define schema at M1 |
| **UX design changes** | Some UI rework | Dashboard + UX | Get UX sign-off before M3 |

---

## Pitfall Warnings

### ⚠️ For Dashboard Team
- **Don't assume all models support streaming** — Model Serving API may return non-streaming for some models
- **Don't hardcode pane count** — Design for N panes even if initial limit is 4
- **Don't block UI on slow panes** — Each pane must be independently responsive

### ⚠️ For Model Serving Team
- **Don't share state between concurrent requests** — Each pane's request is independent
- **Don't aggregate rate limits silently** — Surface rate limit errors per-request
- **Don't assume single model per session** — Requests specify model individually

### ⚠️ For MCP/Guardrails/Knowledge Teams
- **Don't require global configuration** — Per-request overrides are the requirement
- **Don't fail silently** — Surface errors so Dashboard can show per-pane status
- **Don't break existing single-pane behavior** — This feature extends, not replaces

### ⚠️ For All Teams
- **Don't design in isolation** — Attend M1 contract review
- **Don't skip stub/mock phase** — Dashboard needs to integrate before APIs are complete
- **Don't change contracts after M1** — Version bumps only with cross-team agreement

---

## Open Questions (Require Cross-Team Discussion)

| # | Question | Affects | Proposed Owner |
|---|----------|---------|----------------|
| 1 | What's the rate limit policy for multi-pane requests? Same user, 4 models? | MS, Dashboard | Model Serving Lead |
| 2 | Can MCP servers be attached per-request or only per-session today? | MCP, Dashboard | MCP Lead |
| 3 | Are guardrails currently toggleable per-request? | Guardrails, Dashboard | Guardrails Lead |
| 4 | Is model pricing data currently exposed via API? | MS, Dashboard | Model Serving Lead |
| 5 | Who owns the WebSocket infrastructure for streaming? | MS, Dashboard | Platform Lead |

---

## Next Steps

1. **Schedule M1: Contract Review** — All teams, 1 hour, within next 5 days
2. **Each team**: Review this plan and confirm requirements are understood
3. **Each team**: Identify any requirements that need clarification or adjustment
4. **Dashboard Team**: Begin UX design work in parallel with contract review
5. **Model Serving**: Confirm streaming API supports concurrent same-user requests

---

## Constitution Compliance

| Principle | Status | Notes |
|-----------|--------|-------|
| I. PatternFly-First | ✅ | Dashboard owns UI decisions; PatternFly expected |
| II. Definition of Ready | ⚠️ | Pending M1 contract review |
| III. Definition of Done | ✅ | Each epic has acceptance criteria |
| VII. Stakeholder Collaboration | ⚠️ | UX review needed before M3 |
| VIII. Cross-Team Coordination | ✅ | Requirements-only plan; implementation owned by teams |
