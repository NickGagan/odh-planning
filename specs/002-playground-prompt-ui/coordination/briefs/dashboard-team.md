# Team Brief: Dashboard Team

**Feature**: Prompt-Centric Gen AI Playground UI (002-playground-prompt-ui)  
**Your Role**: **Implementation Owner**  
**Timeline**: 6 weeks from kickoff  
**Date**: January 7, 2026

---

## Your Responsibilities

You are the **implementation owner** for this feature. You will design, build, test, and deploy the new Playground UI.

**Key Deliverables**:
- Chat-based conversation interface with message history
- Model selection dropdown and switching logic
- Parameter controls (temperature, top-p, max tokens, repetition penalty)
- Configuration builder with tabs (Model, Prompt, Knowledge, MCP, Guardrails)
- Template save/load functionality
- Visual feedback for processing states and errors
- Unit tests (Jest) and E2E tests (Cypress)
- Accessibility compliance (WCAG 2.1 AA)

---

## Requirements Summary

### Must-Have (P1)
1. **Conversational Iteration**: Chat interface where users send messages and receive responses with full history visible
2. **Model Switching**: Users can switch models mid-conversation with context preserved
3. **Parameter Controls**: Sliders/inputs for temperature, top-p, max tokens, repetition penalty

### Should-Have (P2)
4. **Configuration Tabs**: Tabbed interface for Model, Prompt, Knowledge, MCP, Guardrails (non-Model tabs can be placeholders initially)
5. **Template Management**: Save/load complete configurations as named templates

### Nice-to-Have (P3)
6. **Visual Feedback**: Loading states, error messages, success confirmations

**Full Requirements**: See [spec.md](../../spec.md) for 24 detailed functional requirements (FR-001 through FR-024)

---

## Technical Constraints

### Must Follow
- **PatternFly-First** (Constitution Principle I): Use PatternFly components, no custom CSS
- **No Backend Changes**: Use existing `/api/model/inference` and `/api/models` endpoints only
- **Session-Scoped Storage**: Data persists within browser session only (cleared on close)
- **Browser Support**: Last 2 major versions of Chrome, Firefox, Edge, Safari
- **Display Size**: Optimized for 1280px+ desktop (mobile out of scope)

### Performance Targets
- UI interactions: <100ms response time
- Model switching: <5 seconds
- Template operations: <5 seconds
- Display performance: 50 messages without degradation

### Quality Standards
- **Testing**: Unit tests (Jest) + E2E tests (Cypress) required before merge
- **Accessibility**: WCAG 2.1 AA compliance, use `cy.testA11y()` in tests
- **Code Review**: 2 approvals (1 advisor + 1 team member who tested locally)

---

## API Integration

### Existing Endpoints (Use As-Is)

**Model Inference**:
```
POST /api/model/inference
Body: { model, messages[], parameters }
```

**Model Listing**:
```
GET /api/models
Response: { models: [...] }
```

**Key Integration Points**:
- Send **full conversation history** to inference API (don't truncate)
- Model switch: Include full history in next request to new model
- Error handling: Display error messages and actionable guidance from API
- Rate limiting: Handle 429 responses with Retry-After countdown

**Full API Details**: See [contracts/existing-apis.md](../../contracts/existing-apis.md)

---

## Dependencies

| Dependency | Status | Contact | Notes |
|------------|--------|---------|-------|
| Backend Inference API | ✅ Ready | Backend Team | Existing, stable |
| Backend Models API | ✅ Ready | Backend Team | Existing, stable |
| PatternFly React 5.x | ✅ Ready | Platform Team | Available in codebase |
| UX Prototype | ✅ Ready | UX Team | https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground |

**No blockers**: All dependencies are ready for you to start implementation.

---

## Implementation Autonomy

Per **Constitution Principle IX**, you own **all implementation decisions**:

**You Decide**:
- Technology choices (state management, hooks vs. classes)
- Component architecture (file structure, component hierarchy)
- Data flow patterns (Context API, prop drilling, custom hooks)
- Testing strategy (test file organization, mocking approach)
- Development workflow (branch strategy, PR process)

**Plan Specifies** (what you must deliver):
- User requirements and acceptance criteria
- API contracts (request/response formats)
- Performance targets and quality standards
- Integration points and constraints

**Recommendation**: Start with simplest approach (React hooks + sessionStorage), iterate based on discoveries.

---

## Timeline & Milestones

| Week | Focus | Deliverables |
|------|-------|-------------|
| 1 | Setup & P1 Start | Route setup, basic chat UI |
| 2 | P1 Completion | Chat working, model switching, parameters |
| 3 | P2 Features | Config tabs, template save/load |
| 4 | P3 Polish | Visual feedback, error handling |
| 5 | Testing & Bugs | E2E tests, fix issues |
| 6 | Review & Launch | Stakeholder demos, final approval |

**Sync Points**:
- **Week 1**: UX design review (confirm PatternFly component choices)
- **Week 3**: Mid-implementation check with QE (test coverage review)
- **Week 5**: Pre-release demo with all stakeholders

---

## Quality Criteria

### Performance
- [ ] 5 conversational exchanges in <2 minutes
- [ ] Model switching in <5 seconds
- [ ] UI interactions respond in <100ms
- [ ] Template save/load in <5 seconds
- [ ] 50 messages display without performance issues

### Functionality
- [ ] All 6 user stories pass acceptance criteria
- [ ] Full conversation history sent to backend on model switch
- [ ] Parameters applied correctly to requests
- [ ] Templates save and restore complete configuration
- [ ] Errors displayed with actionable guidance

### Code Quality
- [ ] PatternFly components used (no custom CSS)
- [ ] Unit tests for hooks and utilities
- [ ] E2E tests for all user stories
- [ ] Accessibility tests passing (`cy.testA11y()`)
- [ ] Code reviewed by advisor + team member

---

## Risks & Pitfalls

### Watch Out For

1. **Browser Storage Limits**: SessionStorage ~5-10MB. Monitor usage, warn users if approaching.

2. **Don't Truncate Client-Side**: Send full conversation history to backend. Let backend handle context window limits.

3. **Race Conditions**: Cancel pending requests when switching models to avoid wrong responses.

4. **Parameter Validation**: Validate ranges client-side before submission (different models have different limits).

5. **PatternFly Overuse**: Don't create custom components if PatternFly equivalents exist. Check docs first.

6. **Testing Gaps**: Don't skip E2E tests. Required by Constitution Principle IV.

### Get Help With
- **PatternFly Questions**: Check docs, ask in #patternfly channel
- **API Issues**: Contact Backend Team (#backend-team)
- **Design Questions**: Ask UX Team (#ux-team) or review prototype
- **Architecture Decisions**: Schedule time with Dashboard Architect

---

## Success Metrics

You're successful when:
- ✅ All 6 user stories meet acceptance criteria
- ✅ Performance targets met
- ✅ Tests passing (unit + E2E + accessibility)
- ✅ Code reviewed and approved
- ✅ PM sign-off obtained
- ✅ User satisfaction target: 85% "easier to use" rating post-launch

**Post-Launch** (monitor with analytics):
- Template usage: 60% save ≥1 template in first 5 sessions
- Support tickets: 50% reduction in Playground usability issues (3 months)

---

## Resources

### Documentation
- [Feature Spec](../../spec.md) - Complete requirements and acceptance criteria
- [Epic Plan](../../plan.md) - Full context, risks, dependencies
- [API Contracts](../../contracts/existing-apis.md) - Backend integration details
- [Constitution](../../../../.specify/memory/constitution.md) - Development principles

### Design Reference
- UX Prototype: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground

### Communication
- **Daily Standups**: #crimson-dashboard
- **Design Questions**: #ux-team + UX lead
- **API Questions**: #backend-team
- **Blockers**: Escalate to Dashboard Architect or PM

---

## Next Steps

1. **Review this brief** and full spec/plan documents
2. **Attend kickoff meeting** (Week 1) - ask clarifying questions
3. **Choose implementation approach** - discuss with team
4. **Set up development environment** - branch, routing, basic structure
5. **Begin P1 implementation** - start with chat interface

**Questions?** Reach out in #crimson-dashboard or schedule time with Dashboard Architect.

---

**Your Mission**: Build a chat-based Playground that makes AI Engineers 40% more productive. You've got full autonomy on HOW to build it. Let's ship this! 🚀

