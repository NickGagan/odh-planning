# Quickstart: Playground Compare

**Feature**: 004-playground-compare  
**Date**: 2026-01-21  
**Audience**: Engineers implementing this feature

## Overview

This guide provides a fast path to understanding the Playground Compare feature and getting started with implementation.

---

## What We're Building

A multi-pane comparison experience in the existing Playground that allows users to:
- Create 2-4 chat panes side-by-side
- Configure each pane independently (model, MCPs, knowledge, guardrails)
- Run prompts in synchronized mode (same prompt → all panes) or independent mode
- View streaming responses from all panes simultaneously
- Export comparison results

---

## Key Documents

| Document | Purpose |
|----------|---------|
| [spec.md](./spec.md) | Feature requirements and acceptance criteria |
| [plan.md](./plan.md) | Technical approach and constitution check |
| [research.md](./research.md) | Codebase findings and technical decisions |
| [data-model.md](./data-model.md) | Entity definitions and state shape |
| [contracts/consumed-apis.md](./contracts/consumed-apis.md) | Existing APIs consumed |

---

## Codebase Orientation

### Where to Look

```
packages/gen-ai/frontend/src/app/
├── Chatbot/
│   ├── ChatbotPlayground.tsx    # ⭐ Current single-pane implementation
│   ├── ChatbotSettingsPanel.tsx # Configuration UI (right drawer)
│   ├── components/              # Reusable UI components
│   └── hooks/
│       ├── useChatbotMessages.ts   # ⭐ Message handling + streaming
│       ├── useSourceManagement.ts  # RAG source handling
│       └── useFileManagement.ts    # File upload handling
├── context/
│   ├── ChatbotContext.tsx       # Model state (shared)
│   └── GenAiContext.tsx         # Project/namespace context
└── services/
    └── llamaStackService.ts     # ⭐ API client for inference
```

### Key Files to Study

1. **`ChatbotPlayground.tsx`** — Understand the current single-pane architecture
2. **`useChatbotMessages.ts`** — Core message handling; will be instantiated per-pane
3. **`llamaStackService.ts`** — API client; see `createResponse` for inference calls
4. **`ChatbotSettingsPanel.tsx`** — Configuration UI that will be replicated per-pane

---

## Technical Approach Summary

### State Isolation Strategy

Each pane gets its own instances of:
- `useChatbotMessages` hook (messages, loading, streaming)
- `useSourceManagement` hook (if RAG enabled per-pane)
- Configuration state (model, MCPs, temperature, etc.)

The parent `ComparisonSession` component manages:
- Pane registry (add/remove/toggle)
- Prompt mode (synchronized vs independent)
- Shared prompt input (when synchronized)
- Layout and visibility

### No BFF Changes Required

The existing `/gen-ai/api/v1/responses` endpoint accepts per-request configuration:
- `model`, `mcp_servers`, `vector_store_ids`, `temperature`, etc.

Multiple concurrent requests are supported naturally.

### Streaming Works Out of the Box

Each `useChatbotMessages` hook manages its own `AbortController`. Concurrent streaming across panes is already supported by the architecture.

---

## Getting Started

### 1. Set Up Local Development

```bash
# From repository root
cd packages/gen-ai

# Start with mock clients (no external dependencies)
make dev-start
```

This starts:
- Frontend dev server on port 8080
- BFF with mock clients on port 8043

### 2. Explore Existing Playground

1. Open http://localhost:8080/gen-ai/playground
2. Select a model, configure MCP servers
3. Send messages and observe streaming
4. Study the settings panel layout

### 3. Run Tests

```bash
# Unit tests
cd packages/gen-ai/frontend
npm test

# E2E tests (requires running server)
cd packages/gen-ai/frontend/src/__tests__/cypress
npm run cypress:open
```

---

## Implementation Roadmap

### Phase 1: Multi-Pane Foundation (Epic 1)

1. Create `ComparisonSession` container component
2. Extract `Pane` component from `ChatbotPlayground`
3. Implement pane add/remove/toggle controls
4. Build side-by-side layout (await UX designs)

### Phase 2: Per-Pane Configuration (Epic 2)

1. Move model selection from `ChatbotContext` to per-pane state
2. Clone configuration functionality
3. Per-pane MCP server selection
4. Per-pane knowledge source selection
5. Guardrails toggle (pending team confirmation)

### Phase 3: Prompt Management (Epic 3)

1. Implement synchronized/independent mode toggle
2. Shared prompt input for synchronized mode
3. Multi-pane dispatch mechanism
4. Mode switching with history preservation

### Phase 4: Analytics & Export (Epics 4-5)

1. Display runtime metrics (latency, tokens)
2. Export session to JSON
3. Export configuration for recreation

---

## Common Patterns

### Creating a New Pane

```typescript
const createPane = (): PaneState => ({
  id: crypto.randomUUID(),
  configuration: {
    modelId: defaultModel,
    mcpServerIds: [],
    vectorStoreId: null,
    guardrailsEnabled: true,
    systemInstruction: DEFAULT_SYSTEM_INSTRUCTIONS,
    temperature: 0.1,
    isStreamingEnabled: true,
  },
  messages: [initialBotMessage()],
  isLoading: false,
  isStreamingWithoutContent: false,
  error: null,
});
```

### Cloning a Pane Configuration

```typescript
const cloneConfiguration = (source: PaneConfiguration): PaneConfiguration => ({
  ...source,
  mcpServerIds: [...source.mcpServerIds], // Shallow copy array
});
```

### Synchronized Prompt Dispatch

```typescript
const handleSynchronizedSubmit = async (prompt: string) => {
  const visiblePanes = getVisiblePanes();
  await Promise.all(
    visiblePanes.map(pane => pane.handleMessageSend(prompt))
  );
};
```

---

## Testing Considerations

### Unit Tests

- Pane isolation: Config changes in one pane don't affect siblings
- Mode switching preserves history
- Clone creates independent configuration

### E2E Tests (Cypress)

- Create 4 panes and configure each differently
- Synchronized mode sends to all visible panes
- Toggle pane off/on preserves state
- Concurrent streaming doesn't block

### Accessibility

- Keyboard navigation between panes
- Screen reader announces pane context
- Focus management on pane add/remove

---

## Questions?

- **Architecture**: Consult [research.md](./research.md)
- **State Shape**: Consult [data-model.md](./data-model.md)
- **APIs**: Consult [contracts/consumed-apis.md](./contracts/consumed-apis.md)
- **Requirements**: Consult [spec.md](./spec.md)

---

## Dependencies to Watch

| Dependency | Status | Impact |
|------------|--------|--------|
| UX Designs | ⏳ Pending | Blocks Epic 1 UI work |
| Guardrails per-request | ⏳ Pending | May affect Epic 2 scope |
