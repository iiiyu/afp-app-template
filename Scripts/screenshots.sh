#!/usr/bin/env bash
# Capture store screenshots: run UITests/ScreenshotFlows per device, export the
# named attachments from the xcresult into Store/screenshots/<device>/.
# App Store requires 6.9" iPhone; iPad 13" only if the app claims iPad support.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

DEVICES=("${SCREENSHOT_DEVICES:-iPhone 17 Pro Max}")
RESULTS="afp/artifacts/results"
mkdir -p "$RESULTS"

for device in "${DEVICES[@]}"; do
  slug=$(echo "$device" | tr '[:upper:] ' '[:lower:]-')
  bundle="$RESULTS/screenshots-$slug.xcresult"
  out="Store/screenshots/$slug"
  rm -rf "$bundle" "$out"
  mkdir -p "$out"

  echo "capturing on $device …"
  set -o pipefail
  xcodebuild test -project App.xcodeproj -scheme App \
    -destination "platform=iOS Simulator,name=$device" \
    -only-testing:UITests/ScreenshotFlows \
    -resultBundlePath "$bundle" | xcbeautify

  xcrun xcresulttool export attachments --path "$bundle" --output-path "$out"

  # Rename UUID exports to their attachment names (e.g. 01-home.png).
  jq -r '.[].attachments[] | "\(.exportedFileName)\t\(.suggestedHumanReadableName)"' \
    "$out/manifest.json" | while IFS=$'\t' read -r exported suggested; do
    mv "$out/$exported" "$out/$(echo "$suggested" | sed -E 's/_[0-9]+_[0-9A-F-]{36}//')"
  done
  rm -f "$out/manifest.json"

  echo "→ $out"
  ls "$out"
done
