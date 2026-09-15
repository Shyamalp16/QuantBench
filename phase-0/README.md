# QuantBench Phase 0 Governance Package

| Field | Value |
|---|---|
| Package version | 1.0.0 |
| Owner | Shyamal Patel |
| Status | Approved |
| Governing specification | `PLAN.md` version 1.1 |
| Prepared | 2026-09-15 |

This directory is the Phase 0 product-charter and compliance-boundary deliverable. It contains no operational software and grants no trading authority.

## Contents

- `product-charter.md` — mission, scope, stakeholders, authority, approvals, and success criteria.
- `requirements-traceability.md` — stable Version 1 requirements with owners, sources, verification methods, and acceptance criteria.
- `terminology-and-calculations.md` — safety-critical financial and lifecycle definitions.
- `prop-firm-rule-packs.md` — documentation-only initial rule packs and deployment blockers.
- `evidence/source-manifest.csv` — public-safe source metadata and local snapshot hashes.
- `security-and-risk.md` — threat model, security boundary, and master risk register.
- `operations-policies.md` — retention, backup/restore, incident, and change-control policies.
- `reference-workstation.md` — reference hardware and benchmark method.
- `demonstration.md` — Phase 0 review walkthrough.
- `acceptance-report.md` — gate assessment and owner sign-off record.

## Authority

`PLAN.md` remains authoritative. These documents clarify and trace it; they do not alter its architecture, invariants, phase order, gates, or exclusions. Any conflict is resolved in favor of `PLAN.md` until an approved change request changes the controlling specification.

## Evidence handling

The Git repository is public. It contains only source metadata, hashes, citations, and concise factual extracts. Full snapshots are stored outside Git at:

`%LOCALAPPDATA%\QuantBench\evidence-vault\2026-09-15`

An absent snapshot or unresolved effective date is an evidence gap and blocks deployment that depends on the affected rule. No authenticated portal, credential, or scraped private content is included.

