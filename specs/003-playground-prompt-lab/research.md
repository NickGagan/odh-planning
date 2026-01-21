# Research: Gen AI Playground Prompt Lab UI Rework

**Date**: 2026-01-08  
**Feature**: 003-playground-prompt-lab

## Summary

This document consolidates research findings and decisions made during specification and planning for the Playground UI rework.

---

## Decision Log

### 1. Conversation History Persistence

**Decision**: Ephemeral (page state only)

**Rationale**: 
- Chat is for experimentation, not record-keeping
- Simplifies implementation (no backend storage needed)
- Aligns with "no backend changes" scope constraint
- Users can save configurations separately if needed

**Alternatives Considered**:
- Session storage persistence: Rejected (adds complexity, unclear value)
- Backend persistence: Rejected (violates scope constraint)

---

### 2. Model Unavailability Handling

**Decision**: Block message sending + inline error + prompt re-selection

**Rationale**:
- Clear feedback to user about the problem
- Preserves configuration so user can fix and continue
- Prevents confusing partial failures

**Alternatives Considered**:
- Auto-switch to fallback model: Rejected (user may want specific model)
- Silent failure: Rejected (poor UX)

---

### 3. Save Scope

**Decision**: Configuration only (no chat history)

**Rationale**:
- Aligns with ephemeral chat decision
- Saves are for reusable configurations, not test sessions
- Reduces storage requirements

**Alternatives Considered**:
- Config + chat snapshot: Rejected (scope creep, storage complexity)

---

### 4. Accessibility Approach

**Decision**: Phased — basic keyboard nav now, WCAG 2.1 AAA later

**Rationale**:
- Delivers core functionality faster
- Full accessibility is significant effort
- Constitution requires A11y testing; phased approach still complies

**Alternatives Considered**:
- Full WCAG 2.1 AA in first release: Rejected (timeline risk)
- No accessibility: Rejected (constitution violation)

---

### 5. Response Streaming

**Decision**: Required (FR-022)

**Rationale**:
- Modern LLM UX expectation
- Reduces perceived latency
- Aligns with watsonx.ai and similar tools

**Technical Note**: Requires SSE support from inference API (assumed available)

---

### 6. Code Export Format

**Decision**: Deferred

**Rationale**:
- P3 priority feature
- Multiple valid options (Python, cURL, multi-language tabs)
- Can ship Epics 1-3 without this decision

**To Resolve**: Before Epic 4 implementation, clarify with PM/stakeholders

---

## API Assumptions Validated

| API | Assumption | Confidence |
|-----|------------|------------|
| Model list | Returns name, ID, parameter ranges | High (standard pattern) |
| Inference | Supports SSE streaming | Medium (needs verification) |
| Vector stores | Filterable by project | High (standard pattern) |
| Guardrails | Returns active count | Medium (needs verification) |
| Config save/load | Accepts full config payload | Medium (schema TBD) |

**Action Item**: Early integration testing recommended to validate API assumptions before deep implementation.

---

## PatternFly Component Mapping

Based on the prototype and requirements, the following PatternFly components are likely needed:

| UI Element | Likely PatternFly Component |
|------------|----------------------------|
| Two-panel layout | Page + Split layout |
| Configuration tabs | Tabs component |
| Model dropdown | Select / Dropdown |
| Parameter sliders | Slider component |
| Prompt text area | TextArea |
| Knowledge checkboxes | Checkbox group |
| Chat messages | Custom (PF-styled, needs review) |
| Processing indicator | Spinner / Skeleton |
| Header actions | Button group |

**Risk**: Chat message display may require custom styling. If so, must follow constitution override process.

---

## Open Questions (Low Priority)

These do not block implementation but should be resolved eventually:

1. **Conversation history limits**: How many messages before performance degrades?
2. **Long prompt handling**: What happens if system prompt exceeds context window?
3. **Rate limiting UX**: How to communicate rate limits to users?
4. **Extreme parameter values**: Validation or allow model to error?

---

## References

- Prototype: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground
- watsonx.ai Prompt Lab (competitive reference)
- Constitution v1.7.1 (PatternFly, testing, accessibility requirements)

