# Feature Specification: Playground Compare

**Feature Branch**: `004-playground-compare`  
**Created**: 2026-01-21  
**Status**: Draft  
**Input**: User description: "Multi-instance comparison experience in Playground for comparing models, prompts, MCP servers, guardrails, and knowledge sources side-by-side"

## Epics & User Stories *(mandatory)*

### Epic 1: Multi-Pane Playground Interface (Priority: P1)

Enable users to create and manage multiple chat instances within a single Playground view, providing the foundation for side-by-side comparison workflows.

**User Value**: Users can spin up multiple chat environments simultaneously without switching contexts or opening separate windows, dramatically accelerating experimentation.

**User Stories**:

- **Story 1.1**: As an AI engineer, I want to add multiple chat panes to my Playground so that I can compare different configurations simultaneously.
- **Story 1.2**: As a platform user, I want to toggle individual panes on or off so that I can focus on specific comparisons without losing my other configurations.
- **Story 1.3**: As an AI engineer, I want to view all active panes side-by-side so that I can directly compare outputs visually.
- **Story 1.4**: As a platform user, I want to resize or rearrange panes so that I can optimize my workspace for different comparison tasks.

**Acceptance Criteria**:

1. **Given** a user is in the Playground, **When** they request a new pane, **Then** a new chat instance appears alongside existing panes.
2. **Given** multiple panes are open, **When** the user toggles a pane off, **Then** the pane is hidden but its configuration is preserved.
3. **Given** a hidden pane exists, **When** the user toggles it back on, **Then** the pane reappears with its previous configuration and chat history intact.
4. **Given** 2-4 panes are visible, **When** the user views the Playground, **Then** all panes are displayed side-by-side with adequate space for comparison.

---

### Epic 2: Pane Configuration (Priority: P1)

Allow each chat pane to be independently configured with its own model, MCP servers, knowledge sources, and guardrails, ensuring complete isolation between comparison instances.

**User Value**: Users can test different combinations of AI configurations in isolation, enabling precise A/B testing and systematic evaluation of each variable.

**User Stories**:

- **Story 2.1**: As an AI engineer, I want to select a different model for each pane so that I can benchmark Granite, Llama-3, and Claude on identical prompts.
- **Story 2.2**: As a platform user, I want to connect different MCP servers to each pane so that I can evaluate GitHub vs. Jira tool integrations.
- **Story 2.3**: As an AI engineer, I want to attach different knowledge sources to each pane so that I can compare outputs based on different document sets.
- **Story 2.4**: As a platform user, I want to enable or disable guardrails per pane so that I can assess safety guardrail effectiveness on the same input.
- **Story 2.5**: As an AI engineer, I want to clone an existing pane's configuration to a new pane so that I can quickly set up A/B comparisons by modifying just one variable.

**Acceptance Criteria**:

1. **Given** a user is configuring a pane, **When** they select a model, **Then** only that pane uses the selected model while others remain unchanged.
2. **Given** multiple panes exist, **When** the user enables an MCP server on one pane, **Then** other panes are not affected by that configuration.
3. **Given** a pane has a knowledge source attached, **When** another pane is configured, **Then** each pane's knowledge source selection remains independent.
4. **Given** guardrails are enabled on one pane, **When** another pane has guardrails disabled, **Then** each pane processes inputs according to its own guardrail settings.
5. **Given** a configured pane exists, **When** the user clones it, **Then** a new pane is created with identical configuration settings (model, MCPs, knowledge sources, guardrails).

---

### Epic 3: Prompt Management (Priority: P1)

Provide flexible prompt entry modes that support both synchronized prompting across all panes and independent per-pane prompting, accommodating different comparison workflows.

**User Value**: Users can efficiently run the same prompt across all configurations for direct comparison, or craft unique prompts per pane for more nuanced testing scenarios.

**User Stories**:

- **Story 3.1**: As an AI engineer, I want to enter a prompt once and run it across all panes simultaneously so that I can compare model responses to identical input.
- **Story 3.2**: As a platform user, I want to edit prompts independently in each pane so that I can test prompt variations against the same model.
- **Story 3.3**: As an AI engineer, I want to switch between synchronized and independent prompt modes so that I can adapt my workflow to different testing needs.

**Acceptance Criteria**:

1. **Given** synchronized mode is active, **When** the user submits a prompt, **Then** all visible panes receive and process the same prompt simultaneously.
2. **Given** independent mode is active, **When** the user edits a prompt in one pane, **Then** other panes maintain their own prompt text.
3. **Given** synchronized mode is active, **When** the user switches to independent mode, **Then** each pane retains its current conversation and allows independent edits going forward.
4. **Given** prompts have been executed, **When** the user switches between modes, **Then** existing chat history in each pane is preserved.

---

### Epic 4: Comparison Analytics (Priority: P2)

Display runtime metrics and performance data inline with each pane's output, enabling quantitative comparison alongside qualitative response evaluation.

**User Value**: Users can assess not just response quality but also performance characteristics like latency and token usage, informing both quality and efficiency decisions.

**User Stories**:

- **Story 4.1**: As an AI engineer, I want to see response latency displayed under each pane so that I can compare model speed.
- **Story 4.2**: As a platform user, I want to see token counts for each response so that I can evaluate cost implications across models.
- **Story 4.3**: As an AI engineer, I want to view additional runtime metrics so that I can make informed decisions about model selection.

**Acceptance Criteria**:

1. **Given** a response is generated, **When** the output appears, **Then** latency information is displayed inline below the response.
2. **Given** a response is generated, **When** the output appears, **Then** token usage (input and output tokens) is displayed inline below the response.
3. **Given** multiple panes have responses, **When** the user views the comparison, **Then** metrics are consistently positioned across all panes for easy scanning.

---

### Epic 5: Export (Priority: P2)

Enable users to export comparison sessions including chat results and configurations for offline review and future reference.

**User Value**: Users can save and share their comparison work for offline review, documentation, or team collaboration, preserving valuable experimentation results.

**User Stories**:

- **Story 5.1**: As an AI engineer, I want to export all chat results from my comparison session so that I can review outputs offline or share with colleagues.
- **Story 5.2**: As a platform user, I want to export the configuration of each pane so that I can recreate comparison setups later.

**Acceptance Criteria**:

1. **Given** a comparison session is active, **When** the user requests an export, **Then** chat content from all panes is included in the export.
2. **Given** a comparison session is active, **When** the user requests an export, **Then** each pane's configuration (model, MCPs, knowledge sources, guardrails) is included.

---

### Edge Cases

- What happens when a model becomes unavailable mid-comparison? Each pane should gracefully handle its own errors without affecting other panes.
- How does the system handle vastly different response times? Panes should display responses as they arrive; slow responses should not block other panes.
- What happens when the user's viewport is too narrow for side-by-side display? The layout should adapt responsively, potentially stacking panes or providing horizontal scrolling.
- How are very long responses handled across multiple panes? Each pane should independently scroll while maintaining the side-by-side layout.
- What happens if an MCP server times out for one pane? The affected pane should display an error while other panes continue operating normally.
- What happens if the user navigates away or refreshes mid-session? Session is lost; user should be warned before destructive navigation if unsaved work exists.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow users to create multiple chat panes within a single Playground session *(Epic 1)*
- **FR-002**: System MUST support a minimum of 2 and a maximum of 4 visible panes simultaneously *(Epic 1)*
- **FR-003**: System MUST provide controls to toggle individual panes on/off while preserving their state *(Epic 1)*
- **FR-004**: System MUST display active panes in a side-by-side layout for direct comparison *(Epic 1)*
- **FR-005**: System MUST allow independent model selection for each pane *(Epic 2)*
- **FR-006**: System MUST allow independent MCP server configuration for each pane *(Epic 2)*
- **FR-007**: System MUST allow independent knowledge source attachment for each pane *(Epic 2)*
- **FR-008**: System MUST allow independent guardrail configuration for each pane *(Epic 2)*
- **FR-009**: System MUST ensure complete configuration isolation between panes *(Epic 2)*
- **FR-010**: System MUST allow users to clone an existing pane's configuration to a new pane *(Epic 2)*
- **FR-011**: System MUST provide a synchronized prompt mode where one input runs across all visible panes *(Epic 3)*
- **FR-012**: System MUST provide an independent prompt mode where each pane has its own editable prompt *(Epic 3)*
- **FR-013**: System MUST allow users to switch between synchronized and independent prompt modes *(Epic 3)*
- **FR-014**: System MUST display response latency inline with each pane's output *(Epic 4)*
- **FR-015**: System MUST display token usage (input/output) inline with each pane's output *(Epic 4)*
- **FR-016**: System MUST support export of chat results from all panes *(Epic 5)*
- **FR-017**: System MUST support export of pane configurations *(Epic 5)*
- **FR-018**: System MUST respect existing platform permissions—users can only configure panes with models, MCPs, and knowledge sources they are authorized to access *(Epic 2)*

### Key Entities

- **Comparison Session**: A Playground session containing multiple panes; tracks session-level state including prompt mode and pane arrangement
- **Pane**: An individual chat instance within a comparison session; contains its own configuration, conversation history, and display state
- **Pane Configuration**: The settings applied to a single pane including model selection, MCP servers, knowledge sources, and guardrail settings
- **Prompt Mode**: Session-level setting determining whether prompts are synchronized across panes or independent per pane; defaults to synchronized mode
- **Runtime Metrics**: Performance data associated with each response including latency and token counts

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can create, configure, and run at least 4 simultaneous chat instances within a single Playground session
- **SC-002**: Users can complete a model comparison task (same prompt across 3+ models) without switching windows or tabs
- **SC-003**: Configuration changes in one pane do not affect any other pane's settings or outputs
- **SC-004**: All visible panes display responses and runtime metrics in a directly comparable side-by-side layout
- **SC-005**: Users can export a complete comparison session (all chats and configurations) in a single action
- **SC-006**: Switching between synchronized and independent prompt modes preserves all existing chat history
- **SC-007**: Individual pane failures (model errors, timeouts) do not disrupt other active panes

## Cross-Team Dependencies

| Team | Requirement | Type | Notes |
|------|-------------|------|-------|
| **Model Serving** | Support concurrent model inference requests from multiple panes | Capacity | Load patterns change—single user may hit 4 models simultaneously |
| **MCP Team** | Per-pane MCP server connections | Integration | Each pane may connect to different MCP servers; concurrent tool calls expected |
| **Guardrails Team** | Per-request guardrail configuration | Integration | Confirm guardrails can be toggled independently per request context (not session-wide) |
| **Knowledge Team** | Per-pane RAG source attachment | Integration | Multiple knowledge source connections active in one session |
| **UX Team** | Multi-pane layout design | Design | Side-by-side layout, prompt mode toggle, config cloning, metrics display, responsive behavior |
| **QE Team** | Expanded test coverage | Testing | Combinatorial testing across pane configs, sync modes, concurrent responses, edge cases |
| **Platform/Backend** | Permissions integration | Integration | Existing authZ must work for per-pane resource access validation |

### Blocking Dependencies

- **UX Team**: Layout designs needed before UI implementation can begin
- **Guardrails Team**: Must confirm per-request guardrail toggle is feasible (vs. session-level only)

### Informational (Capacity/Awareness)

- **Model Serving**: FYI on changed load patterns (4x concurrent requests per user possible)
- **QE Team**: Test matrix expansion—early awareness for capacity planning

## Clarifications

### Session 2026-01-21

- Q: Does a comparison session persist when user navigates away or refreshes the browser? → A: Sessions are ephemeral—lost on navigation/refresh (no persistence)
- Q: What is the maximum number of panes allowed? → A: 4 panes maximum (performance constraint)
- Q: Which prompt mode is active by default when starting a new session? → A: Synchronized mode (shared prompt input)
- Q: Can all users access all resources in comparison panes? → A: Respect existing platform permissions per user
- Q: Can users duplicate an existing pane's configuration to a new pane? → A: Yes, allow cloning pane configurations

## Assumptions

- Comparison sessions do not persist across page refreshes or navigation; users must manually export to preserve their work
- Users have access to multiple models, MCP servers, and knowledge sources through the existing platform (subject to their existing permissions)
- The existing Playground infrastructure supports the configuration options (models, MCPs, guardrails, knowledge sources) that will be exposed per pane
- Users are familiar with basic Playground functionality and understand the concepts of models, MCPs, guardrails, and knowledge sources
- The platform can handle concurrent requests from multiple panes without significant performance degradation
- Export format will follow existing platform conventions for data export (specific format to be determined during implementation)
