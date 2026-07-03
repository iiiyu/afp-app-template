#!/usr/bin/env bash
# Regenerate App.xcodeproj from project.yml. The xcodeproj is never edited by hand.
set -euo pipefail
cd "$(dirname "$0")/.."
xcodegen generate --quiet
echo "generated App.xcodeproj"
