# Retention, Backup, Restore, Incident, and Change Policies

| Field | Value |
|---|---|
| Document version | 1.0.0 |
| Owner | Security/SRE reviewer — Shyamal Patel |
| Approval status | Approved |

## Data classification and retention

| Class | Examples | Retention | Disposal |
|---|---|---|---|
| Authoritative trading/audit | Commands, orders, executions, positions, risk, leases, incidents, operator actions, releases | Seven years after account closure or longer if agreement/law requires | Cryptographic erasure of encrypted backup keys plus verified local deletion after hold review |
| Governance evidence | Firm sources, agreements, rule versions, approvals, change requests, phase acceptance | Seven years after last dependent account closes; never shorter than authoritative audit | Same as authoritative data |
| Research provenance | Certified datasets, manifests, strategy/parameter versions, completed experiments and seeds | Seven years after last dependent result/deployment | Content-addressed deletion only after dependency and legal-hold check |
| Operational telemetry | Structured logs, traces, metrics without secrets | 30 days readily searchable; one year compressed | Automated expiry with audit record |
| Temporary imports/builds | Untrusted extraction, caches, unsigned artifacts | Seven days or completion of validation, whichever is later | Secure workspace cleanup; preserve only hashes and required evidence |
| Secrets | Signing material, supported local tokens | Only while operationally required; never in logs or Git | Revoke first, then Credential Manager/DPAPI deletion and rotation record |

Legal hold, active incident, dispute, audit, or open payout/account lifecycle suspends deletion. Account identifiers are masked outside authorized operational views.

## Backup policy

- Follow 3-2-1: primary local data, encrypted local backup on separate media, and encrypted offline/offsite copy.
- Operational state: application-consistent incremental backup daily and full backup weekly.
- Evidence vault and immutable releases: back up after every accepted change and verify recorded hashes.
- Keep 30 daily, 12 monthly, and 7 annual recovery points for seven-year classes, subject to capacity and legal obligations.
- Backup credentials and encryption keys are stored separately through approved Windows facilities; brokerage passwords are never collected.
- A backup is not successful until manifest, size, encryption, and sample hash verification pass.
- Alert and block promotion when the latest required backup or verification is stale.

## Restore policy

- Perform a sample restore monthly and a full isolated restore quarterly.
- Restore into an isolated location, verify hashes and schema versions, replay projections, reconcile counts/totals, and document elapsed time.
- Never restore over active authoritative data. Preserve the damaged source and incident evidence.
- Resume operation only after broker/account/order/execution/position reconciliation and explicit operator approval.
- Target recovery point is 24 hours for governance/research data and zero acknowledged-event loss for operational outboxes; target recovery time is four hours for the workstation and the stricter 30-second active-state reconciliation gate once implemented.

## Incident severity and response

| Severity | Definition | Examples | Acknowledge | Contain | Resolution requirement | Owner |
|---|---|---|---|---|---|---|
| P0 | Actual or imminent uncontrolled financial/safety exposure, credential compromise, or corrupted authoritative state. | Duplicate exposure, unknown live position, missing protection, unauthorized order, leaked credential. | 5 minutes | 15 minutes | Immediate pause/quarantine/cancel/flatten under preapproved procedure; independent review and complete reconciliation before resumption. | Risk engineer + SRE |
| P1 | Severe loss of control, integrity, or availability without confirmed uncontrolled exposure. | Persistent broker/local mismatch, failed recovery, corrupted database copy, release-signature failure. | 15 minutes | 60 minutes | Root cause or approved containment within 24 hours; blocks phase acceptance and promotion. | Technical architect + SRE |
| P2 | Material degradation with safe containment intact. | Delayed research job, noncritical UI/API outage, recoverable data-import defect. | 1 business day | 2 business days | Fix or scheduled mitigation within 5 business days; trend review. | Owning engineer |
| P3 | Minor defect, documentation issue, or improvement with no safety/economic impact. | Cosmetic defect, nonblocking wording issue. | 3 business days | As scheduled | Prioritized in normal backlog; cannot conceal a higher-severity condition. | Product owner |

Incident records include identifier, detection and event times, severity, owner, affected assets/accounts, timeline, evidence hashes, containment, reconciliation, root cause, corrective actions, approvals, and closure criteria. Severity may only increase automatically; lowering it requires an audited human decision.

## Notification and escalation

- P0 pages the operator, Risk, and SRE roles immediately and repeats until acknowledged.
- P1 pages the technical owner and SRE immediately and notifies Product Owner.
- P2/P3 enter the tracked incident system with their response target.
- When one person fills multiple roles, one acknowledgement may cover notification but does not satisfy later independent-review requirements.

## Change control

Every change to scope, architecture, safety invariants, phase order/gates, performance thresholds, supported firms/instruments, or live behavior uses a `CR-YYYY-NNN` record containing exact proposed change, motivation, impact across all disciplines, threat/risk updates, regression plan, independent approvals, effective point, migration, and rollback. Until approved, current specifications remain authoritative.

Emergency change authority is limited to reducing exposure, pausing, quarantining, cancelling, or flattening through preapproved controls. It cannot weaken a gate or enable new live behavior.

## Policy review

Review these policies at every phase gate, after every P0/P1 incident, after a material firm-rule change, and at least annually. More restrictive law, agreement, exchange, or broker requirements take precedence and trigger change control.

