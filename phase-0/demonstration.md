# Phase 0 Demonstration Packet

| Field | Value |
|---|---|
| Version | 1.0.0 |
| Owner | Program manager — Shyamal Patel |
| Status | Ready for owner review |
| Demonstration date | 2026-09-15 |

## Purpose

This walkthrough demonstrates that QuantBench has a bounded Version 1 charter, stable requirements, a fail-closed firm-rule evidence model, explicit safety/security risks, operating policies, and a reproducible benchmark baseline before operational software exists.

## Walkthrough

1. Open `product-charter.md` and confirm Windows 11, NinjaTrader 8, NQ/MNQ/ES/MES, the four selected 25K plan families, exclusions, assigned roles, and no trading authority.
2. Select `SAFE-013` in `requirements-traceability.md` and follow it to the unknown-state quarantine requirement and its planned chaos/state-machine verification.
3. Select `PF-TS25-003` in `prop-firm-rule-packs.md` and observe that contradictory Select contract limits are preserved as a deployment blocker rather than resolved optimistically.
4. Select `PF-LF25-010`, `PF-LD25-010`, `PF-TS25-010`, and `PF-TG25-006` and confirm that unresolved automation authority blocks deployment.
5. Open `evidence/source-manifest.csv`; verify each source has firm/plan scope, URL, retrieval time, effective-date state, snapshot hash when archived, archive result, and rule-use status.
6. Open `security-and-risk.md`; follow `THR-012` to `RSK-004` through `RSK-006` and confirm missing or conflicting firm policy fails closed.
7. Open `operations-policies.md`; review P0 handling, backup/restore, retention, and small-team approval limitations.
8. Open `reference-workstation.md`; confirm exact captured hardware and the cold/warm percentile methodology used by later release gates.
9. Open `acceptance-report.md`; verify every Phase 0 and universal definition-of-done item is passed, blocked, or explicitly not applicable.

## Demonstrated outcomes

- The selected plan scope is LucidFlex 25K, LucidDaily 25K, Tradeify Select 25K with both funded paths, and Tradeify Growth 25K.
- Firm rules cannot authorize deployment until exact applicable agreements, effective dates, source snapshots, and written automation interpretations are present.
- The public repository contains no credentials or full third-party snapshots.
- All Version 1 requirement families and all 23 locked safety invariants have stable traceability IDs.
- The sole-owner governance exception cannot authorize material risk changes or live operation.
- No trading adapter, strategy engine, backtester, router, risk kernel, database, order path, or operational interface has been implemented.

## Known limitations

- Public Tradeify help pages and Lucid legal pages returned HTTP 403 to the non-authenticated archival client; their URLs remain indexed, but the missing snapshots block dependent deployment.
- Firm page publication/update labels do not establish purchase-specific contractual effective dates.
- Exact LucidFlex/LucidDaily agreements and written automation approval are not available.
- Tradeify’s apparent cross-firm bot restriction has not been interpreted in writing for QuantBench’s sequential routing model.
- Later-phase executable tests, schemas, benchmarks, and certifications do not yet exist and are explicitly outside Phase 0.

