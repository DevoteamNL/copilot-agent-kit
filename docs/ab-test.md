# A/B test: Opus-only vs Sonnet + Haiku helpers

**Date:** 2026-10-28
**Task:** implement the approved plan *v0.7.1 / 03 – cancel wording* in iAsset Syncer (PyQt6). The plan covered
code, offscreen UI tests, Dutch translations, NL/EN READMEs, the changelog and architecture docs. Size: S.

| | A: Opus 5.5 only | B: Sonnet 5.5 + Haiku 5.5 Runner |
|---|---|---|
| Same instructions | developer agent + project instructions | same + `token-saver` skill |
| Wall time | ~4.3 min | ~4.4 min |
| ruff / pyright | pass / 0 errors | pass / 0 errors |
| pytest | 958 passed | 958 passed |
| Diff | 13 files, +148/−36 | 13 files, +124/−29 |
| Delegations | – | 3 Runner runs, 0 Scout |
| Blind review score (Opus judge) | 44 / 50 | 40 / 50 |
| Blocking / Major findings | 0 / 0 | 0 / 0 |

**Verdict of the blind judge:** *materially equivalent; a reviewer would approve both.* Both runs independently made
the same correct design decision: they kept the log in English with shared constants instead of translating at the
call site. A was somewhat stronger on tests (it drove the UI checkbox, asserted the in-progress status and updated
all test fakes) and used keyword-only typed parameters. B left 5 test fakes un-updated (harmless today).

**Conclusion:** use Sonnet + Haiku for implementation and keep an Opus review step. The review catches the
remaining test-thoroughness gap at a fraction of the cost of running Opus for the whole implementation. Escalate
to Opus for complex or risky steps.
