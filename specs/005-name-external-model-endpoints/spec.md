# Feature Specification: External Model Endpoints Support

**Feature Branch**: `005-name-external-model-endpoints`
**Created**: 2026-02-17
**Status**: Draft
**Strategic Input**: JIRA RHAISTRAT-172 - AI Asset Endpoints - External Model Endpoints Support

## Overview

Enable users to register and utilize external third-party model endpoints (e.g., Anthropic, OpenAI, Cohere, Gemini) directly within the AI Available Assets page in Gen AI Studio. Users will provide their own external model service URLs and API keys for authentication. This extends the current capability beyond namespace-hosted LLS servers to include any arbitrary external endpoint hosting OpenAI-compliant APIs.

**Scope**: External endpoints will be visible in the AI Available Assets page and selectable in the AI Playground for inference.

**Out of Scope**: API key rotation/management, integration with model serving deployments, pipelines, or other Gen AI Studio features beyond Assets and Playground.

---

## Epics & User Stories

### Epic 1: External Endpoint Registration - MVP (Priority: P1, Owner: gen-ai)

Provide a minimal user interface for registering external model endpoints with secure credential storage. Users can input basic service details using text inputs and save the configuration.

**User Value**: AI Engineers and Platform Engineers can integrate external AI services (Anthropic, OpenAI, etc.) into their Gen AI Studio workflow without waiting for internal model deployments.

**Technical Considerations**:
- User-provided API keys must be stored as Kubernetes Secrets, not plain text
- Endpoint URL is a passthrough to a service hosting OpenAI-compliant APIs
- Model ID is a **text input** for MVP (model picker is stretch goal in Epic 4)
- Model Alias is an **optional text input** for user-friendly naming
- "Verify Model" button allows connection testing before saving
- External endpoints are namespace-scoped
- **Feature flag for cluster admins** to control whether external models can be added (security risk mitigation). Disabled by default.
- **Feature flag in odh-dashboard** to control UI visibility of external model registration. Disabled by default.
- [NEEDS CLARIFICATION: What is the scope of model verification - health check (ping) or sample inference request?]
- [NEEDS CLARIFICATION: Is model verification only optional or automatic (verify during registration and warn on failure)?]
- [NEEDS CLARIFICATION: Are we automatically adding this external model to the llama stack instance after creation?]
- [NEEDS CLARIFICATION: Are secrets namespace-scoped OR user-scoped?]
- [NEEDS CLARIFICATION: If endpoints are namespace-scoped but secrets are user-scoped, what happens when User B tries to use an endpoint registered by User A with User A's secret?]
- [NEEDS ClARIFICATION: What are the implementation details for pointing to an external model? e.g. Is it a LLMInferenceService that's proxying to the external API through some Serving runtime]
- [NEEDS CLARIFICATION: Is selecting a serving runtime required for external endpoint registration? It was mentioned in the epic.]

**Outcomes by Persona**:

_AI Engineer_:
- Can access a registration form/wizard from the AI Available Assets page
- Can input model ID, endpoint URL, and API key
- Can optionally input a model alias for user-friendly naming
- Can select an existing serving runtime (if required - pending clarification)
- Can click a "Verify Model" button to test the connection before saving
- Receives immediate feedback on connection test (success or actionable error message)
- Can save the external endpoint configuration and see it immediately appear in the Assets list
- Receives clear validation feedback if required fields are missing

_Platform Engineer_:
- Can enable/disable external model registration for the cluster via feature flag (cluster admin capability)
- Can control UI visibility of external model registration via odh-dashboard feature flag
- Can register external endpoints for team use (scoping TBD - see clarifications above)
- Understands that API keys are securely stored as Kubernetes Secrets
- Understands the security implications of allowing external model connections and can mitigate risks via feature flags
- [NEEDS CLARIFICATION: Architecture to confirm which RBAC roles in the namespace are required for registration]

> **⚠️ Dependency**: UX Team must provide design for minimal registration wizard. Core fields: Model ID (required text), Endpoint URL, API Key, Model Alias (optional text), and "Verify Model" button for optional connection testing. [NEEDS CLARIFICATION: Is Serving Runtime selection required?]

> **🚨 BLOCKER**: Scoping questions must be resolved - are secrets namespace-scoped or user-scoped? If mismatch between endpoint and secret, design needed for access control.

> **🚨 BLOCKER**: Implementation details for pointing to an external model need to be determined.

> **🚨 BLOCKER**: Implementation details for creating and fetching a secret need to be determined.


---

### Epic 2: External Endpoint Display and Management (Priority: P1, Owner: gen-ai)

Display registered external endpoints in the AI Available Assets page with clear visual distinction from internal models. Users can view endpoint details and delete endpoints. Access control depends on scoping model (see clarifications).

**User Value**: AI Engineers and Platform Engineers have a centralized view of all available AI assets—both internal and external—and can manage external endpoints as needed.

**Technical Considerations**:
- External models must be visually distinguishable from internal models in the Assets list
- Deletion must remove both the endpoint record and the associated Kubernetes Secret

**Outcomes by Persona**:

_AI Engineer_:
- Can view external models in the AI Available Assets page alongside internal models
- Can identify which models are external vs. internal at a glance
- Can see key metadata for each external endpoint: model ID (or model alias if set) and endpoint URL
- Can delete external endpoints

_Platform Engineer_:
- [NEEDS CLARIFICATION: Is this role relevant for this feature? If creating as an LLMInferenceService, is this visible in AI Hub?]
- Can audit which external endpoints are registered?
- Understands that deletion removes secrets and cleans up namespace resources

> **⚠️ Dependency**: UX Team must provide design for visual distinction patterns (icon, badge, label, filter, or separate section).

> **⚠️ Dependency**: [NEEDS CLARIFICATION UX Team must provide design for scoping mismatch scenario if endpoints are namespace-scoped but secrets are user-scoped. What happens when User B sees an endpoint registered by User A but cannot access User A's secret?]

---

### Epic 3: External Endpoint Integration with AI Playground (Priority: P1, Owner: gen-ai)

Make external endpoints selectable in the AI Playground for inference. Requests are proxied to the external service using the stored API key for authentication. Access control depends on scoping model.

**User Value**: AI Engineers can use external models in the Playground to test prompts, compare responses, and validate model behavior without leaving Gen AI Studio.

**Technical Considerations**:
- Must be able to call responses API for the external model via Llamastack repsonses API
- API key from Kubernetes Secret may need to be injected into outbound requests to the external service
- OpenAI-compliant API format expected by Playground must be maintained end-to-end
- Streaming responses and error handling must work consistently with internal models
- [NEEDS CLARIFICATION: If endpoints are namespace-scoped but secrets are user-scoped, how does the system handle authentication when User B tries to use an endpoint registered by User A?]

**Outcomes by Persona**:

_AI Engineer_:
- Can select a registered external endpoint from the model picker in AI Playground (scoping TBD)
- Can send inference requests to the external endpoint and receive responses in the Playground UI
- Experiences consistent behavior whether using internal or external models (streaming, error states, response formatting)
- Receives clear error messages if the external service is unreachable or returns an error
- [If scoping mismatch exists] Receives clear error message if attempting to use an endpoint without access to the associated secret

_Platform Engineer_:
- Understands that external requests are authenticated using the stored Kubernetes Secret
- Can troubleshoot failed external requests using standard logging and monitoring tools

> **⚠️ Dependency**: Architecture must clarify authentication mechanism if endpoints and secrets have different scoping (namespace vs user).

---

## Edge Cases

- **Invalid or unreachable endpoint URL during verification**: When user clicks "Verify Model" button, system should display clear error message if external service cannot be reached; user can still proceed to save without successful verification (optional test)
- **Expired or invalid API key**: Inference requests to external service will fail; error message should indicate authentication failure without exposing the API key in logs or UI
- **External service rate limiting**: If external provider throttles requests, error should surface to user in Playground with clear indication of rate limit issue
- **Scoping mismatch (if endpoints are namespace-scoped but secrets are user-scoped)**: When User B tries to use an endpoint registered by User A, the system must detect that User B does not have access to User A's secret and display a clear error message (e.g., "Cannot authenticate - secret not accessible")
- **Namespace deletion**: When namespace is deleted, all external endpoint records and associated Kubernetes Secrets should be cleaned up automatically
- **Duplicate model IDs or aliases**: System should allow or prevent duplicate model IDs within the same namespace; if allowed, users must be able to distinguish between them (e.g., by URL, alias, or description)
- **URL format validation**: Should the system validate that the endpoint URL follows expected patterns (e.g., HTTPS required)? Or accept any URL and let inference failures surface naturally?

---

## Potential Spikes

### Spike 1: OpenAI-Compliant Passthrough Mechanism
**Uncertainty**: How will serving runtimes proxy requests to external endpoints while maintaining OpenAI API compatibility end-to-end?
**Spike Goal**: Validate that existing serving runtimes can forward requests to arbitrary external URLs without breaking Playground's expected request/response format.
**Recommended Timebox**: 2 days

### Spike 2: Kubernetes Secret Injection for Inference
**Uncertainty**: How will API keys stored as Kubernetes Secrets be injected into inference requests sent to external services?
**Spike Goal**: Determine the mechanism for runtime access to secrets (environment variables, volume mounts, or sidecar injection) and confirm compatibility with serving runtime architecture.
**Recommended Timebox**: 2 days

---

## Cross-Team Dependencies

| Team | Requirement | Type | Notes |
|------|-------------|------|-------|
| **UX Team** | Design for minimal registration wizard with required fields (Model ID text, URL, API Key, optional Model Alias, "Verify Model" button, and potentially Serving Runtime - pending clarification) | Design | Blocking for Epic 1 MVP |
| **UX Team** | Design for visual distinction between external and internal models (icon, badge, filter, etc.) | Design | Blocking for Epic 2 |
| **UX Team** | (TBD) Design for scoping mismatch scenario: What UI/error shows when User B tries to use endpoint registered by User A if secrets are user-scoped? | Design | Blocking for Epic 2 & 3 if scoping mismatch exists |

---

## Performance & Scaling

- **Increased external API calls**: Each external endpoint in use may generate additional outbound API requests to third-party services; namespace-level rate limiting or quota management may be needed to prevent cost overruns
- **Secret storage overhead**: Each external endpoint creates a new Kubernetes Secret; no significant impact expected for typical use (dozens of endpoints per namespace)
- **Latency variability**: External model response times depend on third-party service performance; Playground should remain responsive even if external requests are slow (non-blocking UI)
- **Concurrent external requests**: Multiple users in a namespace using the same external endpoint simultaneously will increase load on the external service; users are responsible for managing their own API rate limits and quotas

---

## Success Criteria

### Measurable Outcomes

- **SC-001**: AI Engineers can successfully register external model endpoints and see them appear in AI Available Assets without errors
- **SC-002**: AI Engineers can distinguish between internal and external models in the Assets list at a glance
- **SC-003**: AI Engineers can select external endpoints in the AI Playground and receive inference responses consistently
- **SC-004**: API keys are stored securely as Kubernetes Secrets and never exposed in plain text in logs or UI
- **SC-005**: External endpoint deletion removes all associated resources (endpoint record and Secret) from the namespace
- **SC-006**: Users with namespace access can view and use all registered external endpoints (namespace-scoped visibility)
- **SC-007**: Registration form provides clear validation feedback and prevents submission with missing required fields
- **SC-008**: External model inference requests fail gracefully with actionable error messages when external services are unreachable or return errors

---

## Open Questions for Architecture Review

The following questions require architectural clarification before implementation:

**Q**: **🚨 CRITICAL** - Are secrets (API keys) namespace-scoped OR user-scoped?
**A**: _______________

**Q**: **🚨 CRITICAL** - If external endpoints are namespace-scoped but secrets are user-scoped, what happens when User B tries to use an endpoint registered by User A with User A's secret? How should the system handle authentication and what error/UX should be shown?
**A**: _______________

**Q**: **🚨 CRITICAL** - What are the implementation details for pointing to an external model? (e.g., Is it a LLMInferenceService that's proxying to the external API using a serving runtime?)
**A**: _______________

**Q**: Is selecting a serving runtime required for external endpoint registration, or can this be auto-determined/optional?
**A**: _______________

**Q**: **🚨 CRITICAL** - What are the implementation details for creating and fetching a secret?
**A**: _______________

**Q**: What RBAC roles are required for users to register external endpoints?
**A**: _______________

**Q**: What is the scope of model verification? Should it be a health check (ping endpoint) or a sample inference request to the model?
**A**: _______________

**Q**: Is model verification optional (user clicks "Verify Model" button), or should we verify automatically during registration and warn the user if it fails?
**A**: _______________

**Q**: Are we automatically adding this model to the llama stack instance after creation?
**A**: _______________

**Q**: Should duplicate model IDs or aliases be allowed within the same scope (namespace or user)? If so, how should users distinguish between them?
**A**: _______________
