# Mutation Testing Policy

| Ecosystem | Runner | Configuration/report |
|---|---|---|
| TypeScript | StrykerJS with Vitest | `apps/desktop/stryker.config.json`, HTML/JSON |
| C# | Stryker.NET | `stryker-config.json`, HTML/JSON |
| Python | mutmut | `uv.lock`, terminal/JUnit-compatible CI capture |
| Rust | cargo-mutants | `apps/desktop/src-tauri/mutants.toml`, CI artifact |

Phase 1 has no safety-critical business branch, so mutation scores are reported but do not gate acceptance. From the first applicable phase, surviving mutants in mandatory safety checks fail the phase regardless of aggregate score.

