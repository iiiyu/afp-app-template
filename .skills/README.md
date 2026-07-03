# Agent Skills

Skills are part of the template and version with it. App repos never edit
skills locally; improvements flow back to `afp-app-template` and arrive via
template version bumps.

## First-party (planned — Sprint B)

| Skill | Role | Fixed artifact | Gate |
|---|---|---|---|
| `scaffold-from-spec` | Instantiate template from a spec package | `afp/reports/scaffold-report.md` | verify all green on empty shell |
| `implement-milestone` | Core loop: implement one milestone, verify, self-repair (≤5 attempts) | `afp/reports/milestone-N-report.md` | verify all green |
| `cross-review` | Second agent reviews the diff against the spec's verification matrix | `afp/reports/review-findings.md` | 0 blockers |
| `ui-polish-pass` | Compare screenshots against `03-ui-contract.md`, fix | `afp/reports/ui-review.md` | human (supervised) |
| `store-assets` | Generate `Store/` content from spec copy | `Store/metadata/` complete | `store_lint` |
| `capture-screenshots` | Drive `Scripts/screenshots.sh`, validate output | `Store/screenshots/` | size/count check |
| `release-train` | Version bump → hand off to human release lane | `afp/reports/release-N-report.md` | human (permanent) |

## Vendored

`vendor/asc/` — App Store Connect skills shipped with the `asc` CLI, pinned.
Install/update only via `asc install-skills` into this directory, recorded as a
template version change.
