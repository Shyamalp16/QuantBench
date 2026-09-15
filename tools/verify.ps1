param(
    [switch]$SkipBundle,
    [switch]$SkipSecurity
)

$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
Push-Location $repoRoot

try {
    $preferredNode = 'C:\Program Files\nodejs'
    $currentNodeVersion = node --version
    if ($currentNodeVersion -ne 'v24.19.0' -and (Test-Path -LiteralPath (Join-Path $preferredNode 'node.exe'))) {
        $env:Path = "$preferredNode;$env:Path"
    }

    if ((node --version) -ne 'v24.19.0') { throw 'Node.js 24.19.0 LTS is required.' }
    if ((python --version) -notmatch 'Python 3\.11\.') { throw 'Python 3.11 is required.' }
    if ((dotnet --version) -notmatch '^10\.') { throw '.NET SDK 10 is required.' }
    if ((rustc --version) -notmatch '^rustc 1\.98\.1 ') { throw 'Rust 1.98.1 is required.' }

    if (-not $SkipSecurity) {
        $stagedPaths = git diff --cached --name-only
        if ($stagedPaths) {
            gitleaks git --staged --redact --no-banner .
        }
        else {
            gitleaks git --redact --no-banner .
        }
    }

    pnpm install --frozen-lockfile
    pnpm format:check
    pnpm lint
    pnpm typecheck
    pnpm test
    pnpm build
    if (-not $SkipSecurity) { pnpm audit --audit-level high }

    dotnet restore QuantBench.slnx --locked-mode
    if (-not $SkipSecurity) {
        $nugetAudit = dotnet list QuantBench.slnx package --vulnerable --include-transitive
        if ($LASTEXITCODE -ne 0) { throw 'NuGet vulnerability audit failed.' }
        $nugetAudit | Write-Host
        if ($nugetAudit -match '(?im)^\s*>\s+.+\s+(Low|Moderate|High|Critical)\s+https?://') {
            throw 'NuGet reported a vulnerable dependency.'
        }
    }
    dotnet format QuantBench.slnx --verify-no-changes --no-restore
    dotnet build QuantBench.slnx --configuration Release --no-restore
    dotnet test QuantBench.slnx --configuration Release --no-build --collect:"XPlat Code Coverage"

    uv sync --frozen --all-groups --all-packages
    uv run ruff format --check .
    uv run ruff check .
    uv run pyright
    uv run pytest
    if (-not $SkipSecurity) { uv run pip-audit }

    cargo fmt --manifest-path apps/desktop/src-tauri/Cargo.toml --check
    cargo clippy --manifest-path apps/desktop/src-tauri/Cargo.toml --all-targets --all-features -- -D warnings
    cargo test --manifest-path apps/desktop/src-tauri/Cargo.toml --all-targets --all-features
    if (-not $SkipSecurity) { cargo audit --file apps/desktop/src-tauri/Cargo.lock }

    & "$PSScriptRoot\verify-schemas.ps1"
    & "$PSScriptRoot\inventory-licenses.ps1"

    if (-not $SkipBundle) {
        pnpm --filter @quantbench/desktop tauri build --bundles msi
        $msi = Get-ChildItem `
            -LiteralPath 'apps/desktop/src-tauri/target/release/bundle/msi' `
            -Filter '*.msi' |
            Sort-Object LastWriteTimeUtc -Descending |
            Select-Object -First 1
        if (-not $msi) { throw 'Tauri did not produce an MSI.' }
        & "$PSScriptRoot\sign-development-msi.ps1" -MsiPath $msi.FullName
    }

    git diff --check
    if ($LASTEXITCODE -ne 0) { throw 'Git whitespace validation failed.' }

    Write-Host 'QuantBench Phase 1 verification: PASS'
}
finally {
    Pop-Location
}

