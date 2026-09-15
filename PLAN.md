# QuantBench Master Project Plan

| Field | Value |
|---|---|
| Product | QuantBench |
| Document version | 1.1 |
| Status | Controlling project specification |
| Product type | Greenfield Windows desktop quantitative research and execution workstation |
| Version 1 focus | NinjaTrader 8 and CME futures: NQ, MNQ, ES, and MES |
| Repository | `D:\Codes\QuantBench` |

## 1. Authority and use of this document

This file is the governing plan for QuantBench. Every project chat, implementation task, review, and release decision must begin by reading the current committed version of `PLAN.md` and must remain within its scope.

The following rules apply:

1. QuantBench is a completely separate greenfield product. No existing repository is its foundation, and QuantBench code must not be added to another product.
2. The architecture, safety invariants, phase order, phase gates, and Version 1 exclusions in this document are locked.
3. A contributor may make implementation decisions inside these boundaries but may not silently change architecture, weaken a gate, defer required safety work, substitute a locked component, or expand scope.
4. Work begins at Phase 0. A later phase may not begin until the preceding phase has a signed acceptance record.
5. If a request conflicts with this plan, work must stop at the conflict. The conflict must be documented and handled through the change-control process in Section 16.
6. Unknown or ambiguous safety, brokerage, exchange, or prop-firm behavior is deployment-blocking. It must never be resolved by an optimistic assumption.
7. This document describes planned work. It does not imply that any phase, capability, certification, or live-trading approval is complete.

## 2. Product mission

QuantBench will provide one controlled workstation for the complete lifecycle of futures strategies:

- Import, normalize, inspect, certify, and version market data.
- Create, edit, test, package, and version trading strategies.
- Maintain a Strategy Library for strategies authored in QuantBench, imported from Python or QuantBench packages, and pasted from external AI conversations.
- Import externally authored strategies through a mandatory untrusted-code validation pipeline.
- Backtest strategies with reproducible and explicitly modeled execution behavior.
- Compare experiments while exposing selection bias and preventing overfitting.
- Combine strategies into deterministic portfolio and meta-strategy configurations.
- Model complete prop-firm evaluation, funded-account, fee, breach, and payout economics.
- Discover and import connected NinjaTrader accounts.
- Bind every account to its exact firm, plan, lifecycle stage, and effective rule version.
- Promote immutable strategy versions through shadow, simulated, forward-paper, evaluation, funded-pilot, and live modes.
- Route each trade intent to zero or one eligible account.
- Monitor orders, executions, positions, risk, drawdown, incidents, and payout state.
- Detect failures, quarantine uncertainty, reconcile state, and recover safely.
- Use AI to investigate logs and incidents without granting AI authority over orders, risk, rules, or deployments.
- Suspend strategies and accounts automatically when operational, safety, or economic gates fail.

QuantBench is not a high-frequency trading platform. The live safety and order path must remain local and must not depend on cloud availability.

## 3. Version 1 scope

### 3.1 Included

- Windows 11 desktop application.
- NinjaTrader 8 integration.
- CME equity-index futures, initially NQ, MNQ, ES, and MES.
- Local historical research, optimization, simulation, and portfolio analysis.
- Versioned strategy source, parameter presets, tests, research notes, backtest history, and deployment associations in a unified Strategy Library.
- Strategy import by pasted code, Python file, or QuantBench Strategy Package (`.qbs`).
- NinjaTrader-connected simulation, evaluation, and funded accounts after certification.
- Sequential account routing in which one trade is assigned to no more than one account.
- Prop-firm rule, fee, lifecycle, and payout modeling based on archived source evidence.
- Local operational monitoring, reconciliation, audit, backup, and recovery.
- Read-only AI incident investigation and reporting.

### 3.2 Explicit exclusions

- Cryptocurrency, options, equities, or other asset classes.
- Brokers not reachable through the approved NinjaTrader integration.
- Mobile order control.
- Browser scraping of prop-firm portals.
- Automated evaluation purchases, resets, or payout requests.
- A drag-and-drop or no-code strategy builder.
- Sub-millisecond, colocated, or HFT execution.
- Automatic production promotion of AI-generated strategies.
- Copying the same trade across multiple accounts.
- Automatic resumption from unknown broker state.
- Cloud dependencies in the live risk or order path.

New adapters or asset classes may be proposed only after the funded pilot and only through approved change control.

## 4. Locked architecture

### 4.1 Mandatory technology choices

| Layer or capability | Mandatory technology |
|---|---|
| Desktop shell | Tauri 2 |
| UI | React, TypeScript strict mode, Vite |
| UI primitives | Tailwind CSS, Radix primitives |
| Tables and forms | TanStack Table, React Hook Form, Zod |
| Charts | Apache ECharts |
| Strategy editor | Monaco Editor |
| Local control service | C#/.NET Windows Service |
| NinjaTrader adapter | C# NinjaScript AddOn |
| Strategy and research runtime | Python |
| Dataframe engine | Polars |
| Numerical and statistical stack | NumPy, SciPy, Statsmodels, scikit-learn |
| Optimization | Optuna |
| Acceleration | Numba only where benchmarks justify it |
| Cross-process analytical format | Apache Arrow IPC |
| Long-term market-data format | Partitioned Parquet |
| Analytical database | DuckDB, owned by exactly one analytics process |
| Operational database | SQLite in WAL mode, with the control service as sole writer |
| Local API | Versioned localhost REST plus WebSocket event stream |
| Logs and telemetry | Structured JSONL through Serilog and OpenTelemetry |
| Secrets | Windows Credential Manager and DPAPI |
| Packaging | Signed Windows MSI |
| CI | GitHub Actions on Windows runners |

Technology substitutions require an approved change request. DuckDB must have a single owning process. The desktop UI must never read either database directly.

### 4.2 Process boundaries

QuantBench consists of four isolated process classes:

#### A. QuantBench Desktop

- Presentation and operator interaction only.
- Communicates with the control service through the versioned local API.
- Cannot connect directly to NinjaTrader.
- Cannot submit orders or bypass risk and promotion gates.

#### B. QuantBench Control Service

- Continues running when the desktop UI is closed.
- Owns operational state, risk decisions, account routing, deployments, and reconciliation.
- Is the sole writer to the operational SQLite database.
- Is the only process allowed to command the NinjaTrader adapter.
- Emits immutable audit events for every state-changing action.

#### C. Quant Worker

- Runs research, backtests, optimization, Monte Carlo analysis, and isolated live strategy processes.
- Has no broker credentials and no direct order access.
- Emits only normalized trade intents through approved contracts.
- Uses the same immutable strategy package for backtest and live signal generation.

#### D. NinjaTrader AddOn

- Discovers accounts and publishes account, connection, order, execution, position, and relevant market events.
- Receives idempotent order commands only from the control service.
- Maintains a durable disk outbox with ordered, authenticated events.
- Never performs strategy research, prop-firm selection, risk authorization, or account-routing logic.

### 4.3 Required repository shape

The monorepo created in Phase 1 will use this structure:

```text
QuantBench/
|-- apps/
|   `-- desktop/
|-- services/
|   `-- control-service/
|-- engines/
|   `-- quant-worker/
|-- adapters/
|   `-- ninjatrader/
|-- packages/
|   |-- contracts/
|   |-- strategy-sdk/
|   `-- ui-components/
|-- schemas/
|-- migrations/
|-- tests/
|   |-- integration/
|   |-- replay/
|   |-- chaos/
|   `-- acceptance/
|-- benchmarks/
|-- docs/
|   |-- adr/
|   |-- specifications/
|   |-- runbooks/
|   `-- releases/
`-- tools/
```

This structure is planned work for Phase 1 and must not be created prematurely during documentation-only planning.

## 5. Non-negotiable safety invariants

These invariants apply from the first prototype and take precedence over convenience, performance, or schedule:

| ID | Invariant |
|---|---|
| SAFE-001 | A strategy never communicates directly with NinjaTrader. |
| SAFE-002 | The UI never communicates directly with NinjaTrader. |
| SAFE-003 | AI never submits, changes, cancels, or approves an order. |
| SAFE-004 | AI never modifies a risk limit, prop rule, account state, or deployment. |
| SAFE-005 | Every deployable strategy version is immutable, content-hashed, and signed through the approved promotion flow. |
| SAFE-006 | Every trade intent selects zero or one account, never multiple accounts. |
| SAFE-007 | One account may hold only one active QuantBench lease. |
| SAFE-008 | An account receives no new entry while it has an unresolved order or position. |
| SAFE-009 | No order is submitted from a stale account, price, rule, clock, or connection snapshot. |
| SAFE-010 | Risk is reserved atomically before order submission. |
| SAFE-011 | A duplicate command resolves to the original order and never creates another order. |
| SAFE-012 | A filled position receives protective orders within its configured deadline. |
| SAFE-013 | Unknown broker state causes quarantine and never automatic resumption. |
| SAFE-014 | Reconnection requires complete order, execution, position, and account reconciliation. |
| SAFE-015 | A stale, contradictory, or changed prop-firm rule pack blocks the affected account. |
| SAFE-016 | Strategy code cannot override account-level or fleet-level risk. |
| SAFE-017 | Daily-loss calculations include an explicit safety buffer for slippage and liquidation uncertainty. |
| SAFE-018 | Every state-changing action produces an immutable audit event. |
| SAFE-019 | Only signed, promoted, certified builds may operate live. |
| SAFE-020 | The product has no control that can force live operation through a failed gate. |
| SAFE-021 | Imported or AI-authored strategy code is untrusted and cannot execute outside the validation sandbox until every required import gate passes. |
| SAFE-022 | Strategy code and parameter sets are separate immutable, versioned objects; edits cannot alter completed results or active deployments. |
| SAFE-023 | Editing a deployed strategy creates a draft fork; the active deployment remains bound to its original immutable versions until a replacement completes promotion. |

Violating any invariant is a release blocker. A requested behavior that appears to require an exception must be handled as an architecture and threat-model change, not as an implementation shortcut.

## 6. Domain and state model

### 6.1 Required domain entities

The operational model must include, at minimum:

- Market reference: `Instrument`, `Contract`, `TradingSession`, `MarketDataset`, `MarketEvent`.
- Strategy and research: `Strategy`, `StrategyVersion`, `StrategyParameterSet`, `StrategyPackage`, `StrategyImport`, `ImportValidationRun`, `Experiment`, `BacktestRun`, `BacktestTrade`, `TradeIntent`, `MetaStrategy`, `PortfolioRun`.
- Firm and account: `PropFirm`, `PropRulePack`, `Account`, `AccountLifecycleEvent`, `RiskSnapshot`, `AccountLease`, `Payout`, `Expense`.
- Deployment and execution: `Deployment`, `OrderCommand`, `OrderEvent`, `Execution`, `Position`.
- Operations and governance: `ConnectionEvent`, `Incident`, `OperatorAction`, `AIAnalysis`, `Release`.

Important changes are append-only events. Current account, order, position, risk, and deployment state are projections derived from those events and must be reproducible through deterministic replay.

### 6.2 Account lifecycle

Normal progression:

```text
Imported -> Verified -> Evaluation -> PassedAwaitingActivation -> Funded
Funded -> PayoutEligible -> PayoutPending -> Funded
```

Exceptional or terminal transitions from any applicable active state:

```text
Suspended -> Quarantined -> Breached -> Closed
```

Exact permitted transitions, guards, and reversibility must be defined in the Phase 0 requirements and Phase 2 event schemas. No transition may be inferred from UI state alone.

### 6.3 Deployment lifecycle

```text
Draft
  -> BacktestValidated
  -> Shadow
  -> Simulated
  -> ForwardPaper
  -> EvaluationPilot
  -> FundedPilot
  -> Live
  -> Paused
  -> Retired
```

A deployment cannot skip a state. Resumption or rollback rules must be explicit, audited, and subject to the gates appropriate to the destination state.

### 6.4 Order lifecycle

Primary progression:

```text
Created -> RiskReserved -> Dispatched -> Acknowledged -> Working
        -> PartiallyFilled -> Filled -> Closing -> Reconciled
```

Alternative terminal or containment states:

```text
Cancelled | Rejected | Expired | Unknown | Quarantined
```

Every transition must carry its source, sequence, timestamp, idempotency identity, causation/correlation identity, and supporting broker or system evidence.

## 7. Required user experience

QuantBench is not complete until all screens below exist and meet their applicable acceptance criteria.

### 7.1 Approved visual system

The interface combines the approved live-trading flight-deck composition with the approved prop-firm control-system structure. The written rules below are authoritative when a visual reference is unavailable.

- Use a dark graphite and navy foundation with crisp white and cool-gray typography.
- Use emerald for healthy or eligible state, amber for warnings and uncertainty, and red only for confirmed danger or quarantine.
- Reserve violet for simulations, probability distributions, and probability ranges.
- Use minimal shadows, restrained corner radii, dense institutional layouts, strong alignment, and deliberate information hierarchy.
- Use monospaced typography for prices, quantities, IDs, hashes, timestamps, and other exact operational values.
- Keep primary navigation and the system-health bar persistent across every page.
- Use the live-trading flight-deck composition for Command Center: system health across the top, live chart and active-trade ribbon, account-eligibility queue, fleet risk, recent event ledger, and protected Pause and Emergency Flatten controls.
- Use the prop-firm control-system structure for Prop Lab, Accounts, and Routing: account lifecycle pipeline, fleet economics, Monte Carlo cash-flow distributions, rule warnings and expiry, complete fleet tables, and exact eligibility/rejection explanations.
- Strategy Library, Strategy Lab, and Backtest Lab use the same dark institutional language; a separate light workspace is not permitted.
- Safety-critical actions require protected interaction patterns appropriate to their risk, clear resulting state, and immutable operator audit events.

Visual consistency may not obscure state. Color is never the only state indicator, and warning colors may not be used decoratively.

### 7.2 Required screens

| Screen | Required capabilities |
|---|---|
| Command Center | Persistent system health; live chart and active-trade ribbon; active strategies; positions and working orders; account-eligibility queue; fleet P&L and remaining risk; recent event ledger; incidents and blocked accounts; protected global Pause and Emergency Flatten controls. |
| Data Vault | CSV, Parquet, and NinjaTrader import; manifests and hashes; instrument/session/timezone/contract mapping; missing, duplicate, invalid, and out-of-order inspection; contract-roll controls; comparison and certification. |
| Strategy Library | Strategies created internally, pasted from AI responses, imported from Python, or imported as `.qbs`; versions, presets, tests, notes, backtests, deployments, account associations, warnings, validation state, and full audit history. |
| Strategy Lab | Monaco Python editor; parameter schema editor; indicator library; unit-test runner; strategy manifest and dependency lock; signal/order charts; version comparison. |
| Backtest Lab | Dataset/date selection; costs, fills, and latency; sizing/account configuration; single, batch, and parameter-sweep runs; progress, cancellation, and reproducibility hash. |
| Results Explorer | Equity/drawdown; trades/executions; MAE/MFE; time, side, session, and regime splits; parameter and cost sensitivity; Monte Carlo distributions; multi-experiment comparison. |
| Meta Lab | Strategy combinations; priority/conflict rules; correlation analysis; exposure caps; portfolio backtests; account-routing simulations. |
| Prop Lab | Rule-pack editor; account-lifecycle pipeline; evaluation/funded lifecycle simulation; fee/payout modeling; pass/breach/payout probabilities; expected net profit; cash and fee burn; Monte Carlo fleet/routing simulation; rule-change sensitivity, warnings, and expiry handling. |
| Accounts | Account discovery; historical transaction import; complete fleet table; firm/plan/stage mapping; lifecycle state; rule version, expiry, and buffers; verification/reconciliation status; suspend, quarantine, and close controls. |
| Routing | Explainable account eligibility and deterministic ranking; exact selection and rejection reasons; current leases and reservations; fleet constraints; rule warnings; and shadow-policy comparison. |
| Deployments | Immutable strategy selection; mode and eligible pool; approved risk envelope; deployment checklist; promotion history and rollback. |
| Orders and Positions | Complete lifecycle; partial fills; protective orders; broker/local comparison; manual quarantine and reconciliation workflow. |
| Risk Center | Per-trade, daily, account, trailing-drawdown, and fleet limits; stale-data controls; kill-switch history; violations and near misses. |
| Operations | Logs, metrics, traces, incidents, recovery attempts, AI summaries, backup/restore, clock, disk, and service health. |
| Audit | Immutable event timeline; strategy, rule, and deployment hashes; operator actions; dispute-investigation exports. |

Shared UX requirements include keyboard accessibility and explicit loading, empty, stale, blocked, disconnected, and error states. User-facing errors must explain both the condition and the safe next action.

### 7.3 Strategy Library experience

The Strategy Library is the required system of record for strategy work. Its primary table shows:

- Strategy name, asset, timeframe, and strategy family.
- Current version and authoring source.
- Validation state and warning count.
- Latest backtest result and current deployment state.
- Last-modified timestamp.

Each strategy has the following views: Overview, Source Code, Parameters, Tests, Backtests, Versions, Deployments, and Audit History.

A validated strategy page exposes a prominent **Run Backtest** action. It opens a review drawer containing dataset, date range, instruments/contracts, parameter set, position sizing, commission, slippage and fill models, starting capital, account type, prop rule pack, random seed, and walk-forward/out-of-sample configuration. From this drawer an operator can run a backtest, quick smoke test, full validation, parameter sweep, walk-forward analysis, prop-firm simulation, or comparison with the previous version.

Submitted work enters a visible queue, exposes its current stage and progress, supports safe cancellation, and opens the result when complete. Every specification is hashed so that the strategy, parameter set, dataset, and execution assumptions reproduce the same result. A successful backtest never promotes a strategy automatically.

## 8. Delivery model and universal quality gate

### 8.1 Phase governance

- Phases are sequential. Parallel discovery may occur only when it does not implement or approve a later phase early.
- Each phase must define traceable requirements, test evidence, a demonstration artifact, known limitations, and an acceptance report.
- The acceptance report must be signed by the accountable roles defined for that phase.
- A phase is complete only after its acceptance record is committed, approved, tagged, and immutable.
- A defect or discovery that invalidates an earlier gate reopens that gate and blocks dependent promotion.

### 8.2 Universal definition of done

Every phase must satisfy all applicable items below:

- All acceptance requirements are implemented; no placeholder or TODO stands in for required behavior.
- Unit, integration, replay, and acceptance tests pass as applicable.
- Core risk, order, and rule code reaches at least 95% branch coverage.
- Other production code reaches at least 85% branch coverage.
- Mutation testing demonstrates that required safety checks cannot be removed undetected.
- Determinism and reproducibility tests pass.
- Performance benchmarks pass on the declared reference workstation.
- Security, secret, dependency, vulnerability, and license scans pass.
- Database migrations are tested forward and backward.
- User-facing failure messages are actionable.
- Documentation, runbooks, threat model, and risk register are current.
- A demonstration artifact and signed acceptance report exist.
- No unresolved P0 or P1 defect exists.
- The completed phase is released as an immutable tag.
- A correctly formatted externally AI-authored strategy imports without manual code changes.
- Unsafe imported code is rejected with a precise, actionable explanation.
- Parameters can be changed through versioned parameter sets without source-code editing.
- A complete backtest can be launched through the UI.
- Every result identifies the exact strategy version, parameter-set version, dataset, seed, and execution assumptions.
- Earlier results remain reproducible after later strategy or parameter edits.
- Imported strategies cannot access accounts, broker APIs, credentials, or environment secrets.
- Imported or modified strategies cannot bypass the deployment-promotion lifecycle.
- Editing a strategy cannot change an active deployment.
- Strategy versions, parameter sets, import validation runs, and deployments have complete audit histories.

Where an item is genuinely not applicable, the acceptance report must state why; it may not simply omit the item.

## 9. Progressive implementation plan

### Phase 0 — Product charter and compliance boundary

**Objective:** Establish the legal, operational, economic, safety, and requirements baseline before building operational software.

**Required work:**

- Freeze Version 1 scope to Windows 11, NinjaTrader 8, NQ, MNQ, ES, and MES.
- Identify every intended prop firm and plan.
- Archive source terms, payout rules, and automation policies with retrieval and effective dates.
- Define account equity, realized and unrealized P&L, trailing floor, daily reset, breach, and all other safety-critical terminology.
- Determine what automation each firm permits; prohibit credential scraping and policy evasion.
- Define the reference workstation hardware and measurement method.
- Create the product requirements, threat model, master risk register, data-retention policy, backup policy, and incident-reporting policy.
- Define P0 through P3 severity, response ownership, and resolution requirements.
- Create a complete requirement-to-acceptance traceability matrix.

**Exit gate:**

- Every Version 1 requirement has a stable ID, owner, source, verification method, and acceptance criterion.
- Every firm rule has source evidence and an effective date.
- Every ambiguous or contradictory rule is marked deployment-blocking.
- The charter, product requirements, threat model, risk register, definitions, initial rule packs, and acceptance matrix are approved.

### Phase 1 — Repository and engineering controls

**Objective:** Establish the reproducible monorepo, build, review, and supply-chain foundation.

**Required work:**

- Create the required monorepo structure.
- Configure formatting, linting, strict compilation, and static analysis for C#, Python, TypeScript, and Rust/Tauri components.
- Configure signed commits, branch protection, required reviews, and protected releases.
- Add Windows CI for every language and package.
- Add lockfiles, secret scanning, vulnerability scanning, and automated license inventory.
- Establish architecture decision records and release, incident, acceptance, and change-request templates.
- Configure code-coverage and mutation-testing reports.

**Exit gate:**

- A clean checkout builds and tests with one documented command.
- No secret exists in source control or build artifacts.
- CI blocks failed formatting, linting, compilation, tests, vulnerabilities, and schema incompatibility.
- The empty application produces a signed development build.

### Phase 2 — Contracts, identifiers, and event ledger

**Objective:** Establish versioned contracts and deterministic operational truth.

**Required work:**

- Define UUID/ULID identity rules and causation/correlation semantics.
- Define versioned JSON schemas for every domain event.
- Implement SQLite WAL operational storage with one control-service writer.
- Implement append-only audit storage and forward/backward-tested migrations.
- Build account, order, position, risk, and deployment projections.
- Add deterministic replay from an empty database.
- Add backup, integrity-check, and restore operations.

**Exit gate:**

- Event replay produces byte-equivalent projections.
- Duplicate event IDs are idempotent; conflicting duplicates are rejected.
- Application paths cannot update or delete audit events.
- Crash recovery passes at every transaction boundary.

### Phase 3 — Desktop shell and design system

**Objective:** Deliver the secure presentation shell and resilient service connection.

**Required work:**

- Build the Tauri shell and Windows installer.
- Implement initial local-administrator authentication.
- Implement the approved dark institutional design system, tokens, typography, status semantics, density, protected controls, and shared layouts.
- Implement the persistent primary navigation and system-health bar.
- Establish the flight-deck Command Center composition and prop-control layouts for Prop Lab, Accounts, and Routing.
- Create navigation and placeholders for every required screen.
- Implement shared loading, empty, stale, blocked, disconnected, and error states.
- Add keyboard accessibility and baseline assistive-technology support.
- Build versioned REST and WebSocket client adapters.
- Add signed automatic-update plumbing, disabled for production until certification.

**Exit gate:**

- Every required route exists.
- The Command Center, Prop Lab, Accounts, Routing, Strategy Library, Strategy Lab, and Backtest Lab conform to the approved shared visual direction.
- Color is not the sole carrier of state, and red is used only for confirmed danger or quarantine.
- The UI never reads a database or connects to NinjaTrader directly.
- The application reconnects to a restarted control service without losing state.
- Playwright smoke tests cover navigation, authentication, disconnection, and service failure.

### Phase 4 — Market Data Vault

**Objective:** Produce immutable, traceable, certified research datasets.

**Required work:**

- Import CSV, Parquet, and NinjaTrader historical exports.
- Create an instrument master for NQ, MNQ, ES, and MES, including tick size, point value, exchange timezone, and session calendar.
- Normalize timestamps to UTC while preserving source timestamps and provenance.
- Detect duplicates, gaps, out-of-order rows, invalid OHLC, and inconsistent metadata.
- Support individual contracts and explicit continuous-series construction.
- Store immutable canonical partitions in Parquet.
- Generate manifests with source hashes, transformations, schema, coverage, and quality metrics.
- Add visual inspection, comparison, certification, and quarantine workflows.

**Exit gate:**

- Known fixtures reproduce identical canonical hashes.
- DST, holidays, session boundaries, and contract rolls have dedicated tests.
- No backtest can consume an uncertified dataset.
- A 10-million-bar import passes the reference-hardware benchmark.

### Phase 5 — Strategy SDK, Library, and import validation

**Objective:** Define a deterministic, isolated strategy contract shared by research and live signal generation; establish the Strategy Library; and safely ingest internally, manually, and AI-authored strategies.

**Mandatory lifecycle interface:**

```text
on_start(context)
on_session_start(context, session)
on_bar(context, bar)
on_tick(context, tick)                 # optional
on_order_update(context, order)
on_execution(context, execution)
on_session_end(context, session)
on_stop(context)
```

**Permitted outputs:** entry intent, exit intent, cancel intent, hold/no-action, metadata, and diagnostics.

**Strategy Library scope:**

- Strategies written inside QuantBench.
- Strategies manually created with external AI tools or pasted from chat responses.
- Imported `.py` strategy files.
- Imported `.qbs` QuantBench Strategy Packages.
- Multiple immutable versions of a strategy.
- Separately versioned parameter presets.
- Tests, research notes, and backtest history.
- Deployment and account associations.

**Required import methods:** paste code, import one `.py` file, or import one `.qbs` package.

**QuantBench Strategy Package format:**

```text
strategy-name.qbs
|-- manifest.json
|-- strategy.py
|-- parameters.json
|-- tests/
|-- requirements.lock
|-- README.md
`-- research-notes.md
```

QuantBench must publish a downloadable, versioned AI Strategy Authoring Specification that can be attached to an external AI conversation. It defines supported callbacks, available data fields, intent emission, parameter declarations, allowed libraries, forbidden APIs, test structure, and exact `.qbs` assembly. A conforming AI-generated strategy must import without manual rewriting, but remains untrusted until validated.

**Mandatory import-validation pipeline:**

```text
Upload or paste
-> Parse
-> Schema validation
-> Dependency inspection
-> Forbidden API scan
-> Compile
-> Unit tests
-> Determinism test
-> Smoke backtest
-> Draft Strategy Library entry
```

The pipeline rejects direct NinjaTrader or broker access, network calls, arbitrary filesystem access, dynamic package installation, subprocess creation, undeclared dependencies, credential or environment-secret access, nondeterministic wall-clock behavior, malformed parameter declarations, and unsupported order behavior. Rejections must identify the exact failed rule and safe remediation. A draft library entry has no deployment authority.

**Parameter model:**

Strategy source and parameters are separate immutable objects. A strategy version may be paired with one or more versioned parameter sets, such as `NQ-ORB v1.4.0` with `Evaluation-FastPass v3`. Editing parameters creates a new parameter-set version and never mutates a completed backtest or active deployment.

Supported parameter types are integer, decimal, boolean, enum, time, duration, price/ticks, dollar amount, percentage, instrument, timeframe, trading session, and list/range. Every declaration includes name, description, type, default, minimum and maximum where applicable, increment, allowed values, optimization permission, live-change permission, and dependency rules.

The parameter UI provides bounded sliders, exact numeric entry, enumeration dropdowns, saved presets, side-by-side preset comparison, reset to strategy defaults, validation, evaluation/funded presets, and locking for sensitive live parameters. A parameter marked live-changeable still requires an explicitly versioned and audited policy; it may not mutate an immutable deployment silently.

**Modification workflow:**

```text
Open strategy
-> Create draft revision
-> Edit code or parameters
-> Run tests
-> Run smoke backtest
-> Run complete validation
-> Compare with prior version
-> Save immutable version
-> Promote or reject
```

Editing a deployed strategy always creates a fork. The live deployment continues to use its original strategy and parameter versions until the replacement completes every promotion gate.

**Required work:**

- Provide a deterministic clock and seeded random source.
- Block direct wall-clock, network, filesystem, secret, broker, and order access.
- Define typed parameter schemas, strategy manifests, and dependency locks.
- Implement the Strategy Library table, required strategy detail views, import provenance, warnings, validation state, and audit history.
- Implement paste, `.py`, and `.qbs` ingestion plus the complete validation pipeline.
- Generate and version the downloadable AI Strategy Authoring Specification.
- Implement immutable parameter sets, typed controls, presets, comparison, validation, and sensitivity locks.
- Provide a unit-test harness, state serialization, and restart support.
- Enforce resource and time limits.
- Content-hash, sign, and promote immutable packages.
- Use the same package in backtest and live signal-generation contexts.

**Exit gate:**

- Identical inputs and seed produce identical intents.
- Restarted execution reproduces uninterrupted output.
- Forbidden APIs are blocked and covered by adversarial tests.
- A strategy cannot access secrets or order APIs.
- A correctly formatted AI-authored strategy package imports without code changes.
- Every unsafe import category is rejected with a precise explanation.
- Parameter changes require no source edit and create a new immutable parameter-set version.
- Previous tests and results remain reproducible after later edits.
- Imported code cannot reach accounts, credentials, environment secrets, broker APIs, networks, arbitrary files, installers, or subprocesses.
- Editing a deployed strategy leaves the active deployment byte-for-byte unchanged.
- Strategy, strategy-version, parameter-set, import-validation, and deployment associations have complete audit history.

### Phase 6 — Baseline event-driven backtester

**Objective:** Produce chronologically correct and fully reconcilable baseline simulations.

**Required work:**

- Process market and system events chronologically.
- Support market, limit, stop-market, stop-limit, DAY, GTC, and OCO brackets.
- Model partial fills, rejections, commissions per contract and side, and configurable latency.
- Track cash, margin, strategy/account positions, and realized/unrealized P&L separately.
- Enforce exchange and session rules.
- Produce immutable trade, order, and execution ledgers.
- Support bounded progress reporting and cancellation.
- Orchestrate one-click runs from the validated Strategy Library entry through a review drawer.
- Require explicit review of dataset, date range, instruments/contracts, immutable parameter set, sizing, commissions, slippage, fill model, starting capital, account type, prop rule pack, seed, and walk-forward/out-of-sample configuration.
- Support UI actions for a standard backtest, quick smoke test, full validation, parameter sweep, walk-forward analysis, prop-firm simulation, and previous-version comparison.
- Place submitted runs in a visible job queue with stage, progress, safe cancellation, and automatic result opening on completion.
- Hash the full run specification, including strategy, parameters, data, seed, and execution assumptions.

**Exit gate:**

- Hand-calculated fixtures reconcile exactly.
- Strategy output follows the SDK contract.
- Every P&L value traces to executions.
- Same-bar ambiguity is never silently resolved.
- A complete backtest can be launched through the UI without editing source or configuration files.
- Re-running an identical specification reproduces the result.
- Successful results do not grant deployment eligibility or trigger automatic promotion.

### Phase 7 — Execution realism

**Objective:** Quantify execution uncertainty with explicit, versioned models.

**Required fill models:** tick-accurate; quote/trade when quote data exists; one-second; and OHLC with pessimistic and optimistic alternatives.

**Required work:**

- Model gap-through stops, price improvement, limit touch versus trade-through, queue/participation, partial fills, and rejection.
- Model slippage by session, volatility, and order size.
- Version exchange, clearing, and broker fee schedules.
- Model rollover, forced session close, connection latency, and rejection scenarios.
- Distinguish broker-hosted from local protective-order behavior.

**Exit gate:**

- Models pass reference-path tests.
- Ambiguous results are displayed as ranges.
- Every report names the exact fill and cost model.
- No result is labeled net without fees and slippage.

### Phase 8 — Research validation and experiment governance

**Objective:** Make results reproducible and expose overfitting, uncertainty, and selection history.

**Required work:**

- Support train, validation, out-of-sample, and locked holdout partitions.
- Support expanding and rolling walk-forward tests plus purged and embargoed cross-validation.
- Provide block/bootstrap confidence intervals and dependence-preserving Monte Carlo reshuffling.
- Run cost, latency, parameter-neighborhood, regime, annual, benchmark, and null-strategy sensitivity tests.
- Account for multiple testing.
- Maintain an immutable experiment registry; completed results cannot be overwritten.
- Audit holdout access and export a reproduction bundle.

**Required reports:** return, drawdown, Sharpe, Sortino, Calmar, profit factor, expectancy, win/loss magnitude, MAE/MFE, exposure, turnover, tail loss, CVaR, capacity, cost sensitivity, annual/monthly/session slices, parameter heat maps, confidence intervals, and the complete trade ledger.

**Exit gate:**

- Independent replay reproduces every headline metric.
- Selection history and holdout access are disclosed.
- Failed research gates block promotion.

### Phase 9 — Parameter optimization

**Objective:** Search reproducibly without allowing validation leakage or automatic promotion.

**Required work:**

- Support grid, random, and Bayesian search.
- Run every search against an immutable strategy version and a versioned parameter-set/search-space manifest; each trial produces traceable candidate parameter-set values.
- Separate development and validation data and computation.
- Provide a job queue, worker limits, cancellation, reproducible seeds, and search-space manifests.
- Support Pareto optimization across return, drawdown, stability, and turnover.
- Display overfit warnings and maintain a champion/challenger registry.
- Prohibit automatic production promotion.

**Exit gate:**

- A repeated search reproduces every trial.
- Validation data does not influence parameter selection.
- The UI exposes all attempted trials, not only winners.

### Phase 10 — Meta-strategy and portfolio engine

**Objective:** Combine strategy intents deterministically and reconcile portfolio economics.

**Required work:**

- Normalize intents and resolve contradictions using explicit priority rules.
- Combine strategies by vote, score, risk contribution, or fixed allocation.
- Calculate concurrent and rolling correlations.
- Enforce instrument and fleet exposure limits and prevent duplicate economic exposure.
- Backtest the exact chronological combined portfolio.
- Attribute performance by strategy, instrument, session, and account.
- Simulate one-account-at-a-time routing.

**Exit gate:**

- Portfolio P&L reconciles to constituent executions.
- Input ordering does not change results unless an explicit priority requires it.
- Duplicate signals cannot create duplicate positions.
- Meta-strategies reference only immutable strategy and parameter-set versions; mutable aliases such as `latest` are forbidden.

### Phase 11 — Prop-firm rule engine and lifecycle simulator

**Objective:** Model the complete economic and rule lifecycle using effective-dated evidence.

**Every rule pack must encode:** evaluation/reset/activation/monthly fees; profit target; daily loss; static or trailing drawdown; intraday or end-of-day updates; minimum/maximum trading days; contract limits/scaling; consistency rules; news/overnight/weekend restrictions; payout threshold/buffer/split/cap/cadence; maximum accounts; automation/copying restrictions; source evidence; and effective date.

**Required work:**

- Build the validated rule-pack editor.
- Simulate evaluation-to-funded progression, resets, repurchases, payouts, fees, and cash flow.
- Run correlated fleet, rule-change, and routing-policy simulations.
- Report expected value per purchased evaluation; pass, first-payout, and breach probabilities; expected time/cash to payout; confidence intervals; and worst-case scenarios.

**Exit gate:**

- Hand-worked firm examples reconcile exactly.
- Every decision traces to an exact rule version.
- Unknown or contradictory rules block simulation promotion.
- A strategy cannot be labeled prop-viable unless conservative expected net value is positive.

### Phase 12 — NinjaTrader observation bridge and account import

**Objective:** Observe and reconcile NinjaTrader state without order-submission capability.

**Required work:**

- Build the C# AddOn using supported NinjaTrader account APIs.
- Discover accounts and publish masked account identifiers.
- Subscribe to account, order, execution, position, price-connection, and order-connection updates.
- Maintain a durable file outbox with sequence numbers, HMAC, and idempotency keys.
- Keep NinjaTrader callbacks non-blocking.
- Import historical executions.
- Map accounts to firm, plan, stage, and rule pack through the UI.
- Store no brokerage passwords.
- Maintain local fill-derived state because provider account values may vary.

**Exit gate:**

- Connected Sim101 events reconcile exactly.
- Restarting either side loses no events.
- Duplicated events are harmless.
- The adapter contains no order-submission code.

### Phase 13 — Risk kernel

**Objective:** Make pre-trade authorization and continuous containment deterministic, testable, and independent of strategy code.

**Required pre-entry checks:**

- Account is connected, verified, fresh, permitted, and not leased elsewhere.
- Price and order feeds are healthy and fresh.
- Firm rules are current and unambiguous.
- No unresolved order or position exists.
- Instrument, quantity, trading window, news, overnight, and weekend rules permit entry.
- Worst-case loss fits daily and total drawdown after conservative buffers.
- Fleet exposure and correlation limits permit entry.
- The deployment is active, approved, and healthy.
- Global and account kill switches are clear.

**Independent runtime guards:** unprotected position, P&L mismatch, drawdown proximity, stale data, excess latency, repeated rejection, clock drift, disk pressure, process/service health, and contract rollover.

**Exit gate:**

- Property-based tests show that risk logic can only preserve, reduce, or reject requested exposure.
- Mutation tests cannot remove a required check without failure.
- Boundary values have exact tests.
- Core risk branch coverage is at least 95%.

### Phase 14 — Shadow master router

**Objective:** Prove deterministic, single-account selection without sending orders.

**Required work:**

- Filter eligible accounts and calculate worst-case post-trade state.
- Rank accounts with a versioned deterministic policy.
- Atomically acquire one account lease and reserve risk.
- Record the selected account and every rejection reason.
- Hold the lease until confirmed flat, then reconcile and release it.
- Simulate alternative routing policies.
- Send no order during this phase.

**Default ranking:**

1. Accounts closest to an operational deadline without violating risk.
2. Funded accounts with adequate payout and drawdown buffer.
3. Evaluation accounts by marginal probability of passing.
4. Remaining eligible accounts by longest time since last trade.
5. Stable account ID as the deterministic final tie-breaker.

**Exit gate:**

- Ten million simulated concurrent routing attempts produce no double lease.
- Every signal selects zero or one account.
- Chronological replay is deterministic.
- Shadow decisions reconcile with the prop simulator.

### Phase 15 — Simulated order execution

**Objective:** Validate the complete order path using only dedicated simulation accounts.

**Required work:**

- Add create, submit, change, and cancel operations to the NinjaTrader AddOn.
- Support broker-compatible OCO brackets.
- Publish every order and execution transition.
- Enforce idempotent command IDs.
- Handle partial entry/exit fills, rejections, and cancel/replace races.
- Implement emergency cancel and flatten.
- Reconcile on startup and reconnection.
- Permit only Sim101 and dedicated simulation accounts.

**Exit gate:**

- Restart and retry campaigns produce zero duplicate orders.
- Every simulated position reconciles.
- Protective-order deadlines are met.
- Unknown state always quarantines.
- Evaluation and funded accounts cannot be selected.

### Phase 16 — Deployment manager

**Objective:** Control evidence-based promotion of immutable strategy releases.

**Required work:**

- Begin deployment selection from a validated Strategy Library entry only.
- Build the deployment creation wizard.
- Attach immutable strategy, parameter, dataset, rule, and evidence hashes.
- Attach the approved risk envelope and account-pool selection.
- Enforce checklists, independent approvals, and promotion states.
- Support scheduled start/stop windows, audited rollback to paused, and version history.
- Prohibit mutable `latest` strategy references.

**Exit gate:**

- A deployment can be recreated from its manifest.
- A one-byte change produces a new version.
- Rollback preserves all audit history.
- Failed gates prevent promotion.

### Phase 17 — Operations, recovery, and AI supervision

**Objective:** Maintain deterministic safety and recovery while using AI only as a read-only investigative aid.

**Deterministic supervisor duties:** watchdogs, heartbeats, bounded reconnects, feed freshness, disk/database health, backup verification, reconciliation, kill switches, and alerts.

**Permitted AI duties:** summarize incidents; correlate log events; rank likely causes; compare prior failures; recommend tests or operator actions; create daily operational reports; and flag unusual error patterns for human review.

AI may also analyze a strategy or propose code and parameter changes. Every proposal is recorded as externally authored, becomes an untrusted draft fork in the Strategy Library, and must pass the same import, test, backtest, validation, comparison, approval, and promotion lifecycle as any other change. AI cannot save over an immutable version or advance a proposal through a gate.

**AI schedule:** immediately for a new incident; every 60 seconds while active; at session close; and after deployment or rule changes.

**Exit gate:**

- AI exposes no callable order, risk, rule, account-state, or deployment-changing interface.
- Redaction tests remove credentials and account secrets.
- Disabling AI has no effect on trading safety.
- Deterministic monitoring remains functional without internet access.

### Phase 18 — Chaos, security, and release certification

**Objective:** Demonstrate safe, deterministic behavior under failure before forward-paper operation.

**Mandatory scenarios:** price-feed loss; order-server loss; NinjaTrader, control-service, UI, or worker crash; machine restart; duplicate, delayed, or out-of-order command/event; partial fill; rejected protective stop; cancel/fill race; broker/local position mismatch in either direction; P&L disagreement; stale prop rule; day/session/DST/contract rollover; exchange halt; clock drift; disk full; corrupt database copy; invalid import; and multiple QuantBench instances.

**Exit gate:**

- No scenario can create an unprotected or duplicate position without a P0 alert and deterministic emergency response.
- Backup restoration succeeds.
- The threat model is reviewed again.
- Penetration, dependency, and release scans pass.
- A signed release candidate completes a seven-day simulation soak.

### Phase 19 — Forward-paper certification

**Objective:** Validate production-equivalent behavior with live data and simulated execution under a preregistered test.

**Required operation:**

- Run the complete system with the exact strategies, routing, costs, risk envelopes, and rule packs proposed for the pilot.
- Make no parameter changes during the registered test.
- Reconcile every signal, route, order, fill, and account calculation daily.
- Compare modeled and observed slippage and latency.
- Record downtime and missed opportunities.
- Change economic assumptions only through a new versioned experiment.

**Exit gate:**

- The predefined minimum sample is reached.
- No unresolved P0/P1 incident or unexplained reconciliation mismatch remains.
- Observed costs remain within certified assumptions.
- Conservative prop-level expected value remains positive.
- The risk committee record approves an evaluation pilot.

### Phase 20 — Single evaluation-account pilot

**Objective:** Prove controlled operation on one evaluation account at minimum permitted size.

**Required controls:** one account; minimum permitted size; additional drawdown buffer; no automatic purchase/reset; immediate order and incident alerts; daily reconciliation; automatic pause on unknown state; and no unattended resumption.

**Exit gate:**

- No system-caused rule violation occurs.
- Account calculations reconcile with the firm.
- Routing and protective orders perform correctly.
- The pilot meets preregistered operational and economic criteria.

### Phase 21 — Funded pilot and fleet rollout

**Objective:** Expand only after demonstrated safety, reconciliation, and payout economics.

**Fixed sequence:**

1. One funded account.
2. First eligible payout.
3. Successful post-payout reconciliation.
4. Two-account sequential fleet.
5. Five-account sequential fleet.
6. Any larger fleet only after a new certification review.

**Controls at every level:**

- One trade is routed to one account.
- Account selection remains deterministic and versioned.
- Fleet size is capped by conservative cash-flow simulation.
- A firm-rule change automatically suspends affected accounts.
- Material strategy drift blocks further expansion.
- Each expansion level has its own acceptance record and approval.

## 10. Fixed implementation sequence

```text
Charter
-> Engineering foundation
-> Event ledger
-> Desktop shell
-> Data Vault
-> Strategy SDK, Library, and import validation
-> Backtester and one-click orchestration
-> Execution realism
-> Research governance
-> Optimization
-> Meta engine
-> Prop simulator
-> NinjaTrader observation
-> Risk kernel
-> Shadow router
-> Simulated execution
-> Deployment manager
-> Monitoring and AI
-> Chaos certification
-> Forward paper
-> Evaluation pilot
-> Funded rollout
```

The trading adapter, strategy runtime, risk kernel, and account router must not be implemented early. The only authorized implementation starting point is Phase 0.

## 11. Performance release gates

All measurements use the Phase 0 reference workstation, versioned fixtures, declared workload shape, warm/cold-state rules, and reproducible benchmark scripts.

| Capability | Required threshold |
|---|---|
| UI interaction response | Under 100 ms p95 |
| Normal dashboard API response | Under 250 ms p95 |
| Ordinary filtered historical analytics query | Under 1 second p95 |
| Local pre-trade risk and routing decision | Under 50 ms p99 |
| Control-service-to-bridge acknowledgement | Under 250 ms p99, excluding broker latency |
| Restart and reconciliation | Under 30 seconds for 100 accounts and 10,000 active-day order events |
| Baseline event-driven backtest | At least 5 million bar-events per minute per worker |
| Service outage durability | No data loss over 24 hours when sufficient disk is available |
| Import and backtest memory | Memory-bounded; full dataset residency in RAM is not required |

These thresholds are release gates, not aspirational targets. Benchmark methodology may be clarified during Phase 0, but a threshold may change only through approved change control.

## 12. Security, privacy, and compliance principles

- Store no brokerage passwords.
- Store supported local secrets only through Windows Credential Manager and DPAPI.
- Mask account identifiers outside authorized operational views and redact them from AI inputs.
- Authenticate and sequence inter-process messages; reject replays, conflicts, and invalid identities.
- Apply least privilege to every process and contract.
- Treat all pasted, imported, externally generated, and AI-authored strategy code as untrusted input.
- Prevent strategy imports from using network access, arbitrary filesystem access, subprocesses, dynamic installers, credentials, environment secrets, or broker APIs.
- Keep the live order and risk path locally operable without internet or AI.
- Preserve source evidence and effective dates for every external rule used in a decision.
- Prohibit scraping, credential capture, or evasion of broker, exchange, or prop-firm policies.
- Treat releases, strategy packages, rules, deployments, audit events, and acceptance evidence as immutable, content-addressed artifacts where applicable.
- Document retention, backup, restore, export, and secure-deletion requirements during Phase 0.

## 13. Observability and incident policy

- Logs are structured JSONL and participate in trace/correlation context.
- Metrics, traces, events, commands, operator actions, and incident records must support a single chronological investigation.
- P0–P3 definitions, paging/notification expectations, owners, and response times are established in Phase 0.
- P0 and P1 incidents block phase acceptance and live promotion until resolved and reviewed.
- Unknown broker state, a missing protective order, duplicate exposure, or an unexplained reconciliation difference must be treated as safety-critical.
- Automated recovery must be bounded. Exhausted or ambiguous recovery ends in pause or quarantine, never optimistic continuation.
- AI conclusions are advisory, attributable, redactable, and stored separately from authoritative system state.

## 14. Testing and evidence strategy

The test program must cover:

- Unit tests for deterministic business and numerical rules.
- Property-based tests for risk monotonicity, identity, idempotency, leases, and state-machine invariants.
- Mutation tests for safety-critical branches.
- Contract/schema compatibility tests across process and release boundaries.
- Adversarial strategy-import tests covering every forbidden capability and a clean import of each supported format.
- Parameter-versioning tests proving that edits cannot mutate completed runs or active deployments.
- Integration tests for database, API, event, outbox, and process behavior.
- Replay tests from immutable event logs and datasets.
- Golden, hand-calculated financial and execution fixtures.
- Differential tests between reference and optimized implementations.
- UI accessibility and failure-state tests.
- Performance and memory benchmarks on reference hardware.
- Chaos and restart tests at every relevant transaction boundary.
- Security, secret, dependency, license, penetration, and artifact-signature checks.
- Acceptance tests mapped to stable requirement IDs.

Evidence must identify the exact code version, configuration, schema versions, data hashes, strategy hashes, rule hashes, seed, clock model, fill model, fee model, environment, and test result.

## 15. Roles and approvals

Required accountable roles, even when one person temporarily fills more than one:

- Product owner.
- Program manager.
- Technical architect.
- Quant research lead.
- Execution/NinjaTrader engineer.
- Risk engineer.
- Data engineer.
- Frontend engineer.
- QA/automation engineer.
- Security/SRE reviewer.

Live execution and material risk changes require two independent approvals. The author of a material risk change cannot be its sole approver. Phase 0 must define the approval matrix, separation-of-duties exceptions for a small team, and which exceptions still prohibit live operation.

## 16. Change control

Any change to scope, architecture, safety invariants, phase order, gates, thresholds, supported firms/instruments, or live behavior requires:

1. A uniquely identified change request.
2. The motivation and proposed exact wording or design change.
3. Impact analysis covering architecture, data, safety, security, operations, economics, compliance, schedule, and compatibility.
4. Updates to the threat model and risk register.
5. An updated verification and regression test plan.
6. Independent review and required approvals.
7. A new version of affected specifications and this plan where applicable.
8. A recorded effective point and migration or rollback strategy.

Until approval is complete, the existing plan remains authoritative. Emergency containment may reduce exposure, pause, quarantine, cancel, or flatten according to preapproved procedures; it may not weaken a gate or authorize new live behavior.

## 17. Required planning artifacts

The following are deliverables of later phases and are not created merely by adopting this plan:

- Product charter and Version 1 product requirements.
- Terminology and financial-calculation specification.
- Prop-firm source archive and effective-dated rule packs.
- Threat model, master risk register, and security plan.
- Requirements-to-acceptance traceability matrix.
- Reference-workstation and benchmark specification.
- Data retention, backup, restore, and incident policies.
- Architecture decision records.
- API, event, strategy SDK, and storage specifications.
- Visual design-system specification and protected-control interaction rules.
- Downloadable AI Strategy Authoring Specification and `.qbs` package specification.
- Release, incident, phase-acceptance, and change-request templates.
- Operations, reconciliation, quarantine, emergency cancel/flatten, backup, and recovery runbooks.
- Research, economic, forward-paper, evaluation-pilot, and funded-pilot protocols.

Each artifact must have an owner, version, approval status, and links to the requirements and evidence it governs.

## 18. Current project state and next authorized work

At adoption of Version 1.1:

- Product implementation status: not started.
- Current delivery phase: Phase 0.
- Operational trading authority: none.
- Certified strategies, datasets, rule packs, deployments, accounts, builds, or releases: none.
- Next authorized work: Phase 0 documentation, source collection, definitions, risk analysis, requirements, and acceptance planning only.

No operational software, NinjaTrader adapter, strategy engine, backtester, router, risk kernel, or order path should be created until its prerequisite phases and signed gates are complete.
