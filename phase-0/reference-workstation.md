# Reference Workstation and Benchmark Method

| Field | Value |
|---|---|
| Specification version | 1.0.0 |
| Owner | QA/Automation engineer — Shyamal Patel |
| Approval status | Approved |
| Captured | 2026-09-15 |

## Hardware and operating system

| Component | Baseline |
|---|---|
| Manufacturer/model | ASUSTeK ASUS TUF Gaming F15 FX507VV |
| OS | Microsoft Windows 11 Home, 64-bit, version 10.0.26200, build 26200 |
| CPU | Intel Core i7-13620H, 10 physical cores, 16 logical processors |
| Memory | 15.6 GiB reported usable physical memory |
| Integrated GPU | Intel UHD Graphics, driver 32.0.101.6790 |
| Discrete GPU | NVIDIA GeForce RTX 4060 Laptop GPU, driver 32.0.16.1692 |
| Workspace volume | D:, NTFS, 683.6 GiB total, 302.5 GiB free at capture |
| Power/network | Must be recorded per benchmark run |

GPU adapter-memory values reported through WMI are not treated as authoritative; benchmarks that use GPU memory must capture it through an approved vendor tool. QuantBench Version 1 has no GPU performance dependency unless a later approved benchmark establishes one.

## Controlled run conditions

- AC power connected; Windows power mode set to Best performance and recorded.
- Machine temperature stabilized for ten minutes; no OS update, antivirus full scan, game, or unrelated build in progress.
- Record OS build, BIOS, CPU/GPU driver, storage free space, power mode, toolchain versions, source commit, configuration, and fixture hashes.
- Synchronize system time and record UTC offset, drift source, and monotonic-clock availability.
- Pin benchmark process priority/affinity only when the benchmark specification explicitly requires it; otherwise use normal defaults.
- Keep at least 20% workspace free and record thermal throttling or memory pressure.

## Measurement method

- Cold run: new process with relevant application caches cleared by the benchmark harness; OS disk cache is not claimed cleared unless the method proves it.
- Warm run: at least one untimed warm-up followed by measured runs using identical immutable input.
- Latency gates: minimum 30 cold and 100 warm samples; report p50, p95, p99, maximum, and confidence interval where meaningful.
- Throughput gates: five one-minute measured intervals after warm-up; report events/minute for each interval and the median.
- Restart/reconciliation: five cold process restarts against the fixed 100-account/10,000-event fixture; all must remain below the gate.
- Memory: record baseline, peak working set, committed bytes, and input size; reject unbounded growth across scaled fixtures.
- Compare only runs with matching workload, configuration, data hash, clock model, and toolchain major versions.

## Locked release thresholds

| Benchmark ID | Capability | Gate |
|---|---|---|
| PERF-001 | UI interaction response | Under 100 ms p95 |
| PERF-002 | Normal dashboard API response | Under 250 ms p95 |
| PERF-003 | Filtered historical analytics query | Under 1 second p95 |
| PERF-004 | Local pre-trade risk and routing decision | Under 50 ms p99 |
| PERF-005 | Control-service-to-bridge acknowledgment | Under 250 ms p99 excluding broker latency |
| PERF-006 | Restart and reconciliation | Under 30 seconds for 100 accounts and 10,000 active-day order events |
| PERF-007 | Baseline event-driven backtest | At least 5 million bar-events/minute/worker |
| PERF-008 | Service outage durability | No data loss over 24 hours when sufficient disk exists |
| PERF-009 | Import/backtest memory | Memory-bounded; full dataset residency is not required |

Phase 0 records the machine and method. Later phases provide versioned fixtures and executable benchmark harnesses before the corresponding threshold can be accepted.

