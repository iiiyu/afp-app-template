# ADR 0004: Human-paced cadence; four permanent human gates

Date: 2026-07-03 · Status: accepted

## Decision

Shipping cadence is controlled by the human operator — no automated release
scheduling. Four gates are permanently human regardless of automation level:
spec approval, first submission of an app (including ASC app record creation,
which the public API cannot do), pricing, and kill decisions.

## Rationale

App Store 4.3(a)/4.2 policies target exactly the "app factory" pattern; the
developer account is the single point of total failure. Throughput is bounded
by review quality, not build capacity. Machine-checkable gates may graduate
from supervised to auto over time; these four never do.
