# Tasks: Playground Compare

**Input**: Design documents from `/specs/004-playground-compare/`  
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/ ✅

**Tests**: Tests are included per constitution requirement (Principle IV: Comprehensive Testing).

**Organization**: Tasks are grouped by epic (user story) to enable independent implementation and testing.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which epic/story this task belongs to (E1, E2, E3, E4, E5)
- Include exact file paths in descriptions

## Path Conventions

- **Frontend**: `packages/gen-ai/frontend/src/app/`
- **Tests (Unit)**: `packages/gen-ai/frontend/src/app/**/__tests__/`
- **Tests (E2E)**: `packages/gen-ai/frontend/src/__tests__/cypress/`

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and foundational types/utilities

- [ ] T001 Create TypeScript interfaces for ComparisonSession, Pane, PaneConfiguration in `packages/gen-ai/frontend/src/app/Chatbot/types/comparison.ts`
- [ ] T002 [P] Create PaneState interface and RuntimeMetrics type in `packages/gen-ai/frontend/src/app/Chatbot/types/comparison.ts`
- [ ] T003 [P] Create utility functions for pane ID generation and configuration cloning in `packages/gen-ai/frontend/src/app/Chatbot/utils/paneUtils.ts`
- [ ] T004 [P] Add constants for MAX_PANES, DEFAULT_PROMPT_MODE in `packages/gen-ai/frontend/src/app/Chatbot/const.ts`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core state management and hooks that ALL epics depend on

**⚠️ CRITICAL**: No epic work can begin until this phase is complete

- [ ] T005 Create useComparisonSession hook for session-level state management in `packages/gen-ai/frontend/src/app/Chatbot/hooks/useComparisonSession.ts`
- [ ] T006 Create usePaneState hook wrapping existing useChatbotMessages with pane isolation in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePaneState.ts`
- [ ] T007 [P] Create ComparisonSessionContext for sharing session state across components in `packages/gen-ai/frontend/src/app/context/ComparisonSessionContext.tsx`
- [ ] T008 [P] Add unit tests for useComparisonSession hook in `packages/gen-ai/frontend/src/app/Chatbot/hooks/__tests__/useComparisonSession.spec.ts`
- [ ] T009 [P] Add unit tests for usePaneState hook in `packages/gen-ai/frontend/src/app/Chatbot/hooks/__tests__/usePaneState.spec.ts`

**Checkpoint**: Foundation ready - epic implementation can now begin

---

## Phase 3: Epic 1 - Multi-Pane Playground Interface (Priority: P1) 🎯 MVP

**Goal**: Enable users to create and manage 2-4 chat panes side-by-side within a single Playground view

**Independent Test**: User can add panes, toggle visibility, and see side-by-side layout; hidden panes restore with state intact

### Tests for Epic 1

- [ ] T010 [P] [E1] E2E test for pane add/remove in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/multi-pane.cy.ts`
- [ ] T011 [P] [E1] E2E test for pane toggle visibility in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/pane-toggle.cy.ts`
- [ ] T012 [P] [E1] Unit test for ComparisonPlayground component in `packages/gen-ai/frontend/src/app/Chatbot/compare/__tests__/ComparisonPlayground.spec.tsx`
- [ ] T061 [P] [E1] E2E test for pane resize in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/pane-resize.cy.ts`
- [ ] T062 [P] [E1] E2E test for pane error isolation (one pane fails, others continue) in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/error-isolation.cy.ts`

### Implementation for Epic 1

- [ ] T013 [E1] Create ComparisonPlayground container component in `packages/gen-ai/frontend/src/app/Chatbot/compare/ComparisonPlayground.tsx`
- [ ] T063 [E1] Create PaneErrorBoundary component to isolate per-pane failures in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneErrorBoundary.tsx`
- [ ] T014 [P] [E1] Create Pane wrapper component extracting from ChatbotPlayground, wrapped in PaneErrorBoundary, in `packages/gen-ai/frontend/src/app/Chatbot/compare/Pane.tsx`
- [ ] T015 [P] [E1] Create PaneHeader component with toggle/close controls in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneHeader.tsx`
- [ ] T016 [E1] Create PaneLayout component using PatternFly Flex for side-by-side layout in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneLayout.tsx`
- [ ] T017 [E1] Create AddPaneButton component in `packages/gen-ai/frontend/src/app/Chatbot/compare/AddPaneButton.tsx`
- [ ] T018 [E1] Implement pane visibility toggle logic preserving hidden pane state in `packages/gen-ai/frontend/src/app/Chatbot/hooks/useComparisonSession.ts`
- [ ] T019 [E1] Add responsive layout handling for narrow viewports in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneLayout.tsx`
- [ ] T064 [E1] Implement pane resize with drag handles in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneLayout.tsx`
- [ ] T020 [E1] Wire ComparisonPlayground into existing Chatbot routing in `packages/gen-ai/frontend/src/app/Chatbot/ChatbotPage.tsx`

**Checkpoint**: Epic 1 complete - users can add/remove/toggle/resize 2-4 panes side-by-side

---

## Phase 4: Epic 2 - Pane Configuration (Priority: P1)

**Goal**: Enable independent configuration of each pane (model, MCPs, knowledge, guardrails) with complete isolation

**Independent Test**: Changing config in one pane does not affect siblings; clone creates independent copy

### Tests for Epic 2

- [ ] T021 [P] [E2] E2E test for per-pane model selection in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/pane-config.cy.ts`
- [ ] T022 [P] [E2] E2E test for configuration cloning in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/config-clone.cy.ts`
- [ ] T023 [P] [E2] Unit test for PaneConfigPanel component in `packages/gen-ai/frontend/src/app/Chatbot/compare/__tests__/PaneConfigPanel.spec.tsx`

### Implementation for Epic 2

- [ ] T024 [E2] Create PaneConfigPanel component adapting ChatbotSettingsPanel for per-pane use in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneConfigPanel.tsx`
- [ ] T025 [E2] Move model selection from ChatbotContext to per-pane state in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePaneState.ts`
- [ ] T026 [P] [E2] Add per-pane MCP server selection to PaneConfigPanel in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneConfigPanel.tsx`
- [ ] T027 [P] [E2] Add per-pane knowledge source selection to PaneConfigPanel in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneConfigPanel.tsx`
- [ ] T028 [E2] Add per-pane guardrails toggle to PaneConfigPanel in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneConfigPanel.tsx`
- [ ] T029 [E2] Implement cloneConfiguration function in `packages/gen-ai/frontend/src/app/Chatbot/utils/paneUtils.ts`
- [ ] T030 [E2] Add ClonePaneButton component with clone action in `packages/gen-ai/frontend/src/app/Chatbot/compare/ClonePaneButton.tsx`
- [ ] T031 [E2] Integrate permission checks for per-pane resource access in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneConfigPanel.tsx`

**Checkpoint**: Epic 2 complete - each pane has isolated configuration; cloning works

---

## Phase 5: Epic 3 - Prompt Management (Priority: P1)

**Goal**: Support synchronized (one prompt → all panes) and independent (per-pane prompts) modes with history preservation

**Independent Test**: Sync mode sends to all visible panes; independent mode allows per-pane editing; mode switch preserves history

### Tests for Epic 3

- [ ] T032 [P] [E3] E2E test for synchronized prompt mode in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/sync-prompt.cy.ts`
- [ ] T033 [P] [E3] E2E test for independent prompt mode in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/independent-prompt.cy.ts`
- [ ] T034 [P] [E3] Unit test for usePromptMode hook in `packages/gen-ai/frontend/src/app/Chatbot/hooks/__tests__/usePromptMode.spec.ts`

### Implementation for Epic 3

- [ ] T035 [E3] Create usePromptMode hook managing mode state and dispatch in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePromptMode.ts`
- [ ] T036 [E3] Create SharedPromptInput component for synchronized mode in `packages/gen-ai/frontend/src/app/Chatbot/compare/SharedPromptInput.tsx`
- [ ] T037 [E3] Create PromptModeToggle component in `packages/gen-ai/frontend/src/app/Chatbot/compare/PromptModeToggle.tsx`
- [ ] T038 [E3] Implement synchronized dispatch calling all visible pane handleMessageSend in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePromptMode.ts`
- [ ] T039 [E3] Ensure mode switching preserves all pane conversation history in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePromptMode.ts`
- [ ] T040 [E3] Integrate SharedPromptInput into ComparisonPlayground layout in `packages/gen-ai/frontend/src/app/Chatbot/compare/ComparisonPlayground.tsx`
- [ ] T041 [E3] Add visual indicator for active prompt mode in `packages/gen-ai/frontend/src/app/Chatbot/compare/PromptModeToggle.tsx`

**Checkpoint**: Epic 3 complete - synchronized and independent prompt modes work with history preservation

---

## Phase 6: Epic 4 - Comparison Analytics (Priority: P2)

**Goal**: Display runtime metrics (latency, tokens) inline with each pane's responses

**Independent Test**: Bot responses show latency and token counts; metrics positioned consistently across panes

### Tests for Epic 4

- [ ] T042 [P] [E4] E2E test for metrics display in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/metrics-display.cy.ts`
- [ ] T043 [P] [E4] Unit test for RuntimeMetricsDisplay component in `packages/gen-ai/frontend/src/app/Chatbot/compare/__tests__/RuntimeMetricsDisplay.spec.tsx`

### Implementation for Epic 4

- [ ] T044 [E4] Create RuntimeMetricsDisplay component in `packages/gen-ai/frontend/src/app/Chatbot/compare/RuntimeMetricsDisplay.tsx`
- [ ] T045 [E4] Extract latency from inference response timing in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePaneState.ts`
- [ ] T046 [E4] Extract token counts from inference response metadata in `packages/gen-ai/frontend/src/app/Chatbot/hooks/usePaneState.ts`
- [ ] T047 [E4] Integrate RuntimeMetricsDisplay into message rendering in `packages/gen-ai/frontend/src/app/Chatbot/compare/Pane.tsx`
- [ ] T048 [E4] Style metrics for consistent positioning across panes in `packages/gen-ai/frontend/src/app/Chatbot/compare/RuntimeMetricsDisplay.tsx`

**Checkpoint**: Epic 4 complete - metrics visible and comparable across panes

---

## Phase 7: Epic 5 - Export (Priority: P2)

**Goal**: Enable users to export comparison sessions (chats + configs) for offline review

**Independent Test**: Export action generates JSON file with all pane conversations and configurations

### Tests for Epic 5

- [ ] T049 [P] [E5] E2E test for session export in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/export.cy.ts`
- [ ] T050 [P] [E5] Unit test for export utility functions in `packages/gen-ai/frontend/src/app/Chatbot/utils/__tests__/exportUtils.spec.ts`

### Implementation for Epic 5

- [ ] T051 [E5] Create generateExportData utility building JSON structure in `packages/gen-ai/frontend/src/app/Chatbot/utils/exportUtils.ts`
- [ ] T052 [E5] Create downloadExport utility triggering browser download in `packages/gen-ai/frontend/src/app/Chatbot/utils/exportUtils.ts`
- [ ] T053 [E5] Create ExportButton component in `packages/gen-ai/frontend/src/app/Chatbot/compare/ExportButton.tsx`
- [ ] T054 [E5] Integrate ExportButton into ComparisonPlayground header in `packages/gen-ai/frontend/src/app/Chatbot/compare/ComparisonPlayground.tsx`
- [ ] T055 [E5] Add unsaved changes warning before destructive navigation in `packages/gen-ai/frontend/src/app/Chatbot/compare/ComparisonPlayground.tsx`

**Checkpoint**: Epic 5 complete - users can export sessions for offline review

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Quality improvements across all epics

- [ ] T056 [P] Run accessibility audit on all new components using `cy.testA11y()` in `packages/gen-ai/frontend/src/__tests__/cypress/cypress/e2e/playground-compare/a11y.cy.ts`
- [ ] T057 [P] Add keyboard navigation between panes in `packages/gen-ai/frontend/src/app/Chatbot/compare/PaneLayout.tsx`
- [ ] T058 Code cleanup and removal of any debug code across all compare/ components
- [ ] T059 [P] Performance profiling for 4-pane concurrent streaming
- [ ] T060 Update quickstart.md with final implementation notes in `specs/004-playground-compare/quickstart.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all epics
- **Epic 1 (Phase 3)**: Depends on Foundational - MVP milestone
- **Epic 2 (Phase 4)**: Depends on Foundational; integrates with Epic 1 components
- **Epic 3 (Phase 5)**: Depends on Foundational; integrates with Epic 1 layout
- **Epic 4 (Phase 6)**: Depends on Epic 1 Pane component
- **Epic 5 (Phase 7)**: Depends on Epic 1 session state
- **Polish (Phase 8)**: Depends on all desired epics being complete

### Epic Dependencies

| Epic | Can Start After | Integrates With | Independent? |
|------|-----------------|-----------------|--------------|
| Epic 1 (Multi-Pane) | Phase 2 | None | ✅ Yes - MVP |
| Epic 2 (Config) | Phase 2 | Epic 1 layout | ✅ Yes |
| Epic 3 (Prompts) | Phase 2 | Epic 1 layout | ✅ Yes |
| Epic 4 (Analytics) | Epic 1 | Pane messages | ✅ Yes |
| Epic 5 (Export) | Epic 1 | Session state | ✅ Yes |

### Within Each Epic

1. Tests written FIRST (should FAIL before implementation)
2. Component scaffolding
3. Core logic implementation
4. Integration with existing components
5. Polish and edge case handling

### Parallel Opportunities

**Setup Phase**: T001-T004 can run in parallel (different files)

**Foundational Phase**: T007-T009 can run in parallel after T005-T006

**Epic 1**: T010-T012, T061-T062 tests in parallel; T014-T015 components in parallel

**Epic 2**: T021-T023 tests in parallel; T026-T027 config panels in parallel

**Epic 3**: T032-T034 tests in parallel

**Cross-Epic**: Once Phase 2 complete, Epics 1, 2, 3 can proceed in parallel with different developers

---

## Parallel Example: Epic 1

```text
# Launch all tests for Epic 1 together:
T010: E2E test for pane add/remove
T011: E2E test for pane toggle visibility
T012: Unit test for ComparisonPlayground
T061: E2E test for pane resize
T062: E2E test for error isolation

# Launch parallel component work after tests:
T014: Create Pane wrapper component (uses T063 PaneErrorBoundary)
T015: Create PaneHeader component
```

---

## Parallel Example: Cross-Epic

```text
# After Foundational (Phase 2) complete, three developers can work in parallel:

Developer A (Epic 1):
  T013 → T014/T015 → T016 → T017 → T018 → T019 → T020

Developer B (Epic 2):
  T024 → T025 → T026/T027 → T028 → T029 → T030 → T031

Developer C (Epic 3):
  T035 → T036 → T037 → T038 → T039 → T040 → T041
```

---

## Implementation Strategy

### MVP First (Epic 1 Only)

1. Complete Phase 1: Setup (T001-T004)
2. Complete Phase 2: Foundational (T005-T009)
3. Complete Phase 3: Epic 1 (T010-T020)
4. **STOP and VALIDATE**: Test multi-pane layout independently
5. Deploy/demo if ready - users can compare side-by-side with basic config

### Incremental Delivery

| Milestone | Epics | User Value |
|-----------|-------|------------|
| MVP | 1 | Multi-pane layout, basic chat in each pane |
| Config | 1 + 2 | Per-pane model/MCP/knowledge selection |
| Prompts | 1 + 2 + 3 | Synchronized and independent prompt modes |
| Analytics | 1-4 | Runtime metrics for comparison |
| Full | 1-5 | Export capability |

### Story Point Estimates (Relative)

| Phase | Tasks | Estimated Effort |
|-------|-------|------------------|
| Setup | 4 | Small |
| Foundational | 5 | Medium |
| Epic 1 | 15 | Large |
| Epic 2 | 11 | Large |
| Epic 3 | 10 | Medium |
| Epic 4 | 7 | Small |
| Epic 5 | 7 | Small |
| Polish | 5 | Small |
| **Total** | **64** | |

---

## Notes

- [P] tasks = different files, no dependencies on incomplete tasks
- [E1-E5] labels map tasks to specific epics for traceability
- Each epic should be independently completable and testable
- Tests should FAIL before implementation (TDD approach)
- Commit after each task or logical group
- Stop at any checkpoint to validate epic independently
- **Blocking dependency**: UX designs needed before starting Epic 1 UI work
