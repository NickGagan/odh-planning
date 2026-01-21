# Feature Specification: Gen AI Playground Prompt Lab UI Rework

**Feature Branch**: `003-playground-prompt-lab`  
**Created**: January 8, 2026  
**Status**: Draft  
**Input**: User description: "Rework Gen AI Playground UI to adopt prompt-lab-style look and feel similar to watsonx.ai Prompt Lab"

## Problem Statement

The current Gen AI Playground UI does not align with modern prompt-centric workflows or user expectations established by tools like watsonx.ai Prompt Lab. While functionally capable, the experience is fragmented and does not provide a clear, intuitive flow for prompt iteration, model experimentation, and configuration management. This creates unnecessary friction for AI Engineers and slows iteration speed.

## Proposed Solution

Rework the Gen AI Playground front-end to adopt a prompt-lab-style layout and interaction pattern. This restructures the UI around a two-panel design: a configuration builder on the left and a conversation/chat panel on the right, enabling prompt-driven experimentation with clear visual feedback.

## Scope

**In Scope:**
- UI layout restructuring for the Playground page
- Interaction patterns and flow improvements
- Visual design updates aligned with prompt-lab patterns

**Out of Scope:**
- Backend or API changes
- Model serving, evaluation logic, or data ingestion behavior changes
- Changes to other Gen AI studio pages (AutoRAG, Prompt lab, API keys, etc.)
- Navigation or information architecture changes outside the Playground page

---

## Epics & User Stories *(mandatory)*

### Epic 1: Core Playground Experience (Priority: P1)

The complete two-panel prompt lab interface enabling AI Engineers to configure experiments and test prompts interactively. This epic delivers the foundational experience: a Configuration Builder (left panel) with tabbed organization for all settings, and a Conversation Panel (right panel) with streaming chat capabilities.

**User Value**: AI Engineers can configure their complete experiment setup and immediately test it through an interactive chat interface—all in a single, cohesive view that enables rapid prompt iteration.

**User Stories**:

*Configuration Builder:*
- **Story 1.1**: As an AI Engineer, I want to select a model and adjust its parameters (temperature, top P, max tokens, repetition) in the Model tab, so I can configure how the model behaves before testing
- **Story 1.2**: As an AI Engineer, I want to write and edit a system prompt in a dedicated Prompt tab, so I can define the model's behavior and context
- **Story 1.3**: As an AI Engineer, I want to connect vector stores as knowledge sources in the Knowledge tab, so I can test RAG scenarios
- **Story 1.4**: As an AI Engineer, I want to configure MCP settings in a dedicated tab, so I can test specific context protocol configurations
- **Story 1.5**: As an AI Engineer, I want to configure guardrails in a dedicated tab, so I can test how safety filters affect responses

*Conversation Panel:*
- **Story 1.6**: As an AI Engineer, I want to send messages in a chat interface, so I can test my prompt and model configuration
- **Story 1.7**: As an AI Engineer, I want to see model responses with clear attribution (model name, timestamp), so I know which model generated each response
- **Story 1.8**: As an AI Engineer, I want to see a visual indicator when the model is processing, so I know my request is being handled
- **Story 1.9**: As an AI Engineer, I want to see a welcome state when no conversation exists, so I understand how to begin

**Acceptance Criteria**:

*Layout:*
1. **Given** I am on the Playground page, **When** I view the interface, **Then** I see a two-panel layout with configuration builder on the left and conversation panel on the right

*Configuration Builder:*
2. **Given** I am on the Playground page, **When** I view the configuration builder, **Then** I see tabs for Model, Prompt, Knowledge, MCP, and Guardrails
3. **Given** the Model tab is open, **When** I select a model and adjust parameters, **Then** values update in real-time with slider position and numeric input
4. **Given** I am in the Prompt tab, **When** I type in the text area, **Then** my system prompt is captured and preserved across tab switches
5. **Given** I am in the Knowledge tab, **When** I check vector store checkboxes, **Then** those knowledge sources are connected for this session
6. **Given** I am in the Guardrails tab with active guardrails, **When** I view the tab label, **Then** I see a badge indicating the count of active guardrails
7. **Given** I have configured settings in any tab, **When** I switch to another tab and return, **Then** all my settings are preserved

*Conversation Panel:*
8. **Given** I am on the Playground page, **When** I view the conversation panel, **Then** I see a message input field at the bottom
9. **Given** I have configured a model, **When** I type a message and press send, **Then** my message appears in the conversation and a streaming response is generated
10. **Given** the model responds, **When** I view the response, **Then** I see the model name and timestamp clearly attributed
11. **Given** the model is generating a response, **When** I view the conversation panel, **Then** I see a clear visual indicator of processing
12. **Given** no conversation exists, **When** I view the conversation panel, **Then** I see a welcome state with guidance on how to begin

---

### Epic 2: Session Management (Priority: P2)

Workflow actions that allow AI Engineers to manage their playground sessions—starting fresh conversations while preserving configuration, and saving configurations for later use or sharing.

**User Value**: AI Engineers can iterate rapidly by resetting conversations without losing their setup, and can save successful configurations for future use or team collaboration.

**User Stories**:

- **Story 2.1**: As an AI Engineer, I want to start a new conversation while preserving my configuration, so I can quickly test different scenarios without reconfiguring
- **Story 2.2**: As an AI Engineer, I want to save my complete playground configuration, so I can return to it later or share it with colleagues
- **Story 2.3**: As an AI Engineer, I want to be warned about unsaved changes when navigating away, so I don't accidentally lose my work

**Acceptance Criteria**:

1. **Given** I have an active conversation, **When** I click "New chat" in the header, **Then** the conversation clears but all configuration settings remain intact
2. **Given** I click "New chat", **When** I view the conversation panel, **Then** I see a welcome state ready for a new conversation
3. **Given** I have configured a session, **When** I click "Save" in the header, **Then** my configuration (model, parameters, system prompt, knowledge, MCP, guardrails) is persisted (chat history excluded)
4. **Given** I have saved a configuration, **When** I return to the Playground later, **Then** I can load my saved configuration
5. **Given** I have unsaved changes, **When** I attempt to navigate away, **Then** I receive a prompt to save or discard changes

---

### Epic 3: Developer Integration (Priority: P3)

Features that bridge playground experimentation to production development—viewing generated code and working within project context for resource organization.

**User Value**: AI Engineers can export their tested configurations as code for application integration, and organize their work within project boundaries that control available resources.

**User Stories**:

- **Story 3.1**: As an AI Engineer, I want to view code that replicates my configuration programmatically, so I can integrate my tested prompt into applications
- **Story 3.2**: As an AI Engineer, I want to copy generated code to my clipboard, so I can easily use it in my development workflow
- **Story 3.3**: As an AI Engineer, I want to work within a specific project context, so I access project-specific resources (knowledge sources, guardrails)

**Acceptance Criteria**:

1. **Given** I have configured a playground session, **When** I click "View code" in the header, **Then** I see code that replicates my model selection, parameters, and system prompt
2. **Given** the code view is displayed, **When** I click copy, **Then** the code is copied to my clipboard
3. **Given** I am on the Playground page, **When** I view the header, **Then** I see a project selector showing the current project
4. **Given** I select a different project, **When** the page updates, **Then** available resources reflect the selected project context

---

### Edge Cases

- **Model unavailability**: When the selected model becomes unavailable during a session, the system MUST block message sending and display an inline error prompting the user to select a different model. Configuration remains editable.
- How does the system handle extremely long system prompts that exceed model context limits?
- What happens if the user loses network connectivity mid-conversation?
- How does the system behave when all model parameters are set to extreme values?
- What happens when a vector store in Knowledge becomes unavailable after being selected?
- How does the system handle rapid message sending (rate limiting feedback)?

---

## Requirements *(mandatory)*

### Functional Requirements

**Layout & Structure (Epic 1):**
- **FR-001**: System MUST display a two-panel layout with configuration builder on the left and conversation panel on the right *(Epic 1)*
- **FR-002**: System MUST provide a tabbed interface in the configuration builder with tabs for: Model, Prompt, Knowledge, MCP, and Guardrails *(Epic 1)*
- **FR-003**: System MUST display a header bar with project selector, Save action, New chat action, and View code action *(Epic 2, Epic 3)*

**Model Configuration (Epic 1):**
- **FR-004**: System MUST provide a dropdown selector for choosing from available models *(Epic 1)*
- **FR-005**: System MUST display the currently selected model name prominently *(Epic 1)*
- **FR-006**: System MUST provide slider controls with numeric input fields for: Temperature, Top P, Max tokens, and Repetition penalty *(Epic 1)*
- **FR-007**: System MUST show appropriate min/max ranges for each parameter slider *(Epic 1)*
- **FR-008**: System MUST include help icons with tooltips explaining each parameter *(Epic 1)*

**Prompt Configuration (Epic 1):**
- **FR-009**: System MUST provide a large text area for entering system prompts in the Prompt tab *(Epic 1)*
- **FR-010**: System MUST preserve prompt text across tab switches and page interactions *(Epic 1)*

**Knowledge Configuration (Epic 1):**
- **FR-011**: System MUST display available vector stores as a selectable list with checkboxes *(Epic 1)*
- **FR-012**: System MUST allow multiple knowledge sources to be selected simultaneously *(Epic 1)*

**MCP Configuration (Epic 1):**
- **FR-013**: System MUST provide MCP configuration options in a dedicated tab *(Epic 1)*

**Guardrails Configuration (Epic 1):**
- **FR-014**: System MUST display available guardrails configurations in a dedicated tab *(Epic 1)*
- **FR-015**: System MUST show a badge on the Guardrails tab indicating the count of active guardrails *(Epic 1)*

**Conversation Panel (Epic 1):**
- **FR-016**: System MUST display a chat-style conversation interface *(Epic 1)*
- **FR-017**: System MUST show a message input field at the bottom of the conversation panel *(Epic 1)*
- **FR-018**: System MUST display user messages and model responses with clear visual distinction *(Epic 1)*
- **FR-019**: System MUST show model attribution (model name) and timestamp on model responses *(Epic 1)*
- **FR-020**: System MUST display a visual indicator when the model is generating a response *(Epic 1)*
- **FR-021**: System MUST display a welcome state with guidance when no conversation exists *(Epic 1)*
- **FR-022**: System MUST stream model responses as they are generated *(Epic 1)*
- **FR-023**: Conversation history is ephemeral (page state only); NOT persisted across page refresh *(Epic 1)*

**Session Management (Epic 2):**
- **FR-024**: System MUST allow users to start a new chat while preserving configuration *(Epic 2)*
- **FR-025**: System MUST allow users to save their complete playground configuration *(Epic 2)*
- **FR-026**: System MUST prompt users about unsaved changes when navigating away *(Epic 2)*

**Developer Integration (Epic 3):**
- **FR-027**: System MUST allow users to view generated code for their configuration *(Epic 3)*
- **FR-028**: System MUST allow users to copy generated code to clipboard *(Epic 3)*
- **FR-029**: System MUST allow users to switch between projects via a project selector *(Epic 3)*

**State Management (Epic 1):**
- **FR-030**: System MUST preserve all configuration settings when switching between tabs *(Epic 1)*

**Accessibility (All Epics):**
- **FR-031**: System MUST support basic keyboard navigation for all interactive elements *(All Epics)*
- **FR-032**: Full WCAG 2.1 AAA compliance is deferred to follow-up release *(All Epics)*

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: AI Engineers can set up a complete playground configuration (model, parameters, system prompt) efficiently without unnecessary steps
- **SC-002**: Users can send a message and view a model response within a single, uninterrupted visual flow
- **SC-003**: First-time users can successfully complete a basic prompt test (configure model, write prompt, send message, receive response) without assistance
- **SC-004**: Users can iterate on prompts faster compared to the current UI [NEEDS CLARIFICATION: baseline measurement and target improvement TBD by PM/UX]
- **SC-005**: Users report reduced cognitive load when switching between configuration and conversation (measured via user feedback/surveys)
- **SC-006**: Tab switching between configuration sections completes with no perceptible delay
- **SC-007**: The interface aligns with industry-standard GenAI tooling patterns, as validated by UX review against watsonx.ai Prompt Lab and similar tools

---

## Assumptions

- Users have access to at least one deployed model to test in the playground
- Vector stores and guardrails are pre-configured in the system and available for selection
- The existing backend APIs support all configuration options displayed in the new UI
- Project context and permissions are managed externally and provided to the playground
- MCP configuration options are defined by existing system capabilities

---

## Dependencies

- Available models must be queryable from existing model serving infrastructure
- Vector store listings must be available from knowledge management system
- Guardrails configurations must be retrievable from guardrails service
- User authentication and project context must be provided by the platform

---

## Clarifications

### Session 2026-01-08

- Q: What happens when the selected model becomes unavailable during a session? → A: Block message sending + inline error prompting user to select different model; config remains editable
- Q: What language/format should "View code" export use? → A: Deferred to later clarification
- Q: What accessibility standards are required? → A: Basic keyboard navigation for initial release; WCAG 2.1 AAA compliance in follow-up
- Q: How is conversation history handled? → A: Chat not persisted outside page state (ephemeral); responses streamed; history limits deferred to later work
- Q: What gets saved when user clicks "Save"? → A: Config only (model, parameters, system prompt, knowledge, MCP, guardrails); no chat history

---

## Glossary

- **Configuration Builder**: The left panel containing all setup options organized in tabs
- **System Prompt**: Instructions provided to the model that define its behavior and context
- **Temperature**: A parameter controlling randomness in model responses (higher = more random)
- **Top P**: Nucleus sampling parameter that controls diversity of responses
- **Max Tokens**: Maximum length of the model's response
- **Repetition Penalty**: Parameter that discourages the model from repeating itself
- **MCP (Model Context Protocol)**: Protocol for managing model context and state
- **Guardrails**: Safety and content moderation filters applied to model interactions
- **Vector Store**: A database storing embeddings for retrieval-augmented generation (RAG)
