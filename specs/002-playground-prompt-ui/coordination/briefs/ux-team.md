# Team Brief: UX Team

**Feature**: Prompt-Centric Gen AI Playground UI (002-playground-prompt-ui)  
**Your Role**: **Design Validation & Accessibility Review**  
**Timeline**: 6 weeks from kickoff  
**Date**: January 7, 2026

---

## Your Responsibilities

You are responsible for **design validation and user experience quality**.

**Key Deliverables**:
- Design review and PatternFly component guidance (Week 1)
- Onboarding/tour design (tooltips, first-use experience) (Week 3)
- Accessibility validation (WCAG 2.1 AA compliance) (Week 5)
- Final UX sign-off before launch (Week 6)

---

## Design Reference

**UX Prototype**: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground

This prototype is the **design reference** for implementation. Dashboard team will build to match this look and feel using PatternFly components.

---

## User Requirements Summary

### Target Persona
**Alex the AI Engineer** (THE BUILDER)
- Driven by urgency and practicality
- Seeks quickest path to integrate LLM
- Pain point: Manual, time-consuming prompt engineering

### Core User Flows

1. **Conversational Iteration**: User sends messages, receives responses, builds on conversation
2. **Model Switching**: User selects different model mid-conversation, context preserved
3. **Parameter Tuning**: User adjusts temperature, top-p, max tokens via sliders/inputs
4. **Template Management**: User saves configuration, loads it later
5. **Visual Feedback**: User sees loading states, errors, success confirmations

**Full User Stories**: See [spec.md](../../spec.md) for 6 detailed user stories with acceptance scenarios

---

## Design Requirements

### Layout
- **Split-panel interface**: Configuration builder (left) + Chat interface (right)
- **Configuration tabs**: Model, Prompt, Knowledge, MCP, Guardrails (tabbed navigation)
- **Chat view**: Conversation thread with user/assistant messages, input at bottom

### Key Components Needed
- **Chat Interface**: Message list (scrollable), message input (textarea), send button
- **Model Selector**: Dropdown with model names, clear indication of active model
- **Parameter Controls**: Sliders or number inputs for temperature, top-p, max tokens, repetition penalty
- **Configuration Tabs**: Tab navigation for different configuration categories
- **Template Manager**: Save modal, template list, load action

### PatternFly Alignment
Dashboard team will use **PatternFly components only** (Constitution Principle I):
- `Page`, `Panel`, `Split` for layout
- `Tabs` for configuration sections
- `DataList` or `Card` for messages
- `TextArea`, `Slider`, `NumberInput` for inputs
- `Button`, `Dropdown` for actions
- `Alert`, `Spinner` for feedback

**Your Input Needed**: Confirm PatternFly component choices align with design intent (Week 1 review)

---

## Accessibility Requirements

### WCAG 2.1 AA Compliance
- **Keyboard Navigation**: All interactive elements accessible via Tab/Enter
- **Screen Reader Support**: ARIA labels on all controls and messages
- **Color Contrast**: 4.5:1 minimum for text
- **Focus Indicators**: Visible focus states on all interactive elements

### Specific Considerations
- **Chat History**: Screen readers should announce new messages
- **Model Selector**: Clear ARIA label ("Select model")
- **Parameter Sliders**: Keyboard adjustable, values announced
- **Error Messages**: Announced to screen readers, with actionable guidance
- **Loading States**: "Processing" announced, not just visual spinner

**Your Validation** (Week 5): Run accessibility audit, confirm compliance

---

## Onboarding & First-Use Experience

### User Needs
- New users should understand interface **without documentation**
- First message should be successful **within 1 minute**
- Tour should be **optional but helpful**

### Design Requests (Week 3)

1. **Tooltips**: Helpful hints on first hover/focus
   - Model selector: "Choose which AI model to use"
   - Parameters: Brief explanation of temperature, top-p, etc.
   - Templates: "Save this configuration for reuse"

2. **Tour Feature** (optional):
   - Brief walkthrough on first visit
   - Highlights: chat input, model selector, parameter controls, template save
   - User can skip or dismiss

3. **Empty State**:
   - When chat is empty, show example prompts or starter message
   - E.g., "Hello! Welcome to the Playground. Try asking me a question."

**Deliverable**: Design mockups or specs for onboarding elements

---

## Timeline & Sync Points

| Week | UX Activity | Deliverable |
|------|-------------|-------------|
| 1 | **Design Review** | Confirm PatternFly components, approve layout approach |
| 3 | **Onboarding Design** | Provide tooltips, tour, empty state designs |
| 5 | **Accessibility Audit** | Run audit, document issues, approve fixes |
| 6 | **Final Sign-Off** | Confirm UI matches design intent, approve for launch |

**Estimated Effort**: 8-12 hours over 6 weeks

---

## Success Criteria

You're successful when:
- ✅ UI visually matches prototype reference design
- ✅ PatternFly components used appropriately
- ✅ WCAG 2.1 AA compliance validated
- ✅ Onboarding elements present and effective
- ✅ User satisfaction target met: 85% "easier to use" rating post-launch

---

## Risks

### Risk 1: PatternFly Limitations
**Scenario**: Dashboard team finds PatternFly components don't perfectly match design

**Mitigation**:
- Week 1 design review identifies gaps early
- Compromise on PatternFly-native alternatives rather than custom CSS
- Document decisions in `pf-overrides` if truly necessary

**Your Action**: Be flexible on PatternFly constraints while maintaining UX quality

### Risk 2: Accessibility Gaps
**Scenario**: Initial implementation misses accessibility requirements

**Mitigation**:
- Week 5 audit catches issues before launch
- Dashboard team fixes before Week 6 sign-off

**Your Action**: Provide clear, actionable feedback on accessibility issues

---

## Communication

### Contact Points
- **Primary**: #ux-team Slack channel
- **Design Questions**: Tag UX lead or schedule design review
- **Accessibility**: Use accessibility channel for specific guidance

### Updates Needed
- Prototype changes affecting design reference
- New PatternFly component releases affecting design approach
- User feedback from beta testing

**Notify**: #crimson-dashboard channel

---

## Resources

- [Feature Spec](../../spec.md) - User stories and acceptance criteria
- [UX Prototype](https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground) - Design reference
- [PatternFly React Docs](https://www.patternfly.org/v4/) - Component library

---

## Next Steps

1. **Review UX prototype** and this brief
2. **Attend kickoff meeting** (Week 1) - design review session
3. **Provide PatternFly guidance** - confirm component choices
4. **Design onboarding elements** (Week 3)
5. **Conduct accessibility audit** (Week 5)
6. **Final sign-off** (Week 6)

**Questions?** Reach out in #ux-team or schedule time with UX lead.

---

**Summary**: Validate design, ensure accessibility, sign off before launch. Your eye for detail ensures Alex the AI Engineer has a delightful experience! ✨

