# Research: Playground Compare

**Feature**: 004-playground-compare  
**Date**: 2026-01-21  
**Status**: Complete

## Executive Summary

Research confirms the existing Playground architecture supports extension to multi-pane comparison with minimal BFF changes. The frontend can reuse existing hooks (`useChatbotMessages`) per-pane with isolated state. Key technical decisions focus on state isolation patterns and synchronized prompt dispatch.

---

## Research Topics

### 1. Existing Playground Architecture

**Decision**: Extend existing `ChatbotPlayground.tsx` pattern; each pane gets its own hook instances.

**Findings**:
- Current implementation in `packages/gen-ai/frontend/src/app/Chatbot/ChatbotPlayground.tsx`
- State managed via custom hooks: `useChatbotMessages`, `useSourceManagement`, `useFileManagement`, `useAlertManagement`
- Model selection via `ChatbotContext` (React Context)
- Streaming supported via `onStreamData` callback in `llamaStackService.ts`
- Configuration UI in `ChatbotSettingsPanel.tsx` (right-side drawer)

**Rationale**: Hooks are already designed for single-instance use with clear interfaces. Instantiating multiple hook instances (one per pane) achieves isolation without refactoring.

**Alternatives Considered**:
- Redux/global state for all panes → Rejected (unnecessary complexity; panes are independent)
- Single hook managing array of pane states → Rejected (violates hook composition patterns)

---

### 2. State Isolation Strategy

**Decision**: Parent container manages pane registry; each pane is a self-contained component with its own hook instances.

**Findings**:
- `useChatbotMessages` hook manages: messages[], isLoading, streaming state, abort controller
- Each hook instance maintains independent `AbortController` for streaming
- Configuration state (model, MCPs, knowledge, guardrails) currently in component state
- No shared mutable state between potential panes

**Rationale**: React's composition model naturally isolates state per component instance. Wrapping the existing `ChatbotPlayground` component (or extracting a `Pane` component from it) allows multiple instances.

**Key Constraint**: `ChatbotContext` is currently shared (selectedModel, models list). For multi-pane, model selection must move to per-pane state.

---

### 3. Streaming & Non-Blocking Responses

**Decision**: Streaming is already non-blocking; no BFF changes required.

**Findings**:
- `llamaStackService.ts` uses `fetch` with `AbortController` per request
- Streaming handled via `onStreamData` callback, updating state incrementally
- Each hook instance maintains its own `abortControllerRef`
- Responses process independently—slow response in one pane doesn't block others

**Rationale**: The existing architecture supports concurrent streaming naturally. Multiple `useChatbotMessages` instances can run concurrent inference requests.

**Verified in**: `useChatbotMessages.ts` lines 243-324 (streaming implementation)

---

### 4. API Contracts (BFF)

**Decision**: No BFF changes required for core functionality.

**Findings**:
- `/gen-ai/api/v1/responses` endpoint accepts per-request configuration:
  - `model`: Model ID
  - `mcp_servers`: Array of MCP server configs (per-request)
  - `vector_store_ids`: Knowledge source IDs (per-request)
  - `temperature`, `stream`, `instructions`: Per-request parameters
- Guardrails currently configured at server level—need confirmation on per-request toggle

**Open Question**: Guardrails team must confirm if per-request guardrail enable/disable is supported or requires BFF enhancement.

**Rationale**: Existing API already accepts all configurable parameters per-request, enabling per-pane configuration without contract changes.

---

### 5. PatternFly Multi-Pane Layout

**Decision**: Use PatternFly `Flex`/`Grid` or `Split` components for side-by-side layout.

**Findings**:
- `@patternfly/react-core` provides `Flex`, `FlexItem`, `Grid`, `GridItem`, `Split`, `SplitItem`
- `@patternfly/chatbot` `Chatbot` component works in `ChatbotDisplayMode.embedded` (current usage)
- No built-in "multi-chatbot" layout in PatternFly; custom composition required
- Responsive behavior: PatternFly Flex supports `breakpointMods` for responsive layouts

**Rationale**: Standard PatternFly layout components provide the foundation. UX team designs will specify exact layout approach.

**Reference**: Current implementation uses `Drawer` for settings panel—this pattern can be extended.

---

### 6. Synchronized vs. Independent Prompt Mode

**Decision**: Session-level mode toggle; synchronized mode dispatches to all visible pane instances.

**Findings**:
- No existing precedent in codebase for cross-component message dispatch
- Options evaluated:
  1. Callback prop from parent to each pane
  2. Event emitter/pub-sub pattern
  3. Shared ref to dispatch function per pane

**Rationale**: Parent container holds refs/callbacks to each pane's `handleMessageSend`. In synchronized mode, parent intercepts submit and calls all panes. In independent mode, each pane handles its own submit.

**Pattern**:
```
Parent (ComparisonSession)
  ├── promptMode: 'synchronized' | 'independent'
  ├── sharedPromptInput (when synchronized)
  └── paneRefs: Map<paneId, { handleMessageSend, config }>
```

---

### 7. Configuration Cloning

**Decision**: Deep copy of pane configuration object; no shared references.

**Findings**:
- Configuration includes: modelId, mcpServerIds[], vectorStoreId, guardrailsEnabled, systemInstruction, temperature
- All primitive or array values—simple spread/JSON clone sufficient
- No circular references or complex objects

**Rationale**: `structuredClone()` or spread operator handles configuration cloning safely.

---

### 8. Export Functionality

**Decision**: Client-side export; generate JSON/Markdown from in-memory state.

**Findings**:
- No existing export feature in Playground
- Messages stored in hook state as `MessageProps[]` array
- Configuration stored in component state
- Browser `Blob` + `URL.createObjectURL` for download

**Rationale**: Since sessions are ephemeral, export is the only way to preserve work. Client-side generation avoids BFF complexity.

**Format Options**:
- JSON (structured, re-importable in future)
- Markdown (human-readable comparison report)

---

### 9. Runtime Metrics Display

**Decision**: Metrics available from inference response; display inline below each message.

**Findings**:
- `CreateResponseResponse` from BFF includes timing data
- Token counts available in response metadata
- PatternFly Chatbot supports custom content below messages

**Rationale**: Extend message display component to show latency + token count inline.

---

## Open Questions (Resolved)

| Question | Resolution |
|----------|------------|
| How is model selection scoped? | Move from `ChatbotContext` to per-pane state |
| Can multiple streams run concurrently? | Yes—each hook instance has independent abort controller |
| Is BFF change needed for per-pane config? | No—API already accepts per-request config |

## Open Questions (Pending)

| Question | Owner | Status |
|----------|-------|--------|
| Can guardrails be toggled per-request? | Guardrails Team | Awaiting confirmation |
| Multi-pane UX layout specification? | UX Team | Awaiting designs |

---

## Recommendations

1. **Start with Epic 1** (Multi-Pane Interface) once UX designs available
2. **Refactor `ChatbotPlayground` into composable `Pane` component** for reuse
3. **Move model selection to per-pane state** early to unblock Epic 2
4. **Add integration tests for concurrent streaming** (Cypress with multiple pane stubs)
5. **Defer export format decision** to implementation; start with JSON for simplicity
