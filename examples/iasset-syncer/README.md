# Example: iAsset Syncer agents

These are the project-specific versions of the role agents, as used in iAsset Syncer: a PyQt6 desktop tool that
reads from and writes to a live SaaS API (Visma iAsset). Compare them with the generic agents in `../../agents/`
to see what is worth making project-specific:

- **Hard safety rules** (never touch live data, keyring service name, profile file location) as `DO NOT` lines.
- **Exact check commands** with venv paths for Windows and for the Linux cloud agent.
- **Where the truth is**: bundled API specs in `docs/api/`, the architecture doc, instruction files.
- **Cloud-agent fallbacks**: what to do when a subagent or the user is not available.
- **Domain checks for the Reviewer** (writes need a preview, `SENSITIVE_FIELDS`, bilingual comments).

They reference `iAsset ...` agent names and relative links into that repository, so they do not work as-is
elsewhere. Copy one, rename it, and replace the specifics with yours.
