# Team Brief: QE Team

**Feature**: Prompt-Centric Gen AI Playground UI (002-playground-prompt-ui)  
**Your Role**: **Test Planning & Quality Validation**  
**Timeline**: 6 weeks from kickoff  
**Date**: January 7, 2026

---

## Your Responsibilities

You are responsible for **test strategy, quality validation, and final approval**.

**Key Deliverables**:
- Test plan covering all user stories (Week 2)
- Mid-implementation test coverage review (Week 3)
- E2E test validation and bug reporting (Week 4-5)
- Final quality sign-off before launch (Week 6)

---

## Test Scope

### Functional Testing

**6 User Stories to Validate**:
1. **P1: Conversational Iteration** - Send/receive messages, view history
2. **P1: Model Switching** - Switch models, context preserved
3. **P1: Parameter Controls** - Adjust settings, verify applied
4. **P2: Configuration Tabs** - Navigate tabs, settings persist
5. **P2: Template Management** - Save/load configurations
6. **P3: Visual Feedback** - Loading states, errors, success messages

**Full Acceptance Criteria**: See [spec.md](../../spec.md) - each user story has Given/When/Then scenarios

### Non-Functional Testing

**Performance**:
- [ ] 5 conversational exchanges in <2 minutes
- [ ] Model switching in <5 seconds
- [ ] UI interactions respond in <100ms
- [ ] Template save/load in <5 seconds
- [ ] 50+ messages display without degradation

**Accessibility**:
- [ ] WCAG 2.1 AA compliance
- [ ] Keyboard navigation works
- [ ] Screen reader compatibility
- [ ] Color contrast meets standards

**Browser Compatibility**:
- [ ] Chrome (last 2 versions)
- [ ] Firefox (last 2 versions)
- [ ] Edge (last 2 versions)
- [ ] Safari (last 2 versions)

---

## Test Approach

### Unit Tests (Dashboard Team Responsibility)
Dashboard team will write Jest unit tests for:
- Hooks and utilities
- Component logic
- Session storage operations

**Your Role**: Review test coverage in Week 3, ensure critical paths covered

### E2E Tests (Dashboard Team + QE)
Dashboard team will write Cypress E2E tests for:
- All 6 user stories
- Error scenarios
- Edge cases

**Your Role**:
- Validate E2E tests exist and pass (Week 4)
- Run tests in different browsers (Week 5)
- Report any gaps or failures

### Manual Testing (QE Team)
You will manually test:
- User flows end-to-end
- Edge cases not covered by automation
- Visual design vs. prototype
- Accessibility with screen readers
- Performance under load

**Timeline**: Week 5 intensive testing, Week 6 regression

---

## Edge Cases to Test

### Known Edge Cases (from plan)

1. **Extremely Long Prompts**: What happens when user exceeds context window?
   - Expected: Clear warning, prevent submission or show error

2. **Model Unavailability**: What if selected model is offline?
   - Expected: Clear error message, suggest alternative model

3. **Concurrent Requests**: What if user rapidly submits multiple messages?
   - Expected: Queue or disable send button, clear status

4. **Browser Refresh**: What happens to conversation on refresh?
   - Expected: Lost (session storage cleared) - warn user before navigation

5. **Very Large Responses**: How are long model responses displayed?
   - Expected: Scrollable, no UI breakage

6. **Rate Limiting**: What happens when rate limit hit?
   - Expected: Clear message with countdown timer, retry after wait

7. **Empty Prompts**: Can user submit empty message?
   - Expected: Validation prevents submission

8. **Invalid Parameters**: What if user enters out-of-range values?
   - Expected: Validation prevents submission, show error

---

## Quality Criteria

### Must Pass Before Launch

**Functional**:
- [ ] All 24 functional requirements (FR-001 through FR-024) validated
- [ ] All 6 user stories pass acceptance scenarios
- [ ] Zero P1/P2 bugs outstanding
- [ ] P3 bugs documented with mitigation plans

**Performance**:
- [ ] All performance targets met (see Test Scope section)
- [ ] No performance regressions from current Playground

**Accessibility**:
- [ ] WCAG 2.1 AA compliance validated
- [ ] Cypress `cy.testA11y()` tests passing
- [ ] Manual screen reader testing passed

**Cross-Browser**:
- [ ] Works in all 4 supported browsers (last 2 versions)
- [ ] No browser-specific bugs

---

## Timeline & Deliverables

| Week | QE Activity | Deliverable |
|------|-------------|-------------|
| 1 | **Kickoff** | Understand requirements, attend kickoff meeting |
| 2 | **Test Planning** | Test plan document with coverage matrix |
| 3 | **Test Coverage Review** | Review Dashboard team's unit/E2E tests, provide feedback |
| 4 | **Initial Testing** | Run E2E tests, manual exploratory testing, file bugs |
| 5 | **Intensive Testing** | Performance, accessibility, edge cases, regression |
| 6 | **Final Validation** | Verify all bugs fixed, provide quality sign-off |

**Estimated Effort**: 20-30 hours over 6 weeks

---

## Bug Reporting

### Severity Definitions

- **P1 (Blocker)**: Feature unusable, no workaround (blocks launch)
- **P2 (High)**: Major functionality broken, workaround exists (should fix before launch)
- **P3 (Medium)**: Minor issue, non-critical path (can defer post-launch)
- **P4 (Low)**: Nice-to-have, cosmetic (backlog)

### Filing Bugs
- Use standard bug template
- Link to feature: 002-playground-prompt-ui
- Include: Steps to reproduce, expected vs. actual, screenshots/video
- Tag: Dashboard team

**Target**: Zero P1/P2 bugs at launch

---

## Success Criteria

You're successful when:
- ✅ Test plan covers all user stories and edge cases
- ✅ All automated tests (unit + E2E) reviewed and passing
- ✅ Manual testing completed across browsers
- ✅ Performance and accessibility validated
- ✅ Zero P1/P2 bugs outstanding
- ✅ Quality sign-off provided

**Post-Launch**: Monitor production for 2 weeks, file any new issues

---

## Risks

### Risk 1: Late Discovery of Accessibility Issues
**Mitigation**: Accessibility testing starts Week 3 (not Week 5)

**Your Action**: Flag accessibility gaps early

### Risk 2: Performance Issues with Long Conversations
**Mitigation**: Load testing with 50+ message conversations

**Your Action**: Test performance edge cases explicitly

### Risk 3: Browser-Specific Bugs
**Mitigation**: Cross-browser testing in Week 5

**Your Action**: Test in all 4 browsers, not just Chrome

---

## Communication

### Contact Points
- **Primary**: #qe-team Slack channel
- **Bug Reports**: File in Dashboard repository, tag QE team
- **Test Status**: Daily updates in #crimson-dashboard during Week 5

### Updates Needed
- Test plan shared in Week 2
- Test results shared in Week 5
- Quality sign-off communicated in Week 6

**Notify**: #crimson-dashboard channel

---

## Resources

- [Feature Spec](../../spec.md) - Complete requirements with acceptance criteria
- [Epic Plan](../../plan.md) - Risk register, edge cases, quality criteria
- [UX Prototype](https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground) - Design reference

---

## Next Steps

1. **Review this brief** and spec/plan documents
2. **Attend kickoff meeting** (Week 1)
3. **Create test plan** (Week 2) - share with Dashboard team
4. **Review test coverage** (Week 3) - ensure critical paths tested
5. **Begin testing** (Week 4-5) - file bugs, validate fixes
6. **Provide sign-off** (Week 6) - approve for launch

**Questions?** Reach out in #qe-team or #crimson-dashboard.

---

**Summary**: Ensure quality through comprehensive testing. Your validation prevents issues from reaching users! 🛡️

