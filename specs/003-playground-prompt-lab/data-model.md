# Data Model: Playground Prompt Lab

**Feature**: 003-playground-prompt-lab  
**Date**: 2026-01-08

> This feature is frontend-only. This document describes the **client-side state model** and the **persisted configuration entity**.

---

## Client-Side State Model

The Playground page maintains ephemeral state in memory (lost on page refresh).

### PlaygroundState

```
PlaygroundState
├── configuration: PlaygroundConfiguration
├── conversation: ConversationState
└── ui: UIState
```

### PlaygroundConfiguration

All settings in the Configuration Builder. This is what gets persisted when user clicks "Save".

```
PlaygroundConfiguration
├── modelId: string (required)
├── parameters
│   ├── temperature: number (0-2, default 0.7)
│   ├── topP: number (0-1, default 0.9)
│   ├── maxTokens: number (1-4096, default 2048)
│   └── repetitionPenalty: number (0-2, default 1)
├── systemPrompt: string (optional)
├── knowledgeSources: string[] (vector store IDs)
├── guardrails: string[] (guardrail IDs)
└── mcpConfig: object (schema TBD)
```

### ConversationState

Ephemeral chat history. NOT persisted.

```
ConversationState
├── messages: Message[]
├── isGenerating: boolean
└── error: Error | null

Message
├── id: string (client-generated UUID)
├── role: "user" | "assistant"
├── content: string
├── timestamp: Date
└── metadata (assistant only)
    ├── modelId: string
    └── modelName: string
```

### UIState

Transient UI state.

```
UIState
├── activeTab: "model" | "prompt" | "knowledge" | "mcp" | "guardrails"
├── hasUnsavedChanges: boolean
├── currentProjectId: string
└── codeViewOpen: boolean
```

---

## Persisted Entity: SavedConfiguration

Stored via `/api/playground/config` endpoints.

```
SavedConfiguration
├── id: string (server-generated)
├── name: string (user-provided)
├── projectId: string
├── config: PlaygroundConfiguration (see above)
├── createdAt: timestamp
├── updatedAt: timestamp
└── createdBy: string (user ID)
```

**Identity**: Unique by `id`. Users may have multiple configurations with the same name.

**Lifecycle**:
1. Created: User clicks "Save", provides name
2. Updated: User loads, modifies, saves again
3. Deleted: Future feature (not in current scope)

**Constraints**:
- `modelId` must reference a valid, available model
- `knowledgeSources` must reference valid vector stores in the project
- `guardrails` must reference valid guardrails in the project
- No chat history is stored

---

## State Transitions

### Configuration State

```
[Empty] → [Model Selected] → [Configured] → [Saved]
                ↓                  ↓
         [Modified] ←──────────────┘
```

- **Empty**: Initial state, no model selected
- **Model Selected**: User has selected a model
- **Configured**: User has made changes to parameters/prompt/etc.
- **Modified**: User has changed a previously saved configuration
- **Saved**: Configuration persisted to backend

### Conversation State

```
[Empty] → [User Message Sent] → [Generating] → [Response Received]
   ↑              ↑                   ↓              ↓
   └──────────────┴───────────────────┴──────────────┘
                          ↓
                    [New Chat]
```

- **Empty**: No messages (welcome state shown)
- **User Message Sent**: User typed and sent a message
- **Generating**: Model is processing, streaming response
- **Response Received**: Full response displayed
- **New Chat**: User clicked "New chat", returns to Empty

---

## Validation Rules

| Field | Rule |
|-------|------|
| modelId | Required; must be in available models list |
| temperature | 0 ≤ value ≤ 2 |
| topP | 0 ≤ value ≤ 1 |
| maxTokens | 1 ≤ value ≤ model's max |
| repetitionPenalty | 0 ≤ value ≤ 2 |
| systemPrompt | Optional; no max length enforced (model handles truncation) |
| knowledgeSources | Each ID must be valid vector store in current project |
| guardrails | Each ID must be valid guardrail in current project |

---

## Notes

- No database schema changes required (backend APIs already exist)
- Client state management approach is implementation decision (not specified here per Constitution Principle IX)
- Message IDs are client-generated for key stability in rendering

