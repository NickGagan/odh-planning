# Data Model: Playground Compare

**Feature**: 004-playground-compare  
**Date**: 2026-01-21

## Overview

This document defines the client-side data model for the Playground Compare feature. All state is ephemeral (in-memory only); no persistence layer is involved.

---

## Entities

### ComparisonSession

The top-level container managing multiple panes within a single Playground view.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Unique session identifier (client-generated UUID) |
| `panes` | `Pane[]` | Array of active panes (2-4 items) |
| `promptMode` | `'synchronized' \| 'independent'` | Current prompt entry mode; default: `'synchronized'` |
| `sharedPromptDraft` | `string \| null` | Draft prompt text when in synchronized mode |
| `visiblePaneIds` | `string[]` | IDs of panes currently displayed (supports toggle on/off) |
| `createdAt` | `Date` | Session creation timestamp |

**State Transitions**:
- `promptMode` can change at any time; conversation history preserved
- `visiblePaneIds` changes when toggling panes; hidden panes retain full state

---

### Pane

An individual chat instance within the comparison session.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Unique pane identifier (client-generated UUID) |
| `configuration` | `PaneConfiguration` | Model, MCPs, knowledge, guardrails settings |
| `messages` | `Message[]` | Conversation history for this pane |
| `isLoading` | `boolean` | Whether inference is in progress |
| `isStreamingWithoutContent` | `boolean` | Streaming started but no content yet |
| `error` | `string \| null` | Current error message, if any |
| `displayOrder` | `number` | Position in side-by-side layout (0-indexed) |

**Relationships**:
- Belongs to exactly one `ComparisonSession`
- Contains one `PaneConfiguration`
- Contains zero or more `Message` entities

---

### PaneConfiguration

Settings applied to a single pane, fully isolated from other panes.

| Field | Type | Description |
|-------|------|-------------|
| `modelId` | `string` | Selected model identifier |
| `mcpServerIds` | `string[]` | Array of enabled MCP server IDs |
| `vectorStoreId` | `string \| null` | Knowledge source (vector store) ID |
| `guardrailsEnabled` | `boolean` | Whether safety guardrails are active |
| `systemInstruction` | `string` | System prompt/instruction text |
| `temperature` | `number` | Model temperature (0.0-1.0) |
| `isStreamingEnabled` | `boolean` | Whether responses stream incrementally |

**Constraints**:
- `modelId` must be a valid model the user has permission to access
- `mcpServerIds` must reference accessible MCP servers
- `temperature` clamped to [0.0, 1.0] range

**Clone Operation**: All fields are primitive or arrays of primitives; shallow copy is sufficient.

---

### Message

A single message (user or bot) within a pane's conversation.

| Field | Type | Description |
|-------|------|-------------|
| `id` | `string` | Unique message identifier |
| `role` | `'user' \| 'bot'` | Message author role |
| `content` | `string` | Message text content |
| `timestamp` | `Date` | When message was sent/received |
| `toolResponse` | `ToolResponse \| null` | MCP tool call result, if applicable |
| `sources` | `Source[] \| null` | RAG sources cited, if applicable |
| `metrics` | `RuntimeMetrics \| null` | Performance data (bot messages only) |
| `isLoading` | `boolean` | Whether message is still being generated |

**Relationships**:
- Belongs to exactly one `Pane`

---

### RuntimeMetrics

Performance data associated with a bot response.

| Field | Type | Description |
|-------|------|-------------|
| `latencyMs` | `number` | Time to first token (or complete response) in milliseconds |
| `inputTokens` | `number` | Number of tokens in the prompt |
| `outputTokens` | `number` | Number of tokens in the response |
| `totalTokens` | `number` | Sum of input + output tokens |

---

### ToolResponse

Result of an MCP tool call (existing type from codebase).

| Field | Type | Description |
|-------|------|-------------|
| `serverLabel` | `string` | MCP server name |
| `toolName` | `string` | Tool that was called |
| `toolArguments` | `object` | Arguments passed to the tool |
| `toolOutput` | `string` | Tool execution result |

---

### Source

RAG citation source (existing type from codebase).

| Field | Type | Description |
|-------|------|-------------|
| `title` | `string` | Source document title |
| `link` | `string` | Reference link (may be internal ID) |

---

## State Shape (TypeScript)

```typescript
interface ComparisonSessionState {
  id: string;
  panes: Map<string, PaneState>;
  promptMode: 'synchronized' | 'independent';
  sharedPromptDraft: string;
  visiblePaneIds: string[];
  paneOrder: string[]; // Ordered list for layout
}

interface PaneState {
  id: string;
  configuration: PaneConfiguration;
  messages: MessageProps[]; // From @patternfly/chatbot
  isLoading: boolean;
  isStreamingWithoutContent: boolean;
  error: string | null;
}

interface PaneConfiguration {
  modelId: string;
  mcpServerIds: string[];
  vectorStoreId: string | null;
  guardrailsEnabled: boolean;
  systemInstruction: string;
  temperature: number;
  isStreamingEnabled: boolean;
}

interface RuntimeMetrics {
  latencyMs: number;
  inputTokens: number;
  outputTokens: number;
  totalTokens: number;
}
```

---

## Entity Relationship Diagram

```
┌─────────────────────────────────────────────────────────┐
│                   ComparisonSession                      │
│  ┌───────────────────────────────────────────────────┐  │
│  │ id, promptMode, sharedPromptDraft, visiblePaneIds │  │
│  └───────────────────────────────────────────────────┘  │
│                          │                               │
│                          │ 1:N                           │
│                          ▼                               │
│  ┌──────────────────────────────────────────────────┐   │
│  │                      Pane                         │   │
│  │  ┌────────────────────────────────────────────┐  │   │
│  │  │ id, displayOrder, isLoading, error         │  │   │
│  │  └────────────────────────────────────────────┘  │   │
│  │                │                 │               │   │
│  │                │ 1:1             │ 1:N           │   │
│  │                ▼                 ▼               │   │
│  │  ┌─────────────────┐    ┌─────────────────┐    │   │
│  │  │ PaneConfiguration│    │    Message      │    │   │
│  │  │  modelId        │    │  id, role       │    │   │
│  │  │  mcpServerIds[] │    │  content        │    │   │
│  │  │  vectorStoreId  │    │  timestamp      │    │   │
│  │  │  guardrailsEnabled│  │  toolResponse?  │    │   │
│  │  │  systemInstruction│  │  sources?       │    │   │
│  │  │  temperature    │    │  metrics?       │    │   │
│  │  └─────────────────┘    └─────────────────┘    │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

---

## Validation Rules

| Entity | Rule | Error |
|--------|------|-------|
| `ComparisonSession` | 2 ≤ `panes.length` ≤ 4 | "Must have 2-4 panes" |
| `ComparisonSession` | `visiblePaneIds` ⊆ `panes.keys()` | "Invalid pane ID" |
| `PaneConfiguration` | `modelId` is non-empty | "Model selection required" |
| `PaneConfiguration` | 0.0 ≤ `temperature` ≤ 1.0 | "Temperature out of range" |
| `Message` | `content` is non-empty (user messages) | "Message cannot be empty" |

---

## Export Format

When exporting a session, the JSON structure follows this schema:

```json
{
  "exportedAt": "2026-01-21T10:30:00Z",
  "sessionId": "uuid",
  "panes": [
    {
      "paneId": "uuid",
      "configuration": { /* PaneConfiguration */ },
      "messages": [
        {
          "role": "user",
          "content": "...",
          "timestamp": "...",
          "metrics": null
        },
        {
          "role": "bot",
          "content": "...",
          "timestamp": "...",
          "metrics": { "latencyMs": 450, "inputTokens": 50, "outputTokens": 120, "totalTokens": 170 }
        }
      ]
    }
  ]
}
```
