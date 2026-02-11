# Feature Specification: Playground Prompts

**Feature Branch**: `009-playground-prompts`
**Created**: 2026-01-27
**Status**: Draft
**Input**: User description: "Playground-native Prompt experience for loading, editing, saving, and versioning prompts from Prompt Registry"

## Design References

- **Prototype**: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground
- **Figma**: https://www.figma.com/design/0KwA2EuFmA48GAQAOyjbIb/3.4-Playground?node-id=440-3247&t=aCrLHQvSQ2iGGXat-0

## Epics *(mandatory)*

### Epic 1: Load Prompt Modal (Priority: P1, Owner: Dashboard/gen-ai)

Implement a "Load Prompt" modal accessible from the existing prompt area in Playground, allowing users to browse and load prompts from the Prompt Registry or Sample Prompts.

**User Value**: Users can discover and load governed prompts directly within Playground, eliminating manual copy/paste and maintaining version awareness.

**Technical Considerations**:
- Modal opens via "Load Prompt" button in existing prompt area
- Must support browsing both Prompt Registry (versioned) and Sample Prompts (non-versioned)
- Sidebar within modal shows prompt details and version selector when a prompt is selected

**Outcomes by Persona**:

_AI Engineer_:
- Click "Load Prompt" to open prompt selection modal
- Browse prompts from Prompt Registry and Sample Prompts
- Select a prompt to view details in sidebar (name, description, version history)
- Choose specific version from dropdown before loading

_Data Scientist_:
- Quickly find relevant prompts by browsing available options
- Understand prompt purpose from metadata before loading

---

### Epic 2: Version Selection (Priority: P1, Owner: Dashboard/gen-ai)

Enable version selection when loading prompts from the Prompt Registry, allowing users to work with specific versions of governed prompts.

**User Value**: Users can select and work with specific prompt versions, enabling reproducible experimentation and safe rollback to known-good versions.

**Technical Considerations**:
- Version dropdown appears in sidebar when registry prompt is selected
- Default to latest version, allow selection of older versions
- Sample prompts have no version selector (non-versioned)

**Outcomes by Persona**:

_AI Engineer_:
- See version dropdown in prompt details sidebar
- View version number and timestamp for each version
- Switch between versions before clicking "Load Prompt"
- Load older version if latest has issues

_ML Ops Engineer_:
- Reproduce experiments with specific prompt versions
- Compare behavior across prompt versions

---

### Epic 3: Prompt Editing with Unsaved State (Priority: P1, Owner: Dashboard/gen-ai)

Allow users to edit registry prompts within Playground, with clear visual indication of unsaved changes and no implicit autosave. Sample/starter prompts are read-only and cannot be edited.

**User Value**: Users can experiment with registry prompt modifications safely, knowing changes won't affect the saved version until explicitly saved. Sample prompts serve as read-only templates that can be used as-is or saved as new prompts.

**Technical Considerations**:
- Editable prompt area within Playground for registry prompts only
- Sample/starter prompts are read-only (no editing capability)
- Clear visual state for "Modified" / "Unsaved changes" on editable prompts
- No autosave behavior; all saves are explicit
- Inline warning near "Load Prompt" button when unsaved changes exist

**Outcomes by Persona**:

_AI Engineer_:
- Edit loaded registry prompts freely within Playground
- See clear "Unsaved changes" indicator when modifications exist
- See warning message near "Load Prompt" when attempting to load different prompt with unsaved changes
- Understand that sample prompts are read-only templates
- Understand that changes are not automatically saved

_Data Scientist_:
- Experiment with registry prompt variations without affecting saved versions
- Use sample prompts as-is for quick experimentation
- Clearly distinguish between original and modified prompt state

**Editability by Prompt Source**:
| Prompt Source | Editable | Notes |
|---------------|----------|-------|
| Registry prompt | ✅ Yes | Can edit, save as new version or fork |
| Sample prompt | ❌ No | Read-only; can only save as new prompt |
| Local/new | ✅ Yes | Editable until saved |

**Visual States** (for editable prompts):
| State | Indicator |
|-------|-----------|
| Clean (unchanged) | No indicator |
| Modified (unsaved) | "Unsaved changes" badge/label |
| Loading different prompt | Inline warning: "Loading prompt will overwrite current prompt" |
| Sample prompt loaded | "Read-only" indicator |

---

### Epic 4: Save Prompt (Priority: P1, Owner: Dashboard/gen-ai)

Enable users to save prompts from Playground, supporting save as new version (for registry prompts), save as new prompt (fork), and save new prompt (from scratch).

**User Value**: Users can persist their prompt work from Playground to the Prompt Registry, creating new versions or new prompts as appropriate.

**Technical Considerations**:
- Save options depend on prompt provenance (registry, sample, local/new)
- Registry prompts can save as new version or fork as new prompt
- Sample prompts can only be saved as new prompt (no versioning)
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
| Sample prompt | ❌ No | ✅ Yes |
| Local/new | ❌ No | ✅ Yes |

> **Dependency**: Razzmatazz team (RHAISTRAT-150) must provide save/version APIs.

---

### Epic 5: Revert Unsaved Changes (Priority: P1, Owner: Dashboard/gen-ai)

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

### Epic 6: Prompt Provenance Display (Priority: P1, Owner: Dashboard/gen-ai)

Display clear provenance information for the current prompt, helping users understand the source and governance status of the prompt they're working with.

**User Value**: Users always know whether they're working with a governed registry prompt, a sample prompt, or an unsaved local prompt, informing their save and sharing decisions.

**Technical Considerations**:
- Provenance indicator visible in prompt area
- Shows source type and version (if applicable)
- Updates when prompt is loaded or saved

**Outcomes by Persona**:

_AI Engineer_:
- See provenance indicator showing prompt source (Registry, Sample, Local)
- See version number for registry prompts
- Understand governance status at a glance

**Provenance Indicators**:
| Source | Display |
|--------|---------|
| Registry prompt | "From Registry: [name] v[version]" |
| Sample prompt | "Sample: [name]" |
| Local/unsaved | "Unsaved prompt" |

---

### Edge Cases

- What happens when Prompt Registry API is unavailable? Show error state in modal; allow continued editing of current prompt; disable save to registry.
- What happens if user tries to save a prompt with a name that already exists? Show error from registry API; prompt user to choose different name.
- What happens if the prompt version was deleted while user was editing? Save as new version fails; offer to save as new prompt instead.
- What happens when loading a prompt type incompatible with current Playground mode? [NEEDS CLARIFICATION: How do text vs chat prompts map to Playground?]
- What happens if registry save fails mid-operation? Show error message; preserve local state; allow retry.
- What happens with very long prompts? Prompt area should scroll; consider character limit warnings if registry has limits.

## Potential Spikes

| Area | Uncertainty | Spike Goal | Recommended Timebox |
|------|-------------|------------|---------------------|
| Prompt Registry API Contract | APIs being built in parallel (RHAISTRAT-150) | Validate API contract for load/save/version operations | 2 days |
| Prompt Type Mapping | Unclear how "text" vs "chat" prompts map to Playground UI | Determine UX for loading different prompt types | 1 day |

## Performance & Scaling

| Concern | Impact | Consideration |
|---------|--------|---------------|
| **Registry API latency** | Modal load time depends on registry response | Consider pagination/lazy loading for large prompt catalogs |
| **Version history size** | Prompts with many versions may have long dropdown | Limit displayed versions; provide search/filter if needed |
| **Prompt size** | Very large prompts may impact editor performance | Monitor editor performance; consider lazy rendering |

## System Constraints

- No autosave; all saves are explicit user actions
- Sample prompts are read-only and cannot be edited (can only be saved as new prompt)
- Sample prompts cannot be versioned (only forked as new prompt)
- Prompt Registry APIs must be available for full functionality (partial degradation if unavailable)
- Prompts have two types: "text" and "chat" (chat has system prompt component)

## Key Entities

- **Prompt**: A reusable instruction template, either "text" type or "chat" type (with system component)
- **Prompt Version**: A specific revision of a registry prompt, with version number and timestamp
- **Prompt Registry**: The governed store for versioned prompts (RHAISTRAT-150)
- **Sample Prompt**: A non-versioned example prompt for learning/templates
- **Prompt Provenance**: The source and governance status of a prompt (Registry, Sample, Local)

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can load prompts from Prompt Registry into Playground via modal
- **SC-002**: Users can load sample prompts into Playground
- **SC-003**: Users can select specific versions when loading registry prompts
- **SC-004**: Users can edit registry prompts without immediately affecting saved versions (sample prompts are read-only)
- **SC-005**: Users can save edits as new version (registry prompts) or new prompt
- **SC-006**: Sample prompts cannot be versioned (only saved as new prompt)
- **SC-007**: Users can revert unsaved edits back to loaded version
- **SC-008**: Prompt provenance is clearly visible (Registry, Sample, Local)
- **SC-009**: Unsaved changes are clearly indicated with "Modified" state

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

### Q1: Sample Prompts Source
Where do sample prompts come from?
1. Bundled with product - Sample prompts shipped as static content with Dashboard
2. ConfigMap/admin-managed - Platform admin configures sample prompts
3. External repository - Fetched from a Red Hat-managed samples repository
4. Other

### Q2: Prompt Type Mapping
Prompts can be "text" or "chat" (with system component). When loading into Playground:
1. Text prompts → user message area
2. Chat prompts → system prompt + optionally pre-fills user message
3. User chooses where to apply
4. Other

### Q3: Save Destination Model
When a user saves a new prompt or new version from Playground, where does it go?
1. Always to Prompt Registry (governed)
2. User chooses destination (registry, personal workspace, etc.)
3. Local only option (browser/session) without registry
4. Registry within user's namespace
5. Other

## Clarifications

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
- Sample prompts exist and are accessible (source to be clarified)
- Users understand the difference between governed (registry) and sample prompts
- Modal/drawer pattern is consistent with existing Playground UI patterns
- Prompt Registry handles authorization (who can save/version prompts)

## Future Considerations (Post-MVP)

- Visual diff between prompt versions
- Inline prompt metadata editing (tags, owner, status)
- Read-only view for certified prompts
- Prompt comparison across models (ties into eval workflows)
- Approval workflows for prompt changes
- Non-playground consumers (SDK, CI, etc.)
