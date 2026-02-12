# ODH Planning Session Configuration

This file configures Claude Code sessions for the ODH Planning repository, automating the spec-kit workflow for feature specification.

## Session Initialization

When a session starts, follow this initialization flow:

### Step 1: Welcome and Mode Selection

Begin by greeting the user and asking:

```
Welcome to ODH Planning! This session will help you create or continue work on a feature specification.

Are you working on:
1. **New Specification** - Create a new feature spec from strategic input
2. **Existing Specification** - Continue work on an existing spec branch

Please choose (1 or 2):
```

### Step 2: Branch Setup

**If New Specification (1):**

1. Confirm we're on the latest `main` branch:
   ```bash
   git fetch origin
   git checkout main
   git pull origin main
   ```

2. Proceed to [Step 3: Gather Strategic Input](#step-3-gather-strategic-input-new-specs-only)

**If Existing Specification (2):**

1. Ask for the branch identifier:
   ```
   Please provide the branch name or spec number (e.g., "004-playground-compare" or just "4"):
   ```

2. List available spec branches to help the user if needed:
   ```bash
   git branch -a | grep -E '^[* ]*[0-9]{3}-|remotes/origin/[0-9]{3}-'
   ```

3. Checkout the specified branch:
   ```bash
   git fetch origin
   git checkout <branch-name>
   ```

4. Load and summarize the existing spec files:
   - Read `specs/<branch-name>/spec.md`
   - Read any files in `specs/<branch-name>/checklists/`
   - Read any files in `specs/<branch-name>/contracts/`

5. Present a summary:
   ```
   Loaded specification: [Feature Name]
   Status: [Draft/In Review/Approved]
   Epics: [count]
   
   What would you like to do?
   - Update the specification
   - Run /speckit.clarify to resolve open questions
   - Run /speckit.checklist to validate requirements
   - Something else?
   ```

6. Await user command and proceed accordingly.

### Step 3: Gather Strategic Input (New Specs Only)

For new specifications, gather the required context:

**3a. Strategic Link**

```
Please provide the strategic link (Jira epic, initiative, or feature request URL):
```

**3b. Load or Request Description**

- **If Jira integration is available**: Use `gh` or Jira CLI to fetch the strategic item's description:
  ```bash
  # Example for GitHub issue
  gh issue view <issue-number> --json title,body
  ```

- **If no integration or manual input preferred**: Ask the user:
  ```
  Please provide the jira description
  ```

**3c. Additional Context (Optional)**

```
Do you have any additional context to provide?
- Figma designs or mockups (URL)
- Technical documentation
- Related specifications in this repo
- API contracts or dependencies

(Enter URLs/paths or type "skip" to continue):
```

### Step 4: Start Specification (New Specs Only)

Once context is gathered, initiate the spec-kit workflow:

1. Summarize the collected input:
   ```
   Ready to create specification with:
   - Strategic Input: [link/description summary]
   - Additional Context: [list any provided]
   
   Starting specification discovery...
   ```

2. Begin the `/speckit.specify` flow, which will:
   - Conduct discovery through sequential clarifying questions (per Constitution Principle X)
   - Create the feature branch using `.specify/scripts/bash/create-new-feature.sh`
   - Generate the spec.md following the template and constitution guidelines
   - Validate against the spec quality checklist

## Key References

### Constitution Location
- `.specify/memory/constitution.md` - Crimson Dashboard Constitution (v3.0.0)

### Spec-Kit Commands
- `/speckit.specify` - Create new specification from description
- `/speckit.clarify` - Resolve [NEEDS CLARIFICATION] markers
- `/speckit.checklist` - Validate specification completeness
- `/speckit.plan` - (Not used in current workflow - spec.md is terminal artifact)

### Templates
- `.specify/templates/spec-template.md` - Specification structure
- `.specify/templates/checklist-template.md` - Requirements checklist format

### Team Ownership Reference
Consult Constitution Principle VIII for team-to-code-area mappings. Primary teams:
- `gen-ai` - GenAI features
- `model-serving-metrics` - Model serving
- `model-registry-catalog` - Model registry
- `pipelines` - ML pipelines
- `workbenches` - Notebooks/workbenches
- `platform` - Core platform

### Target Personas
All specifications must reference these personas (Constitution Section):
- **Data Scientist** - The Innovator (notebooks, experimentation)
- **AI Engineer** - The Builder (GenAI apps, prompt engineering)
- **ML Ops Engineer** - The Automator (deployment, monitoring)
- **Platform Engineer** - The Enabler (infrastructure, security)

## Workflow Principles

1. **Spec.md is the terminal artifact** - No separate planning or task generation phase
2. **Sequential discovery** - Ask clarifying questions ONE AT A TIME
3. **Cross-team dependencies** - Identify early using OWNERS reference
4. **Spike identification** - Flag areas of uncertainty for time-boxed research
5. **Immutable specs** - Once created, tracking happens in Jira/external systems
6. **Technology-agnostic** - Specify WHAT and WHY, never HOW to implement

## Error Handling

- If branch doesn't exist: Offer to create it or list available branches
- If spec file is missing: Offer to initialize from template
- If git operations fail: Check remote connectivity, suggest manual steps
- If strategic link is inaccessible: Fall back to manual description input

## Session Commands

The user may use these commands at any time:
- `status` - Show current branch and spec summary
- `constitution` - Display relevant constitution principles
- `teams` - Show team ownership reference
- `personas` - Display target persona summaries
