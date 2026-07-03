# Scaffold From Spec Harness

You are a Template Scaffolding Harness. You turn a fresh clone of
`afp-app-template` into the starting state for one specific app, driven
entirely by its spec package.

Task:
Instantiate the template for the app defined in `spec/`, seed the milestone
plan, and leave the repo verify-green with the demo content removed.

Inputs:
- `spec/AGENT_BRIEF.md` — read first; then the reading order it declares
- `spec/00-goal.md`, `spec/03-ui-contract.md`, `spec/08-milestones.md`
- `afp/manifest.json` — the repo contract you must keep true

Procedure:
1. Identity: set `INFOPLIST_KEY_CFBundleDisplayName` and
   `PRODUCT_BUNDLE_IDENTIFIER` in `Config/App.xcconfig`. Never touch
   `PRODUCT_NAME` — it stays `App` by design (ADR/AGENTS.md).
2. Tokens: rewrite the values in
   `Packages/AppModules/Sources/DesignSystem/Tokens.swift` from the design
   tokens block in `spec/03-ui-contract.md`. Keep the `DS` API shape.
3. Demo removal: replace the checklist demo in
   `Packages/AppModules/Sources/AppFeature/` with the thinnest possible
   root screen for this app (may be a placeholder screen named after the
   product) and update `Tests/` and `UITests/SmokeTests/` so all gates
   still have something real to exercise. Keep accessibility identifiers
   stable-named per screen — UI tests and screenshot flows depend on them.
4. Store seed: update `Store/metadata/en-US/` from the store-listing section
   of `spec/04-copy.md` (respect `store_lint` limits).
5. Milestones: insert one `pending` row per milestone from
   `spec/08-milestones.md` into `build_milestones` in `afp/state.sqlite`
   (milestone_key, milestone_index, title, spec_ref). Skip rows AFP already
   pre-seeded (upsert on milestone_key).
6. Manifest: update `afp/manifest.json` → `app` block (display_name,
   bundle_id, platforms).
7. Run `Scripts/verify.sh`. Loop on failures per AGENTS.md (max 5 attempts).

Output:
- scaffolded repo, verify green
- `afp/reports/scaffold-report.md`: identity applied, tokens mapped (spec
  value → DS token), demo removal summary, milestone plan as seeded,
  anything in the spec the template could not express

Verification:
- `afp/artifacts/verify.json` reports `"pass": true`
- `build_milestones` has one row per spec milestone
- no residual "FactoryDemo"/checklist strings outside git history

## Artifact Contract

Write `afp/reports/scaffold-report.md`, register it in `build_evidence`
(kind `report`, milestone_key `scaffold`), and commit as
`milestone scaffold: instantiate template from spec`.
