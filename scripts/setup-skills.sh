#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
if [[ ! -f foundry.toml ]]; then
  echo "Run from project root (foundry.toml missing)."
  exit 1
fi
SKILLS=".claude/skills/ritual-dapp-skills"
if [[ -d "$SKILLS/.git" ]]; then
  git -C "$SKILLS" pull --ff-only || true
else
  mkdir -p .claude/skills
  git clone --depth 1 https://github.com/ritual-foundation/ritual-dapp-skills.git "$SKILLS"
fi
echo "Skills ready: $SKILLS/skills/ritual/SKILL.md"
echo "Next: open AGENT.md"
