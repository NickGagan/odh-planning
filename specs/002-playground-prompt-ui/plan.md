# Epic Plan: Prompt-Centric Gen AI Playground UI

**Branch**: `002-playground-prompt-ui` | **Date**: 2026-01-07 | **Spec**: [spec.md](./spec.md)  
**Target Persona**: Alex the AI Engineer (THE BUILDER)

---

## Executive Summary

Redesign the Gen AI Playground user interface to adopt a chat-based, prompt-lab-style experience that enables rapid conversational iteration with GenAI models. The new experience must allow users to experiment with prompts, switch between models while preserving conversation context, adjust parameters, save configurations as templates, and receive clear visual feedback—all within a unified, intuitive interface.

**Core User Need**: AI Engineers need a streamlined workflow for prompt experimentation that reduces cognitive load and accelerates iteration cycles from concept to production.

**Key Value Proposition**: 40% reduction in time spent on prompt experimentation through conversational UI patterns familiar from modern GenAI tools (ChatGPT, Claude, watsonx.ai Prompt Lab).

---

## Requirements

### User Stories (Prioritized)

All user stories reference **Alex the AI Engineer** persona and include Given/When/Then acceptance criteria. See [spec.md](./spec.md) for complete details.

#### P1: Conversational Prompt Iteration
Users must be able to send messages and receive responses in a chat-based interface with full conversation history visible and accessible.

#### P1: Model Selection and Switching
Users must be able to select different models and switch mid-conversation with full conversation context preserved for the new model.

#### P1: Configuration Builder with Parameter Controls
Users must be able to adjust model parameters (temperature, top-p, max tokens, repetition penalty) through organized, clearly-labeled controls.

#### P2: Configuration Tabs for Advanced Settings
Users must be able to access different configuration categories (Model, Prompt, Knowledge, MCP, Guardrails) through organized tabs.

#### P2: Template Save and Load
Users must be able to save complete playground configurations as named templates and load them later.

#### P3: Clear Visual Feedback
Users must receive real-time status indicators for message processing (pending, streaming, complete, error states).

### Functional Requirements

See [spec.md](./spec.md) for 24 detailed functional requirements (FR-001 through FR-024). Key requirements:

- **Conversation Management**: System must preserve full conversation history within a session
- **Model Context**: When switching models, full conversation history must be provided to the new model
- **Parameter Application**: Parameter changes must apply to all subsequent requests within the session
- **Display Performance**: Interface must display and manage at least 50 messages without performance degradation
- **Template Operations**: Save/load operations for configuration templates
- **Error Handling**: Clear error messages with actionable guidance when requests fail

---

## API Contracts

### Existing Endpoints (No Changes Required)

**Model Inference**:
```
POST /api/model/inference
Request: { model, messages[], parameters }
Response: { id, model, content, metadata }
```

**Model Listing**:
```
GET /api/models
Response: { models: [{ id, name, capabilities, contextWindow, defaultParameters }] }
```

### Contract Requirements

- Inference API must accept **full conversation history** as messages array
- Model responses must include **metadata** (tokens used, processing time, model version)
- Error responses must provide **actionable guidance** for users
- Model list must include **default parameters** for each model
- API must handle **context window limits** gracefully (truncate or error with clear message)

See [contracts/existing-apis.md](./contracts/existing-apis.md) for complete API specifications.

---

## Integration Points

### Backend Integration

- **Existing Inference API**: Frontend integrates with existing `/api/model/inference` endpoint
- **Model Discovery**: Frontend retrieves available models from `/api/models` endpoint
- **Authentication**: Uses existing Red Hat SSO/OAuth flow (no changes)
- **Session Management**: Uses existing browser session cookies (no changes)

### UX Integration

- **Design Reference**: Implementation should align with UX prototype at https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground
- **PatternFly Alignment**: Interface must use PatternFly components and patterns per Constitution Principle I
- **Accessibility**: Must meet WCAG 2.1 AA standards

### Routing Integration

- **New Route**: Playground interface accessible at `/playground` route
- **Navigation**: Must integrate with existing dashboard navigation structure

---

## Dependencies

### Upstream Dependencies

| Dependency | Owner | Status | Required By | Notes |
|------------|-------|--------|-------------|-------|
| Model Inference API | Backend Team | ✅ Ready | Phase 1 | Existing API, no changes needed |
| Model Listing API | Backend Team | ✅ Ready | Phase 1 | Existing API, no changes needed |
| PatternFly React 5.x | Platform Team | ✅ Ready | Phase 1 | Available in existing codebase |
| UX Prototype | UX Team | ✅ Ready | Phase 1 | Reference design complete |

### Downstream Dependencies

None - this is a frontend-only feature with no downstream dependencies.

---

## Constraints

### Technical Constraints

- **No Backend Changes**: Implementation MUST use existing APIs without modifications
- **Browser Compatibility**: Must support last 2 major versions of Chrome, Firefox, Edge, Safari
- **Display Size**: Optimized for desktop 1280px width and above (mobile out of scope)
- **Session Scope**: Data persistence limited to browser session (cleared on browser close)
- **Performance**: UI interactions must respond within 100ms
- **Message Display**: Must handle at least 50 messages without performance degradation

### Business Constraints

- **No New Infrastructure**: Must deploy within existing dashboard infrastructure
- **Authentication**: Must use existing SSO (no new authentication mechanisms)
- **Compliance**: Must adhere to existing data privacy and security policies

### Design Constraints

- **PatternFly-First**: Must use PatternFly components (Constitution Principle I)
- **Accessibility**: Must pass WCAG 2.1 AA standards
- **Consistency**: Interaction patterns must align with watsonx.ai Prompt Lab and similar tools

---

## Quality Criteria

### Performance Targets

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Conversational exchanges | 5 exchanges in < 2 minutes | User testing + analytics |
| Model switching time | < 5 seconds | Automated E2E tests |
| First message success | 90% within 1 minute of opening | User testing + analytics |
| Template operations | < 5 seconds (95% of requests) | Performance monitoring |
| Status indicator updates | < 1 second (99% of operations) | Automated tests |
| UI interaction response | < 100ms | Performance profiling |
| Message display performance | 50 messages, < 100ms interactions | Load testing |

### User Experience Targets

| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Ease of use rating | 85% "easier to use" or better | Post-launch user survey |
| Time reduction | 40% reduction in experimentation time | Comparative user studies |
| Support ticket reduction | 50% fewer usability issues (3 months) | Support ticket analysis |
| Template adoption | 60% save ≥1 template in first 5 sessions | Product analytics |

### Accessibility Standards

- **WCAG 2.1 AA Compliance**: All interactive elements must be keyboard accessible
- **Screen Reader Support**: All content must be properly labeled with ARIA attributes
- **Color Contrast**: Must meet 4.5:1 contrast ratio for text
- **Focus Management**: Logical tab order and visible focus indicators

---

## Risk Register

### Risk 1: Context Window Exhaustion
**Impact**: High | **Likelihood**: Medium

**Description**: Long conversations may exceed model context windows, causing errors or degraded responses.

**Mitigation Strategy**:
- Frontend team: Display token count indicators and warnings when approaching limits
- Backend team: Handle context window limits gracefully (truncate oldest messages or return clear error)
- UX team: Provide user options (clear conversation, summarize context)

**Owner**: Frontend Team (UI warnings) + Backend Team (API handling)

---

### Risk 2: User Resistance to Change
**Impact**: Medium | **Likelihood**: Medium

**Description**: Users familiar with current UI may resist the chat-based interface, leading to adoption challenges.

**Mitigation Strategy**:
- UX team: Create in-app onboarding tooltips and tour feature
- Docs team: Provide migration guide comparing old vs. new workflows
- PM team: Gather early feedback through beta testing program

**Owner**: UX Team + PM Team

---

### Risk 3: Performance Degradation with Long Conversations
**Impact**: Medium | **Likelihood**: Low

**Description**: Displaying many messages may strain browser performance.

**Mitigation Strategy**:
- Frontend team: Implement efficient rendering strategy for message lists
- QE team: Conduct load testing with 50+ message conversations
- Engineering: Monitor performance metrics during beta testing

**Owner**: Frontend Team

---

### Risk 4: Rate Limiting User Frustration
**Impact**: Low | **Likelihood**: Medium

**Description**: Backend rate limits may interrupt user experimentation flow.

**Mitigation Strategy**:
- Frontend team: Display clear messaging with countdown timers when rate limited
- Backend team: Document rate limits in API responses (Retry-After header)
- PM team: Communicate rate limits in user documentation

**Owner**: Frontend Team + Backend Team

---

### Risk 5: Template Feature Discoverability
**Impact**: Low | **Likelihood**: Medium

**Description**: Users may not discover or adopt template save/load functionality.

**Mitigation Strategy**:
- Frontend team: Provide prominent UI hints and pre-populated example templates
- UX team: Include template workflow in onboarding tour
- Analytics: Track template usage and iterate based on data

**Owner**: Frontend Team + UX Team

---

## Pitfalls to Avoid

### Technical Pitfalls

1. **Browser Storage Limits**: Browser sessionStorage has ~5-10MB limit. Monitor usage and warn users if approaching limits.

2. **Model Context Truncation**: Don't truncate conversation history client-side. Send full history to backend and let it handle context window limits based on model capabilities.

3. **Race Conditions**: When switching models mid-conversation, ensure pending requests are cancelled or marked as stale to avoid displaying responses from the wrong model.

4. **Parameter Validation**: Validate parameter ranges client-side to match model capabilities (different models have different max token limits).

5. **Session Loss**: Users may lose work if browser crashes or they accidentally close the tab. Consider warning users before navigation or providing browser-native prompts.

### UX Pitfalls

6. **Over-Complication**: Keep the interface simple and focused on core prompt iteration workflow. Defer advanced features to future releases.

7. **Hidden Configuration**: Don't hide parameter controls or configuration tabs. Make them visible but non-intrusive.

8. **Poor Error Recovery**: When errors occur, provide clear actionable guidance and easy retry options. Don't force users to start over.

9. **Context Loss on Model Switch**: Clearly indicate to users that conversation context is preserved when switching models. Show visual confirmation of the switch.

### Process Pitfalls

10. **Skipping Accessibility**: Don't treat accessibility as an afterthought. Include a11y testing from the beginning (Constitution Principle IV).

11. **Implementation Without Tests**: Don't merge code without comprehensive unit and E2E tests (Constitution Principle IV).

12. **Ignoring PatternFly**: Don't create custom components or CSS when PatternFly equivalents exist (Constitution Principle I).

---

## Acceptance Criteria

### Definition of Ready (Pre-Implementation)

- ✅ User stories reference target personas
- ✅ Acceptance criteria defined (Given/When/Then)
- ✅ Dependencies identified and ready
- ✅ Stakeholders reviewed (PM, Engineering, QE, UX, Docs)
- ✅ Architectural review completed
- ✅ UX designs reviewed and signed off
- ✅ API requirements documented
- ✅ Backend APIs confirmed ready

### Definition of Done (Pre-Release)

Per Constitution Principle III, feature must meet:

- [ ] Code reviewed by Dashboard Advisor + team member who ran it locally
- [ ] Automated tests written and passing (Cypress E2E + Jest unit tests)
- [ ] UI matches UX design prototype
- [ ] Demo recorded showing all user stories
- [ ] Tested using built image (nightly ODH or RC build)
- [ ] UI microcopy reviewed
- [ ] PM sign-off obtained
- [ ] Related UX stories closed
- [ ] Follow-up issues created and linked

### User Story Acceptance

Each user story (1-6) must independently pass its Given/When/Then acceptance scenarios. See [spec.md](./spec.md) for complete scenario definitions.

---

## Success Metrics

### Launch Criteria

Feature is ready for release when:

1. All 6 user stories meet acceptance criteria
2. All Definition of Done items completed
3. Performance targets met (see Quality Criteria section)
4. Accessibility standards met (WCAG 2.1 AA)
5. Zero P1/P2 bugs outstanding
6. Stakeholder sign-offs obtained (PM, UX, QE)

### Post-Launch Monitoring (3 Months)

Monitor these metrics post-launch:

- **Adoption**: % of active users who access Playground at least once
- **Engagement**: Average messages sent per session
- **Template Usage**: % of users who save at least one template
- **Model Switching**: % of sessions with model switch
- **Error Rates**: % of messages resulting in errors
- **Support Tickets**: Count of Playground-related usability issues
- **User Satisfaction**: Survey responses (target: 85% "easier to use" rating)

---

## Cross-Team Coordination

### Sync Points

| Milestone | Teams Involved | Purpose | Timeline |
|-----------|---------------|---------|----------|
| API Contract Review | Frontend, Backend | Confirm existing APIs meet requirements | Week 1 |
| UX Design Review | Frontend, UX | Align on interaction patterns and components | Week 1 |
| Mid-Implementation Check | Frontend, QE | Review test coverage and edge cases | Week 3 |
| Pre-Release Demo | All stakeholders | Validate against acceptance criteria | Week 5 |
| Go/No-Go | PM, Engineering, QE, UX | Final release decision | Week 6 |

### Communication Channels

- **Daily Standups**: #crimson-dashboard channel
- **Design Questions**: #ux-team + UX lead
- **API Questions**: #backend-team + API owners
- **Blockers**: Escalate to Dashboard Architect or PM

---

## Out of Scope (Future Enhancements)

The following are explicitly deferred to future releases:

1. **Server-Side Persistence**: Cross-session conversation recovery requires backend changes
2. **Multi-Model Comparison**: Running multiple models simultaneously requires UI redesign
3. **Conversation Export**: JSON/Markdown/PDF export requires new backend endpoints
4. **Mobile Optimization**: Responsive design for mobile/tablet form factors
5. **Advanced Prompt Engineering**: Few-shot builders, chain-of-thought templates require Prompt tab implementation
6. **Collaborative Features**: Sharing conversations or templates with team members
7. **Custom Model Deployment**: Ability to add new models without backend changes

---

## Reference Materials

### Specification
- [spec.md](./spec.md) - Complete feature specification with user stories and requirements

### API Documentation
- [contracts/existing-apis.md](./contracts/existing-apis.md) - Existing backend API contracts

### Design Reference
- UX Prototype: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground

### Development Standards
- [Constitution](../../.specify/memory/constitution.md) - Development principles and quality gates

---

## Implementation Ownership

**Implementing Team**: Crimson Dashboard Frontend Team

**Stakeholders**:
- **PM**: Product requirements and user acceptance
- **UX**: Design patterns and user experience
- **QE**: Test planning and quality validation
- **Backend**: API support and troubleshooting
- **Docs**: Release notes and user documentation

**Technical Decisions**: Frontend team owns all implementation decisions including technology choices, architecture patterns, component design, and file organization per Constitution Principle IX.

---

## Notes

- This is a **frontend-only feature** with no backend changes required
- **No new infrastructure** or deployment changes needed
- **Target launch**: Within 6 weeks from kickoff
- **Early access**: Consider beta program with select AI Engineers for feedback

---

**Plan Status**: ✅ Ready for Implementation

**Next Steps**:
1. Frontend team: Choose implementation approach and begin development
2. QE team: Create test plan based on acceptance criteria
3. All teams: Attend kickoff meeting to confirm understanding of requirements
