<!--
SYNC IMPACT REPORT
==================
Version change: 2.0.0 → 2.1.0 (MINOR: Added cross-team dependency requirement to specification discovery)

Modified principles:
- Principle X: Added REQUIRED cross-team dependency identification during /speckit.specify
  - New "Cross-Team Dependencies" section format for specs
  - Dependency types: Capacity, Integration, Design, Testing, Informational
  - Agent must proactively identify dependencies even if user doesn't mention them
  - Common triggers documented for automatic dependency detection

Rationale:
- Cross-team dependencies were only surfaced during planning, causing late discovery
- Moving identification to specification phase enables earlier coordination
- Proactive detection ensures dependencies aren't missed when user forgets to mention them

Templates requiring updates:
- spec-template.md: ⚠ Should add Cross-Team Dependencies section placeholder

Follow-up TODOs:
- Update spec-template.md with Cross-Team Dependencies section
==================

PREVIOUS SYNC IMPACT REPORT (2.0.0)
===================================
Version change: 1.8.1 → 2.0.0 (MAJOR: Consolidated principles, revised personas, updated epic model)

Modified principles:
- Target Personas: Removed persona names, streamlined to role-focused format with essential characteristics only
- Principle VIII: Revised Cross-Team Coordination with dedicated requirements section and inline callouts
- Principle IX: Consolidated epic-level planning, removed team briefs, clarified Crimson as primary consumer
- Principle X: Added Open Questions export format for PM follow-up
- Principle XII: Revised epic definition (single sprint, shippable, single-team ownership)

Added sections:
- Cross-Team Requirements section format (in Principle VIII)
- Open Questions export format (in Principle X)
- Phase/milestone organization for multi-sprint features (in Principle XII)

Removed sections:
- Persona names and narrative elements (quotes, detailed profiles)
- Post-Planning Workflow team briefs section from Principle IX
- Team briefs references from Principle VIII

Rationale: 
- Personas simplified to role focus for clarity without fictional names
- Epic definition aligned with actual team workflow (sprint-scoped, single-team)
- Cross-team coordination improved with dedicated requirements section and inline callouts
- Team briefs removed since Crimson is primary consumer and distributes as needed
- Added Open Questions export for async PM collaboration
==================
-->

# Crimson Dashboard Constitution

## Target Personas

> These roles MUST be referenced in user stories and planning documents.

### Data Scientist — THE INNOVATOR

**Role**: Develops and evaluates core AI/ML models through rigorous experimentation.

**Key Characteristics**:
- Focused on scientific inquiry, primarily working in notebooks
- Skills: Data processing, feature engineering, model building
- Often disconnected from production operational realities

**Core Pain Points**:
- Notebooks don't translate to production; tooling is fragmented
- Data quality issues make prep cumbersome but critical
- Difficulty making models actionable for business stakeholders

---

### AI Engineer — THE BUILDER

**Role**: Develops and deploys AI-infused applications, bridging Dev, Ops, and AI/ML.

**Key Characteristics**:
- Driven by urgency and practicality; seeks quickest path to integrate LLMs
- Skills: GenAI application development, model selection, prompt engineering, evaluations
- Bridge between data science experimentation and production deployment

**Core Pain Points**:
- Limited by proprietary data; hindered by external resource restrictions
- Manual and time-consuming prompt engineering and testing
- Deployment process is overly complex
- Evaluation methods are largely manual and repetitive

---

### ML Ops Engineer — THE AUTOMATOR

**Role**: Automates the entire AI/ML model lifecycle: deployment, monitoring, and maintenance.

**Key Characteristics**:
- Focused on reliability, security, scalability, and reproducibility
- Skills: MLOps system management, scalable deployments, monitoring
- Acts as "glue" between teams; industrializes notebook code into production pipelines

**Core Pain Points**:
- Transition from Data Science to MLOps is frequently not smooth
- Many AI/ML apps not adequately monitored (operational blind spot)
- Constantly industrializing notebook code into robust, production-ready pipelines

---

### Platform Engineer — THE ENABLER

**Role**: Creates and maintains reliable, cost-efficient, and secure compute, storage, and networking environments.

**Key Characteristics**:
- Strategic automation and empowerment focus
- Skills: GPU management, container orchestration, operating systems management
- Abstracts complexity for Data Scientists while maintaining security and compliance

**Core Pain Points**:
- Grapples with legal approval, RBAC, compliance, and data privacy challenges
- Ensuring sensitive internal data is not exposed to public libraries or LLMs
- Critical need for robust AuthN/AuthZ, RBAC, and Quota Management

---

### Cross-Role Pain Points

These pain points affect multiple roles and SHOULD inform feature prioritization:

| Pain Point | Description | Affected Roles |
|------------|-------------|----------------|
| **The Data Dilemma** | Data is fuel but constant source of friction. Unstructured data, quality issues, bureaucratic access hurdles. | Data Scientist, AI Engineer, ML Ops Engineer |
| **The Evaluation Bottleneck** | Crisis of confidence in evaluating GenAI systems. Manual/subjective processes, untrustworthy automation. | AI Engineer, ML Ops Engineer |
| **The Collaboration Chasm** | Organizational structure mirrors fragmented toolchain. Broken handoffs, especially Data Science → MLOps. | Data Scientist, AI Engineer, ML Ops Engineer |

**What Our Personas Need**:
- **Accelerated Time-to-Value**: Move from concept to production in days, not months
- **Improved Quality & Trust**: Robust evaluation, security, and observability build trust
- **Enhanced Collaboration**: A common platform breaks down silos
- **Strategic Agility**: Transform AI from risky experiments into scalable, repeatable capability

## Core Principles

### I. PatternFly-First Design

Crimson Dashboard MUST be a PatternFly-first application. All UI development prioritizes PatternFly components and patterns over custom implementations.

**Non-negotiable rules:**
- Custom styling MUST be avoided; do not add CSS for "minor tweaks" that drift from native PatternFly behavior
- Using `style` or `className` props to "nudge" UI rendering indicates incorrect approach and MUST be reconsidered
- Custom components MUST be pre-approved by the team before implementation
- PatternFly overrides (when PF has bugs or limitations) MUST be placed in a dedicated `components/pf-overrides` folder
- Generic reusable components MUST reside in `components/` with clear single-purpose definitions

**Rationale:** PatternFly ensures consistent Red Hat enterprise UX, reduces maintenance burden, and enables seamless upgrades. Custom CSS becomes technical debt that breaks with PatternFly version updates.

### II. Definition of Ready

No development work MUST begin until the feature meets Definition of Ready criteria. This ensures alignment across all stakeholders before investment.

**Non-negotiable rules:**
- Requirements MUST be documented as user stories referencing target personas (e.g., "As an AI Engineer...")
- Acceptance criteria MUST exist and be understood by the implementation team
- Dependencies MUST be identified and not blocking completion
- All stakeholders (PM, Engineering, QE, UX, Docs) MUST review requirements with no outstanding questions
- Architectural review MUST be completed for new features with one of the Dashboard Advisors
- UX designs MUST be reviewed and signed off with no major changes expected
- API requirements (REST and CRD) MUST be clearly documented and reviewed
- Backend dependencies and APIs MUST be fully ready (including operator support)

**Rationale:** Red Hat's Open Decision Framework emphasizes transparent, inclusive decision-making. Starting work without clear requirements leads to rework, scope creep, and misaligned expectations.

### III. Definition of Done

A feature, bug, or story MUST meet all Definition of Done criteria before release. No exceptions without documented architectural approval.

**Non-negotiable rules:**
- Code MUST be reviewed by an advisor AND another dashboard team member who ran it locally
- New backend pod endpoints MUST have architectural security review
- Code changes MUST have appropriate automated tests (Cypress and/or Jest unit tests)
- UI visual changes MUST match UX designs
- Demo MUST be created and recorded for features; screenshots MUST be added for bug fixes
- All changes MUST be tested using a built image (nightly ODH or RC build)
- Reviewer MUST identify code that behaves differently upstream vs downstream
- UI microcopy MUST be reviewed
- PM MUST sign off on functionality
- Related UX stories MUST be closed
- Follow-up issues MUST be created and linked for items that do not block release

**Rationale:** Definition of Done prevents incomplete work from reaching users and ensures consistent quality standards across the team.

### IV. Comprehensive Testing

Testing is mandatory and MUST cover multiple levels. Tests MUST exist before code can be merged.

**Non-negotiable rules:**
- **Unit tests (Jest)**: MUST cover all utility and hook functions
- **E2E tests (Cypress)**: MUST test full user flows against production-like environments
- **Accessibility testing**: MUST run on new pages and modals; use `cy.testA11y()` for other checkpoints
- Test files MUST use `.spec.ts` extension and reside in `__tests__` directories adjacent to source files
- Tests MUST be independently runnable; no sequence dependencies between tests
- Mock data MUST be created within individual tests; no shared mutable mock instances
- Page objects MUST encapsulate all selectors; tests MUST NOT contain raw selectors
- `data-testid` MUST be used for primary element selection with meaningful descriptive names

**Hook testing requirements:**
- Hooks MUST be tested using the `testHook` utility
- Hook stability MUST be asserted after each render using `hookToBeStable`
- Async hook operations MUST use `waitForNextUpdate` for proper timing

**Rationale:** Red Hat's Secure Development Lifecycle integrates testing throughout the process. Comprehensive testing prevents regressions and ensures reliability for enterprise customers.

### V. Code Quality & Review Standards

All code MUST pass PR review checklist before merge. Reviews MUST verify functional correctness and architectural alignment.

**Non-negotiable rules:**
- Every code PR MUST have a linked issue describing the change
- PR template MUST be completed with screenshots and answers to all questions
- Tests MUST exist and pass; reviewers MUST test the PR image on cluster
- eslint ignore statements MUST be verified; no ignoring React hook dependency errors without exceptional justification
- `as` keyword usage MUST be flagged and reconsidered (indicates type system circumvention)
- Optional chaining MUST have fallback values
- Components MUST be properly decomposed with single responsibility
- Custom hooks MUST be used liberally to co-locate related logic

**Hook performance rules:**
- `useCallback` MUST be used ONLY when reference stability matters:
  - Functions passed as props to child components
  - Functions used as `useEffect` dependencies
  - Functions returned from custom hooks
- `useMemo` MUST NOT be used for non-expensive computations
- Functions exported from custom hooks MUST ALWAYS be memoized
- `useEffect` MUST NOT compute incoming props into local `useState` (use `useMemo` instead)

**Rationale:** Code review is the primary quality gate. Consistent standards reduce cognitive load and ensure maintainable code.

### VI. Modular Architecture

Features MUST be developed as modular, independently testable units. Module federation enables scalable development.

**Non-negotiable rules:**
- Modules MUST have `module-federation` config OR export `./extensions` to be valid
- Unit tests MUST exist in `__tests__` directories within the module
- E2E tests MUST exist in `packages/cypress/cypress/tests/e2e/` matching module name
- Quality gates MUST pass before merge (75% threshold for RHOAI)
- Modules with BFF (Backend-For-Frontend) capabilities MUST pass API-specific checks

**Import restrictions:**
- `/src/api` MAY only import from `/src/utilities`
- `/src/components` MAY only import from `/src/utilities`; MUST NOT contain application concepts
- `/src/concepts` MUST NOT import from `/src/pages`
- `/src/utilities` MUST NOT import from anywhere; only generic utilities allowed

**Rationale:** Modular architecture enables parallel development, isolated testing, and independent deployment. Clear import rules prevent circular dependencies and maintain separation of concerns.

### VII. Stakeholder Collaboration

Development MUST include continuous stakeholder engagement. Red Hat's open decision framework requires inclusive participation.

**Non-negotiable rules:**
- UX MUST be involved in all UI changes; designs MUST be reviewed before implementation
- PM MUST review and sign off on functionality before release
- Docs MUST receive issue identification for release notes
- Working cluster link MUST be provided for UXD, PM, and Docs to test features
- Demo recording MUST be shared with stakeholders during acceptance
- Architectural changes MUST have Dashboard Architect approval
- Security-sensitive changes (backend endpoints) MUST have security review

**Rationale:** Red Hat's community-first approach requires collaboration across disciplines. Early stakeholder involvement prevents late-stage surprises and rework.

### VIII. Cross-Team Coordination

Cross-team features MUST be planned at the epic/requirements level, with dependencies identified as early as possible. Team ownership MUST be determined using the project's OWNERS files.

**Non-negotiable rules:**
- Cross-team dependencies MUST be identified at the earliest planning stage (specification or earlier)
- Dependencies MUST be refined and validated as planning progresses
- Integration points MUST be defined through versioned contracts (OpenAPI, event schemas, data formats)
- Dependencies MUST be documented with clear ownership and timelines
- Teams MUST NOT prescribe implementation approaches to other teams
- Team ownership MUST be identified using `OWNERS` and `OWNERS_ALIASES` files in the codebase

**Team identification via OWNERS files:**
- Reference `../../odh-dashboard/OWNERS` for directory-to-team mapping
- Reference `../../odh-dashboard/OWNERS_ALIASES` for team member lists
- Use the `filters` section in OWNERS to identify which team owns which directories
- When a feature touches multiple directories with different owners, identify ALL affected teams

**Key team ownership areas (from OWNERS):**
- `packages/gen-ai/` → gen-ai-approvers
- `frontend/src/(api|concepts|pages)/modelServing/` → model-serving-metrics-approvers
- `frontend/src/(api|concepts|pages)/pipelines/` → pipelines-approvers
- `frontend/src/(concepts|pages)/connectionTypes/` → connections-approvers
- `frontend/src/(api|concepts)/(acceleratorProfiles|hardwareProfiles)/` → hardware-profiles-approvers
- `frontend/src/(api|concepts)/(notebooks|notebookController)/` → workbenches-approvers
- `frontend/src/(api|concepts|pages)/(modelCatalog|modelRegistry)/` → model-registry-catalog-approvers
- `frontend/src/plugins/` → platform-approvers
- `packages/cypress/` → quality-e2e-testing-approvers

**Cross-Team Requirements section:**

All plans with cross-team dependencies MUST include a dedicated "Cross-Team Requirements" section containing:

| Team | Requirement | Needed By | Contact | Status |
|------|-------------|-----------|---------|--------|
| [Team name from OWNERS] | [What is needed from them] | [Date/Sprint] | [Owner contact] | [Pending/In Progress/Complete] |

**Inline dependency callouts:**

Within epics, cross-team dependencies MUST be called out inline:

> **⚠️ Dependency**: [Team name] must provide [specific requirement] by [date/milestone].

**Primary consumer:** Crimson (gen-ai dashboard team) is the primary consumer of all planning artifacts. Crimson extracts and distributes relevant information to other teams as needed.

**Rationale:** Teams closest to their domain make the best implementation decisions. Early dependency identification reduces costly late-stage discoveries. Crimson as the coordination hub ensures consistent communication.

### IX. Epic-Level Planning

ALL feature planning MUST produce epic-level requirements, NOT implementation details. Engineers own technical implementation decisions.

**Non-negotiable rules:**
- Plans MUST define: requirements, acceptance criteria, API contracts, dependencies, risks, pitfalls
- Plans MUST NOT define: tech stack, architecture patterns, component structure, state management, folder structure
- Engineers MUST choose their own: language, framework, libraries, design patterns, file organization
- Technology constraints MUST only be specified when: mandated by existing infrastructure, compliance, or security requirements

**Epic-level planning artifacts:**
- **Requirements**: User stories with acceptance criteria (Given/When/Then)
- **API Contracts**: Versioned interface definitions (OpenAPI, GraphQL schemas, event formats)
- **Dependencies**: What other teams/systems are needed, when, and who owns them
- **Risk Register**: Known pitfalls, blockers, and mitigation strategies
- **Quality Criteria**: Performance targets, security requirements, accessibility standards (WHAT, not HOW)
- **Cross-Team Requirements**: Dedicated section per Principle VIII

**What should NOT be in plans:**
- ❌ Tech stack decisions ("Use React 18", "Use PostgreSQL")
- ❌ Architecture patterns ("Use Redux for state management", "Use Repository pattern")
- ❌ File/folder structure ("Create `src/components/`", "Put hooks in `hooks/`")
- ❌ Component designs ("Create a `ChatInterface.tsx` component")
- ❌ Implementation approaches ("Use sessionStorage", "Use custom hooks")

**What SHOULD be in plans:**
- ✅ Requirements ("Users must be able to switch models mid-conversation with context preserved")
- ✅ Contracts ("Model inference API accepts conversation history array and returns response object")
- ✅ Constraints ("Must support 50+ messages without performance degradation")
- ✅ Integration points ("Integrates with existing /api/model/inference endpoint")
- ✅ Risks ("Context window exhaustion may cause errors; teams should handle gracefully")
- ✅ Cross-team dependencies with inline callouts

**Rationale:** Engineers closest to the codebase make the best implementation decisions. Planning should empower teams with clear requirements and constraints, then trust them to choose appropriate solutions. Plans become durable (survive tech changes) and focused on user value.

### X. Specification Discovery Process

Before writing any feature specification, the agent MUST conduct a structured discovery process through sequential clarifying questions. This ensures accurate requirements and reduces rework.

**Non-negotiable rules:**
- `/speckit.specify` MUST ask clarifying questions ONE AT A TIME before writing the specification
- Each question MUST be answered before the next question is asked
- Questions MUST NOT be batched together (no "Here are 5 questions...")
- Agent MUST wait for user response and incorporate the answer before proceeding
- Agent MUST NOT begin writing the specification until discovery is complete
- Discovery MUST continue until the agent has sufficient context to write an accurate spec

**Discovery areas to explore (as needed):**
- Scope boundaries: What is explicitly in/out of scope?
- Target personas: Which users are affected? (Reference constitution personas)
- Existing context: How does this relate to existing features or specs?
- Dependencies: What systems, teams, or APIs are involved?
- Success criteria: How will we know this feature is successful?
- Constraints: What limitations exist (technical, timeline, regulatory)?
- Edge cases: What unusual scenarios should be considered?
- Visual/UX references: Are there prototypes, mockups, or reference designs?

**Cross-team dependency identification (REQUIRED):**

Specifications MUST include a "Cross-Team Dependencies" section identifying all teams that may be impacted by or need to contribute to the feature. This section MUST be populated during `/speckit.specify`, not deferred to planning.

For each dependency, identify:
- **Team**: Which team is involved (reference OWNERS files per Principle VIII)
- **Requirement**: What is needed from them
- **Type**: Capacity | Integration | Design | Testing | Informational
- **Notes**: Additional context (blocking vs. FYI, timeline sensitivity)

Dependency types:
- **Capacity**: Team needs awareness of changed load/volume patterns
- **Integration**: Feature requires API, contract, or integration point with team's domain
- **Design**: UX/design work needed from team
- **Testing**: QE involvement for test coverage
- **Informational**: FYI for awareness, no action required

The agent MUST proactively identify cross-team dependencies based on the feature description, even if the user does not explicitly mention them. Common triggers:
- Multiple models/MCPs/guardrails → Model Serving, MCP, Guardrails teams
- New UI patterns or layouts → UX Team
- Changed API contracts → Backend/Platform team
- New user flows or edge cases → QE Team
- Data persistence or state changes → relevant data-owning team

**Question flow principles:**
- Start with scope and relationship to existing work
- Move to user impact and personas
- Explore technical dependencies and constraints
- Clarify success metrics and acceptance criteria
- Confirm understanding before proceeding

**When to stop asking questions:**
- Agent has clear understanding of scope, users, and success criteria
- No remaining ambiguities that would result in [NEEDS CLARIFICATION] markers
- User indicates they have provided sufficient context
- Discovery has covered all relevant areas for the feature type

**Open Questions export format:**

When discovery is complete, the agent MUST offer to export any unanswered questions or items needing PM clarification in this simple format:

```
## Open Questions for PM Review

Q: [Question text]
A: _______________

Q: [Question text]
A: _______________

Q: [Question text]
A: _______________
```

This format is designed for easy forwarding to product ownership for async clarification.

**Rationale:** Front-loading discovery produces higher-quality specifications with fewer assumptions. Sequential questioning allows each answer to inform subsequent questions. The Open Questions export enables async collaboration with PM when needed.

### XI. Factual Accuracy in Specifications

Agents MUST NOT fabricate metrics, acceptance criteria, or measurable outcomes. All quantitative targets in specifications MUST come from user input, existing documentation, or be explicitly marked as undefined.

**Non-negotiable rules:**
- Agents MUST NOT invent specific percentages (e.g., "90% of users")
- Agents MUST NOT invent time targets (e.g., "under 60 seconds", "within 2 minutes")
- Agents MUST NOT invent quantity targets (e.g., "50% faster", "1000 concurrent users")
- Agents MUST NOT invent comparative metrics (e.g., "3x improvement")
- Hard numbers MUST only appear if explicitly provided by the user or found in existing documentation
- When metrics are required but not provided, agents MUST use `[NEEDS CLARIFICATION: metric TBD]`
- When general direction is sufficient, agents MUST use qualitative language (e.g., "faster", "improved", "most users")

**Acceptable patterns when metrics not provided:**
- ✅ "Users can complete the task efficiently" (qualitative)
- ✅ "Response time should be perceptibly fast" (qualitative)
- ✅ "Most users should succeed on first attempt" (directional)
- ✅ "Performance should not degrade under load" (constraint without specific number)
- ✅ "[NEEDS CLARIFICATION: target completion time TBD by PM]" (explicit gap)

**Unacceptable patterns (fabricated metrics):**
- ❌ "Users can complete the task in under 60 seconds" (invented time)
- ❌ "90% of users should succeed" (invented percentage)
- ❌ "50% faster than current implementation" (invented comparison)
- ❌ "Handle 1000 concurrent users" (invented capacity)

**Rationale:** Fabricated metrics create false expectations and undermine trust in specifications. Stakeholders may plan around invented numbers, leading to misaligned goals. Gaps should be visible, not papered over with plausible-sounding fiction.

### XII. Epic Structure & Organization

Specifications MUST organize work into Epics as the primary output unit. Epics MUST be scoped to enable focused delivery and clear ownership.

**Epic definition:**
- An Epic MUST be completable within a single sprint
- An Epic MUST produce shippable, demonstrable code
- An Epic MUST be owned by a single team
- When multiple teams are involved, each team MUST have their own coordinated epic(s)

**Non-negotiable rules:**
- `/speckit.specify` MUST output Epics as the primary work units
- Related user stories MUST be consolidated under parent Epics
- Each Epic MUST have: description, user value statement, and consolidated acceptance criteria
- User stories within an Epic MUST be specific, testable scenarios that together fulfill the Epic
- Epics MUST be prioritized (P1, P2, P3); stories within epics inherit the epic's priority

**Multi-sprint feature organization:**

When a feature spans multiple sprints, epics MUST be organized by phase/milestone:

```
### Phase 1: [Milestone Name] (Sprint X)

#### Epic 1.1: [Epic Name] (Priority: P1, Owner: [Team])
...

#### Epic 1.2: [Epic Name] (Priority: P1, Owner: [Team])
...

### Phase 2: [Milestone Name] (Sprint X+1)

#### Epic 2.1: [Epic Name] (Priority: P1, Owner: [Team])
...
```

**Cross-team coordination:**

When a feature requires work from multiple teams:
- Each team gets their own epic(s) within the relevant phase
- Dependencies between team epics MUST be documented inline (see Principle VIII)
- Shared milestones MUST have clear integration checkpoints

**Epic structure:**
```
### Epic [N]: [Epic Name] (Priority: P1, Owner: [Team])

[Description of the capability this epic delivers]

**User Value**: [What users can do when this epic is complete]

**User Stories**:
- Story N.1: [Specific scenario]
- Story N.2: [Specific scenario]

**Acceptance Criteria**:
1. Given/When/Then for the epic as a whole

> **⚠️ Dependency**: [If applicable, inline callout per Principle VIII]
```

**Consolidation guidelines:**
- Stories that share the same UI area → single Epic
- Stories that share the same data/state → single Epic
- Stories that must ship together for coherent UX → single Epic

**What makes a good Epic:**
- ✅ "Configuration Builder" (groups model, prompt, knowledge, MCP, guardrails config)
- ✅ "Conversation Experience" (groups chat, responses, history)
- ✅ "Session Management" (groups save, new chat, project context)
- ❌ "Configure Temperature Slider" (too granular — this is a story, not an epic)
- ❌ "All UI Work" (too broad — not completable in one sprint)

**Rationale:** Sprint-scoped, single-team epics enable clear ownership, predictable delivery, and clean handoffs. Phase/milestone organization provides visibility into multi-sprint roadmaps while keeping individual work items manageable.

### XIII. Codebase-Informed Architecture Guidance

All specification, planning, and epic breakdown work MUST be approached from the perspective of a senior architect, with decisions informed by the existing codebase. Output is intended for consumption by any engineer on the team.

**Non-negotiable rules:**
- Agent MUST approach all `/speckit.specify`, `/speckit.plan`, and `/speckit.tasks` work from a senior architect perspective
- Agent MUST research the existing codebase at `../../odh-dashboard` before making architectural recommendations
- Recommendations MUST be consistent with existing patterns, conventions, and abstractions found in the codebase
- Output MUST be written for engineers of varying experience levels (clear, actionable, not assuming deep familiarity)
- Agent MUST identify and reference existing components, utilities, and patterns that can be reused
- Agent MUST flag when recommendations deviate from established codebase patterns, with explicit justification

**Codebase research requirements:**
- Before recommending UI patterns: Check `frontend/src/components/` and `frontend/src/pages/` for existing implementations
- Before recommending state management: Check existing patterns in `frontend/src/concepts/` and custom hooks
- Before recommending API integration: Check `frontend/src/api/` for established patterns
- Before recommending testing approaches: Check existing test files for conventions

**Senior architect perspective means:**
- Consider maintainability and long-term implications
- Identify opportunities for reuse rather than reinvention
- Flag potential technical debt or risks
- Provide context on why certain patterns exist in the codebase
- Make recommendations that scale with team growth
- Ensure consistency across the codebase

**Output for engineers means:**
- Clear, actionable guidance (not abstract theory)
- Reference specific files and patterns when relevant
- Explain the "why" behind recommendations
- Provide enough context for engineers unfamiliar with specific areas
- Avoid jargon without explanation

**Reference codebase**: `../../odh-dashboard`

**Rationale:** Specifications and plans grounded in the actual codebase are more actionable and lead to consistent implementations. A senior architect perspective ensures recommendations consider the broader system and are practical for the team to execute.

## Development Standards

### Technology Stack

- **Frontend**: React + TypeScript + PatternFly
- **Backend**: Node.js + Express + TypeScript
- **Testing**: Jest (unit), Cypress (E2E), axe-core (accessibility)
- **Build**: Webpack + Module Federation
- **Infrastructure**: OpenShift + Kubernetes

### Folder Structure

```text
frontend/
├── src/
│   ├── api/          # K8s and backend API calls only
│   ├── components/   # Generic, reusable components
│   ├── concepts/     # Shared logic across pages
│   ├── pages/        # Route-specific views
│   ├── utilities/    # Generic utilities and hooks
│   └── types.ts      # Shared type definitions
backend/
├── src/
│   ├── routes/       # API endpoints
│   ├── plugins/      # Fastify plugins
│   └── utils/        # Backend utilities
packages/
├── cypress/          # E2E and mocked tests
├── eslint-config/    # Shared linting rules
└── [feature]/        # Modular feature packages
```

### Commit Standards

- Commit messages MUST follow Conventional Commits format
- Each commit SHOULD represent a logical unit of work
- Commits MUST pass all linting and test checks

## Quality Gates

### PR Merge Requirements

| Gate | Requirement | Enforcement |
|------|-------------|-------------|
| Tests Pass | All Jest and Cypress tests | CI/CD |
| Linting | Zero eslint errors | CI/CD |
| Review | 2 approvals (1 advisor + 1 team member) | GitHub |
| Local Test | Reviewer ran code locally | Manual |
| Screenshots | Visual changes documented | PR Template |
| Issue Link | Bug/feature issue attached | PR Template |
| A11y | Accessibility tests pass | CI/CD |

### Release Readiness

- All Definition of Done criteria met
- No blocking issues in linked epic
- Fix version set in Jira
- Release notes provided to docs team
- Stakeholder sign-offs complete

## Governance

This constitution supersedes all other development practices. Amendments require:

1. **Proposal**: Document proposed changes with rationale
2. **Review**: Dashboard Advisors and Tech Lead review
3. **Approval**: Consensus from core team
4. **Migration Plan**: Path for existing code to comply
5. **Version Increment**: Update constitution version per semantic rules

**Compliance enforcement:**
- All PRs MUST verify compliance with these principles
- Reviewers MUST use the PR Review Guidelines checklist
- Non-compliance MUST be justified with documented trade-off analysis
- Complexity MUST be justified; default to simplest working solution

**Amendment guidelines:**
- MAJOR version: Backward-incompatible principle changes or removals
- MINOR version: New principles or materially expanded guidance
- PATCH version: Clarifications, wording improvements, typo fixes

**Version**: 2.1.0 | **Ratified**: 2025-12-19 | **Last Amended**: 2026-01-21
