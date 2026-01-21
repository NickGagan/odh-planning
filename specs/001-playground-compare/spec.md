# Feature Specification: Playground Multi-Pane Comparison

**Feature Branch**: `001-playground-compare`  
**Created**: 2026-01-07  
**Status**: Ready  
**Input**: User description: "Multi-pane comparison experience in Playground for comparing AI model configurations side-by-side"

## Target Personas

> Reference: [Constitution — Target Personas](../../.specify/memory/constitution.md#target-personas)

| Persona | Role | Relevance to This Feature |
|---------|------|---------------------------|
| **Alex the AI Engineer** | THE BUILDER — Develops and deploys AI-infused applications | **Primary user**. Needs to quickly compare models, test prompts, and evaluate configurations before integration. |
| **Deena the Data Scientist** | THE INNOVATOR — Develops and evaluates core AI/ML models | **Secondary user**. May use for model evaluation experiments alongside notebook work. |
| **Maude the ML Ops Engineer** | THE AUTOMATOR — Automates AI/ML lifecycle | **Occasional user**. Reviews model performance metrics; may use export data for production decisions. |

**Pain Points Addressed**:
- Alex's **Evaluation Deficiencies**: "Evaluation methods are largely manual, time-consuming, and repetitive" → Multi-pane comparison speeds up model evaluation
- Alex's **Prompt Management**: "Manual and time-consuming prompt engineering" → Synchronized prompts enable rapid A/B testing
- The **Evaluation Bottleneck**: "Crisis of confidence in evaluating GenAI systems" → Side-by-side comparison with metrics builds confidence

## Clarifications

### Session 2026-01-07

- Q: When a synchronized prompt triggers rate limiting on one or more models, what should happen? → A: Show rate limit error per-pane; other panes continue (isolated failure)
- Q: Should there be a limit on conversation turns per pane? → A: No limit; browser memory is the constraint
- Q: What level of accessibility compliance is required? → A: WCAG 2.1 AA compliance
- Q: Should the system warn users about data sensitivity? → A: One-time informational banner on first use
- Q: How should users clear pane content during a session? → A: "Clear All" button only (panes should be tied together for consistent comparison state)

## Problem Statement

AI engineers and platform users need a way to compare results across multiple configurations — including different models, prompts, MCP servers, guardrails, and knowledge sources — within a single environment. Currently, Playground allows testing of a single chat setup, which slows experimentation and fragments workflows.

## Goal

Provide a multi-instance comparison experience in the Playground that enables users to:
- Spin up multiple chat panes side-by-side, each with unique configurations
- Run synchronized or independent prompts across all panes
- Toggle features (guardrails, MCPs, data sources) per instance

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Model Benchmarking (Priority: P1)

**As Alex the AI Engineer**, I want to compare outputs from different models (e.g., Granite, Llama-3, Claude) using the same prompt so that I can quickly select the best model for my application without repetitive manual testing.

**Why this priority**: This is the core value proposition — comparing models is the primary reason users need multi-pane functionality. Directly addresses Alex's pain point: *"50% of our SW engineering effort is spent custom fitting evaluation to our needs."*

**Independent Test**: Can be fully tested by opening 2-3 panes, selecting a different model in each, sending the same prompt, and comparing the side-by-side outputs.

**Acceptance Scenarios**:

1. **Given** Alex is on the Playground Compare page with 2 panes visible, **When** he configures Pane 1 with Granite and Pane 2 with Llama-3, **Then** each pane shows its selected model in the header.
2. **Given** Alex has 2 panes configured with different models, **When** he types a prompt and sends it in synchronized mode, **Then** both panes display their respective model's response side-by-side.
3. **Given** both panes have completed responses, **When** Alex views the results, **Then** he can see runtime metrics (response time, token count) under each pane for direct comparison.

---

### User Story 2 - Synchronized Prompt Mode (Priority: P1)

**As Alex the AI Engineer**, I want to send the same prompt to all active panes simultaneously so that I can compare outputs without retyping — eliminating the manual, repetitive evaluation process.

**Why this priority**: Synchronized prompts eliminate the friction of manual copy-paste and are essential for fair comparisons. This is tightly coupled with Story 1.

**Independent Test**: Can be fully tested by enabling sync mode, typing one prompt, and verifying it executes across all enabled panes.

**Acceptance Scenarios**:

1. **Given** synchronized mode is enabled (default), **When** Alex types a prompt in the shared input field, **Then** he sees a single prompt input area at the bottom of the page.
2. **Given** Alex has 3 panes enabled and synchronized mode active, **When** he submits a prompt, **Then** all 3 panes begin streaming responses simultaneously.
3. **Given** Alex has 4 panes but only 2 are enabled, **When** he submits a synchronized prompt, **Then** only the 2 enabled panes receive and process the prompt.

---

### User Story 3 - Pane Configuration (Priority: P1)

**As Alex the AI Engineer**, I want to configure each pane independently (model, MCP servers, guardrails, knowledge sources) so that I can isolate variables for comparison — testing one change at a time.

**Why this priority**: Configuration isolation is what makes comparisons meaningful. Users must be able to change one variable while keeping others constant.

**Independent Test**: Can be tested by opening a pane's configuration panel, changing settings, and verifying changes only affect that specific pane.

**Acceptance Scenarios**:

1. **Given** Alex clicks the settings/config icon on Pane 2, **When** the configuration panel opens, **Then** he sees options for Model, MCP Servers, Guardrails, and Knowledge Sources.
2. **Given** Alex changes the model selection in Pane 1, **When** he closes the config panel, **Then** Pane 1 shows the new model and Pane 2 remains unchanged.
3. **Given** Alex enables guardrail "Safety Filter" on Pane 1 only, **When** he sends a synchronized prompt, **Then** Pane 1's response is filtered while Pane 2's is not.

---

### User Story 4 - Add/Remove Panes (Priority: P2)

**As Alex the AI Engineer**, I want to add or remove chat panes so that I can compare as many or as few configurations as needed for my evaluation.

**Why this priority**: Flexibility in pane count adds value but isn't required for basic 2-pane comparison MVP.

**Independent Test**: Can be tested by clicking add/remove buttons and verifying pane count changes correctly.

**Acceptance Scenarios**:

1. **Given** Alex sees 2 panes (default), **When** he clicks "Add Pane", **Then** a 3rd pane appears with default configuration.
2. **Given** Alex has 4 panes (maximum), **When** he attempts to add another pane, **Then** the "Add Pane" button is disabled and indicates the limit is reached.
3. **Given** Alex has 3 panes, **When** he clicks remove on Pane 2, **Then** Pane 2 is removed and the layout adjusts to show remaining panes.
4. **Given** Alex has 2 panes (minimum), **When** he attempts to remove a pane, **Then** the remove option is disabled or hidden.

---

### User Story 5 - Independent Prompt Mode (Priority: P2)

**As Alex the AI Engineer**, I want to send different prompts to different panes so that I can test prompt variations on the same model — optimizing my prompt engineering workflow.

**Why this priority**: Prompt optimization is a key use case but secondary to model comparison. Directly addresses Alex's pain point: *"Manual and time-consuming prompt engineering and testing."*

**Independent Test**: Can be tested by switching to independent mode, typing different prompts in each pane, and verifying each executes separately.

**Acceptance Scenarios**:

1. **Given** Alex toggles from synchronized to independent mode, **When** the mode changes, **Then** each pane displays its own prompt input field.
2. **Given** Alex is in independent mode, **When** he types "Explain AI" in Pane 1 and "Explain ML" in Pane 2, **Then** each pane shows only its own prompt.
3. **Given** Alex is in independent mode with different prompts, **When** he clicks send on Pane 1, **Then** only Pane 1 processes its prompt; Pane 2 remains idle.

---

### User Story 6 - A/B Toggle (Priority: P2)

**As Alex the AI Engineer**, I want to enable/disable individual panes so that I can focus on specific comparisons without removing configurations I might need later.

**Why this priority**: Useful for iterative testing but users can achieve similar results by just not looking at certain panes.

**Independent Test**: Can be tested by toggling a pane off, sending a sync prompt, and verifying the disabled pane doesn't execute.

**Acceptance Scenarios**:

1. **Given** Alex clicks the enable/disable toggle on Pane 3, **When** the pane is disabled, **Then** it appears visually dimmed or marked as inactive.
2. **Given** Pane 2 is disabled, **When** Alex sends a synchronized prompt, **Then** Pane 2 does not receive the prompt or generate a response.
3. **Given** Pane 2 is disabled with existing conversation history, **When** Alex re-enables it, **Then** the conversation history is preserved.

---

### User Story 7 - Export Results (Priority: P3)

**As Alex the AI Engineer**, I want to export my comparison session (configurations + responses) so that I can share results with Maude (ML Ops) for production decisions or Deena (Data Science) for further analysis.

**Why this priority**: Export is valuable for documentation and collaboration but not required for the core comparison experience.

**Independent Test**: Can be tested by running a comparison session, clicking export, and verifying the downloaded file contains all pane data.

**Acceptance Scenarios**:

1. **Given** Alex has completed a comparison session with 3 panes, **When** he clicks "Export", **Then** he sees options for export format (JSON, CSV).
2. **Given** Alex selects JSON export, **When** the file downloads, **Then** it contains each pane's configuration, conversation history, and metrics.
3. **Given** Alex selects CSV export, **When** the file downloads, **Then** it contains a flattened view of metrics suitable for spreadsheet analysis.

---

### User Story 8 - Runtime Metrics Display (Priority: P2)

**As Alex the AI Engineer (or Maude the ML Ops Engineer)**, I want to see performance metrics (latency, tokens, estimated cost) for each response so that I can evaluate model efficiency and cost alongside output quality.

**Why this priority**: Metrics are important for informed decisions but the feature works without them for basic qualitative comparison. Maude especially needs this data for production deployment decisions.

**Independent Test**: Can be tested by sending a prompt and verifying metrics appear below the response.

**Acceptance Scenarios**:

1. **Given** a pane has completed a response, **When** Alex views the pane, **Then** he sees latency (time to first token, total time) displayed.
2. **Given** a pane has completed a response, **When** Alex views the metrics, **Then** he sees input token count, output token count, and estimated cost.
3. **Given** multiple panes have responses, **When** Alex compares metrics, **Then** he can visually identify which model was faster, more token-efficient, or more cost-effective.
4. **Given** Alex is comparing an expensive model (e.g., Claude) with a cheaper model (e.g., Granite), **When** both responses complete, **Then** he can see the cost difference to inform his model selection.

---

### Edge Cases

- What happens when a pane's selected model becomes unavailable mid-session?
  - The pane should display an error state with option to select a different model; other panes continue functioning normally.
  
- What happens when one pane times out while others complete?
  - The timed-out pane shows an error with retry option; completed panes display their results.
  
- How does the system handle network disconnection during streaming?
  - All active streams pause with a reconnection indicator; on reconnection, users can retry failed requests.
  
- What happens when switching between sync/independent mode with in-flight requests?
  - A confirmation dialog appears if requests are active; switching cancels pending requests.
  
- How does the layout respond on smaller screens?
  - Panes stack vertically or offer a tab-based view; visible pane count automatically adjusts.
  
- What happens when a synchronized prompt triggers rate limiting on one or more models?
  - Rate limit errors display per-pane while other panes continue processing (isolated failure). Each rate-limited pane shows the error with retry option; successfully responding panes are unaffected.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow users to create between 2 and 4 chat panes (hard limit of 4 total).
- **FR-002**: System MUST allow each pane to be configured independently with: model selection, MCP server selection, guardrail toggles, and knowledge source selection.
- **FR-003**: System MUST provide a "Synchronized Mode" where a single prompt input broadcasts to all enabled panes.
- **FR-004**: System MUST provide an "Independent Mode" where each pane has its own prompt input field.
- **FR-005**: System MUST display responses from all panes in a side-by-side layout for visual comparison.
- **FR-006**: System MUST allow individual panes to be enabled/disabled without removing their configuration.
- **FR-007**: System MUST display runtime metrics (latency, token counts, estimated cost) inline below each response.
- **FR-008**: System MUST isolate errors to individual panes — one pane failing should not affect others.
- **FR-009**: System MUST support streaming responses that update in real-time for each pane.
- **FR-010**: System MUST allow export of session data including all pane configurations, conversations, and metrics.
- **FR-011**: System MUST maintain pane configuration when switching between synchronized and independent modes.
- **FR-012**: System MUST preserve conversation history when toggling panes on/off.
- **FR-013**: System MUST display estimated cost per response based on model pricing and token usage.
- **FR-014**: System MUST meet WCAG 2.1 AA accessibility standards, including keyboard navigation between panes, screen reader announcements for streaming content, and sufficient color contrast.
- **FR-015**: System MUST display a one-time informational banner on first use informing users that data is processed by selected models.
- **FR-016**: System MUST provide a "Clear All" button that resets conversation history across all panes simultaneously (no per-pane clear).

### Key Entities

- **CompareSession**: Represents an active comparison workspace containing multiple panes, prompt mode setting, and session metadata.
- **ChatPane**: An individual chat instance with its own configuration, conversation history, status (idle/streaming/complete/error), and runtime metrics.
- **PaneConfiguration**: Settings for a single pane including selected model, enabled MCP servers, active guardrails, and knowledge sources.
- **RuntimeMetrics**: Performance data for a response including latency to first token, total duration, input tokens, output tokens, and estimated cost.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Alex can complete a basic 2-model comparison (configure panes, send prompt, view results) in under 60 seconds.
- **SC-002**: System supports 4 concurrent streaming responses without visible lag or frame drops.
- **SC-003**: 90% of users (primarily Alex personas) successfully complete their first comparison session without assistance or documentation.
- **SC-004**: Users report the multi-pane interface as "easy to use" in post-session feedback (target: 4+ out of 5 rating).
- **SC-005**: Time to complete model evaluation tasks is reduced by at least 50% compared to single-pane workflows — addressing Alex's evaluation bottleneck.
- **SC-006**: Each pane displays response metrics within 1 second of completion.
- **SC-007**: Export function produces complete, accurate data that matches the on-screen session.

## Assumptions

- Users (primarily Alex the AI Engineer) have access to at least one AI model through the platform.
- Existing Playground infrastructure supports the models, MCP servers, guardrails, and knowledge sources that will be configurable per pane.
- Platform authentication/authorization is already handled; this feature inherits existing user permissions.
- Hard limit of 4 total panes per session (no hidden/scrollable panes beyond the visible limit).
- Synchronized mode is the default prompt mode since most comparison workflows use identical prompts.
- Sessions are ephemeral — data clears on page refresh (no persistence in initial release).
- Model pricing data is available via platform APIs for cost estimation display.
- Conversation history per pane has no artificial limit; browser memory is the natural constraint.

## Future Enhancements (Out of Scope for Initial Release)

- **Session Persistence**: Save comparison sessions to server with named sessions, enabling users to resume long-running evaluations across browser sessions. This will require backend storage and session management APIs.
