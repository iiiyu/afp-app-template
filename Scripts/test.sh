#!/usr/bin/env bash
# Convenience test run with readable output. verify.sh is the oracle; this is for humans.
set -euo pipefail
cd "$(dirname "$0")/.."
SIM="${VERIFY_SIM:-$(xcrun simctl list devices available | grep -m1 -oE 'iPhone [^(]+' | sed 's/ *$//')}"
set -o pipefail
xcodebuild test -project App.xcodeproj -scheme App \
  -destination "platform=iOS Simulator,name=$SIM" "$@" | xcbeautify
