# Team Brief: Docs Team — Playground Prompt Lab UI Rework

**Feature**: 003-playground-prompt-lab  
**Date**: January 8, 2026  
**Priority**: Medium (docs needed for release)

---

## Your Role

Prepare **user documentation and release notes** for the Playground UI rework.

---

## What's Changing

The Gen AI Playground page is being redesigned with a new two-panel layout:

| Before | After |
|--------|-------|
| Fragmented configuration | Unified Configuration Builder (left panel) |
| Basic chat | Enhanced conversation with streaming (right panel) |
| Limited workflow actions | Save, New chat, View code in header |

---

## User-Facing Changes

### New UI Layout
- **Configuration Builder** (left panel): Tabbed interface for Model, Prompt, Knowledge, MCP, Guardrails
- **Conversation Panel** (right panel): Chat-style interface with streaming responses
- **Header**: Project selector, Save, New chat, View code buttons

### New Features
- **Save configurations**: Users can save their playground setup (model, parameters, prompt, knowledge sources, guardrails)
- **View code**: Users can see code that replicates their configuration
- **Project context**: Users can switch between projects

### Changed Behavior
- **Streaming responses**: Model responses now appear character-by-character
- **Ephemeral chat**: Conversation history is lost on page refresh (not saved)
- **Unsaved changes warning**: Users are prompted when navigating away with unsaved config

---

## Documentation Updates Needed

| Document | Update Type |
|----------|-------------|
| Playground overview | Major rewrite |
| Getting started guide | Update screenshots and flow |
| Configuration reference | New section for tabs |
| FAQ | Add streaming, save/load, ephemeral chat |

---

## Key User Flows to Document

1. **Configure a playground session**
   - Select model → adjust parameters → write prompt → add knowledge → configure guardrails

2. **Test a prompt**
   - Send message → view streaming response → iterate

3. **Save and reload configuration**
   - Click Save → name config → return later → load config

4. **Export to code**
   - Configure session → click View code → copy code

---

## Terminology

| Term | Definition |
|------|------------|
| Configuration Builder | Left panel with tabs for setup |
| System Prompt | Instructions defining model behavior |
| Knowledge Sources | Vector stores for RAG |
| Guardrails | Safety and content filters |
| MCP | Model Context Protocol settings |

See glossary in `specs/003-playground-prompt-lab/spec.md` for full definitions.

---

## Screenshots Needed

- [ ] Full two-panel layout
- [ ] Model tab with parameter sliders
- [ ] Prompt tab with text area
- [ ] Knowledge tab with checkboxes
- [ ] Guardrails tab with badge
- [ ] Chat with streaming response
- [ ] Save dialog
- [ ] View code panel
- [ ] Project selector

---

## Release Notes Draft

```
### Gen AI Playground UI Redesign

The Gen AI Playground has been redesigned with a modern, prompt-lab-style interface:

**New Features:**
- Two-panel layout: Configuration (left) and Conversation (right)
- Tabbed configuration for Model, Prompt, Knowledge, MCP, and Guardrails
- Streaming responses for real-time feedback
- Save and load playground configurations
- View generated code for integration

**Note:** Conversation history is now ephemeral and is not saved between sessions.
```

---

## Timeline

Documentation should be ready before feature release. Coordinate with PM for release date.

---

## Key Documents

| Document | Location |
|----------|----------|
| Full Spec | `specs/003-playground-prompt-lab/spec.md` |
| Glossary | End of spec.md |

---

## Contact

- **Dashboard Team Lead**: TBD
- **Branch**: `003-playground-prompt-lab`

