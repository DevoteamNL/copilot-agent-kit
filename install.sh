#!/usr/bin/env sh
# Installs the kit into ~/.copilot/agents and ~/.copilot/skills (macOS/Linux).
# Use this only if you do NOT install the kit as a plugin (that would load it twice).
set -eu
root="$(cd "$(dirname "$0")" && pwd)"
target="$HOME/.copilot"
mkdir -p "$target/agents" "$target/skills"
for f in "$root"/agents/*.agent.md; do
  cp -i "$f" "$target/agents/"
done
for d in "$root"/skills/*/; do
  name="$(basename "$d")"
  mkdir -p "$target/skills/$name"
  cp -i "$d/SKILL.md" "$target/skills/$name/"
done
echo "Done. Start a new Copilot session to pick up the agents and skills."
