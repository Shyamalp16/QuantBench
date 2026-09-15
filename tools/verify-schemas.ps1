$ErrorActionPreference = 'Stop'

$unexpected = Get-ChildItem -LiteralPath "$PSScriptRoot\..\schemas" -Recurse -File |
    Where-Object { $_.Name -ne 'README.md' }

if ($unexpected) {
    $paths = $unexpected.FullName -join [Environment]::NewLine
    throw "Phase 2 schema baseline is not approved. Unexpected schema files:$([Environment]::NewLine)$paths"
}

Write-Host 'Schema compatibility guard: PASS (no Phase 2 schemas present).'

