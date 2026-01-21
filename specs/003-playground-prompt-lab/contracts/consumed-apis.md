# Consumed API Contracts: Playground Prompt Lab

**Feature**: 003-playground-prompt-lab  
**Type**: Frontend consuming existing backend APIs  
**Date**: 2026-01-08

> This feature is frontend-only. No new APIs are created. This document specifies the **expected contracts** of APIs the frontend will consume.

---

## Model APIs

### GET /api/models

List available models for selection in the Model tab.

**Expected Response**:
```json
{
  "models": [
    {
      "id": "string",
      "name": "string",
      "displayName": "string",
      "parameters": {
        "temperature": { "min": 0, "max": 2, "default": 0.7 },
        "topP": { "min": 0, "max": 1, "default": 0.9 },
        "maxTokens": { "min": 1, "max": 4096, "default": 2048 },
        "repetitionPenalty": { "min": 0, "max": 2, "default": 1 }
      },
      "available": true
    }
  ]
}
```

**Used By**: Epic 1 (Core Playground Experience - Model tab)

---

### POST /api/inference

Send a message and receive a streamed response.

**Expected Request**:
```json
{
  "modelId": "string",
  "messages": [
    { "role": "system", "content": "string" },
    { "role": "user", "content": "string" },
    { "role": "assistant", "content": "string" }
  ],
  "parameters": {
    "temperature": 0.7,
    "topP": 0.9,
    "maxTokens": 2048,
    "repetitionPenalty": 1
  },
  "knowledgeSources": ["vectorStoreId1", "vectorStoreId2"],
  "guardrails": ["guardrailId1"],
  "mcpConfig": {}
}
```

**Expected Response**: Server-Sent Events (SSE) stream

```text
event: message
data: {"content": "Hello", "done": false}

event: message
data: {"content": " world", "done": false}

event: message
data: {"content": "!", "done": true, "metadata": {"model": "llama-3.1-8b", "timestamp": "2026-01-08T12:00:00Z"}}
```

**Used By**: Epic 1 (Core Playground Experience - Conversation Panel)

**Critical Requirement**: Must support SSE streaming for real-time response display.

---

## Knowledge APIs

### GET /api/vector-stores

List available vector stores for knowledge source selection.

**Expected Query Parameters**:
- `projectId` (optional): Filter by project context

**Expected Response**:
```json
{
  "vectorStores": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "documentCount": 1000,
      "available": true
    }
  ]
}
```

**Used By**: Epic 1 (Core Playground Experience - Knowledge tab)

---

## Guardrails APIs

### GET /api/guardrails

List available guardrail configurations.

**Expected Query Parameters**:
- `projectId` (optional): Filter by project context

**Expected Response**:
```json
{
  "guardrails": [
    {
      "id": "string",
      "name": "string",
      "description": "string",
      "type": "input" | "output" | "both",
      "enabled": true
    }
  ]
}
```

**Used By**: Epic 1 (Core Playground Experience - Guardrails tab)

---

## MCP APIs

### GET /api/mcp/config

Get available MCP configuration options.

**Expected Response**:
```json
{
  "options": [
    {
      "id": "string",
      "name": "string",
      "type": "boolean" | "string" | "number",
      "default": "any",
      "description": "string"
    }
  ]
}
```

**Used By**: Epic 1 (Core Playground Experience - MCP tab)

---

## Project APIs

### GET /api/projects

List available projects for project selector.

**Expected Response**:
```json
{
  "projects": [
    {
      "id": "string",
      "name": "string",
      "displayName": "string"
    }
  ],
  "currentProjectId": "string"
}
```

**Used By**: Epic 3 (Developer Integration - Project selector)

---

## Configuration Persistence APIs

### POST /api/playground/config

Save a playground configuration.

**Expected Request**:
```json
{
  "name": "string",
  "projectId": "string",
  "config": {
    "modelId": "string",
    "parameters": {
      "temperature": 0.7,
      "topP": 0.9,
      "maxTokens": 2048,
      "repetitionPenalty": 1
    },
    "systemPrompt": "string",
    "knowledgeSources": ["vectorStoreId1"],
    "guardrails": ["guardrailId1"],
    "mcpConfig": {}
  }
}
```

**Expected Response**:
```json
{
  "id": "string",
  "createdAt": "2026-01-08T12:00:00Z"
}
```

**Used By**: Epic 2 (Session Management - Save)

---

### GET /api/playground/config/:id

Load a saved playground configuration.

**Expected Response**:
```json
{
  "id": "string",
  "name": "string",
  "projectId": "string",
  "config": {
    "modelId": "string",
    "parameters": { ... },
    "systemPrompt": "string",
    "knowledgeSources": [...],
    "guardrails": [...],
    "mcpConfig": {}
  },
  "createdAt": "2026-01-08T12:00:00Z",
  "updatedAt": "2026-01-08T12:00:00Z"
}
```

**Used By**: Epic 2 (Session Management - Load)

---

### GET /api/playground/configs

List saved configurations for current user/project.

**Expected Query Parameters**:
- `projectId` (optional): Filter by project

**Expected Response**:
```json
{
  "configs": [
    {
      "id": "string",
      "name": "string",
      "updatedAt": "2026-01-08T12:00:00Z"
    }
  ]
}
```

**Used By**: Epic 2 (Session Management - Load picker)

---

## Contract Validation Checklist

Before implementation, validate with backend team:

- [ ] Model list API returns parameter ranges
- [ ] Inference API supports SSE streaming
- [ ] Vector store API supports project filtering
- [ ] Guardrails API returns enabled status
- [ ] MCP config schema is documented
- [ ] Config save/load APIs exist and match expected schema

