# Team Brief: Docs Team

**Feature**: Prompt-Centric Gen AI Playground UI (002-playground-prompt-ui)  
**Your Role**: **Release Notes & User Documentation**  
**Timeline**: 6 weeks from kickoff  
**Date**: January 7, 2026

---

## Your Responsibilities

You are responsible for **user-facing documentation** and **release notes**.

**Key Deliverables**:
- Release notes draft (Week 5)
- User guide updates (Week 5-6)
- Feature announcement content (Week 6)
- Documentation sign-off (Week 6)

---

## Feature Overview for Users

### What's Changing
The Gen AI Playground is getting a **complete UI redesign** with a chat-based interface similar to ChatGPT and watsonx.ai Prompt Lab.

### Why It Matters
AI Engineers will be able to iterate on prompts **40% faster** through a more intuitive, conversation-focused workflow.

### What Users Will See
- **New chat interface**: Send messages, receive responses, view conversation history
- **Easy model switching**: Change models mid-conversation without losing context
- **Parameter controls**: Adjust temperature, top-p, max tokens via sliders
- **Configuration tabs**: Organize settings by category (Model, Prompt, Knowledge, MCP, Guardrails)
- **Template management**: Save and reuse favorite configurations

**Visual Reference**: https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground

---

## Documentation Needs

### Release Notes (Week 5)

**Sections to Include**:

1. **Overview**: Brief description of new Playground UI
2. **New Features**:
   - Chat-based conversation interface
   - Model switching with context preservation
   - Parameter controls and configuration tabs
   - Template save/load functionality
3. **Benefits**: Faster prompt iteration, improved usability
4. **Migration Notes**: 
   - No data migration needed (fresh start)
   - Conversation history is session-only (not saved across browser sessions)
   - Templates are session-only initially (server persistence in future release)
5. **Known Limitations**:
   - Desktop only (mobile not optimized)
   - Session-scoped persistence (lost on browser close)
   - Maximum 50 messages displayed (older messages in storage but not visible)
6. **Accessibility**: WCAG 2.1 AA compliant, keyboard accessible, screen reader compatible

**Target Audience**: AI Engineers, Data Scientists, ML practitioners

---

### User Guide Updates (Week 5-6)

**New/Updated Pages**:

1. **Getting Started with Playground**:
   - How to access Playground
   - Sending your first message
   - Understanding model responses

2. **Using the Chat Interface**:
   - Sending messages and viewing responses
   - Reviewing conversation history
   - Starting a new conversation

3. **Selecting and Switching Models**:
   - How to choose a model
   - Switching models mid-conversation
   - Understanding model differences

4. **Configuring Model Parameters**:
   - What is temperature, top-p, max tokens, repetition penalty?
   - How to adjust parameters
   - How parameters affect responses

5. **Managing Templates**:
   - Saving a configuration as a template
   - Loading a saved template
   - Organizing templates

6. **Troubleshooting**:
   - What if I get an error?
   - What if model is unavailable?
   - What if I hit rate limits?
   - What happens to my conversation on browser close?

**Content Type**: Step-by-step guides with screenshots

---

### Feature Announcement (Week 6)

**Channels**:
- Product blog post
- Slack announcement (#rh-ai-users)
- Email to active Playground users
- Social media (if applicable)

**Key Messages**:
- Playground is getting a major UX upgrade
- Chat-based interface like modern GenAI tools
- Faster prompt iteration, easier model comparison
- Available now in OpenShift AI Dashboard

**Call to Action**: Try the new Playground, share feedback

---

## Content Requirements

### Screenshots Needed

Request from Dashboard team (Week 5):

1. **Empty chat state** (first-time user view)
2. **Active conversation** (3-4 message exchanges shown)
3. **Model selector dropdown** (showing available models)
4. **Parameter controls** (sliders/inputs visible)
5. **Configuration tabs** (showing tab navigation)
6. **Template save modal** (save dialog)
7. **Template list** (loaded templates)
8. **Error state** (example error message)

**Format**: PNG, 1280px+ width, annotated if needed

---

### Video/GIF Demos (Optional)

If creating video content:

1. **Quick Start** (30 sec): Open Playground → Send message → Receive response
2. **Model Switching** (30 sec): Switch model → Context preserved → New response
3. **Template Save/Load** (30 sec): Adjust settings → Save template → Load template

**Format**: MP4 or animated GIF

---

## Timeline & Deliverables

| Week | Docs Activity | Deliverable |
|------|-------------|-------------|
| 1 | **Kickoff** | Understand feature, attend meeting |
| 5 | **Content Creation** | Draft release notes, request screenshots |
| 5 | **User Guide Updates** | Draft new/updated pages |
| 6 | **Review & Finalize** | Incorporate feedback, finalize content |
| 6 | **Publish** | Release notes live, user guide updated |
| 7 | **Announcement** | Feature announcement published |

**Estimated Effort**: 12-16 hours over weeks 5-7

---

## Key Messages for Users

### Benefits to Emphasize
- **Faster experimentation**: 40% time reduction
- **Familiar experience**: Like ChatGPT/Claude
- **Easy model comparison**: Switch without losing context
- **Flexible configuration**: Adjust parameters on the fly
- **Reusable templates**: Save time with templates

### Limitations to Communicate
- **Session-only persistence**: Conversations lost on browser close (future: server-side persistence)
- **Desktop-optimized**: Best experience on 1280px+ screens
- **Message display limit**: Last 50 messages visible (older messages stored but not displayed)

### Migration Guide
- **No action required**: Fresh start, no data to migrate
- **Templates**: Old Playground configurations don't carry over (if applicable)
- **Bookmarks**: Update bookmarks to new `/playground` route

---

## Success Criteria

You're successful when:
- ✅ Release notes clearly explain changes and benefits
- ✅ User guide covers all key workflows
- ✅ Screenshots/visuals enhance understanding
- ✅ Known limitations communicated clearly
- ✅ Feature announcement generates interest
- ✅ Documentation reviewed and approved by PM/UX

**Post-Launch**: Monitor for documentation gaps based on user questions

---

## Communication

### Contact Points
- **Primary**: #docs-team Slack channel
- **Dashboard Team**: #crimson-dashboard for screenshots, clarifications
- **PM Team**: For messaging review and approval

### Updates Needed
- Draft release notes for review (Week 5)
- Published documentation links (Week 6)
- Feature announcement timing (Week 7)

---

## Resources

- [Executive Summary](../executive-summary.md) - Business case, key messages
- [Feature Spec](../../spec.md) - User stories, requirements (for understanding feature)
- [UX Prototype](https://andybraren.github.io/rhoai-integration-prototype/gen-ai-studio/playground) - Visual reference

---

## Next Steps

1. **Review executive summary** and spec for context
2. **Attend kickoff meeting** (optional, Week 1) or get notes
3. **Plan documentation structure** (Week 4)
4. **Request screenshots** from Dashboard team (Week 5)
5. **Draft content** (Week 5)
6. **Finalize and publish** (Week 6)
7. **Announce feature** (Week 7)

**Questions?** Reach out in #docs-team or #crimson-dashboard.

---

**Summary**: Help users discover and adopt the new Playground through clear, helpful documentation. Your words make the feature accessible! 📚

