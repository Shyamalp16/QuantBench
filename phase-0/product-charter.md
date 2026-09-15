# Product Charter and Approval Boundary

| Field | Value |
|---|---|
| Document version | 1.0.0 |
| Owner | Product owner — Shyamal Patel |
| Approval status | Approved |
| Source | `PLAN.md` sections 1–7, 10–18 |

## Charter

QuantBench is a greenfield Windows 11 quantitative research and controlled futures-execution workstation. Version 1 supports NinjaTrader 8 and CME NQ, MNQ, ES, and MES. It provides reproducible data, strategy, backtest, portfolio, prop-firm, deployment, routing, risk, execution, monitoring, audit, and recovery workflows while keeping the live safety and order path local.

The product is not an HFT system, does not automate purchases, resets, or payouts, does not scrape authenticated firm portals, and does not copy one trade to multiple accounts. AI is advisory and untrusted: it has no authority over orders, risk, rules, accounts, or deployment promotion.

## Version 1 firm and plan scope

The initial documentation-only rule-pack scope is fixed to:

1. Lucid Trading — LucidFlex 25K evaluation and corresponding funded lifecycle, including DLL-on and DLL-off purchase variants.
2. Lucid Trading — LucidDaily 25K evaluation and corresponding funded lifecycle, including DLL-on/off and evaluation EOD/intraday drawdown variants.
3. Tradeify — Select 25K evaluation and both permanent funded choices: Select Flex and Select Daily.
4. Tradeify — Growth 25K evaluation and corresponding funded lifecycle.

Adding a firm, plan family, or account size requires change control. A promotional price does not create a new plan, but any rule-changing promotion is a separately effective-dated rule version.

## Success criteria

- Research results are reproducible from immutable strategy, parameter, dataset, seed, and execution-assumption versions.
- No strategy, UI, or AI component can communicate directly with NinjaTrader or bypass deterministic risk and promotion gates.
- Every order intent selects zero or one eligible account, and uncertainty results in rejection, pause, or quarantine.
- Every firm decision cites an effective-dated rule version and source evidence.
- Every state change is auditable and replayable.
- No live authority exists until all prerequisite phases, independent approvals, certifications, and pilot gates pass.

## Stakeholders and accountable roles

Shyamal Patel temporarily fills Product Owner, Program Manager, Technical Architect, Quant Research Lead, Execution/NinjaTrader Engineer, Risk Engineer, Data Engineer, Frontend Engineer, QA/Automation Engineer, and Security/SRE Reviewer for Phase 0 and Phase 1.

This small-team exception is valid only for pre-live documentation and engineering foundation work. It does not satisfy independent approval for live execution, a material risk change, a deployment promotion beyond forward paper, or a production signing decision.

## Approval matrix

| Decision | Author | Required approver | Independence | Result without approval |
|---|---|---|---|---|
| Phase 0 documentation | Assigned owner | Product owner | Not required pre-live | Phase 1 blocked |
| Phase 1 foundation | Assigned owner | Product owner | Not required pre-live | Phase 2 blocked |
| Architecture, invariant, phase, or threshold change | Technical architect | Product owner and Security/Risk reviewer | One independent reviewer required | Existing plan remains authoritative |
| Material risk-rule change | Risk engineer | Product owner and independent Risk/Security reviewer | Mandatory | Change rejected |
| Live-capable release | Release author | Product owner and independent Security/Risk reviewer | Mandatory | Release cannot be signed or promoted |
| Deployment promotion to evaluation, funded, or live | Deployment owner | Product owner and independent Risk reviewer | Mandatory | Deployment remains at prior state |
| Emergency containment | On-call operator | Preapproved policy; retrospective review | Retrospective independence required | Only reduce/pause/quarantine/cancel/flatten actions allowed |

## Legal and compliance boundary

- QuantBench records firm rules and technical controls; it does not provide legal, tax, investment, or regulatory advice.
- Only first-party public materials, user-provided agreements, and written firm confirmations may authorize automation.
- Conflicting, missing, stale, or account-inapplicable evidence blocks affected deployment.
- No credential scraping, authenticated portal automation, geographic evasion, policy evasion, or trading for another person is permitted.
- The operator remains responsible for firm agreements, exchange rules, market-data licensing, tax obligations, and broker eligibility.

## Release authority

Operational trading authority is **none**. The Phase 0 and Phase 1 tags certify documentation and engineering controls only. They do not certify a strategy, dataset, account, rule pack, build, deployment, risk model, order path, or live operation.

