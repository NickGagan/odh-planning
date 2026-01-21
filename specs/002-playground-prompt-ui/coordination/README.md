# Coordination & Stakeholder Communication

**Feature**: Prompt-Centric Gen AI Playground UI (002-playground-prompt-ui)  
**Date**: January 7, 2026  
**Purpose**: Cross-team coordination and stakeholder alignment

---

## Overview

This directory contains **stakeholder communication artifacts** generated per Constitution Principle IX (Post-Planning Workflow). These documents enable effective coordination across teams and leadership.

---

## Artifacts

### Executive Summary
**File**: [executive-summary.md](./executive-summary.md)  
**Audience**: Executive team, engineering leads, product leadership  
**Purpose**: High-level overview of business case, scope, timeline, risks, and success metrics

**Distribution**:
- Directors and VPs
- Cross-functional leadership
- Program management

**Use Cases**:
- Executive briefings
- Portfolio reviews
- Budget/resource allocation discussions
- Strategic planning

---

### Team Briefs

Individual briefs for each affected team, containing only their relevant information.

#### Dashboard Team
**File**: [briefs/dashboard-team.md](./briefs/dashboard-team.md)  
**Role**: Implementation Owner  
**Key Sections**: Requirements, technical constraints, dependencies, timeline, implementation autonomy

**Purpose**: Full context for implementing team with clear ownership and decision-making authority.

---

#### Backend Team
**File**: [briefs/backend-team.md](./briefs/backend-team.md)  
**Role**: API Support (No Changes Required)  
**Key Sections**: Existing APIs being used, support responsibilities, contract confirmation needs

**Purpose**: Minimal involvement brief - confirms no backend changes, clarifies support role.

---

#### UX Team
**File**: [briefs/ux-team.md](./briefs/ux-team.md)  
**Role**: Design Validation & Accessibility Review  
**Key Sections**: Design requirements, PatternFly guidance, accessibility standards, onboarding design

**Purpose**: Ensures design integrity and accessibility compliance throughout implementation.

---

#### QE Team
**File**: [briefs/qe-team.md](./briefs/qe-team.md)  
**Role**: Test Planning & Quality Validation  
**Key Sections**: Test scope, edge cases, quality criteria, UAT checklist

**Purpose**: Comprehensive quality assurance coverage and sign-off responsibility.

---

#### PM Team
**File**: [briefs/pm-team.md](./briefs/pm-team.md)  
**Role**: Product Owner & User Acceptance  
**Key Sections**: User requirements, acceptance criteria, success metrics, go/no-go decision

**Purpose**: Product validation and launch decision authority.

---

#### Docs Team
**File**: [briefs/docs-team.md](./briefs/docs-team.md)  
**Role**: Release Notes & User Documentation  
**Key Sections**: Documentation needs, content requirements, feature messaging

**Purpose**: User-facing content creation and feature announcement.

---

## Distribution Guidelines

### Pre-Kickoff (Week 0)
**Distribute**:
- Executive Summary → Leadership + All Team Leads
- Individual Team Briefs → Respective teams

**Method**: Email with links to briefs, schedule kickoff meeting

---

### Kickoff Meeting (Week 1)
**Attendees**: Representatives from all teams + PM + Architect

**Agenda**:
1. Overview (PM): Business case and user needs (10 min)
2. Requirements (PM): User stories and acceptance criteria (15 min)
3. Technical Context (Dashboard): Implementation approach (10 min)
4. Team Roles (All): Each team confirms responsibilities (15 min)
5. Dependencies (All): Cross-team coordination needs (10 min)
6. Q&A (All): Clarifying questions (10 min)

**Outcome**: All teams understand scope, responsibilities, and timelines

---

### Sprint Planning/Refinement
**Use Team Briefs**:
- Dashboard Team: Plan sprints based on P1/P2/P3 priorities
- QE Team: Create test plans from acceptance criteria
- UX Team: Schedule design reviews at key milestones

---

### Status Updates
**Use Executive Summary**:
- Weekly status reports to leadership
- Monthly program reviews
- Quarterly OKR tracking

---

## Maintenance

### When to Update Briefs

**Requirements Change**: Update affected team briefs and executive summary

**Timeline Shift**: Update all briefs with new milestones

**Scope Change**: Update executive summary (in/out of scope) and affected team briefs

**Risk Discovered**: Add to executive summary risk register

### Version Control

- Track changes in git
- Note significant updates in brief headers
- Communicate updates to affected teams

---

## Contact & Feedback

**Questions about briefs**: #crimson-dashboard Slack channel  
**Feedback on format**: PM Team or Dashboard Architect  
**Missing information**: File issue or reach out to brief owner

---

## Templates

These briefs serve as **templates for future features**. When creating new feature plans:

1. Copy structure from this feature's briefs
2. Customize content for new feature context
3. Ensure each brief is 1-2 pages (concise, actionable)
4. Focus on WHAT each team needs to know, not HOW to implement

---

## Benefits of This Approach

✅ **Clarity**: Each team gets only their relevant information  
✅ **Efficiency**: No need to read entire plan to understand your role  
✅ **Accountability**: Clear ownership and deliverables per team  
✅ **Alignment**: Everyone understands the big picture via executive summary  
✅ **Scalability**: Works for single-team and cross-team features  
✅ **Reusability**: Briefs serve as templates for future features

---

**Generated by**: Constitution Principle IX (Post-Planning Workflow)  
**Version**: 1.0  
**Last Updated**: January 7, 2026

