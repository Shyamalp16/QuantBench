# Safety-Critical Terminology and Calculations

| Field | Value |
|---|---|
| Document version | 1.0.0 |
| Owner | Risk engineer — Shyamal Patel |
| Approval status | Approved |
| Source | `PLAN.md` sections 5–6, 11–14 and firm sources in `evidence/source-manifest.csv` |

Unless a firm rule explicitly defines otherwise, calculations use exact decimal arithmetic in USD, exchange timestamps normalized to UTC, and the declared CME trading session. Display rounding never changes risk decisions.

## Core financial terms

| ID | Term | Definition |
|---|---|---|
| QB-TERM-001 | Account balance | Firm- or broker-reported settled/realized account value, excluding open-position unrealized P&L unless the applicable rule explicitly includes it. |
| QB-TERM-002 | Account equity | Account balance plus marked-to-market unrealized P&L and any explicitly included fees or adjustments. The price source and timestamp are part of the value. |
| QB-TERM-003 | Realized P&L | Sum of matched closing execution proceeds less opening cost basis, commissions, exchange, routing, and other applicable realized fees. |
| QB-TERM-004 | Unrealized P&L | Mark-to-market value of open positions using the current certified price snapshot, contract multiplier, side, quantity, and average entry price, net of estimated exit costs when used for risk. |
| QB-TERM-005 | Net liquidation value | Equity after accrued fees and conservative estimated costs to close all open positions. It is not assumed equal to a firm dashboard field. |
| QB-TERM-006 | Daily P&L | Realized P&L plus rule-applicable unrealized P&L and fees between the rule pack’s session reset boundaries. |
| QB-TERM-007 | High-water mark | Maximum rule-defined balance or equity observed at the rule-defined sampling points, never inferred from UI display alone. |
| QB-TERM-008 | Maximum loss limit | The rule-defined loss floor whose touch or breach produces a hard breach or other specified outcome. |
| QB-TERM-009 | Trailing floor | `high_water_mark - trailing_drawdown_amount`, capped or locked exactly as the effective rule pack specifies. |
| QB-TERM-010 | Daily loss limit | The rule-defined daily loss threshold and reset behavior. A soft DLL blocks trading until reset; a hard DLL terminates the account only when the rule states that outcome. |
| QB-TERM-011 | Safety buffer | Additional conservative amount reserved for slippage, fees, price movement, liquidation latency, and model uncertainty; it reduces usable risk and never increases it. |
| QB-TERM-012 | Remaining loss capacity | `max(0, governing_floor_distance - safety_buffer - reserved_risk)`, evaluated using the most conservative applicable account value. |
| QB-TERM-013 | Worst-case trade loss | Stop-distance loss plus entry/exit slippage, commissions, fees, gap allowance, partial-fill exposure, and protective-order uncertainty. |
| QB-TERM-014 | Profit target | Minimum rule-defined cumulative profit required for lifecycle eligibility; reaching it does not imply promotion until all other conditions pass. |
| QB-TERM-015 | Consistency percentage | `largest_eligible_day_profit / eligible_cumulative_profit × 100`; nonpositive denominators produce “not eligible,” not zero. |
| QB-TERM-016 | Payout buffer | Rule-defined balance/equity that must remain after payout. It is separate from the trading safety buffer. |
| QB-TERM-017 | Payout-eligible amount | Minimum of rule cap, rule formula, positive cycle profit, and amount above any required buffer, after fees and pending withdrawals. Negative values clamp to zero. |
| QB-TERM-018 | Trading day | The firm-defined session bucket, not a civil calendar day. Until verified, use no default and block firm-dependent calculations. |
| QB-TERM-019 | Daily reset | Effective boundary at which daily counters and soft locks reset. DST, holiday, and exchange-session handling must be explicit in the rule version. |
| QB-TERM-020 | Breach | Rule-authoritative terminal violation. A suspected or locally calculated breach is quarantined until reconciled; it is never silently reversed. |

## Lifecycle terms

| ID | Term | Definition |
|---|---|---|
| QB-TERM-021 | Verified account | Account identity, connection, firm, plan, stage, rule version, and balances have been reconciled with acceptable evidence. |
| QB-TERM-022 | Suspended | No new entry is allowed; state is known and can be reviewed. |
| QB-TERM-023 | Quarantined | State is unknown, contradictory, stale, or unreconciled; automatic resumption is prohibited. |
| QB-TERM-024 | Account lease | Exclusive, time-bounded, auditable ownership of an account by one routing decision until confirmed flat and reconciled. |
| QB-TERM-025 | Risk reservation | Atomic allocation of worst-case loss capacity before order submission. |
| QB-TERM-026 | Trade intent | Broker-independent, normalized request emitted by an immutable strategy package; it has no authority to choose an account or submit an order. |
| QB-TERM-027 | Rule version | Immutable set of firm rules with source evidence, effective interval, retrieval time, and ambiguity status. |
| QB-TERM-028 | Stale rule | Rule whose review-by date passed, source disappeared, source changed without review, or account agreement version is unknown. |

## Conservative precedence

When local, broker, and firm values disagree, QuantBench uses the value that allows the least additional exposure while quarantining the account for reconciliation. A missing price, clock, connection, rule, order, execution, position, or account snapshot makes dependent pre-trade calculations invalid and rejects entry.

## Open calculation questions

The exact firm-specific trading-day boundaries, price marks, commission treatment, trailing-floor sampling, post-payout floor behavior, and live-transition rules are defined only by the effective rule pack. Any unanswered item is tagged `DEPLOYMENT_BLOCKING`; no generic definition above resolves it optimistically.

