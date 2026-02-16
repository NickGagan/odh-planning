# Feature Specification: Playground Prompts

**Feature Branch**: `009-playground-prompts`
**Created**: 2026-01-27
**Status**: Draft
**Input**: User description: "Playground-native Prompt experience for loading, editing, saving, and versioning prompts from Prompt Registry"

## Design References

- **Prototype**: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground
- **Figma**: https://www.figma.com/design/0KwA2EuFmA48GAQAOyjbIb/3.4-Playground?node-id=440-3247&t=aCrLHQvSQ2iGGXat-0

### User Flow Summary (from Figma)

The Prompt tab provides two entry paths for working with managed prompts:

**Path A: Draft → Save (Top row)**
1. User drafts a prompt directly in the Instructions text field
2. When ready, user opens Save Prompt modal
3. Modal requires: prompt name, prompt type (text or chat)
4. Prompt field auto-populates with drafted content
5. For chat type, the drafted prompt becomes the system prompt

**Path B: Load → Edit → Save (Middle row)**
1. User clicks "Load Prompt" to open modal
2. User browses/searches prompts in namespace registry
3. Sidebar shows prompt preview with version selector
4. Loaded prompt displays with provenance indicator and "Clear" option
5. System instructions load as read-only by default
6. User clicks "Edit prompt" to enable editing
7. Modified prompts show "Unsaved changes" indicator
8. User saves changes (new version or new prompt)

**Path C: Example Prompts Flow (Bottom row)**
1. User clicks to view example prompts from global registry
2. User can preview prompt details before loading
3. Example prompt loads as read-only (can query model immediately)
4. User enters edit mode to modify
5. User saves edited prompt to namespace registry

### Open Design Questions (from Figma)

- Should example prompts have a dedicated tab in the load modal? (Pending: dedicated tab vs mixed list with filter)

## Epics *(mandatory)*

### Epic 1: Load Prompt Modal (Priority: P1, Owner: Dashboard/gen-ai)

Implement a "Load Prompt" modal accessible from the existing prompt area in Playground, allowing users to browse, preview, and load prompts from the Prompt Registry or Example Prompts with version selection.

**User Value**: Users can discover and load governed prompts directly within Playground, eliminating manual copy/paste, maintaining version awareness, and enabling reproducible experimentation.

**Technical Considerations**:
- Modal opens via "Load Prompt" button in existing prompt area
- Must support browsing both Prompt Registry (versioned) and Example Prompts (non-versioned)
- Sidebar within modal shows prompt details and version selector when a prompt is selected
- Version dropdown appears in sidebar when registry prompt is selected
- Default to latest version, allow selection of older versions
- Example prompts have no version selector (non-versioned)

**Outcomes by Persona**:

_AI Engineer_:
- Click "Load Prompt" to open prompt selection modal
- Browse prompts from Prompt Registry and Example Prompts
- Select a prompt to view details in sidebar (name, description, version history)
- See version dropdown in prompt details sidebar for registry prompts
- View version number and timestamp for each version
- Switch between versions before clicking "Load Prompt"
- Load older version if latest has issues

_Data Scientist_:
- Quickly find relevant prompts by browsing available options
- Understand prompt purpose from metadata before loading

_ML Ops Engineer_:
- Reproduce experiments with specific prompt versions
- Compare behavior across prompt versions

---

### Epic 2: Prompt State & Editing (Priority: P1, Owner: Dashboard/gen-ai)

Manage prompt state in Playground including provenance display, edit mode, unsaved change tracking, and clearing loaded prompts. Example prompts are read-only and cannot be edited.

**User Value**: Users always know the source and state of their current prompt, can safely experiment with modifications without affecting saved versions, and can clear prompts to start fresh.

**Technical Considerations**:
- Provenance indicator visible in prompt area showing source and version
- "Edit prompt" button to enter edit mode for registry prompts
- Example prompts are read-only (no editing capability)
- Clear visual state for "Modified" / "Unsaved changes" on editable prompts
- No autosave behavior; all saves are explicit
- Inline warning near "Load Prompt" button when unsaved changes exist
- "Clear" action to unload current prompt and return to blank state

**Outcomes by Persona**:

_AI Engineer_:
- See provenance indicator showing prompt source (Registry, Example, Local)
- See version number for registry prompts
- Click "Edit prompt" to enter edit mode for registry prompts
- Edit loaded registry prompts freely within Playground
- See clear "Unsaved changes" indicator when modifications exist
- See warning message near "Load Prompt" when attempting to load different prompt with unsaved changes
- Click "Clear" to unload current prompt and start fresh
- Understand that example prompts are read-only templates
- Understand that changes are not automatically saved

_Data Scientist_:
- Understand governance status at a glance
- Experiment with registry prompt variations without affecting saved versions
- Use example prompts as-is for quick experimentation
- Clearly distinguish between original and modified prompt state
- Clear prompt to start over with a blank slate

**Editability by Prompt Source**:
| Prompt Source | Editable | Notes |
|---------------|----------|-------|
| Registry prompt | ✅ Yes | Can edit, save as new version or fork |
| Example prompt | ❌ No | Read-only; can only save as new prompt |
| Local/new | ✅ Yes | Editable until saved |

**Visual States**:
| State | Indicator |
|-------|-----------|
| Clean (unchanged) | No indicator |
| Modified (unsaved) | "Unsaved changes" badge/label |
| Loading different prompt | Inline warning: "Loading prompt will overwrite current prompt" |
| Example prompt loaded | "Read-only" indicator |

**Provenance Indicators**:
| Source | Display |
|--------|---------|
| Registry prompt | "From Registry: [name] v[version]" |
| Example prompt | "Example: [name]" |
| Local/unsaved | "Unsaved prompt" |

**Actions**:
| Action | Availability | Behavior |
|--------|--------------|----------|
| Edit prompt | Registry prompts only | Enters edit mode |
| Clear | Any loaded prompt | Unloads prompt, returns to blank state |

---

### Epic 3: Save Prompt (Priority: P1, Owner: Dashboard/gen-ai)

Enable users to save prompts from Playground, supporting save as new version (for registry prompts), save as new prompt (fork), and save new prompt (from scratch).

**User Value**: Users can persist their prompt work from Playground to the Prompt Registry, creating new versions or new prompts as appropriate.

**Technical Considerations**:
- Save options depend on prompt provenance (registry, example, local/new)
- Registry prompts can save as new version or fork as new prompt
- Example prompts can only be saved as new prompt (no versioning)
- New/unsaved prompts save as new prompt

**Outcomes by Persona**:

_AI Engineer_:
- Save modified registry prompt as new version
- Fork any prompt as a new prompt with new name
- Save new prompt created from scratch

_ML Ops Engineer_:
- Maintain version history for iterative prompt development
- Create team-specific forks of shared prompts

**Save Options by Provenance**:
| Prompt Source | Save as New Version | Save as New Prompt |
|---------------|---------------------|-------------------|
| Registry prompt | ✅ Yes | ✅ Yes (fork) |
| Example prompt | ❌ No | ✅ Yes (blank name required) |
| Local/new | ❌ No | ✅ Yes |

**Save Modal Behavior**:
- When saving an example prompt as new: name field is blank (user must provide new name)
- When forking a registry prompt: name field may pre-populate with original name
- Prompt content auto-populates from current playground state

> **Dependency**: Razzmatazz team (RHAISTRAT-150) must provide save/version APIs.

---

### Epic 4: Revert Unsaved Changes (Priority: P1, Owner: Dashboard/gen-ai)

Allow users to revert their edits back to the last loaded version, discarding unsaved changes without affecting registry content.

**User Value**: Users can safely undo experimentation and return to the original prompt state without reloading from the registry.

**Technical Considerations**:
- Revert only available when unsaved changes exist
- Reverts to last loaded version (not necessarily latest registry version)
- No confirmation dialog required (operation is reversible by re-editing)

**Outcomes by Persona**:

_AI Engineer_:
- Click "Revert" to discard unsaved changes
- Return to exact state of last loaded prompt
- Revert is available only when unsaved changes exist

_Data Scientist_:
- Safely abandon failed prompt experiments
- Quickly reset to known-good starting point

---

### Edge Cases

- What happens when Prompt Registry API is unavailable? Show error state in modal; allow continued editing of current prompt; disable save to registry.
- What happens if user tries to save a prompt with a name that already exists? Show error from registry API; prompt user to choose different name.
- What happens if the prompt version was deleted while user was editing? Save as new version fails; offer to save as new prompt instead.
- What happens when loading a legacy "text" prompt? Text prompts are automatically treated as chat-system prompts and loaded into the system prompt area.
- What happens when loading an MLFlow prompt with user/assistant roles? User and assistant rows are displayed as read-only; only the system prompt is editable.
- What happens if registry save fails mid-operation? Show error message; preserve local state; allow retry.
- What happens with very long prompts? Prompt area should scroll; consider character limit warnings if registry has limits.
- What happens when user clicks "Clear"? Prompt is unloaded, provenance indicator removed, prompt area returns to blank state.

## Potential Spikes

| Area | Uncertainty | Spike Goal | Recommended Timebox |
|------|-------------|------------|---------------------|
| Prompt Registry API Contract | APIs being built in parallel (RHAISTRAT-150) | Validate API contract for load/save/version operations | 2 days |
| MLFlow Prompt Handling | Prompts with user/assistant roles need special handling | Validate read-only row behavior and system prompt isolation | 1 day |

## Performance & Scaling

| Concern | Impact | Consideration |
|---------|--------|---------------|
| **Registry API latency** | Modal load time depends on registry response | Consider pagination/lazy loading for large prompt catalogs |
| **Version history size** | Prompts with many versions may have long dropdown | Limit displayed versions; provide search/filter if needed |
| **Prompt size** | Very large prompts may impact editor performance | Monitor editor performance; consider lazy rendering |

## System Constraints

- Prompts are model-agnostic; model configuration is set separately in playground (not stored with prompt)
- No autosave; all saves are explicit user actions — all edits create new versions
- Example prompts are read-only and cannot be edited (can only be saved as new prompt)
- Example prompts cannot be versioned (only forked as new prompt)
- Prompt Registry APIs must be available for full functionality (partial degradation if unavailable)
- All prompts are treated as "chat" type with system prompt component
- Legacy "text" prompts are not supported in 3.4; they will be migrated to chat-system prompts in future releases
- Users can swap between prompt types (text ↔ chat) — existing text prompts load and save as chat-system prompts
- MLFlow-originated prompts with "user" or "assistant" roles have those rows as read-only; only system prompt is editable
- Create prompt modal uses its own UI (not duplicating MLFlow UI) for flexibility

## Key Entities

- **Prompt**: A reusable instruction template; all prompts are "chat" type with system prompt component in 3.4
- **Prompt Version**: A specific revision of a registry prompt, with version number and timestamp
- **Prompt Registry**: The governed store for versioned prompts (RHAISTRAT-150)
- **Example Prompt**: A non-versioned example prompt for learning/templates; read-only
- **Prompt Provenance**: The source and governance status of a prompt (Registry, Example, Local)
- **MLFlow Prompt**: A prompt originating from MLFlow UI that may contain user/assistant roles (read-only rows)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can load prompts from Prompt Registry into Playground via modal
- **SC-002**: Users can load example prompts into Playground
- **SC-003**: Users can select specific versions when loading registry prompts
- **SC-004**: Users can edit registry prompts without immediately affecting saved versions (example prompts are read-only)
- **SC-005**: Users can save edits as new version (registry prompts) or new prompt
- **SC-006**: Example prompts cannot be versioned (only saved as new prompt)
- **SC-007**: Users can revert unsaved edits back to loaded version
- **SC-008**: Prompt provenance is clearly visible (Registry, Example, Local)
- **SC-009**: Unsaved changes are clearly indicated with "Modified" state
- **SC-010**: Users can clear loaded prompt to return to blank state

## Cross-Team Dependencies

| Team | Requirement | Type | Notes |
|------|-------------|------|-------|
| **Razzmatazz** | Prompt Registry APIs (RHAISTRAT-150) | Integration | Load, save, version, list prompts; blocking dependency |
| **UX Team** | Load prompt modal, version selector, state indicators | Design | Modal layout, sidebar, provenance display |
| **Platform/Backend** | API integration | Integration | Proxy or direct calls to Prompt Registry |
| **QE Team** | E2E coverage for prompt workflows | Testing | Load, edit, save, revert flows |
| **Playground Team (gen-ai)** | UI implementation | Integration | Main implementation team |

### Blocking Dependencies

- **Razzmatazz (RHAISTRAT-150)**: Prompt Registry APIs must be available for registry prompt functionality
- **UX Team**: Designs for load modal, version selection, and state indicators

### Informational (Capacity/Awareness)

- **Docs Team**: New prompt workflow needs user documentation

## Needs Clarification

The following questions require PM input before finalizing the specification:

### Q1: Example Prompts Source
Where do example prompts come from?
1. Bundled with product - Example prompts shipped as static content with Dashboard
2. ConfigMap/admin-managed - Platform admin configures example prompts
3. External repository - Fetched from a Red Hat-managed samples repository
4. Other

### Q2: Save Destination Model
When a user saves a new prompt or new version from Playground, where does it go?
1. Always to Prompt Registry (governed)
2. User chooses destination (registry, personal workspace, etc.)
3. Local only option (browser/session) without registry
4. Registry within user's namespace
5. Other

## Clarifications

### Session 2026-02-16

- Q: What is the canonical term for non-versioned template prompts (starter/global/example)? → A: "Example prompts"
- Q: Are example prompts in scope for 3.4? → A: Yes, in scope — browsable and loadable in load modal
- Q: Should example prompts have dedicated tab or mixed list in load modal? → A: Pending UX decision (dedicated tab vs mixed list with filter)
- Q: Should save modal include model configuration? → A: No — prompts are model-agnostic; model set separately in playground
- Q: When saving an example prompt, should name pre-populate? → A: No — blank name; user must provide new name
- Q: Are epics still valid after Figma review? → A: Consolidated from 6 to 4 epics; added "Clear" action to Epic 2

### Design Refinement Session 2026-02-11

- Q: Should we duplicate the MLFlow UI in the create prompt modal? → A: No, use different UI for flexibility
- Q: Can users swap prompt types? → A: Yes, can swap between text and chat types
- Q: How are edits treated? → A: All edits to prompts are treated as new versions
- Q: Do we support the old "text" prompt type? → A: Not for 3.4; text prompts will later be translated to system prompts
- Q: How are prompts treated? → A: All prompts treated as "chat" type; existing text prompts load and save as chat-system prompts
- Q: What about MLFlow prompts with user/assistant roles? → A: User/assistant rows are read-only; only system prompt is editable
- Q: What do we call sample prompts? → A: "Example prompts"; namespace/published prompts come later

### Session 2026-01-27

- Q: Is Prompt Registry available? → A: Being built in parallel (RHAISTRAT-150); some APIs exist, others need coordination
- Q: Where does "Load Prompt" appear? → A: Button in existing prompt area opens modal/drawer
- Q: How does version selection work? → A: Sidebar in modal shows prompt details with version dropdown
- Q: What happens with unsaved changes when loading new prompt? → A: Inline warning "Loading prompt will overwrite current prompt" (no separate dialog)
- Q: What prompt types exist? → A: "text" or "chat"; chat has system prompt component
- Q: Who owns Prompt Registry? → A: Razzmatazz team (RHAISTRAT-150)

## Assumptions

- Prompt Registry (RHAISTRAT-150) will provide APIs for listing, loading, saving, and versioning prompts
- The existing Playground prompt area can accommodate provenance indicators and state badges
- Example prompts exist and are accessible (source to be clarified)
- Users understand the difference between governed (registry) and example prompts
- Modal/drawer pattern is consistent with existing Playground UI patterns
- Prompt Registry handles authorization (who can save/version prompts)

## Future Considerations (Post-MVP)

- Namespace/published prompts (beyond example prompts)
- Support for legacy "text" prompt type migration to chat-system prompts
- Visual diff between prompt versions
- Inline prompt metadata editing (tags, owner, status)
- Read-only view for certified prompts
- Prompt comparison across models (ties into eval workflows)
- Approval workflows for prompt changes
- Non-playground consumers (SDK, CI, etc.)
