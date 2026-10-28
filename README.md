# Copilot agent kit (Devoteam NL)

Spend fewer premium tokens without losing quality, and prevent rework by settling requirements before any code is
written. Works in **GitHub Copilot CLI**, the **GitHub Copilot app** and **VS Code**.

| Component | Type | Model | What it does |
|---|---|---|---|
| **Scout** | agent | Claude Haiku 5.5 | Read-only lookups: "where is X defined", "who calls Y", summarise a file. Says `NOT FOUND` / `NEEDS JUDGEMENT` instead of guessing. |
| **Runner** | agent | Claude Haiku 5.5 | Runs lint/type-check/tests/builds and returns only a PASS/FAIL table plus the failing lines. Never edits. |
| **token-saver** | skill | – | Routing rules: what goes to Haiku, Sonnet or Opus, what must never be delegated, and when to escalate. |
| **grill-me** | skill | – | Relentless requirements interview in rounds, with recommended answers, until nothing is assumed. Adapted from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT). |

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
`skills/*` to `.github/skills/` in that repository.

## Use it in your development process

1. **Clarify** – start every non-trivial feature with *"grill me on …"* (or let your planner agent use `grill-me`).
   Answer each round; "yes" accepts the recommendation. End with a confirmed requirements summary.
2. **Plan** on a strong model (Opus). Let it send fact lookups to **Scout**.
3. **Implement** on Sonnet. Let it run checks through **Runner** and lookups through **Scout**.
4. **Review** on Opus. Let it run checks through **Runner**; keep the verdict on Opus.
5. **Escalate**: if the Sonnet/Haiku step fails twice, switch that step to Opus.

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
- Scout and Runner are generic. Runner finds your checks in `copilot-instructions.md`, `CONTRIBUTING.md`, CI
  workflows or `package.json`/`pyproject.toml`.
- License: MIT. See [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for the grill-me attribution.
