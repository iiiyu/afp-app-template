# ADR 0002: XcodeGen; the xcodeproj is a build product

Date: 2026-07-03 · Status: accepted

## Decision

`project.yml` (XcodeGen) is the only project definition. `App.xcodeproj` is
generated, gitignored, and never hand-edited — by humans or agents.

## Rationale

Hand-editing `.pbxproj` is the top failure mode for agents on Apple projects:
merge conflicts, corrupt references, unbuildable states. A declarative YAML
manifest plus `xcodegen generate` makes the project reproducible and reviewable.

## Considered alternative

**Tuist** — more powerful (caching, graphs) but a much heavier dependency;
revisit if the template outgrows XcodeGen.
