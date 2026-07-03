# ADR 0005: Release lane = xcodebuild cloud signing + asc CLI, no fastlane

Date: 2026-07-03 · Status: accepted

## Decision

Archive/export via `xcodebuild` with App Store Connect API-key cloud signing
(`Scripts/archive.sh`); upload, metadata, validation, and TestFlight via the
`asc` CLI (`Scripts/release.sh`). Its bundled agent skills are vendored into
`.skills/vendor/asc/`, pinned. No fastlane.

## Rationale

Fewer dependencies (asc is a single Go binary, 1200+ ASC endpoints, JSON
output); `asc validate` gives a deterministic pre-submission readiness gate.
Credentials stay in the script lane — agents produce content, scripts perform
dangerous actions.
