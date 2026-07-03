#!/usr/bin/env bash
# Distill an .xcresult bundle into a compact JSON failure summary.
# This is what gets fed back to an agent on a red gate — never raw build logs.
# Usage: Scripts/xcresult-summary.sh path/to/bundle.xcresult
set -euo pipefail

BUNDLE="${1:?usage: xcresult-summary.sh <bundle.xcresult>}"

xcrun xcresulttool get test-results summary --path "$BUNDLE" | jq '{
  result: .result,
  totals: {passed: .passedTests, failed: .failedTests, skipped: .skippedTests},
  failures: [(.testFailures // [])[] | {
    test: .testName,
    target: .targetName,
    message: .failureText
  }]
}'
