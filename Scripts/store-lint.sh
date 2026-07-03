#!/usr/bin/env bash
# Gate: store_lint — validate Store/ metadata against App Store limits.
# Deterministic and offline; asc validate covers the online checks at release time.
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
FAIL=0

err() {
  echo "store_lint: $1"
  FAIL=1
}

chars() {
  # UTF-8-aware character count of a file's content, trailing newline excluded.
  printf %s "$(cat "$1")" | wc -m | tr -d ' '
}

check() {
  local file="Store/metadata/en-US/$1" max="$2"
  if [[ ! -s "$file" ]]; then
    err "$file is missing or empty"
    return
  fi
  local n
  n=$(chars "$file")
  if ((n > max)); then
    err "$file is $n chars (max $max)"
  fi
}

check name.txt 30
check subtitle.txt 30
check keywords.txt 100
check description.txt 4000
check privacy_url.txt 255

if [[ -s Store/metadata/en-US/privacy_url.txt ]] &&
  ! grep -qE '^https://' Store/metadata/en-US/privacy_url.txt; then
  err "privacy_url.txt must be an https:// URL"
fi

if ((FAIL == 0)); then
  echo "store_lint: all checks passed"
fi
exit $FAIL
