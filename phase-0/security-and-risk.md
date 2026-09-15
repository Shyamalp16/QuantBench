# Threat Model, Security Plan, and Master Risk Register

| Field | Value |
|---|---|
| Document version | 1.0.0 |
| Owner | Security/SRE reviewer — Shyamal Patel |
| Approval status | Approved |
| Method | STRIDE plus trading-safety misuse cases |

## Assets

- Order authority, account state, positions, executions, risk capacity, leases, and kill switches.
- Strategy source, parameter sets, datasets, rule packs, deployments, audit evidence, and releases.
- Brokerage/account identifiers, local secrets, signing keys, and operator identity.
- Availability and integrity of the control service, NinjaTrader bridge, worker, clock, disk, databases, and event streams.

## Trust boundaries

1. Operator ↔ Desktop UI.
2. Desktop UI ↔ localhost control-service API.
3. Control service ↔ operational SQLite store.
4. Control service ↔ authenticated NinjaTrader AddOn channel.
5. Quant worker ↔ immutable inputs and normalized trade-intent contract.
6. NinjaTrader AddOn ↔ broker/provider systems.
7. Local workstation ↔ update, AI, source-evidence, and CI services.
8. Untrusted strategy package ↔ validation sandbox.

Only the control service may authorize risk, route an account, or command the AddOn. The UI, worker, imported code, AI, and external services are outside that authority boundary.

## Threats and required controls

| Threat ID | Category | Scenario | Required control | Verification |
|---|---|---|---|---|
| THR-001 | Spoofing | A process impersonates the control service or AddOn. | Mutual local identity, HMAC/authentication, process allow-list, sequence validation, key rotation. | Contract and adversarial integration tests. |
| THR-002 | Tampering | Command, event, rule, deployment, or audit content changes. | Content hashes, signatures where applicable, append-only records, causal IDs, immutable releases. | Signature/hash and replay tests. |
| THR-003 | Repudiation | Operator or process denies a state-changing action. | Attributable immutable audit event with actor, time, cause, evidence, and result. | Audit completeness test. |
| THR-004 | Information disclosure | Credentials or account identifiers enter logs, AI prompts, exports, or source control. | Credential Manager/DPAPI, masking, redaction, secret scanning, least privilege. | Redaction and secret-scan tests. |
| THR-005 | Denial of service | Disk, CPU, memory, network, broker feed, or process failure prevents safe operation. | Bounded queues, disk guards, watchdogs, local order path, deterministic pause/quarantine. | Performance and chaos campaigns. |
| THR-006 | Elevation of privilege | UI, AI, worker, or strategy bypasses risk or submits orders. | No broker credentials/interfaces; explicit process contracts; OS and sandbox restrictions. | Negative capability and penetration tests. |
| THR-007 | Replay/duplication | Duplicate or reordered commands create duplicate exposure. | Idempotency keys, monotonic sequence, durable outbox, atomic reservation. | Property, replay, and restart tests. |
| THR-008 | Stale state | Risk uses stale price, account, clock, connection, or rule data. | Freshness deadlines, trusted clock, fail-closed checks, quarantine. | Boundary and clock-fault tests. |
| THR-009 | Supply chain | Dependency, installer, build, or update is malicious or vulnerable. | Lockfiles, provenance, SBOM, scanning, signed protected releases. | CI policy and artifact verification. |
| THR-010 | Untrusted code | Imported strategy reads secrets, network, filesystem, subprocess, or broker APIs. | Isolated validation sandbox, deny-by-default capabilities, static/dynamic tests. | Adversarial import corpus. |
| THR-011 | Unsafe recovery | Restart or reconnect resumes with unknown orders/positions. | Full broker/local reconciliation and explicit operator clearance. | Transaction-boundary chaos tests. |
| THR-012 | Policy conflict | Firm terms prohibit or constrain automation/cross-firm use. | Effective-dated evidence and deployment blocker; written authorization. | Acceptance review of rule sources. |

## Security plan

- Apply least privilege to every process, file, IPC endpoint, credential, and CI token.
- Store no brokerage password. Store supported secrets only in Windows Credential Manager or DPAPI-protected material.
- Bind authenticated messages to sender, receiver, schema version, sequence, timestamp, idempotency key, correlation, and payload hash.
- Deny network, arbitrary filesystem, subprocess, dynamic installer, environment-secret, credential, and broker access to imported strategy code.
- Keep live risk and order containment functional with UI, internet, and AI unavailable.
- Sign commits, tags, installers, strategy packages, releases, and deployment manifests according to their later-phase specifications.
- Patch supported toolchains and dependencies; block unsupported or known-critical vulnerable components.
- Redact account identifiers and secrets before AI or export. AI results remain advisory and separate from authoritative state.
- Review this threat model at every phase gate and whenever architecture, rule behavior, or operational authority changes.

## Master risk register

Likelihood and impact use 1–5 scales. Score is likelihood × impact. A risk with safety impact 5, unresolved legal/firm authority, or score 15+ blocks dependent deployment regardless of planned mitigation.

| Risk ID | Risk | L | I | Score | Owner | Current treatment | Status |
|---|---|---:|---:|---:|---|---|---|
| RSK-001 | Duplicate order or position from retry/replay. | 3 | 5 | 15 | Execution engineer | Idempotency, sequence, atomic reservation, reconciliation. | Open — later-phase blocker |
| RSK-002 | Position lacks timely protective orders. | 3 | 5 | 15 | Risk engineer | Independent deadline guard and deterministic emergency response. | Open — later-phase blocker |
| RSK-003 | Broker/local state mismatch permits new exposure. | 4 | 5 | 20 | Risk engineer | Quarantine and full reconciliation before resumption. | Open — later-phase blocker |
| RSK-004 | Firm rule is stale, contradictory, or wrong for purchase date. | 4 | 5 | 20 | Product owner | Effective-dated evidence, expiry, conservative block. | Open — current deployment blocker |
| RSK-005 | Lucid plan-specific automation authority is absent. | 4 | 5 | 20 | Product owner | Obtain exact agreements and written approval. | Open — current deployment blocker |
| RSK-006 | Tradeify cross-firm bot restriction conflicts with selected scope. | 4 | 5 | 20 | Product owner | Obtain written interpretation; segregate or disable deployment if denied. | Open — current deployment blocker |
| RSK-007 | Public repository leaks secrets or account identity. | 3 | 5 | 15 | Security reviewer | Secret scanning, masking, no credentials in Git, protected releases. | Open — Phase 1 control required |
| RSK-008 | Imported strategy escapes its sandbox. | 3 | 5 | 15 | Security reviewer | Capability denial, static/dynamic validation, isolation. | Open — Phase 5 blocker |
| RSK-009 | Single-person governance creates unreviewed safety decisions. | 4 | 5 | 20 | Product owner | Pre-live exception only; independent reviewer required for material risk/live. | Accepted pre-live; live blocker |
| RSK-010 | Workstation failure destroys operational/evidence data. | 3 | 4 | 12 | SRE reviewer | Encrypted 3-2-1 backups and restore drills. | Open — policy defined |
| RSK-011 | Clock/DST/session error corrupts daily limits. | 4 | 5 | 20 | Risk engineer | Trusted monotonic/UTC time plus versioned session calendar. | Open — later-phase blocker |
| RSK-012 | Performance misses deterministic risk/order deadlines. | 3 | 5 | 15 | Technical architect | Reference benchmarks and performance budgets. | Open — later-phase blocker |
| RSK-013 | Dependency or build compromise enters a release. | 3 | 5 | 15 | Security reviewer | Lockfiles, scans, SBOM, signing, branch/release protection. | Open — Phase 1 control required |
| RSK-014 | AI advice is mistaken or contains sensitive data. | 3 | 4 | 12 | Security reviewer | Read-only interface, redaction, attribution, human review. | Open — later-phase blocker |
| RSK-015 | Evidence vault snapshots cannot be captured from protected pages. | 4 | 4 | 16 | Product owner | Obtain user-downloaded copies or written firm documents and verify hashes. | Open — current evidence blocker |
| RSK-016 | Payout/fee assumptions produce false positive economics. | 3 | 4 | 12 | Quant lead | Conservative models, effective-dated fees, sensitivity and hand checks. | Open — Phase 11 blocker |
| RSK-017 | Local disk exhaustion corrupts outbox/database state. | 3 | 5 | 15 | SRE reviewer | Disk thresholds, reserved space, fail-closed containment. | Open — later-phase blocker |
| RSK-018 | Self-signed development certificate is mistaken for production trust. | 2 | 4 | 8 | Security reviewer | Label development-only; production signing unavailable until approved certificate. | Open — Phase 1 control required |

## Residual-risk rule

No risk is closed by documentation alone. A risk becomes `Mitigated` only when its linked control has test evidence; `Accepted` requires the approval matrix; `Closed` requires evidence that the hazard no longer applies. P0/P1 incidents and open deployment blockers prevent phase or deployment promotion as specified in `PLAN.md`.

