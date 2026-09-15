# Phase 1 Demonstration

| Field | Value |
|---|---|
| Version | 1.0.0 |
| Owner | Technical architect — Shyamal Patel |
| Status | Validation passed — awaiting owner sign-off |

1. Clone the accepted revision on Windows with the documented prerequisites.
2. Run `pwsh ./tools/verify.ps1` once after implementation is complete.
3. Observe locked restores and passing TypeScript, Rust, C#, and Python quality/test checks.
4. Inspect the MSI signature and confirm its subject is `QuantBench Development Build Only`.
5. Launch the empty desktop shell and observe “Operational trading authority: none.”
6. Confirm the service and worker identity constants are false for operational authority.
7. Add a temporary file under `schemas/` and demonstrate the compatibility guard rejects it; remove the temporary untracked file without committing it.
8. Review CI, Dependabot, CODEOWNERS, ADR, acceptance, incident, release, and change templates.

No step connects to NinjaTrader, opens a database, starts a trading runtime, or submits an order.

