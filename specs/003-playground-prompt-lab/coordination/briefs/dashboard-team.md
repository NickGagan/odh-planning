# Team Brief: Dashboard Team — Playground Prompt Lab UI Rework

**Feature**: 003-playground-prompt-lab  
**Date**: January 8, 2026  
**Priority**: High (P1 core experience)

---

## Your Role

You are the **primary implementation team** for this feature. This is a frontend-only UI rework of the Gen AI Playground page.

---

## What You're Building

A two-panel prompt lab interface:

| Panel | Contents |
|-------|----------|
| **Left: Configuration Builder** | Tabs for Model, Prompt, Knowledge, MCP, Guardrails |
| **Right: Conversation** | Chat interface with streaming responses |
| **Header** | Project selector, Save, New chat, View code |

**Target User**: Alex the AI Engineer — needs fast prompt iteration with clear visual feedback.

---

## Epics & Priority

| Epic | Priority | Description |
|------|----------|-------------|
| **Epic 1: Core Playground Experience** | P1 | Full two-panel layout: Configuration Builder (left) + Conversation Panel (right) |
| **Epic 2: Session Management** | P2 | Save configs, new chat, unsaved changes warning |
| **Epic 3: Developer Integration** | P3 | View code, project context |

**Recommended delivery order**: Epic 1 (core experience) → Epic 2 → Epic 3

---

## Key Requirements

### Must Have (P1 — Epic 1: Core Playground Experience)
- Two-panel layout with PatternFly components
- **Configuration Builder (Left Panel):**
  - Tabbed interface (Model, Prompt, Knowledge, MCP, Guardrails)
  - Model selection with parameter sliders (temperature, top P, max tokens, repetition)
  - System prompt text area
  - Knowledge source checkboxes
  - Guardrails configuration with active count badge
  - State preservation across tab switches
- **Conversation Panel (Right Panel):**
  - Chat interface with streaming responses
  - Model attribution on responses (name + timestamp)
  - Processing indicator during generation
  - Welcome state when no conversation exists
  - Ephemeral history (lost on refresh)

### Should Have (P2 — Epic 2: Session Management)
- New chat action (clear conversation, keep config)
- Save configuration (excludes chat history)
- Unsaved changes warning
- Load saved configurations

### Nice to Have (P3 — Epic 3: Developer Integration)
- View generated code
- Copy code to clipboard
- Project selector

---

## Technical Constraints

**From Constitution:**
- PatternFly-First (Principle I): No custom CSS without approval
- Testing (Principle IV): Jest unit tests + Cypress E2E required
- Modular Architecture (Principle VI): Follow import restrictions
- Accessibility (FR-031): Basic keyboard navigation required

**From Scope:**
- Frontend-only; no backend changes
- Existing APIs assumed ready
- Conversation is ephemeral (page state only)
- Responses must stream via SSE

---

## API Dependencies

You will consume these existing APIs (see `contracts/consumed-apis.md` for details):

| API | Purpose |
|-----|---------|
| `GET /api/models` | List available models |
| `POST /api/inference` | Send message, receive streamed response |
| `GET /api/vector-stores` | List knowledge sources |
| `GET /api/guardrails` | List guardrails |
| `GET /api/mcp/config` | MCP options |
| `POST /api/playground/config` | Save configuration |
| `GET /api/playground/config/:id` | Load configuration |
| `GET /api/projects` | List projects |

**Action**: Validate these APIs early in implementation. If any are missing or incompatible, escalate immediately.

---

## Edge Cases to Handle

| Scenario | Behavior |
|----------|----------|
| Model becomes unavailable | Block message send, show inline error, prompt re-selection |
| Network error during streaming | Show error, allow retry |
| Tab switch during generation | Response continues in background |
| Unsaved changes + navigation | Show confirmation dialog |

---

## Testing Requirements

- **Unit tests (Jest)**: All utility functions and hooks
- **E2E tests (Cypress)**: Full user flows (configure → chat → save)
- **Accessibility**: `cy.testA11y()` on page load
- **Manual**: Reviewer must run locally before approval

---

## Definition of Done

Per Constitution Principle III:
- [ ] Code reviewed by advisor + team member
- [ ] Tests pass (Jest + Cypress + A11y)
- [ ] UI matches UX designs
- [ ] Demo recorded
- [ ] PM sign-off
- [ ] UX stories closed

---

## Key Documents

| Document | Location |
|----------|----------|
| Full Spec | `specs/003-playground-prompt-lab/spec.md` |
| Plan | `specs/003-playground-prompt-lab/plan.md` |
| API Contracts | `specs/003-playground-prompt-lab/contracts/consumed-apis.md` |
| Data Model | `specs/003-playground-prompt-lab/data-model.md` |
| Quickstart | `specs/003-playground-prompt-lab/quickstart.md` |

---

## Questions?

- **Requirements**: Check spec.md acceptance criteria
- **APIs**: Check contracts/consumed-apis.md
- **Architecture**: Consult Dashboard Advisors
- **UX**: Reference prototype, confirm with UX team

