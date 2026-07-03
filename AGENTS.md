# App Repo Agent Instructions

This repository is an AFP app repo, instantiated from `afp-app-template`. AFP
owns the control-plane UI and launches build agent runs (Codex or Claude Code).
This repo owns the app source, the deterministic script toolchain, fixed-name
build artifacts, and the repo-local `afp/state.sqlite` index. The contract is
declared in `afp/manifest.json`.

## Iron Rules

1. **Never edit `App.xcodeproj` or any `.pbxproj`.** The project is a build
   product. `project.yml` is the only project definition; regenerate with
   `Scripts/gen.sh`. If a file isn't in the project, fix `project.yml`.
2. **`Config/Signing.xcconfig`, certificates, provisioning profiles, API keys,
   and anything credential-shaped are a no-go zone.** Never read, edit, or echo
   them. Never run `Scripts/archive.sh` or `Scripts/release.sh` — those are
   human/CI lanes.
3. **All feature code lives in `Packages/AppModules`.** The `App/` directory is
   a shell (`@main` + assembly) and should almost never change. App identity
   (name, bundle id, version) changes only via `Config/App.xcconfig`.
4. **`Scripts/verify.sh` is the only oracle.** Work is done if and only if
   `afp/artifacts/verify.json` reports `"pass": true`. Never redefine done,
   never weaken a gate, never delete or skip a failing test to get to green.
5. **On a red gate, read the distilled failure, not raw logs.** Test failures:
   `afp/artifacts/results/<gate>-summary.json` (from `Scripts/xcresult-summary.sh`).
   Build failures: `afp/artifacts/logs/<gate>.log`, errors first.
6. **Native-first dependency policy.** StoreKit 2, SwiftData, Swift Testing,
   XCUITest, OSLog, MetricKit. Adding any third-party package requires a human
   decision recorded in `docs/decisions/` — do not add one yourself.
7. **Reference design tokens (`DS.*`), never raw values,** in feature UI code.
   Tokens live in `Packages/AppModules/Sources/DesignSystem/Tokens.swift`.
8. **Don't hand-edit generated output.** `Store/screenshots/` comes from
   `Scripts/screenshots.sh`; `afp/artifacts/` comes from the toolchain.
9. **Work only inside the current milestone's scope** plus its fixed artifacts
   and `afp/state.sqlite`. No opportunistic refactors outside it.
10. **One commit per milestone**, after verify is green, message
    `milestone <key>: <title>`.
11. **You have exactly one turn.** Run every command — especially the verify
    chain — in the foreground and wait for it to finish. Never launch
    background work expecting to resume: nothing resumes, and AFP runs its
    own authoritative verify on this machine after your turn, so leaving
    processes running will corrupt it. If you cannot reach green, leave the
    work uncommitted and state exactly what is red and why.

## Read Order

1. `AGENTS.md` (this file)
2. `afp/manifest.json` (repo contract: gates, paths)
3. `spec/` package, starting from its README / `08-milestones.md`
4. The skill you were launched with, under `.skills/`

## Verify Protocol

```bash
Scripts/verify.sh                      # full gate chain → afp/artifacts/verify.json
VERIFY_SKIP=ui_smoke Scripts/verify.sh # skip listed gates (only when the task says so)
```

Gate ids are a fixed vocabulary: `gen`, `format`, `build_ios`, `unit_tests`,
`ui_smoke`, `store_lint`. Spec verification matrices and AFP verification plans
reference these exact ids. Loop on a milestone at most **5** verify attempts;
if still red, record the milestone as `blocked` in `afp/state.sqlite` with a
summary of what was tried, and stop.

## Milestone Recording

AFP pre-seeds one `pending` row per milestone in `build_milestones` when it
launches a build run. After finishing a milestone:

1. Write `afp/reports/milestone-<index>-report.md` — what was built, decisions
   made, verify outcome.
2. Upsert the row:

```bash
sqlite3 afp/state.sqlite "UPDATE build_milestones SET
  status = 'completed',
  summary = '<one-line summary>',
  artifact_path = 'afp/reports/milestone-<index>-report.md',
  verify_json = '<contents of afp/artifacts/verify.json, compacted>',
  attempts = <verify attempt count>,
  updated_at = strftime('%Y-%m-%dT%H:%M:%SZ','now')
WHERE milestone_key = '<milestone_key>';"
```

3. Register durable evidence (reports, screenshots) in `build_evidence` with
   the same upsert style, paths relative to the repo root.
4. Commit.

If a milestone cannot be completed, set `status = 'failed'` (or `'blocked'`
after exhausting attempts), explain why in `summary`, and stop — never start
the next milestone on top of a red one.
