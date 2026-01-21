# Team Brief: QE Team

**Feature**: Playground Multi-Pane Comparison  
**Epic**: 6 — End-to-End Validation  
**Priority**: P1  
**Full Plan**: [plan.md](../../plan.md)

---

## Target Personas to Validate

| Persona | What to Validate |
|---------|------------------|
| **Alex the AI Engineer** | Can complete 2-model comparison in < 60 seconds; 90% first-use success rate |
| **Deena the Data Scientist** | Feature works for exploratory evaluation alongside notebooks |
| **Maude the ML Ops Engineer** | Export data is complete and accurate for production decisions |

**Primary Focus**: Alex's workflow. His pain point is *"evaluation methods are largely manual, time-consuming, and repetitive"* — we must prove this feature solves it.

---

## Your Mission

Validate the complete multi-pane comparison experience works correctly for **Alex, Deena, and Maude** across all integrated services. You're the final gate before release.

---

## Requirements (5 Total)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| QE-001 | Multi-pane E2E tests | Full user flows tested with real backend |
| QE-002 | Concurrent stream testing | 4 simultaneous streams don't cause issues |
| QE-003 | Error isolation testing | Failures in one pane don't cascade |
| QE-004 | Accessibility testing | WCAG 2.1 AA validation |
| QE-005 | Performance testing | No visible lag with 4 concurrent streams |

---

## Test Scenarios to Cover

### Critical User Flows

| Scenario | Description | Priority |
|----------|-------------|----------|
| Model Comparison | Open 2 panes, select different models, send sync prompt, verify both respond | P1 |
| Add/Remove Panes | Start with 2, add to 4, remove back to 2 | P1 |
| Pane Toggle | Disable pane, send sync prompt, verify disabled pane doesn't respond | P1 |
| Mode Switch | Switch between synchronized and independent mode | P1 |
| Export | Complete session, export JSON, verify all data present | P2 |
| Metrics Display | Verify latency, tokens, cost appear after response | P2 |

### Edge Cases

| Scenario | Description | Expected Behavior |
|----------|-------------|-------------------|
| One pane rate limited | 4 panes, one hits rate limit | Rate-limited pane shows error; others continue |
| Model unavailable | Pane's model goes offline mid-session | Error in that pane; others unaffected |
| Network disconnect | Connection drops during streaming | Reconnection indicator; retry option |
| 4 concurrent streams | All 4 panes streaming simultaneously | No dropped frames, no UI freeze |

### Accessibility

| Test | Requirement |
|------|-------------|
| Keyboard navigation | Tab between panes, focus management |
| Screen reader | Streaming content announced |
| Color contrast | Meets WCAG 2.1 AA |
| Reduced motion | Respects prefers-reduced-motion |

---

## Performance Benchmarks

| Metric | Target |
|--------|--------|
| Time to interactive | < 2 seconds |
| First token latency | < 500ms (per pane) |
| Concurrent stream rendering | No dropped frames with 4 streams |
| Memory per pane | < 50MB |

---

## Test Environment Needs

- [ ] Access to all backend services (Model Serving, MCP, Guardrails, RAG)
- [ ] Multiple model types available (Granite, Llama, Claude)
- [ ] Ability to simulate rate limiting
- [ ] Ability to simulate model unavailability

---

## Timeline

| Milestone | Date | Your Focus |
|-----------|------|------------|
| **M1** | Week 1 | Review test requirements; identify gaps |
| **M3** | Week 5 | Begin testing MVP (2-pane model comparison) |
| **M4** | Week 7 | Full E2E test suite execution |
| **M5** | Week 9 | Final validation; sign-off |

---

## Coordination

You'll work closely with Dashboard Team on test execution. Model Serving and other teams need to support your test environment setup.

---

## Deliverables

1. **Test Plan**: Detailed test cases covering all requirements
2. **Test Results**: Pass/fail report with evidence
3. **Bug Reports**: Any issues found, with reproduction steps
4. **Sign-off**: Confirmation that release criteria met

---

*Questions? Reach out to Dashboard Team lead.*

