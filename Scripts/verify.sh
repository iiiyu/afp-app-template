#!/usr/bin/env bash
# The single oracle entrypoint. Runs the gate chain and writes afp/artifacts/verify.json.
# A milestone is DONE if and only if every non-skipped gate passes.
#
# Gate vocabulary (ids are the contract — spec verification matrices and AFP
# verification_plan entries reference these exact ids):
#   gen | format | build_ios | unit_tests | ui_smoke | store_lint
#
# Env:
#   VERIFY_SKIP  comma-separated gate ids to skip (e.g. "ui_smoke,store_lint")
#   VERIFY_SIM   simulator device name (default: first available iPhone)
set -uo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

ART="afp/artifacts"
LOGS="$ART/logs"
RESULTS="$ART/results"
mkdir -p "$LOGS" "$RESULTS"
rm -f "$ART/verify.json"

SKIP=",${VERIFY_SKIP:-},"
SIM="${VERIFY_SIM:-$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')}"
DEST="platform=iOS Simulator,name=$SIM"
GATES_TMP="$(mktemp)"
OVERALL=pass

run_gate() {
  local id="$1"
  shift
  local log="$LOGS/$id.log"
  if [[ "$SKIP" == *",$id,"* ]]; then
    echo "◌ $id skipped"
    jq -n --arg id "$id" '{id: $id, status: "skip"}' >>"$GATES_TMP"
    return 0
  fi
  local start end status
  start=$(date +%s)
  if "$@" >"$log" 2>&1; then
    status=pass
    echo "✓ $id"
  else
    status=fail
    OVERALL=fail
    echo "✗ $id (see $log)"
  fi
  end=$(date +%s)
  jq -n --arg id "$id" --arg status "$status" --arg log "$log" \
    --argjson duration "$((end - start))" \
    '{id: $id, status: $status, duration_s: $duration, log: $log}' >>"$GATES_TMP"
  [[ "$status" == pass ]]
}

test_gate() {
  # Runs test-without-building for one target filter, then summarizes the xcresult.
  local id="$1" only="$2"
  local bundle="$RESULTS/$id.xcresult"
  rm -rf "$bundle"
  run_gate "$id" xcodebuild test-without-building \
    -project App.xcodeproj -scheme App -destination "$DEST" \
    -only-testing:"$only" -resultBundlePath "$bundle"
  local ok=$?
  if [[ -d "$bundle" ]]; then
    Scripts/xcresult-summary.sh "$bundle" >"$RESULTS/$id-summary.json" 2>/dev/null || true
  fi
  return $ok
}

echo "verify: destination = $DEST"

run_gate gen xcodegen generate --quiet
run_gate format swift format lint --strict --recursive App Packages Tests UITests
run_gate build_ios xcodebuild build-for-testing \
  -project App.xcodeproj -scheme App -destination "$DEST"

if [[ "$OVERALL" == pass ]]; then
  test_gate unit_tests "Tests" || true
  test_gate ui_smoke "UITests/SmokeTests" || true
else
  echo "◌ unit_tests, ui_smoke skipped (build failed)"
  jq -n '{id: "unit_tests", status: "skip", reason: "build_failed"}' >>"$GATES_TMP"
  jq -n '{id: "ui_smoke", status: "skip", reason: "build_failed"}' >>"$GATES_TMP"
fi

run_gate store_lint Scripts/store-lint.sh || true

jq -s --arg overall "$OVERALL" --arg finished "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{contract: "afp-app-repo/v1", finished_at: $finished, pass: ($overall == "pass"), gates: .}' \
  "$GATES_TMP" >"$ART/verify.json"
rm -f "$GATES_TMP"

echo
echo "verify.json → $ART/verify.json"
jq -r '.gates[] | "\(.status)\t\(.id)"' "$ART/verify.json"
[[ "$OVERALL" == pass ]]
