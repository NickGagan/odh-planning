# Team Brief: QE Team — Playground Prompt Lab UI Rework

**Feature**: 003-playground-prompt-lab  
**Date**: January 8, 2026  
**Priority**: High

---

## Your Role

Plan and execute **quality assurance testing** for the Playground UI rework. This is a frontend-only change with no backend modifications.

---

## What's Being Tested

A two-panel prompt lab interface:

| Component | Test Focus |
|-----------|------------|
| Configuration Builder | Tab switching, model selection, parameter controls, state preservation |
| Conversation Panel | Message send, streaming display, model attribution, processing indicator |
| Session Management | New chat, save/load configs, unsaved changes warning |
| Developer Integration | View code, copy to clipboard, project switching |

---

## Test Scenarios by Epic

### Epic 1: Core Playground Experience (P1)

**Configuration Builder:**

| Scenario | Expected Result |
|----------|-----------------|
| View two-panel layout | Config panel left, conversation panel right |
| Select model from dropdown | Model name displayed, parameters populated |
| Adjust temperature slider | Value updates in real-time (slider + input) |
| Enter system prompt | Text preserved across tab switches |
| Select multiple knowledge sources | Checkboxes reflect selection |
| Configure guardrails | Badge shows count of active guardrails |
| Switch tabs repeatedly | All settings preserved |

**Conversation Panel:**

| Scenario | Expected Result |
|----------|-----------------|
| Send message with configured model | Message appears, response streams in |
| View streaming response | Characters appear incrementally |
| Check response attribution | Model name and timestamp visible |
| Send while model generating | Blocked or queued (TBD) |
| Model becomes unavailable | Error shown, can select new model |
| Page refresh during conversation | Conversation lost (ephemeral) |
| No conversation exists | Welcome state displayed |

### Epic 2: Session Management (P2)

| Scenario | Expected Result |
|----------|-----------------|
| Click "New chat" | Conversation clears, config preserved |
| Save configuration | Success confirmation, config persisted |
| Load saved configuration | All settings restored |
| Navigate away with unsaved changes | Warning dialog appears |
| Dismiss warning and navigate | Changes lost |

### Epic 3: Developer Integration (P3)

| Scenario | Expected Result |
|----------|-----------------|
| Click "View code" | Code panel displays |
| Copy code | Clipboard contains valid code |
| Switch project | Available resources update |

---

## Edge Case Testing

| Edge Case | Test Approach |
|-----------|---------------|
| Model unavailable mid-session | Mock API to return unavailable status |
| Network error during streaming | Interrupt connection mid-response |
| Very long response | Send prompt that generates extensive output |
| Extreme parameter values | Set all parameters to min/max |
| Rapid tab switching | Automation to switch tabs quickly |
| Concurrent message sends | Attempt to send while generating |

---

## Accessibility Testing

**Initial Release Requirements:**
- All interactive elements keyboard accessible
- Tab order logical
- Focus visible on active elements
- Screen reader announces key changes

**Tools**: axe-core via `cy.testA11y()`

---

## Test Environment

- **Frontend**: Local dev build or nightly ODH build
- **Backend**: Existing APIs (no changes)
- **Browser**: Chrome, Firefox, Safari (per standard matrix)

---

## Acceptance Criteria Reference

Full Given/When/Then scenarios are in the spec:
- Epic 1: 6 acceptance criteria
- Epic 2: 5 acceptance criteria
- Epic 3: 5 acceptance criteria
- Epic 4: 4 acceptance criteria

See `specs/003-playground-prompt-lab/spec.md` for details.

---

## Definition of Done (QE Sign-off)

- [ ] All acceptance criteria validated
- [ ] Edge cases tested
- [ ] Accessibility audit passed
- [ ] Cross-browser testing complete
- [ ] Regression tests updated
- [ ] No blocking defects

---

## Key Documents

| Document | Location |
|----------|----------|
| Full Spec | `specs/003-playground-prompt-lab/spec.md` |
| API Contracts | `specs/003-playground-prompt-lab/contracts/consumed-apis.md` |

---

## Contact

- **Dashboard Team Lead**: TBD
- **Branch**: `003-playground-prompt-lab`

