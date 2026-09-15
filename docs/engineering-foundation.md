# Engineering Foundation

## Prerequisites

- Windows 11 with Visual Studio 2022 C++ desktop tools, Windows 11 SDK, WebView2, and VBSCRIPT MSI support.
- Node.js 24.19.0 LTS and pnpm 10.10.0.
- .NET SDK 10.0.x.
- Python 3.11.9 and uv 0.12.14.
- Rust 1.98.1 `x86_64-pc-windows-msvc` with rustfmt and Clippy.
- Git, Gitleaks 8.30.1, cargo-audit 0.22.2, and the repository-local .NET tools for the complete security/mutation jobs.

## Clean-checkout verification

From the repository root, run exactly:

```powershell
pwsh ./tools/verify.ps1
```

The command performs frozen restores, formatting checks, lint/static analysis, strict builds, tests/coverage, dependency audit, schema guard, Tauri MSI bundle, and repository-integrity checks. It does not start the control service or grant trading authority.

## Development MSI

`tools/sign-development-msi.ps1` creates a seven-day ephemeral self-signed certificate, signs one explicit MSI, verifies the signer, and removes the temporary certificate and PFX. The resulting artifact is for build-path evidence only and is not trusted for production release or live operation.

## Mutation reports

Mutation runners are configured for TypeScript, C#, Python, and Rust. Because Phase 1 contains only identity/bootstrap code and no safety-critical branch, mutation results are informational; enforcement begins on the first phase that adds applicable production logic. Safety-critical code will require the 95% branch and mutation gates in `PLAN.md`.

