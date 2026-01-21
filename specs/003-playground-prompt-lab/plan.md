# Implementation Plan: Gen AI Playground Prompt Lab UI Rework

**Branch**: `003-playground-prompt-lab` | **Date**: 2026-01-08 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/003-playground-prompt-lab/spec.md`

## Summary

Rework the Gen AI Playground frontend to adopt a prompt-lab-style two-panel layout: configuration builder (left) with tabbed interface for Model, Prompt, Knowledge, MCP, and Guardrails settings, plus a chat-style conversation panel (right) with streaming responses. This is a **frontend-only** change with no backend modifications.

**Primary Persona**: Alex the AI Engineer — needs fast prompt iteration and clear visual feedback for experimentation workflows.

## Technical Context

> Per Constitution Principle IX, this section documents **constraints** from existing infrastructure, not implementation decisions.

**Infrastructure Constraints** (from Constitution Development Standards):
- Frontend: React + TypeScript + PatternFly (mandated)
- Testing: Jest (unit), Cypress (E2E), axe-core (accessibility)
- Build: Webpack + Module Federation

**Scope Constraints** (from Spec):
- Frontend-only; NO backend or API changes
- Playground page only; no navigation changes
- Existing APIs assumed ready and sufficient

**Quality Constraints** (from Clarifications):
- Basic keyboard navigation required for initial release
- WCAG 2.1 AAA deferred to follow-up
- Conversation history is ephemeral (page state only)
- Model responses must stream

## Constitution Check

*GATE: Verified against Constitution v1.7.1*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. PatternFly-First Design | ✅ Pass | UI must use PatternFly components; no custom CSS |
| II. Definition of Ready | ⚠️ Pending | UX designs referenced (prototype); full sign-off TBD |
| III. Definition of Done | ✅ Understood | Tests, demos, reviews required before release |
| IV. Comprehensive Testing | ✅ Understood | Jest + Cypress + A11y testing required |
| V. Code Quality Standards | ✅ Understood | PR checklist, hooks rules apply |
| VI. Modular Architecture | ✅ Understood | Module boundaries and import rules apply |
| VII. Stakeholder Collaboration | ⚠️ Pending | UX, PM, Docs involvement required |
| VIII. Cross-Team Coordination | ✅ N/A | Frontend-only; no cross-team dependencies |
| IX. Epic-Level Planning | ✅ Pass | This plan follows epic-level format |

**Gate Status**: PASS (with stakeholder sign-offs pending as normal pre-dev activity)

---

## Epic Requirements Summary

> Extracted from spec. Full acceptance criteria in [spec.md](./spec.md).

### Epic 1: Core Playground Experience (P1)

**Requirement**: Complete two-panel prompt lab interface with Configuration Builder (left) and Conversation Panel (right), enabling AI Engineers to configure experiments and test prompts interactively.

**Must support**:

*Configuration Builder (Left Panel):*
- Two-panel layout with configuration on left, conversation on right
- Tabbed interface (Model, Prompt, Knowledge, MCP, Guardrails)
- Model selection and parameter adjustment (temperature, top P, max tokens, repetition)
- System prompt text entry and editing
- Knowledge source (vector store) selection via checkboxes
- MCP configuration options
- Guardrails configuration with active count badge
- State preservation across tab switches

*Conversation Panel (Right Panel):*
- Message input and send
- Streaming response display
- Model attribution (name + timestamp) on responses
- Processing indicator during generation
- Welcome state when empty
- Ephemeral history (page state only, lost on refresh)

**API Dependencies**: 
- Model list API (existing)
- Model inference API with streaming support (existing)
- Vector store list API (existing)
- Guardrails list API (existing)
- MCP configuration API (existing)

**Edge Case Handling**:
- Model unavailability: Block message sending, show inline error, prompt model re-selection

---

### Epic 2: Session Management (P2)

**Requirement**: Workflow actions for session lifecycle management.

**Must support**:
- "New chat" action: Clear conversation, preserve configuration
- "Save" action: Persist configuration (model, parameters, prompt, knowledge, MCP, guardrails) — excludes chat history
- Unsaved changes warning on navigation

**API Dependencies**:
- Configuration save/load API (existing)

---

### Epic 3: Developer Integration (P3)

**Requirement**: Features bridging experimentation to production development.

**Must support**:
- "View code" action: Display code replicating current configuration
- Code copy to clipboard
- Project selector in header
- Project context affects available resources

**API Dependencies**:
- Project list API (existing)

**Deferred Clarification**:
- Code export format (language/SDK) TBD

---

## API Contracts

> This feature consumes existing APIs. No new APIs required.

### Consumed APIs (Frontend → Backend)

| API | Purpose | Epic | Notes |
|-----|---------|------|-------|
| `GET /api/models` | List available models | Epic 1 | Returns model name, ID, parameter ranges |
| `GET /api/vector-stores` | List vector stores for knowledge | Epic 1 | Filtered by project context |
| `GET /api/guardrails` | List guardrail configurations | Epic 1 | Returns name, ID, active status |
| `GET /api/mcp/config` | Get MCP configuration options | Epic 1 | Schema TBD by existing API |
| `POST /api/inference` | Send message, receive streamed response | Epic 1 | Must support SSE/streaming |
| `GET /api/projects` | List available projects | Epic 3 | For project selector |
| `POST /api/playground/config` | Save playground configuration | Epic 2 | Payload: model, params, prompt, knowledge, MCP, guardrails |
| `GET /api/playground/config/:id` | Load saved configuration | Epic 2 | Returns full config object |

### Contract Assumptions

- All listed APIs exist and are documented
- Inference API supports Server-Sent Events (SSE) for streaming
- Model metadata includes parameter ranges (min/max for temperature, etc.)
- Project context filters resources appropriately
- Save/load APIs handle all configuration fields

**Risk**: If any API is missing or incompatible, backend team involvement may be needed despite "no backend changes" scope.

---

## Dependencies

| Dependency | Owner | Status | Risk if Delayed |
|------------|-------|--------|-----------------|
| Model list API | Model Serving Team | Assumed Ready | Blocks Epic 1 |
| Inference streaming API | Model Serving Team | Assumed Ready | Blocks Epic 2 |
| Vector store list API | Knowledge Team | Assumed Ready | Blocks Epic 1 |
| Guardrails list API | Guardrails Team | Assumed Ready | Blocks Epic 1 |
| UX designs finalized | UX Team | Prototype available | Rework risk |
| PM sign-off on requirements | PM Team | Spec complete | Scope risk |

---

## Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **API gaps discovered** | Medium | High | Early integration testing; identify gaps in Phase 1 |
| **Streaming API incompatibility** | Low | High | Validate SSE support before Epic 2 implementation |
| **UX design changes** | Medium | Medium | Get UX sign-off before implementation; use prototype as reference |
| **PatternFly component gaps** | Low | Medium | Identify needed components early; request PF-overrides approval if needed |
| **Accessibility gaps in initial release** | Low | Low | Basic keyboard nav scoped; full A11y deferred |
| **Code export format undefined** | High | Low | P3 priority; can ship without if needed |
| **Configuration save API schema mismatch** | Medium | Medium | Validate payload schema before Epic 3 |

---

## Quality Criteria

| Criterion | Target | Measurement |
|-----------|--------|-------------|
| Tab switching latency | No perceptible delay | Manual testing |
| Streaming response display | Real-time character rendering | Visual verification |
| Configuration preservation | 100% across tab switches | Automated test |
| Keyboard navigation | All interactive elements reachable | A11y audit |
| PatternFly compliance | Zero custom CSS | Code review |
| Test coverage | Per constitution standards | CI/CD gates |

---

## Delivery Phases

| Phase | Epics | Milestone |
|-------|-------|-----------|
| **Phase 1** | Epic 1 (Core Playground Experience) | Full two-panel layout functional (configure + chat) |
| **Phase 2** | Epic 2 (Session Management) | Save/load and new chat working |
| **Phase 3** | Epic 3 (Developer Integration) | View code and project context complete |

---

## Post-Planning Artifacts

Per Constitution Principle IX, the following stakeholder artifacts should be generated:

- [ ] Executive Summary
- [ ] Team Briefs (Dashboard, UX, QE, PM, Docs)

**Shall I generate these artifacts now?**
