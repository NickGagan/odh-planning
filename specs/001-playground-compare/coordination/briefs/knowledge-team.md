# Team Brief: Knowledge / RAG Team

**Feature**: Playground Multi-Pane Comparison  
**Epic**: 5 — Per-Request Source Selection  
**Priority**: P2  
**Full Plan**: [plan.md](../../plan.md)

---

## Primary Personas

### Alex the AI Engineer (THE BUILDER)
> *"Limited by proprietary data, hindering external resources/tools."*

**What Alex needs**: Compare how different knowledge sources affect responses. Test "response grounded in Product Docs v2" vs "response grounded in Support KB" to find optimal RAG configuration.

### Deena the Data Scientist (THE INNOVATOR)
> *"Data is frequently fragmented across numerous locations and systems."*

**What Deena needs**: Experiment with different document sets to understand how data sources affect model quality during her evaluation work.

---

## Your Mission

Enable per-request knowledge source selection so **Alex and Deena** can compare outputs with different document sets across panes — testing "Docs v2" in Pane 1 vs "Docs v1" in Pane 2.

---

## Requirements (3 Total)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| KS-001 | Knowledge source registry API | Returns available knowledge sources |
| KS-002 | Per-request source selection | Knowledge sources specified per request |
| KS-003 | Source attribution | Response indicates which sources contributed |

---

## API Contract (Required Output)

### Knowledge Source List

```yaml
GET /api/v1/knowledge-sources

Response 200:
{
  "sources": [
    {
      "id": "product-docs-v2",
      "name": "Product Documentation v2",
      "type": "document",
      "description": "Latest product documentation",
      "documentCount": 1250
    },
    {
      "id": "product-docs-v1",
      "name": "Product Documentation v1 (Legacy)",
      "type": "document",
      "description": "Previous version documentation",
      "documentCount": 980
    },
    {
      "id": "support-kb",
      "name": "Support Knowledge Base",
      "type": "database",
      "description": "Customer support articles"
    }
  ]
}
```

### Integration with Completion

Model Serving will call you with knowledge source IDs. You return which sources were used.

```yaml
# Model Serving passes to you:
knowledgeSourceIds: ["product-docs-v2"]

# You return to Model Serving (for inclusion in response):
knowledgeSourcesUsed: ["product-docs-v2"]
```

---

## Key Question for You

**Can knowledge sources currently be scoped per-request, or only at project/session level?**

The feature requires users to query different document sets per pane for comparison.

---

## Pitfalls to Avoid

⚠️ **Don't require global configuration** — Per-request source selection is the requirement. Users compare "Docs v1" output vs "Docs v2" output.

⚠️ **Don't fail if no sources specified** — Empty `knowledgeSourceIds` should mean "no RAG for this request" (pure model response).

⚠️ **Don't break existing behavior** — This extends current RAG functionality. Default behavior should remain unchanged when not specified.

---

## Use Case Example

User wants to compare how model answers differ based on documentation version:

| Pane 1 | Pane 2 |
|--------|--------|
| `knowledgeSourceIds: ["product-docs-v2"]` | `knowledgeSourceIds: ["product-docs-v1"]` |
| Response grounded in latest docs | Response grounded in legacy docs |
| `knowledgeSourcesUsed: ["product-docs-v2"]` | `knowledgeSourcesUsed: ["product-docs-v1"]` |

---

## Timeline

| Milestone | Date | Your Deliverable |
|-----------|------|------------------|
| **M1** | Week 1 | Confirm per-request support; finalize contract |
| **M2** | Week 3 | Stubbed API available |
| **M4** | Week 7 | Full integration working |
| **M5** | Week 9 | Production ready |

---

## Who You Coordinate With

- **Model Serving**: They call your APIs during completion; you return results to them
- **Dashboard**: They display knowledge source selector

---

*Your implementation decisions are yours to make. This brief defines WHAT, not HOW.*

