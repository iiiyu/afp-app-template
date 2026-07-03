#!/usr/bin/env bash
# One-time setup after clone: toolchain, project generation, repo-local state db.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

command -v brew >/dev/null || {
  echo "Homebrew is required"
  exit 1
}
brew bundle check >/dev/null 2>&1 || brew bundle

Scripts/gen.sh

if [[ ! -f afp/state.sqlite ]]; then
  sqlite3 afp/state.sqlite <afp/schema.sql
  echo "created afp/state.sqlite"
fi

echo "bootstrap complete — run Scripts/verify.sh"
