# Copilot agent kit (Devoteam NL)

Spend fewer premium tokens without losing quality, and prevent rework by settling requirements before any code is
written. Works in **GitHub Copilot CLI**, the **GitHub Copilot app** and **VS Code**.

| Component | Type | Model | What it does |
|---|---|---|---|
| **Scout** | agent | Claude Haiku 5.5 | Read-only lookups: "where is X defined", "who calls Y", summarise a file. Says `NOT FOUND` / `NEEDS JUDGEMENT` instead of guessing. |
| **Runner** | agent | Claude Haiku 5.5 | Runs lint/type-check/tests/builds and returns only a PASS/FAIL table plus the failing lines. Never edits. |
| **token-saver** | skill | – | Routing rules: what goes to Haiku, Sonnet or Opus, what must never be delegated, and when to escalate. |
| **grill-me** | skill | – | Relentless requirements interview in rounds, with recommended answers, until nothing is assumed. Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). |

**Role agents** are generic. They read your project rules from `.github/copilot-instructions.md`, `AGENTS.md`,
`CONTRIBUTING.md` and `.github/instructions/`, so they work in any repository.

| Agent | Model | Role | Delegates to |
|---|---|---|---|
| **Planner** | Opus 5.5 | grill-me, then plans in `docs/plans/` with acceptance criteria and a `[Sonnet]`/`[Opus]` hint per step | Researcher, Scout |
| **Developer** | Sonnet 5.5 | Implements an approved plan test-first, with a test-thoroughness checklist | Researcher, Scout, Runner |
| **Reviewer** | Opus 5.5 | Severity-ranked review, including the acceptance criteria | Runner, Scout |
| **Researcher** | Sonnet 5.5 | Facts with sources and confidence | Scout |
| **Docs Writer** | Sonnet 5.5 | README, manuals, changelog and release notes in all project languages | Scout |
| **Release Manager** | Sonnet 5.5 | Version, changelog, checks, build and tag; confirms every irreversible step | Runner, Scout, Reviewer, Docs Writer |
| **python-ui-agent.en / .nl** | Sonnet 5.5 | Cross-platform Python GUI apps (Flet, PySide6/PyQt6, KivyMD), FOSS research, bilingual manual. Thin wrappers around the `python-ui-agent-en/-nl` skills | Scout, Runner |

Handoff buttons chain them: **Planner → Developer → Reviewer → Developer (fixes)**, with the **Docs Writer** and
**Release Manager** at the end. [examples/iasset-syncer/](examples/iasset-syncer/) shows a project-specific
version (PyQt6 with a live SaaS API): copy a role agent and add your project's hard rules, as done there.

## Install

Pick **one** method (installing both loads everything twice).

**A. As a plugin (recommended, easy to update)**

```powershell
copilot plugin install DevoteamNL/copilot-agent-kit     # Copilot CLI and the Copilot app
copilot plugin update copilot-agent-kit                 # later, to update
```

In VS Code: run **Chat: Install Plugin From Source** and enter `https://github.com/DevoteamNL/copilot-agent-kit`.

**B. Copy into your user folder**

```powershell
gh repo clone DevoteamNL/copilot-agent-kit; cd copilot-agent-kit
powershell -ExecutionPolicy Bypass -File .\install.ps1 -ConfigureVSCode   # Windows (also lets VS Code's Local harness read ~/.copilot)
./install.sh                       # macOS/Linux
```

**C. For a repository (also used by the Copilot cloud agent)**: copy `agents/*.agent.md` to `.github/agents/` and
`skills/*` to `.github/skills/` in that repository, or run
`powershell -ExecutionPolicy Bypass -File .\install.ps1 -Target <repo>\.github`. Copy only the agents you need.

The installers never overwrite existing files (use `-Force` to update). They report files that already exist as
skipped, so check the output if you already had a `planner.agent.md` or similar.

## Use it in your development process

1. **Clarify** – the **Planner** starts with `grill-me` (or say *"grill me on …"* yourself). Answer each round;
   "yes" accepts the recommendation. It ends with numbered acceptance criteria.
2. **Plan** with the **Planner** (Opus). Fact lookups go to **Scout**. You set the plan to `approved`.
3. **Implement** with the **Developer** (Sonnet). Checks go through **Runner**. Steps tagged `[Opus]` are announced
   so you can switch the model for just that step.
4. **Review** with the **Reviewer** (Opus): every acceptance criterion is checked; the verdict stays on Opus.
5. **Document and release** with the **Docs Writer** and **Release Manager** (Sonnet).
6. **Escalate**: if a Sonnet/Haiku step fails twice, switch that step to Opus.

Make the role agents yours: put your check commands, architecture rules and "never do" list in
`.github/copilot-instructions.md`. The agents read it, so you do not need to fork them.

To wire the helpers into your own custom agents, see [examples/tiering.md](examples/tiering.md).

## Does quality hold?

We ran an A/B test on a real approved plan (iAsset Syncer v0.7.1, plan 03). In setup A, Opus did all the work. In
setup B, Sonnet implemented and Haiku ran the checks. Both passed all checks (ruff, pyright, 958 tests). A blind
Opus reviewer judged them **materially equivalent**, with no Blocking or Major findings in either (scores 44 vs 40
out of 50; the gap was in test thoroughness, which the Opus review step catches). Details:
[docs/ab-test.md](docs/ab-test.md).

## Notes

- The `model:` values use the VS Code naming (`"Claude Haiku 5.5 (copilot)"`). If your Copilot plan does not
  offer a model, edit the frontmatter, or remove the line to inherit the session model.
- The python-ui agents load their skill: install the agent **and** its skill together.
- Scout and Runner are generic. Runner finds your checks in `copilot-instructions.md`, `CONTRIBUTING.md`, CI
  workflows or `package.json`/`pyproject.toml`.
- License: MIT. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the grill-me attribution.
