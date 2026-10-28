# Wiring the helpers into your own custom agents

Add the cheap helpers to an agent's `agents:` list (VS Code / Copilot CLI frontmatter) and pick a model per role.

```yaml
# Planner — judgement: keep on Opus
model: "Claude Opus 5.5 (copilot)"
tools: [read, search, edit, todo, agent]
agents: ["Scout"]
```

```yaml
# Developer — implementation: Sonnet is enough when the plan is clear
model: "Claude Sonnet 5.5 (copilot)"
tools: [read, edit, search, execute, todo, agent]
agents: ["Scout", "Runner"]
```

```yaml
# Reviewer — judgement: Opus, but let Haiku run the checks
model: "Claude Opus 5.5 (copilot)"
tools: [read, search, execute, agent]
agents: ["Runner", "Scout"]
```

Then add a short section to the body of each agent:

```markdown
## Saving tokens

Follow the `token-saver` skill. Send mechanical lookups to **Scout** and check runs to **Runner**; read only
Runner's Failures section. If the same step fails twice, stop and recommend switching that step to Opus.
```

And to a planner, before the planning steps:

```markdown
0. **Clarify first.** Unless the request is fully specified, use the `grill-me` skill until goal, scope,
   behaviour, UI text, data safety and acceptance criteria are settled. Copy the confirmed requirements summary
   into the plan.
```

## Suggested tiering

| Role | Model | Why |
|---|---|---|
| Planner, Reviewer, Architect | Opus | Judgement and risk; mistakes here are expensive |
| Developer, Researcher, Docs writer | Sonnet | Executes clear instructions well |
| Scout, Runner, formatting/renames | Haiku | Mechanical, verifiable output |
| Release manager (push/tag/publish) | inherit or Opus | Irreversible actions; never delegate |
