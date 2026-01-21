# Team Brief: Guardrails / Safety Team

**Feature**: Playground Multi-Pane Comparison  
**Epic**: 4 — Per-Request Guardrail Toggle  
**Priority**: P2  
**Full Plan**: [plan.md](../../plan.md)

---

## Primary Persona: Alex the AI Engineer (THE BUILDER)

> *"Evaluation methods are largely manual, time-consuming, and repetitive."*

**Who is Alex?** Develops AI-infused applications and needs to understand how guardrails affect model outputs. Currently, testing guardrail impact requires multiple separate requests and manual comparison.

**What Alex needs from us**: Ability to toggle guardrails per-pane so he can compare "response with Safety Filter" vs "response without Safety Filter" side-by-side to understand guardrail impact.

---

## Your Mission

Enable per-request guardrail toggling so **Alex** can compare outputs with different safety configurations across panes (e.g., guardrail ON in Pane 1 vs guardrail OFF in Pane 2).

---

## Requirements (4 Total)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| GR-001 | Guardrail registry API | Returns available guardrails with metadata |
| GR-002 | Per-request guardrail toggle | Guardrails enabled/disabled per request |
| GR-003 | Guardrail application reporting | Response indicates which guardrails were applied |
| GR-004 | Guardrail block handling | Clear indication when guardrail blocks content |

---

## API Contract (Required Output)

### Guardrail List

```yaml
GET /api/v1/guardrails

Response 200:
{
  "guardrails": [
    {
      "id": "safety-filter",
      "name": "Safety Filter",
      "description": "Blocks harmful content generation",
      "category": "safety",
      "enabledByDefault": true
    },
    {
      "id": "pii-redaction",
      "name": "PII Redaction",
      "description": "Masks personal information in responses",
      "category": "compliance",
      "enabledByDefault": false
    }
  ]
}
```

### Integration with Completion

Model Serving will call you with guardrail IDs. You return application results.

```yaml
# Model Serving passes to you:
guardrailIds: ["safety-filter"]  # Overrides defaults for this request

# You return to Model Serving (for inclusion in response):
guardrailsApplied: ["safety-filter"]
guardrailBlocked: false  # or true if content was blocked
```

---

## Key Question for You

**Are guardrails currently toggleable per-request, or only at account/session level?**

The feature requires users to enable guardrails on Pane 1 while disabling on Pane 2 for direct comparison.

---

## Pitfalls to Avoid

⚠️ **Don't require global configuration** — Per-request override is the requirement. Empty `guardrailIds` array should mean "no guardrails for this request."

⚠️ **Don't fail silently when blocking** — If a guardrail blocks content, return `guardrailBlocked: true` so Dashboard can display appropriate UI.

⚠️ **Don't break existing behavior** — This extends current guardrail functionality. Default behavior should remain unchanged when `guardrailIds` is not specified.

---

## Use Case Example

User wants to test if their prompt triggers the safety filter:

| Pane 1 | Pane 2 |
|--------|--------|
| `guardrailIds: ["safety-filter"]` | `guardrailIds: []` |
| Response shows filtered output | Response shows unfiltered output |
| `guardrailsApplied: ["safety-filter"]` | `guardrailsApplied: []` |

---

## Timeline

| Milestone | Date | Your Deliverable |
|-----------|------|------------------|
| **M1** | Week 1 | Confirm per-request support; finalize contract |
| **M2** | Week 3 | Stubbed API available |
| **M4** | Week 7 | Full integration working |
| **M5** | Week 9 | Production ready |

---

## Who You Coordinate With

- **Model Serving**: They call your APIs during completion; you return results to them
- **Dashboard**: They display guardrail list and toggle UI

---

*Your implementation decisions are yours to make. This brief defines WHAT, not HOW.*

