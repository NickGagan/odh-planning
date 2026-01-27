# Implementation Plan: Playground Compare

**Branch**: `004-playground-compare` | **Date**: 2026-01-21 | **Spec**: [spec.md](./spec.md)  
**Input**: Feature specification from `/specs/004-playground-compare/spec.md`

## Summary

Enable multi-instance comparison in the Playground by allowing users to create 2-4 chat panes side-by-side, each independently configured with model, MCP servers, knowledge sources, and guardrails. Supports synchronized (same prompt across all panes) and independent (per-pane prompts) modes with streaming responses that are non-blocking across panes.

**Key Technical Challenge**: Managing isolated state for multiple panes while supporting synchronized prompt dispatch with independent streaming responses. Each pane must maintain its own configuration, conversation history, and streaming state without affecting siblings.

## Technical Context

**Language/Version**: TypeScript 5.x (Frontend), Go 1.23+ (BFF)  
**Primary Dependencies**: React 18, PatternFly 6 (Chatbot), `@patternfly/chatbot`  
**Storage**: N/A (ephemeral sessions—no persistence)  
**Testing**: Jest (unit), Cypress (E2E), `cy.testA11y()` (accessibility)  
**Target Platform**: Web (OpenShift Dashboard)  
**Project Type**: Web application (monorepo with module federation)  
**Performance Goals**: Non-blocking streaming; 4 concurrent panes without UI jank  
**Constraints**: Maximum 4 panes; client-side memory budget for 4x conversation histories  
**Scale/Scope**: Single-user session; no multi-user collaboration

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Status | Notes |
|-----------|--------|-------|
| I. PatternFly-First | ✅ Pass | Uses `@patternfly/chatbot`, PatternFly layout components |
| II. Definition of Ready | ⚠️ Pending | UX designs needed before implementation; spec complete |
| III. Definition of Done | ✅ N/A | Applies at implementation time |
| IV. Comprehensive Testing | ✅ Pass | Jest + Cypress planned; pane isolation testable |
| V. Code Quality | ✅ Pass | Follows existing hooks pattern |
| VI. Modular Architecture | ✅ Pass | Extends existing `packages/gen-ai/` module |
| VII. Stakeholder Collaboration | ⚠️ Pending | UX review needed |
| VIII. Cross-Team Coordination | ✅ Pass | Dependencies documented in spec |
| IX. Epic-Level Planning | ✅ Pass | Requirements-focused, no implementation prescription |
| XII. Epic Structure | ✅ Pass | Epics sprint-scoped, single-team ownership |
| XIII. Codebase-Informed | ✅ Pass | Patterns derived from existing Chatbot implementation |

**Blocking Items**:
- UX designs for multi-pane layout (Principle II, VII)
- Guardrails team confirmation on per-request toggle feasibility

## Project Structure

### Documentation (this feature)

```text
specs/004-playground-compare/
├── plan.md              # This file
├── spec.md              # Feature specification
├── research.md          # Phase 0 research findings
├── data-model.md        # Entity definitions and state shape
├── quickstart.md        # Developer onboarding guide
├── contracts/           # API contracts (if BFF changes needed)
│   └── consumed-apis.md # Existing APIs consumed by this feature
└── checklists/
    └── requirements.md  # Spec quality checklist
```

### Source Code (repository root)

```text
# Existing structure in odh-dashboard
packages/gen-ai/
├── frontend/src/app/
│   ├── Chatbot/                    # Existing Playground (single pane)
│   │   ├── ChatbotPlayground.tsx   # Current single-pane implementation
│   │   ├── components/             # Reusable chatbot components
│   │   └── hooks/                  # useChatbotMessages, etc.
│   ├── context/
│   │   ├── ChatbotContext.tsx      # Model/session state (shared)
│   │   └── GenAiContext.tsx        # Project/namespace context
│   └── services/
│       └── llamaStackService.ts    # API client for inference
└── bff/                            # Go backend (no changes expected)
```

**Structure Decision**: Extend existing `packages/gen-ai/frontend/src/app/Chatbot/` with new components for multi-pane management. No new top-level modules; reuse existing hooks and contexts where possible.

## Cross-Team Requirements

| Team | Requirement | Needed By | Contact | Status |
|------|-------------|-----------|---------|--------|
| UX Team | Multi-pane layout designs | Before Epic 1 | TBD | Pending |
| Guardrails Team | Confirm per-request guardrail toggle | Before Epic 2 | TBD | Pending |
| Model Serving | Capacity awareness (4x concurrent requests) | FYI | TBD | Informational |
| QE Team | Test matrix expansion | Before Epic 1 | TBD | Informational |

## Complexity Tracking

> No constitution violations requiring justification. Feature fits within existing module boundaries.
