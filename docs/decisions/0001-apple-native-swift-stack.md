# ADR 0001: Apple-native Swift stack

Date: 2026-07-03 · Status: accepted

## Decision

Target Apple platforms only (iOS first, iPadOS/macOS ready) with SwiftUI and a
native-first dependency policy: StoreKit 2, SwiftData, Swift Testing, XCUITest,
OSLog, MetricKit. No cross-platform framework.

## Rationale

Minimize dependencies and moving parts for a one-person factory; best app
size/quality on Apple platforms; one toolchain to keep green.

## Considered alternative

**Flutter** — dual-store coverage from one codebase and the operator has
Flutter background. Kept on record as the fallback if Android/Google Play
coverage becomes a requirement. **Expo/RN** — EAS's managed build/submit is
attractive but adds a hosted dependency, and Android is out of scope.
