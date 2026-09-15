$ErrorActionPreference = 'Stop'
$repoRoot = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..'))
$output = Join-Path $repoRoot 'artifacts\licenses'
New-Item -ItemType Directory -Force -Path $output | Out-Null

Push-Location $repoRoot
try {
    pnpm licenses list --json | Out-File (Join-Path $output 'javascript.json') -Encoding utf8
    dotnet list QuantBench.slnx package --include-transitive | Out-File (Join-Path $output 'dotnet.txt') -Encoding utf8
    uv pip list --format json | Out-File (Join-Path $output 'python.json') -Encoding utf8
    cargo metadata --manifest-path apps/desktop/src-tauri/Cargo.toml --locked --format-version 1 |
        Out-File (Join-Path $output 'rust.json') -Encoding utf8
}
finally {
    Pop-Location
}

Write-Host "License inputs written to $output"

