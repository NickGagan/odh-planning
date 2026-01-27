# Consumed APIs: Playground Compare

**Feature**: 004-playground-compare  
**Date**: 2026-01-21

## Overview

This document describes the existing BFF APIs consumed by the Playground Compare feature. No new endpoints are required; the feature leverages existing per-request configuration capabilities.

---

## Endpoints Used

### 1. Create Response (Chat Inference)

**Endpoint**: `POST /gen-ai/api/v1/responses`  
**Source**: `packages/gen-ai/bff/openapi/src/gen-ai.yaml`

Used for sending prompts to models and receiving responses (streaming or non-streaming).

#### Request

```typescript
interface CreateResponseRequest {
  input: string;                    // User prompt
  model: string;                    // Model ID
  instructions?: string;            // System instruction
  stream?: boolean;                 // Enable streaming (default: true)
  temperature?: number;             // Model temperature (0.0-1.0)
  vector_store_ids?: string[];      // Knowledge source IDs for RAG
  chat_context?: ChatMessage[];     // Conversation history
  mcp_servers?: MCPServerConfig[];  // MCP server configurations
}

interface ChatMessage {
  role: 'user' | 'assistant';
  content: string;
}

interface MCPServerConfig {
  url: string;
  token?: string;
  enabled_tools?: string[];
}
```

#### Response (Non-Streaming)

```typescript
interface CreateResponseResponse {
  content: string;                  // Model response text
  sources?: Source[];               // RAG citations
  toolCallData?: MCPToolCallData;   // MCP tool call results
  // Metrics available in response headers or body (TBD)
}
```

#### Response (Streaming)

- Uses Server-Sent Events (SSE)
- Chunks delivered via `onStreamData` callback
- Final response includes processed content and sources

#### Multi-Pane Usage

Each pane makes independent requests with its own configuration:
- Different `model` per pane ✅
- Different `mcp_servers` per pane ✅
- Different `vector_store_ids` per pane ✅
- Concurrent requests supported ✅

---

### 2. List Models

**Endpoint**: `GET /gen-ai/api/v1/models`

Used to populate model selection dropdowns in each pane.

#### Response

```typescript
interface ListModelsResponse {
  models: Model[];
}

interface Model {
  id: string;
  name: string;
  provider: string;
  capabilities: string[];
}
```

#### Multi-Pane Usage

Single request; response cached and shared across all panes. Model availability doesn't change per-pane.

---

### 3. List MCP Servers

**Endpoint**: `GET /gen-ai/api/v1/mcp/servers`

Used to populate MCP server selection in each pane's configuration.

#### Response

```typescript
interface ListMCPServersResponse {
  servers: MCPServer[];
}

interface MCPServer {
  id: string;
  name: string;
  url: string;
  status: 'connected' | 'disconnected' | 'error';
  tools: MCPTool[];
}
```

#### Multi-Pane Usage

Single request; response cached and shared. Each pane independently selects which servers to enable.

---

### 4. List Vector Stores (Knowledge Sources)

**Endpoint**: `GET /gen-ai/api/v1/vectorstores`

Used to populate knowledge source selection in each pane's configuration.

#### Response

```typescript
interface ListVectorStoresResponse {
  vector_stores: VectorStore[];
}

interface VectorStore {
  id: string;
  name: string;
  file_count: number;
  status: 'ready' | 'processing' | 'error';
}
```

#### Multi-Pane Usage

Single request; response cached and shared. Each pane independently selects which vector store to attach.

---

### 5. Check MCP Server Status

**Endpoint**: `GET /gen-ai/api/v1/mcp/servers/:id/status`

Used to verify MCP server connectivity per pane configuration.

#### Response

```typescript
interface MCPServerStatusResponse {
  id: string;
  status: 'connected' | 'disconnected' | 'error';
  latency_ms?: number;
  error_message?: string;
}
```

#### Multi-Pane Usage

Called per-server when enabling in a pane's configuration. Results may differ if server state changes.

---

## API Behavior Notes

### Concurrent Requests

The BFF supports concurrent requests from the same client session. Multi-pane comparison relies on this for:
- Synchronized mode: 2-4 simultaneous inference requests
- Independent mode: Requests fire as user submits per-pane

### Streaming Isolation

Each streaming request maintains its own SSE connection. Aborting one pane's stream (via `AbortController`) does not affect other panes.

### Error Handling

Errors are isolated per-request. A model timeout in one pane returns an error for that pane only; other panes continue normally.

---

## Guardrails (Pending Confirmation)

**Current Status**: Guardrails configuration mechanism needs confirmation from Guardrails team.

**Question**: Can guardrails be enabled/disabled per-request, or is it a server-level configuration?

**Scenarios**:
1. **Per-request toggle supported**: Add `guardrails_enabled: boolean` to `CreateResponseRequest`
2. **Server-level only**: Guardrails state is global; per-pane toggle displays warning that guardrails apply to all panes

**Action**: Awaiting Guardrails team response before finalizing Epic 2 scope.

---

## No New Endpoints Required

The existing API surface supports all Playground Compare requirements:

| Requirement | API Support |
|-------------|-------------|
| Per-pane model selection | `model` field in request ✅ |
| Per-pane MCP servers | `mcp_servers` field in request ✅ |
| Per-pane knowledge source | `vector_store_ids` field in request ✅ |
| Per-pane system instruction | `instructions` field in request ✅ |
| Per-pane temperature | `temperature` field in request ✅ |
| Concurrent streaming | Independent SSE connections ✅ |
| Per-pane guardrails | **Pending confirmation** |
