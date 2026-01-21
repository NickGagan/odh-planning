# Feature Specification: Playground Compare

**Feature Branch**: `004-playground-compare`  
**Created**: 2026-01-21  
**Status**: Draft  
**Input**: User description: "Multi-instance comparison experience in Playground for comparing models, prompts, MCP servers, guardrails, and knowledge sources side-by-side"

## Epics *(mandatory)*

### Epic 1: Multi-Pane Playground Interface (Priority: P1)

Enable users to create and manage multiple chat instances within a single Playground view, providing the foundation for side-by-side comparison workflows.

**User Value**: Users can spin up multiple chat environments simultaneously without switching contexts or opening separate windows, dramatically accelerating experimentation.

**Technical Considerations**:
- Pane state must be managed at the parent container level; each pane instance is isolated
- Layout must handle dynamic pane count (2-4) without re-rendering sibling panes
- Hidden panes must preserve full state (config + history) without consuming active resources

**Outcomes by Persona**:

_AI Engineer_:
- Add up to 4 chat panes within a single Playground session
- View all active panes side-by-side for direct visual comparison
- Resize or rearrange panes to optimize workspace for different comparison tasks

_Platform User_:
- Toggle individual panes on/off without losing configuration or chat history
- Hidden panes restore with full state intact when toggled back on

---

### Epic 2: Pane Configuration (Priority: P1)

Allow each chat pane to be independently configured with its own model, MCP servers, knowledge sources, and guardrails, ensuring complete isolation between comparison instances.

**User Value**: Users can test different combinations of AI configurations in isolation, enabling precise A/B testing and systematic evaluation of each variable.

**Technical Considerations**:
- Configuration state must be fully isolated per pane; changes must not trigger re-renders in siblings
- Clone operation must deep-copy configuration without shared references
- Permission checks must occur per-pane at configuration time (not just at request time)

**Outcomes by Persona**:

_AI Engineer_:
- Select a different model for each pane to benchmark (e.g., Granite vs. Llama-3 vs. Claude)
- Attach different knowledge sources per pane to compare RAG outputs
- Clone an existing pane's configuration to quickly set up A/B comparisons

_Platform User_:
- Connect different MCP servers to each pane (e.g., GitHub vs. Jira)
- Enable or disable guardrails independently per pane
- Only see resources (models, MCPs, knowledge) they have permission to access

---

### Epic 3: Prompt Management (Priority: P1)

Provide flexible prompt entry modes that support both synchronized prompting across all panes and independent per-pane prompting, accommodating different comparison workflows.

**User Value**: Users can efficiently run the same prompt across all configurations for direct comparison, or craft unique prompts per pane for more nuanced testing scenarios.

**Technical Considerations**:
- Synchronized mode must dispatch to all visible panes simultaneously; streaming responses must be non-blocking across panes
- Mode switching must preserve existing conversation history in all panes
- Each pane must maintain independent conversation context regardless of prompt mode

**Outcomes by Persona**:

_AI Engineer_:
- Enter a prompt once and run it across all panes simultaneously
- Switch between synchronized and independent modes without losing chat history
- Compare model responses to identical input in synchronized mode

_Platform User_:
- Edit prompts independently in each pane when in independent mode
- Test prompt variations against the same model configuration

---

### Epic 4: Comparison Analytics (Priority: P2)

Display runtime metrics and performance data inline with each pane's output for quantitative comparison.

**User Value**: Users can assess performance characteristics like latency and token usage alongside response quality.

**Outcomes by Persona**:

_AI Engineer_:
- See response latency displayed under each pane for speed comparison
- View token counts (input/output) to evaluate cost implications

_Platform User_:
- Metrics consistently positioned across all panes for easy scanning

---

### Epic 5: Export (Priority: P2)

Enable users to export comparison sessions including chat results and configurations for offline review.

**User Value**: Users can save and share comparison work for offline review or team collaboration.

**Outcomes by Persona**:

_AI Engineer_:
- Export all chat results from comparison session for offline review
- Share exported results with colleagues

_Platform User_:
- Export pane configurations to recreate comparison setups later

---

### Edge Cases

- What happens when a model becomes unavailable mid-comparison? Each pane should gracefully handle its own errors without affecting other panes.
- How does the system handle vastly different response times? Panes should display responses as they arrive; slow responses should not block other panes.
- What happens when the user's viewport is too narrow for side-by-side display? The layout should adapt responsively, potentially stacking panes or providing horizontal scrolling.
- How are very long responses handled across multiple panes? Each pane should independently scroll while maintaining the side-by-side layout.
- What happens if an MCP server times out for one pane? The affected pane should display an error while other panes continue operating normally.
- What happens if the user navigates away or refreshes mid-session? Session is lost; user should be warned before destructive navigation if unsaved work exists.

## Performance & Scaling

| Concern | Impact | Consideration |
|---------|--------|---------------|
| **Client Memory** | 4 concurrent panes increase browser memory footprint | Each pane maintains independent state, conversation history, and streaming buffer |
| **API Throughput** | Single user may generate 4x concurrent inference requests | Model Serving team should be aware of changed load patterns per user |
| **Perceived Latency** | In sync mode, slowest pane determines perceived completion | Responses should stream independently; UI should not block on slowest |
| **MCP Connections** | Up to 4 concurrent MCP server connections per session | Connection pooling or limits may be needed at platform level |
| **Degradation** | One slow/failed pane must not affect others | Error isolation and independent streaming are critical |

## System Constraints

- Maximum 4 panes simultaneously (performance constraint)
- Sessions are ephemeral—no persistence across page refresh
- Users can only access models, MCPs, and knowledge sources they have platform permissions for
- Default prompt mode is synchronized; can be switched to independent

## Key Entities

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
