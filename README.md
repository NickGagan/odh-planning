# ODH Planning

Planning and specification repository for OpenShift Data Hub (ODH) features, with a focus on the Crimson Dashboard.

## Purpose

This repository provides a structured approach to feature planning using the `.specify` framework. It contains detailed specifications, implementation plans, and cross-team coordination materials for ODH features.

## Repository Structure

```
specs/
├── 001-playground-compare/      # Feature: Model comparison in playground
├── 002-playground-prompt-ui/    # Feature: Prompt-centric playground UI
└── 003-playground-prompt-lab/   # Feature: Prompt lab functionality
```

Each feature specification includes:
- **spec.md** - Detailed feature specification
- **plan.md** - Implementation plan and approach
- **checklists/** - Requirements and acceptance criteria
- **coordination/** - Executive summaries and team briefs
- **contracts/** - API contracts and dependencies

## Getting Started
> see https://github.com/github/spec-kit
### Templates

Specification templates are available in `.specify/templates/`:
- `spec-template.md` - Feature specification structure
- `plan-template.md` - Implementation planning format
- `tasks-template.md` - Task breakdown template
- `checklist-template.md` - Requirements checklist

### Constitution

The planning framework follows the [Crimson Dashboard Constitution](.specify/memory/constitution.md), which defines personas, principles, and workflows for feature planning.

## Contributing

See [CODEOWNERS](.github/CODEOWNERS) for team ownership and review requirements.

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details.
