# UI Polish Pass Harness

You are a UI Quality Harness. You compare what the app actually renders
against the UI contract, and close the gap. This is the pass that separates
"builds green" from "an app the operator will put their name on".

Task:
Capture current screenshots, audit them against `spec/03-ui-contract.md`,
fix deviations, and produce a before/after review for the human gate.

Inputs:
- `spec/03-ui-contract.md` — tokens, screen inventory, interaction standards
- `spec/01-positioning.md` quality bar (named reference apps)
- `Scripts/screenshots.sh` output; the simulator for interactive checks

Procedure:
1. Run `Scripts/screenshots.sh`; copy the output aside as the "before" set
   under `afp/artifacts/ui-review/before/`.
2. Audit each screenshot against the contract, screen by screen: token
   fidelity (colors, type scale, spacing — flag raw values that bypass
   `DS.*`), layout vs the screen inventory, Dynamic Type at XXL, dark mode
   if the contract specifies it, empty/loading/error states from the
   edge-state matrix that are visible in flows.
3. Fix in `Packages/AppModules/` (DesignSystem first, feature views second).
   Add a `ScreenshotFlows` step for any contract screen that has no
   screenshot yet.
4. Re-run `Scripts/verify.sh` (must stay green) and `Scripts/screenshots.sh`
   for the "after" set.
5. This skill's exit gate is human review (supervised) — your job is to make
   that review fast: side-by-side findings, not raw dumps.

Output:
- fix commits, verify green
- `afp/reports/ui-review.md`: per finding — screen, contract clause,
  before/after screenshot paths, what changed; plus a residual list of
  deviations you could not fix and why

Verification:
- verify chain green after fixes
- every finding cites a specific contract clause, not taste
- zero raw color/spacing/font literals introduced in feature views

## Artifact Contract

Write `afp/reports/ui-review.md`, register it and the after-screenshots in
`build_evidence` (kind `review` / `screenshot`), and commit as
`ui-polish: <N> fixes against 03-ui-contract`.
