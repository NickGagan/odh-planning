# Team Brief: MCP Platform Team

**Feature**: Playground Multi-Pane Comparison  
**Epic**: 3 — Per-Request MCP Support  
**Priority**: P2  
**Full Plan**: [plan.md](../../plan.md)

---

## Primary Persona: Alex the AI Engineer (THE BUILDER)

> *"Limited by proprietary data, hindering external resources/tools."*

**Who is Alex?** Develops AI-infused applications and needs to evaluate which MCP servers (GitHub vs Jira vs custom) work best for his use case. Currently, testing different MCPs requires tedious reconfiguration.

**What Alex needs from us**: Ability to select different MCP servers per-pane so he can compare "response with GitHub MCP" vs "response with Jira MCP" side-by-side.

---

## Your Mission

Enable per-request MCP server selection so **Alex** can compare outputs with different MCP configurations across panes — testing GitHub MCP in Pane 1 vs Jira MCP in Pane 2.

---

## Requirements (4 Total)

| ID | Requirement | Acceptance Criteria |
|----|-------------|---------------------|
| MCP-001 | MCP server registry API | Returns available MCP servers with status |
| MCP-002 | Per-request MCP attachment | MCP servers specified per request, not globally |
| MCP-003 | MCP invocation reporting | Response includes which MCPs were invoked and duration |
| MCP-004 | Graceful MCP failures | MCP errors don't fail the entire request |

---

## API Contract (Required Output)

### MCP Server List

```yaml
GET /api/v1/mcp-servers

Response 200:
{
  "servers": [
    {
      "id": "github-mcp",
      "name": "GitHub",
      "description": "GitHub code search and repo access",
      "status": "available",
      "tools": [
        {
          "name": "search_code",
          "description": "Search code across repos"
        }
      ]
    },
    {
      "id": "jira-mcp",
      "name": "Jira",
      "description": "Jira issue tracking",
      "status": "available",
      "tools": [...]
    }
  ]
}
```

### Integration with Completion

Model Serving will call you with MCP server IDs. You return invocation results.

```yaml
# Model Serving passes to you:
mcpServerIds: ["github-mcp", "jira-mcp"]

# You return to Model Serving (for inclusion in response):
mcpInvocations: [
  {
    "serverId": "github-mcp",
    "toolName": "search_code",
    "durationMs": 234,
    "status": "success"
  }
]
```

---

## Key Question for You

**Can MCP servers currently be attached per-request, or only per-session/globally?**

If only global today, this feature needs per-request support added.

---

## Pitfalls to Avoid

⚠️ **Don't require global configuration** — Per-request MCP selection is the requirement. Users compare GitHub MCP in Pane 1 vs Jira MCP in Pane 2.

⚠️ **Don't fail the entire request if MCP fails** — Return error info for the specific MCP; let the model response continue.

⚠️ **Don't break existing behavior** — This extends single-pane Playground. Existing flows must still work.

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
- **Dashboard**: They display MCP server list and invocation results

---

*Your implementation decisions are yours to make. This brief defines WHAT, not HOW.*

