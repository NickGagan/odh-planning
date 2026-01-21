# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`  
**Created**: [DATE]  
**Status**: Draft  
**Input**: User description: "$ARGUMENTS"

## Epics & User Stories *(mandatory)*

<!--
  IMPORTANT: Work MUST be organized into EPICS as the primary output unit.
  
  Each Epic represents a cohesive, shippable capability that delivers complete user value.
  User stories are consolidated under their parent Epic.
  
  Epic prioritization (P1, P2, P3):
  - P1: Core functionality required for MVP
  - P2: Important but can ship after P1
  - P3: Nice-to-have, lower priority
  
  Consolidation guidelines:
  - Stories sharing the same UI area → single Epic
  - Stories sharing the same data/state → single Epic
  - Stories that must ship together for coherent UX → single Epic
-->

### Epic 1: [Epic Name] (Priority: P1)

[Description of the capability this epic delivers - what problem does it solve?]

**User Value**: [What users can do when this epic is complete]

**User Stories**:

- **Story 1.1**: [Specific user scenario - "As a [persona], I want to [action] so that [benefit]"]
- **Story 1.2**: [Specific user scenario]
- **Story 1.3**: [Specific user scenario]

**Acceptance Criteria**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]
2. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### Epic 2: [Epic Name] (Priority: P1)

[Description of the capability this epic delivers]

**User Value**: [What users can do when this epic is complete]

**User Stories**:

- **Story 2.1**: [Specific user scenario]
- **Story 2.2**: [Specific user scenario]

**Acceptance Criteria**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

### Epic 3: [Epic Name] (Priority: P2)

[Description of the capability this epic delivers]

**User Value**: [What users can do when this epic is complete]

**User Stories**:

- **Story 3.1**: [Specific user scenario]
- **Story 3.2**: [Specific user scenario]

**Acceptance Criteria**:

1. **Given** [initial state], **When** [action], **Then** [expected outcome]

---

[Add more epics as needed - aim for 3-6 per specification]

### Edge Cases

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right edge cases.
-->

- What happens when [boundary condition]?
- How does system handle [error scenario]?

## Requirements *(mandatory)*

<!--
  ACTION REQUIRED: The content in this section represents placeholders.
  Fill them out with the right functional requirements.
  
  Requirements should trace back to Epics (e.g., FR-001 supports Epic 1).
-->

### Functional Requirements

- **FR-001**: System MUST [specific capability] *(Epic 1)*
- **FR-002**: System MUST [specific capability] *(Epic 1)*
- **FR-003**: Users MUST be able to [key interaction] *(Epic 2)*
- **FR-004**: System MUST [data requirement] *(Epic 2)*
- **FR-005**: System MUST [behavior] *(Epic 3)*

*Example of marking unclear requirements:*

- **FR-006**: System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified]

### Key Entities *(include if feature involves data)*

- **[Entity 1]**: [What it represents, key attributes without implementation]
- **[Entity 2]**: [What it represents, relationships to other entities]

## Success Criteria *(mandatory)*

<!--
  ACTION REQUIRED: Define measurable success criteria.
  These must be technology-agnostic and measurable.
  
  IMPORTANT: Do NOT fabricate metrics. Use qualitative language or [NEEDS CLARIFICATION]
  when specific targets have not been provided by stakeholders.
-->

### Measurable Outcomes

- **SC-001**: [Qualitative outcome, e.g., "Users can complete the primary task efficiently"]
- **SC-002**: [Qualitative outcome, e.g., "System responds without perceptible delay"]
- **SC-003**: [Outcome with provided metric, or NEEDS CLARIFICATION if target unknown]
- **SC-004**: [Business outcome, e.g., "Reduced user friction during [workflow]"]
