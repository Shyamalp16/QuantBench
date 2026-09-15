# ADR-0001: Polyglot monorepo engineering foundation

| Field | Value |
|---|---|
| Status | Accepted for Phase 1 |
| Date | 2026-09-15 |
| Owner | Technical architect — Shyamal Patel |
| Requirement IDs | QB-ARC-001–017, QB-GOV-001–007, QB-PHASE-001 |

## Context

QuantBench has four locked process classes across TypeScript/Rust, C#, and Python. The repository must establish reproducible builds and gates without implementing Phase 2+ contracts or trading behavior.

## Decision

Use a pnpm workspace for the Tauri/React desktop, a .NET solution for the empty Windows-service host, a uv workspace for the empty Python worker, and a Cargo crate owned by the Tauri shell. Pin Node 24 LTS, .NET 10 LTS, Python 3.11, Rust 1.98.1 MSVC, and all ecosystem dependencies through lockfiles.

The single local gate is `pwsh ./tools/verify.ps1`. Windows GitHub Actions repeat quality, security, schema-guard, supply-chain, and signed-development-MSI checks. Directories belonging to later phases contain reservation documents only.

## Consequences

- Toolchains remain independently testable but share one phase gate.
- Phase 1 carries build-system complexity before product behavior exists.
- The schema guard rejects premature contracts until Phase 2 replaces it with approved compatibility rules.
- A self-signed development certificate proves signing mechanics but grants no production trust.

## Verification and rollback

The Phase 1 gate verifies clean locked restores, formatting, linting, strict compilation, tests/coverage, dependency audit, Rust checks, schema guard, MSI build, and development signature. Rollback is the accepted `phase-0-v1.0.0` tag; it contains no operational software.

