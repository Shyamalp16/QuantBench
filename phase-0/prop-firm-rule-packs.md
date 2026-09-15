# Initial Prop-Firm Rule Packs

| Field | Value |
|---|---|
| Document version | 1.0.0 |
| Owner | Risk engineer — Shyamal Patel |
| Approval status | Approved |
| Nature | Governance evidence only; not a runtime schema |
| Observation date | 2026-09-15 |

All amounts are USD. `Observed` means the rule appeared in an official public source on the observation date. It does not establish the contractual effective date for a purchased account. `DEPLOYMENT_BLOCKING` means QuantBench must not route an order to the affected plan or lifecycle stage.

## LucidFlex 25K

| Rule ID | Stage | Observed rule | Evidence | Effective date | Status |
|---|---|---|---|---|---|
| PF-LF25-001 | Evaluation | Starting balance $25,000; profit target $1,250; maximum loss limit $1,000; maximum size 2 minis or 20 micros. | LUCID-001 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-002 | Evaluation | Consistency must be 50% or less. | LUCID-001 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-003 | Evaluation/Funded | End-of-day trailing drawdown; initial trail balance $26,100; locked floor $25,100. A payout also moves the floor to the locked balance. | LUCID-003 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-004 | Evaluation/Funded | DLL is selected on or off at purchase and applies to both stages; it cannot be changed for the active account. | LUCID-005 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-005 | Evaluation/Funded | The exact 25K DLL amount is absent from the archived customization source. | LUCID-005 | Not established | DEPLOYMENT_BLOCKING — missing value |
| PF-LF25-006 | Funded | Simulated funded account; no consistency requirement; scaling applies; stated maximum 2 minis or 20 micros. | LUCID-002 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-007 | Funded/Payout | Five separate $100-or-greater profit days per payout cycle and positive net cycle profit are required. | LUCID-004 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-008 | Funded/Payout | 90% trader split; $500 minimum; up to 50% of profit capped at $1,000; maximum five payouts before live transition; no fixed payout window or balance buffer. | LUCID-004 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-009 | Trading | News trading is described as allowed on Flex, subject to slippage and all other rules. | LUCID-012 | Not established | DEPLOYMENT_BLOCKING |
| PF-LF25-010 | Automation | Public help says automated strategies and trade copiers are permitted, while a published agreement for another Lucid plan requires prior written approval. The exact Flex agreement and written authorization are missing. | LUCID-012, LUCID-014 | Not established | DEPLOYMENT_BLOCKING — contractual conflict |

## LucidDaily 25K

| Rule ID | Stage | Observed rule | Evidence | Effective date | Status |
|---|---|---|---|---|---|
| PF-LD25-001 | Evaluation | Starting balance $25,000; profit target $1,250; maximum loss limit $1,000; maximum size 2 minis or 20 micros. | LUCID-006 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-002 | Evaluation | Consistency must be 50% or less. | LUCID-006 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-003 | Evaluation | At purchase, drawdown is selected as EOD or intraday. DLL is independently selected on or off, creating four configurations. | LUCID-008, LUCID-010 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-004 | Evaluation/Funded | When enabled, the fixed DLL is $600, is a soft lock, and resets at the firm-defined session boundary. | LUCID-009 | Not established | DEPLOYMENT_BLOCKING — reset boundary unverified |
| PF-LD25-005 | Evaluation/Funded | Maximum loss is $1,000; initial trail balance $26,100; locked floor $25,100. | LUCID-008 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-006 | Funded | Funded drawdown is always intraday; maximum size is 2 minis or 20 micros; no consistency rule. | LUCID-007, LUCID-008 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-007 | Funded/News | For USD high-impact red-folder news, the account must be flat from one minute before through one minute after; violation is a hard breach. Event-source identity and timestamp precedence are unspecified. | LUCID-007, LUCID-012 | Not established | DEPLOYMENT_BLOCKING — calendar semantics missing |
| PF-LD25-008 | Funded/Payout | 90% trader split; balance must exceed $26,100 buffer; positive profit since prior payout; $500 minimum; maximum is eligible profit above buffer. | LUCID-011 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-009 | Funded/Live | Earning $6,000 in one day is described as a live-transition trigger, but transition/review semantics and open-order handling are not authoritative. | LUCID-011 | Not established | DEPLOYMENT_BLOCKING |
| PF-LD25-010 | Automation | Public help permits automated strategies, but the exact Daily agreement and plan-specific written authorization are missing. | LUCID-012, LUCID-013, LUCID-014 | Not established | DEPLOYMENT_BLOCKING — contractual evidence missing |

## Tradeify Select 25K

| Rule ID | Stage | Observed rule | Evidence | Effective date | Status |
|---|---|---|---|---|---|
| PF-TS25-001 | Evaluation | Starting balance $25,000; target $1,500; EOD trailing maximum drawdown $1,000; no DLL. | TRADEIFY-001 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-002 | Evaluation | 40% consistency, with a paid 50% consistency option; minimum days follow from the selected consistency threshold. | TRADEIFY-001, TRADEIFY-007 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-003 | Evaluation | One official page reports 1 mini/10 micros while another current official page describes evaluation access as 2 minis/20 micros. | TRADEIFY-001, TRADEIFY-002 | Not established | DEPLOYMENT_BLOCKING — contradictory contract limit |
| PF-TS25-004 | Transition | After passing, the operator permanently chooses Select Flex or Select Daily for that account. | TRADEIFY-001, TRADEIFY-002, TRADEIFY-009 | Not established | DEPLOYMENT_BLOCKING |
| PF-TS25-005 | Select Flex | EOD maximum drawdown $1,000; no DLL or consistency; starts at 1 mini/10 micros and scales to 2 minis/20 micros. | TRADEIFY-002 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-006 | Select Flex/Payout | Five $100 winning days; positive cycle profit; 90% trader split; $250 minimum; up to 50% of total profit capped at $1,250; no minimum balance requirement. | TRADEIFY-002 | 2026-09-01 for current cap | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-007 | Select Daily | EOD maximum drawdown $1,000; $500 DLL; $1,100 buffer; no consistency; same scaling as Select Flex. | TRADEIFY-002, TRADEIFY-006 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-008 | Select Daily/Payout | Positive new cycle profit; request up to twice new profit, capped at $600; $250 minimum; 90% trader split; remaining balance must stay above buffer. | TRADEIFY-002 | 2026-09-01 for current cap | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-009 | Funded | Drawdown locks at $25,100 when EOD balance exceeds $26,100 or on payout, whichever occurs first. | TRADEIFY-002, TRADEIFY-005 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TS25-010 | Automation | Bots require sole ownership/proof and live demonstration. Published guidance appears to prohibit using the bot across multiple firms. Exact applicability to sequential routing between Lucid and Tradeify requires written confirmation. | TRADEIFY-008, TRADEIFY-009 | 2026-08-12 guidance; agreement date unknown | DEPLOYMENT_BLOCKING — written approval required |

## Tradeify Growth 25K

| Rule ID | Stage | Observed rule | Evidence | Effective date | Status |
|---|---|---|---|---|---|
| PF-TG25-001 | Evaluation | Starting balance $25,000; target $1,500; $600 soft DLL; $1,000 EOD trailing drawdown; maximum 1 mini/10 micros. | TRADEIFY-003 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TG25-002 | Evaluation | No consistency rule and possible one-day pass. | TRADEIFY-003 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TG25-003 | Funded | $1,000 maximum loss, $600 DLL, and 35% consistency are reported for the current 25K structure. | TRADEIFY-004, TRADEIFY-006 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TG25-004 | Funded/Payout | Minimum eligible balance $26,500; five $100 winning days; $250 minimum payout; $1,000 request cap; 90% trader split. | TRADEIFY-004 | Current purchase rule observed 2026-09-15 | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TG25-005 | Funded | Drawdown locks at $25,100 after balance reaches the rule-defined trigger or on payout. Exact intraday/EOD enforcement precedence requires account-specific confirmation. | TRADEIFY-005 | Not established | DEPLOYMENT_BLOCKING — snapshot unavailable |
| PF-TG25-006 | Automation | Same sole-owner, proof, demonstration, and apparent cross-firm restrictions as other Tradeify plans. | TRADEIFY-008, TRADEIFY-009 | 2026-08-12 guidance; agreement date unknown | DEPLOYMENT_BLOCKING — written approval required |

## Evidence required to unblock deployment

1. Obtain the exact LucidFlex and LucidDaily evaluation and funded agreements applicable to the account purchase date.
2. Obtain written Lucid authorization for QuantBench automation and clarify whether it covers evaluation, simulated funded, and live stages.
3. Obtain written Tradeify confirmation that owner-authored QuantBench automation is permitted and whether the same software/strategy may ever be used with another firm, even sequentially.
4. Capture complete Tradeify help-center snapshots and reconcile the Select evaluation contract-limit contradiction.
5. Establish effective-from and superseded-at timestamps for every rule version, plus firm trading-day/DST/holiday definitions.
6. Verify fees, resets, activation, data/platform fees, maximum account counts, copy/hedging/correlated-product rules, news restrictions, overnight/weekend rules, commissions, and live-transition behavior for each selected plan.

Until all six items are resolved, these rule packs support research annotation only and cannot authorize evaluation, funded, or live deployment.

