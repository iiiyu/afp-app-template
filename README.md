# afp-app-template

Golden template for AFP-built Apple apps (iOS first; iPadOS/macOS ready).
Agents fill this template from a spec package; deterministic scripts own
everything dangerous (signing, upload, submission).

## Quick start

```bash
Scripts/bootstrap.sh   # brew bundle, generate xcodeproj, init state db
Scripts/verify.sh      # full gate chain → afp/artifacts/verify.json
```

Template DoD: clean clone → scripts only → demo app on TestFlight, zero Xcode
GUI steps (`Scripts/archive.sh` + `Scripts/release.sh`, human-run).

## Layout

| Path | Role |
|---|---|
| `project.yml` | Only project definition (XcodeGen); `App.xcodeproj` is generated, gitignored |
| `App/` | App shell: `@main` + assembly only |
| `Packages/AppModules/` | All feature code (AppFeature, DesignSystem, Onboarding, Paywall, Persistence, Support) |
| `Config/` | xcconfigs; `App.xcconfig` = app identity, `Signing.xcconfig` = human-only |
| `Tests/`, `UITests/` | Swift Testing unit tests; XCUITest smoke + screenshot flows |
| `Scripts/` | Deterministic toolchain; `verify.sh` is the single oracle |
| `Store/` | Store metadata as files; `screenshots/` is generated |
| `afp/` | Repo contract (`manifest.json`), state db, artifacts, milestone reports |
| `.skills/` | Agent skills (first-party + vendored asc skills) |
| `docs/decisions/` | ADRs |

## Contract

`AGENTS.md` is the single source of truth for agent behavior. `afp/manifest.json`
declares the machine-readable contract (`afp-app-repo/v1`): gate vocabulary,
artifact paths, state db. AFP's control plane reads both.
