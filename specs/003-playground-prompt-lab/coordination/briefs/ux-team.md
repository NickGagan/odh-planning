# Team Brief: UX Team — Playground Prompt Lab UI Rework

**Feature**: 003-playground-prompt-lab  
**Date**: January 8, 2026  
**Priority**: High

---

## Your Role

Provide **design review and sign-off** for the Playground UI rework. The implementation will reference the existing prototype as an inspirational guide.

---

## What's Being Built

A two-panel prompt lab interface for AI Engineers:

- **Left Panel**: Configuration Builder with tabs (Model, Prompt, Knowledge, MCP, Guardrails)
- **Right Panel**: Chat-style conversation with streaming responses
- **Header**: Project selector, Save, New chat, View code

**Reference Prototype**: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground

---

## Design Requirements

### Layout
- Two-panel layout (config left, chat right)
- Tabbed configuration builder
- Clear visual separation between panels

### Configuration Builder
- Model dropdown with parameter sliders
- Large text area for system prompt
- Checkbox list for knowledge sources
- Badge showing active guardrail count
- Help icons with tooltips on parameters

### Conversation Panel
- Chat-style message display
- Clear user/assistant message distinction
- Model attribution (name + timestamp) on responses
- Processing indicator during generation
- Welcome state when empty

### Header
- Project selector dropdown
- Save button
- New chat button
- View code button

---

## Accessibility Requirements

| Phase | Requirement |
|-------|-------------|
| **Initial Release** | Basic keyboard navigation for all interactive elements |
| **Follow-up** | Full WCAG 2.1 AAA compliance |

---

## User Flows to Validate

1. **Configure → Test**: User selects model, writes prompt, sends message, sees response
2. **Iterate**: User modifies prompt, sends another message
3. **Save → Reload**: User saves config, returns later, loads it
4. **New Chat**: User clears conversation while keeping config

---

## Design Sign-off Checklist

Before implementation begins:

- [ ] Two-panel layout approved
- [ ] Tab order and content approved
- [ ] Model parameter controls approved
- [ ] Chat message styling approved
- [ ] Header actions approved
- [ ] Empty/loading/error states defined
- [ ] Keyboard navigation patterns defined

---

## Key Documents

| Document | Location |
|----------|----------|
| Full Spec | `specs/003-playground-prompt-lab/spec.md` |
| Acceptance Criteria | Epics 1-4 in spec.md |

---

## Contact

- **Dashboard Team Lead**: TBD
- **Branch**: `003-playground-prompt-lab`

