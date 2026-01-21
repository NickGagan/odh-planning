# Quickstart: Playground Prompt Lab Implementation

**Feature**: 003-playground-prompt-lab  
**Date**: 2026-01-08

> This guide provides context for engineers starting implementation. Per Constitution Principle IX, implementation details (file structure, component names, state management) are left to the implementing team.

---

## What You're Building

A two-panel prompt lab interface for the Gen AI Playground:

- **Left Panel**: Configuration Builder with tabs (Model, Prompt, Knowledge, MCP, Guardrails)
- **Right Panel**: Chat-style conversation with streaming responses
- **Header**: Project selector, Save, New chat, View code actions

**Target User**: Alex the AI Engineer — needs fast iteration on prompts with clear visual feedback.

---

## Key Documents

| Document | Purpose |
|----------|---------|
| [spec.md](./spec.md) | Full requirements, epics, acceptance criteria |
| [plan.md](./plan.md) | Dependencies, risks, delivery phases |
| [research.md](./research.md) | Decision log, API assumptions |
| [contracts/consumed-apis.md](./contracts/consumed-apis.md) | Expected API contracts |
| [data-model.md](./data-model.md) | Client state model, persisted entity |

---

## Implementation Priorities

### Phase 1: Core Experience (Epics 1 + 2)

Get the two-panel layout working with basic flow:
1. User selects model, adjusts parameters
2. User writes system prompt
3. User sends message, sees streamed response

**Validation checkpoint**: Can complete a full prompt test cycle.

### Phase 2: Session Management (Epic 3)

Add workflow actions:
1. New chat clears conversation, preserves config
2. Save persists configuration
3. Unsaved changes warning on navigation

**Validation checkpoint**: Can save and reload a configuration.

### Phase 3: Developer Integration (Epic 4)

Add developer-facing features:
1. View code shows replicable configuration
2. Project selector changes available resources

**Validation checkpoint**: Can copy code and switch projects.

---

## Constitution Compliance Checklist

Before starting, review these constitution requirements:

- [ ] **PatternFly-First** (Principle I): Use PF components; no custom CSS without approval
- [ ] **Definition of Ready** (Principle II): UX designs reviewed, API contracts validated
- [ ] **Testing** (Principle IV): Plan Jest unit tests and Cypress E2E tests
- [ ] **Modular Architecture** (Principle VI): Follow import restrictions
- [ ] **Accessibility** (FR-031): Basic keyboard navigation required

---

## API Validation Steps

Before deep implementation, validate these assumptions:

1. **Inference streaming**: Hit `/api/inference` with a test payload. Confirm SSE events arrive as expected.

2. **Model metadata**: Hit `/api/models`. Confirm parameter ranges are included.

3. **Config persistence**: Test save/load cycle with `/api/playground/config` endpoints.

If any API is missing or incompatible, escalate immediately — this is a "frontend-only" feature but depends on existing APIs.

---

## Edge Cases to Handle

| Scenario | Expected Behavior |
|----------|-------------------|
| Model becomes unavailable | Block message send, show inline error, prompt re-selection |
| Network error during streaming | Show error in conversation, allow retry |
| Very long response | Render incrementally (streaming handles this) |
| Tab switch during generation | Response continues, visible when returning to chat |
| Unsaved changes + navigation | Show confirmation dialog |

---

## Testing Expectations

Per Constitution Principle IV:

- **Unit tests (Jest)**: Cover utility functions and hooks
- **E2E tests (Cypress)**: Cover full user flows (configure → chat → save)
- **Accessibility tests**: `cy.testA11y()` on page load and key interactions
- **Test files**: `.spec.ts` in `__tests__` directories

---

## Questions?

- **Requirements unclear?** → Check [spec.md](./spec.md) acceptance criteria
- **API questions?** → Check [contracts/consumed-apis.md](./contracts/consumed-apis.md)
- **Architecture questions?** → Consult Dashboard Advisors (per Definition of Ready)
- **UX questions?** → Reference prototype, confirm with UX team

---

## Ready to Start

1. ✅ Read spec.md for full requirements
2. ✅ Validate API assumptions (see above)
3. ✅ Get UX sign-off on implementation approach
4. ✅ Create feature branch from `003-playground-prompt-lab`
5. ✅ Begin Phase 1 implementation

