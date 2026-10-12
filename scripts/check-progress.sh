#!/usr/bin/env bash
set -e
PROGRESS=".ritual-build/progress.json"
if [[ ! -f "$PROGRESS" ]]; then
  echo "Missing $PROGRESS — run from repo root."
  exit 1
fi
echo "=== Ritual progress.json ==="
if command -v jq >/dev/null 2>&1; then
  echo "Phase: $(jq -r '.current_phase' "$PROGRESS")"
  echo "Intent: $(jq -r '.intent // "null"' "$PROGRESS")"
  echo "Next: $(jq -r '.next_file // "null"' "$PROGRESS")"
  echo "Markers:"
  jq -r '.markers | to_entries[] | "  \(.key): \(.value)"' "$PROGRESS"
else
  cat "$PROGRESS"
fi
