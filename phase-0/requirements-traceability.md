# Version 1 Requirements-to-Acceptance Matrix

| Field | Value |
|---|---|
| Matrix version | 1.0.0 |
| Owner | Program manager — Shyamal Patel |
| Approval status | Approved |
| Governing source | `PLAN.md` version 1.1 |

Each row is a stable requirement. Later specifications and tests may add finer child IDs but may not reuse or silently redefine these IDs. `Review` means documented inspection with attributable evidence; `Test` means automated verification; `Demonstration` means an operator-visible artifact or walkthrough.

## Scope and authority

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| QB-SCP-001 | QuantBench remains a separate greenfield product governed by `PLAN.md`. | Product owner | §§1,18 | Review | No other product is used as its foundation; conflicts use change control. |
| QB-SCP-002 | V1 supports Windows 11 and NinjaTrader 8 only. | Architect | §3 | Build/review | Release manifest names Windows 11 and NT8; other adapters are absent. |
| QB-SCP-003 | V1 instruments are CME NQ, MNQ, ES, and MES only. | Quant lead | §3 | Test/review | Instrument allow-list rejects all others. |
| QB-SCP-004 | V1 includes the complete research-through-controlled-deployment lifecycle in the fixed phase sequence. | Program manager | §§2,9–10 | Gate review | Each phase has accepted predecessor evidence and required artifacts. |
| QB-SCP-005 | V1 excludes crypto, options, equities, unsupported brokers, mobile order control, portal scraping, automated purchases/resets/payouts, no-code builder, HFT, AI auto-promotion, multi-account copying, unknown-state auto-resume, and cloud live-path dependency. | Product owner | §3.2 | Test/review | No released capability or callable interface implements an exclusion. |
| QB-SCP-006 | New adapters/assets require approved post-funded-pilot change control. | Product owner | §3.2 | Review | Change record and required approvals precede implementation. |
| QB-SCP-007 | Unknown safety, brokerage, exchange, or firm behavior blocks deployment. | Risk engineer | §§1,5,12 | Test/review | Unknown input returns blocked/quarantined and creates evidence. |

## Architecture and process boundaries

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| QB-ARC-001 | Desktop uses Tauri 2, React, strict TypeScript, and Vite. | Frontend engineer | §4.1 | Build/config test | Supported locked stack builds on Windows. |
| QB-ARC-002 | UI uses Tailwind, Radix, TanStack Table, React Hook Form, Zod, ECharts, and Monaco for their specified purposes. | Frontend engineer | §4.1 | Dependency/design review | Required surfaces use locked components; substitutions have change approval. |
| QB-ARC-003 | Control service is a C#/.NET Windows Service. | Architect | §4.1 | Integration test | Service installs, runs without UI, and owns control responsibilities. |
| QB-ARC-004 | NinjaTrader adapter is a C# NinjaScript AddOn. | Execution engineer | §4.1 | Build/review | Adapter uses supported AddOn APIs and contains only approved capabilities. |
| QB-ARC-005 | Strategy/research runtime is Python with the locked analytical stack. | Quant lead | §4.1 | Environment/build test | Lockfile contains approved libraries and reproducible runtime. |
| QB-ARC-006 | Cross-process analytics uses Arrow IPC; long-term market data uses partitioned Parquet. | Data engineer | §4.1 | Contract/integration test | Data crosses/stores only in approved formats with versioned schemas. |
| QB-ARC-007 | DuckDB has exactly one analytics-process owner. | Data engineer | §4.1 | Concurrency test | All other processes are denied direct ownership/access. |
| QB-ARC-008 | SQLite runs WAL with the control service as sole writer. | Data engineer | §4.1 | Integration/security test | Concurrent unauthorized writes fail; service writes remain durable. |
| QB-ARC-009 | UI accesses data only through versioned localhost REST and WebSocket APIs. | Architect | §§4.1–4.2 | Negative/integration test | UI has no DB or NinjaTrader connection path. |
| QB-ARC-010 | Logs use structured JSONL with Serilog and OpenTelemetry correlation. | SRE | §4.1 | Schema/replay test | Logs parse and correlate across processes without secrets. |
| QB-ARC-011 | Secrets use Windows Credential Manager and DPAPI. | Security reviewer | §§4.1,12 | Security test | Secret-at-rest and leak tests pass; no brokerage password stored. |
| QB-ARC-012 | Packaging is a signed Windows MSI and CI uses Windows GitHub Actions. | Release owner | §4.1 | Build/signature test | MSI signature verifies and Windows CI gates release. |
| QB-ARC-013 | Desktop is presentation/operator interaction only and has no order authority. | Architect | §4.2A | Negative capability test | Desktop cannot invoke adapter or submit/approve order. |
| QB-ARC-014 | Control service owns operational state, risk, routing, deployments, reconciliation, SQLite writes, and adapter commands. | Architect | §4.2B | Architecture/integration test | No second process can exercise these authorities. |
| QB-ARC-015 | Quant workers have no broker credentials/access and emit normalized trade intents only. | Quant lead | §4.2C | Sandbox/negative test | Network/broker/order interfaces are unavailable. |
| QB-ARC-016 | AddOn publishes broker events through a durable authenticated ordered outbox and contains no research/routing/risk logic. | Execution engineer | §4.2D | Restart/review test | Events survive restart and forbidden responsibilities are absent. |
| QB-ARC-017 | Repository follows the mandated monorepo shape from Phase 1 onward. | Architect | §4.3 | Structure test | Required directories exist and premature implementations do not. |

## Safety invariants

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| SAFE-001 | Strategy never communicates directly with NinjaTrader. | Architect | §5 | Negative capability test | No reachable interface or credential path exists. |
| SAFE-002 | UI never communicates directly with NinjaTrader. | Architect | §5 | Negative capability test | All UI control traverses authenticated service API. |
| SAFE-003 | AI never submits, changes, cancels, or approves an order. | Security reviewer | §5 | Permission/adversarial test | AI surface exposes no such callable capability. |
| SAFE-004 | AI never modifies risk, firm rule, account state, or deployment. | Security reviewer | §5 | Permission/adversarial test | All attempted mutations are impossible and audited. |
| SAFE-005 | Deployable strategy versions are immutable, hashed, and signed through promotion. | Quant lead | §5 | Mutation/signature test | One-byte change creates a distinct version; unsigned version is ineligible. |
| SAFE-006 | Each trade intent selects zero or one account. | Risk engineer | §5 | Property/concurrency test | No outcome contains more than one selected account. |
| SAFE-007 | An account has at most one active QuantBench lease. | Risk engineer | §5 | Property/concurrency test | Ten million simulated races produce no double lease. |
| SAFE-008 | No new entry reaches an account with unresolved order or position. | Risk engineer | §5 | State-machine test | Every unresolved state rejects entry. |
| SAFE-009 | Stale account, price, rule, clock, or connection state rejects submission. | Risk engineer | §5 | Boundary/clock test | Freshness boundary and all stale cases fail closed. |
| SAFE-010 | Risk is reserved atomically before submission. | Risk engineer | §5 | Transaction/concurrency test | No dispatch exists without prior durable reservation. |
| SAFE-011 | Duplicate command resolves to the original order. | Execution engineer | §5 | Idempotency/restart test | Retries create zero additional orders. |
| SAFE-012 | Filled positions receive protection within configured deadline. | Execution engineer | §5 | Latency/chaos test | Deadline always met or P0 emergency response triggers. |
| SAFE-013 | Unknown broker state quarantines and never auto-resumes. | Risk engineer | §5 | Chaos/state-machine test | All unknown transitions end quarantined. |
| SAFE-014 | Reconnection reconciles orders, executions, positions, and accounts before resumption. | Execution engineer | §5 | Restart/replay test | No entry accepted until complete exact reconciliation. |
| SAFE-015 | Stale, contradictory, or changed firm rule pack blocks account. | Risk engineer | §5 | Rule-version test | Affected account becomes ineligible with reason. |
| SAFE-016 | Strategy cannot override account/fleet risk. | Risk engineer | §5 | Mutation/property test | Strategy request can only be preserved, reduced, or rejected. |
| SAFE-017 | Daily-loss calculations include explicit conservative buffer. | Risk engineer | §5 | Boundary/golden test | Capacity subtracts configured slippage/liquidation buffer. |
| SAFE-018 | Every state-changing action emits immutable audit event. | SRE | §5 | Audit completeness test | No state mutation lacks actor, cause, time, and result evidence. |
| SAFE-019 | Only signed, promoted, certified builds may operate live. | Release owner | §5 | Signature/promotion test | Any failed/missing attestation prevents live mode. |
| SAFE-020 | No control can force live operation through a failed gate. | Product owner | §5 | UI/API adversarial test | Overrides can only reduce exposure or remain blocked. |
| SAFE-021 | Imported/AI code remains untrusted until every import gate passes. | Security reviewer | §5 | Adversarial import test | Forbidden capability is rejected with precise reason. |
| SAFE-022 | Strategy code and parameters are separate immutable objects. | Quant lead | §5 | Version/replay test | Parameter edits cannot alter source or prior results. |
| SAFE-023 | Editing deployed strategy creates draft fork without changing active deployment. | Quant lead | §5 | Lifecycle/audit test | Active hashes remain unchanged until approved replacement. |

## Domain, lifecycle, and audit

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| QB-DOM-001 | Operational model contains all market-reference entities listed in §6.1. | Data engineer | §6.1 | Schema review | Versioned schemas cover Instrument, Contract, Session, Dataset, Event. |
| QB-DOM-002 | Operational model contains all strategy/research entities listed in §6.1. | Quant lead | §6.1 | Schema review | Versioned schemas cover each named entity and immutable relationships. |
| QB-DOM-003 | Operational model contains all firm/account entities listed in §6.1. | Risk engineer | §6.1 | Schema review | Versioned schemas cover rules, accounts, lifecycle, risk, lease, payout, expense. |
| QB-DOM-004 | Operational model contains all deployment/execution and governance entities listed in §6.1. | Architect | §6.1 | Schema review | Versioned schemas cover named entities with identity and causation. |
| QB-DOM-005 | Important changes are append-only events and projections replay deterministically. | Architect | §6.1 | Replay/property test | Rebuild equals stored state for all golden logs. |
| QB-DOM-006 | Account lifecycle implements only explicit guarded transitions, including containment/terminal states. | Risk engineer | §6.2 | State-machine test | Invalid transition is rejected and audited. |
| QB-DOM-007 | Deployment lifecycle cannot skip states; resume/rollback is explicit and gated. | Release owner | §6.3 | State-machine test | Every transition follows declared graph and approvals. |
| QB-DOM-008 | Order lifecycle records source, sequence, timestamp, idempotency, correlation/causation, and evidence. | Execution engineer | §6.4 | Contract/replay test | Every transition validates and reconstructs exact state. |

## User experience

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| QB-UX-001 | UI follows the approved dark institutional visual system and persistent navigation/health model. | Frontend engineer | §7.1 | Visual/accessibility review | Tokens, hierarchy, state treatment, and persistent elements conform. |
| QB-UX-002 | Color is never the sole state signal; warnings are not decorative. | Frontend engineer | §7.1 | Accessibility test | Every state has text/icon semantics and contrast passes. |
| QB-UX-003 | Safety-critical actions use protected interaction and immutable operator audit. | Product owner | §7.1 | Interaction/audit test | Accidental activation is prevented and result is explicit. |
| QB-UX-004 | Command Center provides every capability in §7.2. | Product owner | §7.2 | Acceptance demonstration | Health, trading, eligibility, risk, events, incidents, Pause, Flatten are visible. |
| QB-UX-005 | Data Vault provides every capability in §7.2. | Data engineer | §7.2 | Acceptance demonstration | Import, mapping, anomaly inspection, roll, compare, certify work end-to-end. |
| QB-UX-006 | Strategy Library and Strategy Lab provide every capability in §§7.2–7.3. | Quant lead | §§7.2–7.3 | Acceptance demonstration | All views, sources, versions, validation, audit, and editor workflows work. |
| QB-UX-007 | Backtest Lab and Results Explorer provide every capability in §§7.2–7.3. | Quant lead | §§7.2–7.3 | Acceptance demonstration | Reproducible queued runs, cancellation, analyses, comparison, and provenance work. |
| QB-UX-008 | Meta Lab provides every capability in §7.2. | Quant lead | §7.2 | Acceptance demonstration | Combination, conflict, correlation, caps, portfolio, routing simulation work. |
| QB-UX-009 | Prop Lab provides every capability in §7.2. | Risk engineer | §7.2 | Acceptance demonstration | Rules, lifecycle, economics, Monte Carlo, warnings, expiry work. |
| QB-UX-010 | Accounts and Routing provide every capability in §7.2. | Risk engineer | §7.2 | Acceptance demonstration | Discovery/mapping/lifecycle and exact selection/rejection explanations work. |
| QB-UX-011 | Deployments provides every capability in §7.2. | Release owner | §7.2 | Acceptance demonstration | Immutable selection, envelope, gates, history, and rollback work. |
| QB-UX-012 | Orders/Positions and Risk Center provide every capability in §7.2. | Risk engineer | §7.2 | Acceptance demonstration | Lifecycles, comparison, quarantine, limits, switches, and violations work. |
| QB-UX-013 | Operations and Audit provide every capability in §7.2. | SRE | §7.2 | Acceptance demonstration | Investigation, recovery, backup, health, immutable timeline, and export work. |
| QB-UX-014 | All screens are keyboard accessible and expose loading, empty, stale, blocked, disconnected, and error states. | Frontend engineer | §7.2 | Accessibility/state test | Each state is reachable, announced, and actionable. |
| QB-UX-015 | User errors explain the condition and safe next action. | Product owner | §7.2 | Content/acceptance test | No user-facing failure is code-only or actionless. |
| QB-UX-016 | Backtest review captures all declared inputs and successful runs never auto-promote. | Quant lead | §7.3 | Workflow/replay test | Run hash reproduces output; promotion remains separate and gated. |

## Governance, quality, security, and operations

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| QB-GOV-001 | Phases execute sequentially and each has traceable requirements, evidence, demonstration, limitations, and acceptance. | Program manager | §8.1 | Gate review | No later implementation predates accepted predecessor tag. |
| QB-GOV-002 | Phase completes only after accepted record is committed, approved, tagged, and immutable. | Program manager | §8.1 | Git/review | Required record and protected tag identify exact commit. |
| QB-GOV-003 | Invalidated earlier gate reopens and blocks dependent promotion. | Program manager | §8.1 | Change/incident exercise | Dependency status changes to blocked automatically or procedurally. |
| QB-GOV-004 | Applicable unit, integration, replay, acceptance, determinism, performance, security, migration, and documentation gates pass. | QA lead | §8.2 | CI/gate report | Acceptance report links passing evidence or explicit justified N/A. |
| QB-GOV-005 | Safety-critical branch coverage is ≥95%; other production code is ≥85%; mutation tests defend required checks. | QA lead | §8.2 | Coverage/mutation report | Thresholds pass on exact accepted revision. |
| QB-GOV-006 | No unresolved P0/P1 exists at phase acceptance or live promotion. | SRE | §§8.2,13 | Incident query | Gate reports zero unresolved P0/P1. |
| QB-GOV-007 | Strategy import, parameter/versioning, backtest, audit, and deployment-isolation universal gates are satisfied when applicable. | Quant lead | §8.2 | Acceptance tests | Each item passes or acceptance report gives phase-specific N/A rationale. |
| QB-SEC-001 | No brokerage password is stored; identifiers are masked and AI inputs redacted. | Security reviewer | §12 | Secret/redaction test | Scans and adversarial fixtures find no disclosure. |
| QB-SEC-002 | Inter-process messages authenticate identity/sequence and reject replay/conflict. | Security reviewer | §12 | Security/property test | Invalid, duplicate, stale, and conflicting messages fail closed. |
| QB-SEC-003 | Untrusted strategy code lacks network, arbitrary filesystem, subprocess, installers, credentials, environment secrets, and broker APIs. | Security reviewer | §12 | Sandbox/adversarial test | Each forbidden capability is denied with actionable reason. |
| QB-SEC-004 | External rule evidence and effective dates are preserved for every decision. | Product owner | §12 | Trace/audit test | Decision resolves to exact source and version. |
| QB-SEC-005 | Releases and governed artifacts are immutable/content-addressed where applicable. | Release owner | §12 | Hash/signature test | Tampering invalidates verification and prevents use. |
| QB-OBS-001 | Logs, metrics, traces, events, commands, actions, and incidents support one chronological investigation. | SRE | §13 | Incident replay | Correlation reconstructs complete golden incident. |
| QB-OBS-002 | Recovery is bounded and ambiguity ends paused/quarantined. | SRE | §13 | Chaos test | Exhausted recovery never continues optimistically. |
| QB-OBS-003 | AI conclusions are advisory, attributable, redactable, and separate from authority. | Security reviewer | §13 | Architecture/security test | Disabling AI has no safety effect. |
| QB-DATA-001 | Retention, backup, restore, export, and deletion follow approved policy and legal holds. | SRE | §§12,17 | Restore/policy test | Scheduled evidence demonstrates retention and recoverability. |
| QB-INC-001 | P0–P3 severity, owners, response times, containment, and resolution follow the approved incident policy. | SRE | §§13,15 | Incident exercise | Timelines and approvals meet policy. |
| QB-APP-001 | All accountable roles are assigned even when temporarily held by one person. | Product owner | §15 | Review | Approval matrix has a named owner for every role. |
| QB-APP-002 | Live execution and material risk changes require two independent approvals; author is not sole approver. | Product owner | §15 | Permission/review test | System/process blocks self-only approval. |
| QB-CC-001 | Controlled changes use unique record, exact proposal, full impact, threat/risk/test updates, approvals, effective point, and migration/rollback. | Architect | §16 | Change-record review | Incomplete change cannot become effective. |
| QB-CC-002 | Emergency containment may only reduce exposure and cannot weaken gates. | Risk engineer | §16 | Scenario test | Emergency actions are limited to pause/quarantine/cancel/flatten. |

## Performance and testing program

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| PERF-001 | UI response is under 100 ms p95. | Frontend engineer | §11 | Benchmark | Reference method and fixture pass. |
| PERF-002 | Normal dashboard API is under 250 ms p95. | Control-service owner | §11 | Benchmark | Reference method and fixture pass. |
| PERF-003 | Ordinary filtered analytics query is under 1 second p95. | Data engineer | §11 | Benchmark | Reference method and fixture pass. |
| PERF-004 | Local risk/routing decision is under 50 ms p99. | Risk engineer | §11 | Benchmark | Reference method and fixture pass. |
| PERF-005 | Service-to-bridge acknowledgment is under 250 ms p99 excluding broker latency. | Execution engineer | §11 | Benchmark | Reference method and fixture pass. |
| PERF-006 | Restart/reconciliation is under 30 seconds for the declared 100-account/10,000-event load. | SRE | §11 | Benchmark | Every measured run passes. |
| PERF-007 | Baseline backtester handles at least 5 million bar-events/minute/worker. | Quant lead | §11 | Benchmark | Median throughput meets gate without invalid shortcuts. |
| PERF-008 | Service outage loses no data for 24 hours with sufficient disk. | SRE | §11 | Durability test | Exact replay recovers every acknowledged event. |
| PERF-009 | Import/backtest memory is bounded without full dataset residency. | Data engineer | §11 | Scale test | Peak memory follows declared bound across fixtures. |
| QB-TST-001 | Deterministic rules have unit tests and safety invariants have property tests. | QA lead | §14 | CI | Required suites pass with recorded seeds. |
| QB-TST-002 | Safety-critical branches have mutation tests. | QA lead | §14 | Mutation report | Required checks cannot be removed undetected. |
| QB-TST-003 | Cross-process/release schemas have compatibility tests. | Architect | §14 | Contract CI | Incompatible change is blocked. |
| QB-TST-004 | Strategy imports have adversarial forbidden-capability and clean-format tests. | Security reviewer | §14 | Security CI | All forbidden cases reject precisely; supported clean cases pass. |
| QB-TST-005 | Versioning tests prove completed results/deployments cannot mutate. | Quant lead | §14 | Replay/version tests | Historical hashes and outcomes remain unchanged. |
| QB-TST-006 | Database/API/event/outbox/process integration and immutable-log replay are tested. | QA lead | §14 | Integration/replay CI | Golden state and outcomes reconcile exactly. |
| QB-TST-007 | Financial/execution calculations use hand-worked golden fixtures and optimized paths use differential tests. | Quant lead | §14 | Golden/differential CI | Exact expected values match reference. |
| QB-TST-008 | UI accessibility/failure states, reference performance/memory, chaos/restart, secrets/dependencies/licenses/penetration/signatures are tested. | QA/Security | §14 | CI/certification | Every applicable gate produces linked evidence. |
| QB-TST-009 | Evidence identifies exact source/config/schema/data/strategy/rule hashes, seed, clocks, models, environment, and result. | QA lead | §14 | Evidence-schema review | No accepted result lacks required provenance. |

## Fixed phase deliverables and gates

| ID | Requirement | Owner | Source | Verification | Acceptance criterion |
|---|---|---|---|---|---|
| QB-PHASE-000 | Phase 0 establishes charter, definitions, firm evidence, threat/risk/policies, workstation, requirements, and acceptance baseline. | Product owner | §9 Phase 0 | Phase gate | Every Phase 0 exit criterion and applicable universal gate passes. |
| QB-PHASE-001 | Phase 1 establishes reproducible monorepo, build/review/supply-chain controls, signed dev build, and one-command clean build/test. | Architect | §9 Phase 1 | Phase gate | Every Phase 1 exit criterion and applicable universal gate passes. |
| QB-PHASE-002 | Phase 2 defines contracts, identifiers, append-only event ledger, integrity, compatibility, and deterministic replay. | Architect | §9 Phase 2 | Phase gate | Phase 2 exit gate passes. |
| QB-PHASE-003 | Phase 3 delivers desktop shell/design system without broker/order capability. | Frontend engineer | §9 Phase 3 | Phase gate | Phase 3 exit gate passes. |
| QB-PHASE-004 | Phase 4 delivers certified, immutable, reproducible Market Data Vault. | Data engineer | §9 Phase 4 | Phase gate | Phase 4 exit gate passes. |
| QB-PHASE-005 | Phase 5 delivers strategy SDK/library and mandatory untrusted import validation. | Quant lead | §9 Phase 5 | Phase gate | Phase 5 exit gate passes. |
| QB-PHASE-006 | Phase 6 delivers deterministic baseline event-driven backtester and one-click orchestration. | Quant lead | §9 Phase 6 | Phase gate | Phase 6 exit gate passes. |
| QB-PHASE-007 | Phase 7 delivers realistic fills, costs, latency, orders, and protective behavior. | Execution engineer | §9 Phase 7 | Phase gate | Phase 7 exit gate passes. |
| QB-PHASE-008 | Phase 8 delivers research validation, bias controls, preregistration, and governance. | Quant lead | §9 Phase 8 | Phase gate | Phase 8 exit gate passes. |
| QB-PHASE-009 | Phase 9 delivers reproducible, leakage-resistant Optuna optimization. | Quant lead | §9 Phase 9 | Phase gate | Phase 9 exit gate passes. |
| QB-PHASE-010 | Phase 10 delivers deterministic meta-strategy/portfolio engine and single-account routing simulation. | Quant lead | §9 Phase 10 | Phase gate | Phase 10 exit gate passes. |
| QB-PHASE-011 | Phase 11 delivers effective-dated firm-rule engine and lifecycle/economic simulator. | Risk engineer | §9 Phase 11 | Phase gate | Phase 11 exit gate passes. |
| QB-PHASE-012 | Phase 12 delivers observation-only NinjaTrader bridge and account import. | Execution engineer | §9 Phase 12 | Phase gate | Phase 12 exit gate passes and submission code is absent. |
| QB-PHASE-013 | Phase 13 delivers deterministic pre-trade and continuous-containment risk kernel. | Risk engineer | §9 Phase 13 | Phase gate | Phase 13 exit gate passes. |
| QB-PHASE-014 | Phase 14 delivers deterministic shadow router with exclusive lease/reservation and no orders. | Risk engineer | §9 Phase 14 | Phase gate | Phase 14 exit gate passes. |
| QB-PHASE-015 | Phase 15 delivers idempotent simulated order execution and recovery on simulation accounts only. | Execution engineer | §9 Phase 15 | Phase gate | Phase 15 exit gate passes. |
| QB-PHASE-016 | Phase 16 delivers immutable, evidence-based deployment manager and promotion workflow. | Release owner | §9 Phase 16 | Phase gate | Phase 16 exit gate passes. |
| QB-PHASE-017 | Phase 17 delivers deterministic operations/recovery with read-only AI supervision. | SRE | §9 Phase 17 | Phase gate | Phase 17 exit gate passes. |
| QB-PHASE-018 | Phase 18 completes required chaos/security/release certification and seven-day simulation soak. | QA/Security | §9 Phase 18 | Phase gate | Phase 18 exit gate passes. |
| QB-PHASE-019 | Phase 19 completes preregistered forward-paper certification with exact reconciliation. | Quant lead | §9 Phase 19 | Phase gate | Phase 19 exit gate passes. |
| QB-PHASE-020 | Phase 20 completes one minimum-size evaluation-account pilot under stricter controls. | Risk engineer | §9 Phase 20 | Phase gate | Phase 20 exit gate passes. |
| QB-PHASE-021 | Phase 21 follows fixed one-funded-to-fleet rollout with acceptance at every level. | Product owner | §9 Phase 21 | Phase gate | Every expansion step passes before the next begins. |

## Traceability maintenance rule

Every later requirement, test, benchmark, incident, risk treatment, demonstration, and acceptance report references one or more IDs above. A requirement wording change needs change control when it alters scope, architecture, invariant, phase, gate, threshold, supported firm/instrument, or live behavior.

