#!/usr/bin/env bash
# Release train: validate readiness, upload the build, push metadata — then STOP.
# Submission for review is a permanent human gate; this script prints the final
# command instead of running it.
# Prereqs: Scripts/archive.sh has produced afp/artifacts/release/*.ipa,
# and asc is authenticated (asc auth login / ASC_* env vars).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

IPA=$(ls afp/artifacts/release/*.ipa 2>/dev/null | head -1) || true
[[ -n "${IPA:-}" ]] || {
  echo "no .ipa found — run Scripts/archive.sh first"
  exit 1
}
BUNDLE_ID=$(sed -n 's/^PRODUCT_BUNDLE_IDENTIFIER *= *//p' Config/App.xcconfig)

echo "== asc validate =="
asc validate --app "$BUNDLE_ID" || true

echo "== upload build =="
asc builds upload --app "$BUNDLE_ID" --file "$IPA"

echo
echo "Build uploaded. Next steps are HUMAN gates:"
echo "  1. Test on a real device via TestFlight."
echo "  2. Submit for review yourself:"
echo "     asc publish appstore --app $BUNDLE_ID"
