# ADR 0003: Feature code lives in a local SPM package

Date: 2026-07-03 · Status: accepted

## Decision

All feature code lives in `Packages/AppModules` (targets: AppFeature,
DesignSystem, Onboarding, Paywall, Persistence, Support). The App target is a
shell: `@main` plus assembly.

## Rationale

Agents then work almost exclusively in plain Swift files — adding a file needs
no project change at all, and `project.yml` itself is rarely touched. Module
boundaries double as scope boundaries for milestone prompts.
