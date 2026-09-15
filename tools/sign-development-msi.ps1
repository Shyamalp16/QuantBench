param(
    [Parameter(Mandatory)]
    [string]$MsiPath
)

$ErrorActionPreference = 'Stop'
$resolvedMsi = (Resolve-Path -LiteralPath $MsiPath).Path
if ([System.IO.Path]::GetExtension($resolvedMsi) -ne '.msi') {
    throw 'Development signing is limited to an explicit MSI path.'
}

$signTool = Get-ChildItem 'C:\Program Files (x86)\Windows Kits\10\bin' -Filter signtool.exe -Recurse -ErrorAction SilentlyContinue |
    Where-Object FullName -Match '\\x64\\signtool\.exe$' |
    Sort-Object FullName -Descending |
    Select-Object -First 1

if (-not $signTool) {
    throw 'signtool.exe was not found. Install the Windows 11 SDK.'
}

$certificate = New-SelfSignedCertificate `
    -Type CodeSigningCert `
    -Subject 'CN=QuantBench Development Build Only' `
    -CertStoreLocation 'Cert:\CurrentUser\My' `
    -NotAfter (Get-Date).AddDays(7) `
    -KeyAlgorithm RSA `
    -KeyLength 3072 `
    -HashAlgorithm SHA256

$temporaryPfx = Join-Path ([System.IO.Path]::GetTempPath()) "quantbench-dev-$([guid]::NewGuid()).pfx"
$passwordText = [Convert]::ToBase64String([Security.Cryptography.RandomNumberGenerator]::GetBytes(32))
$password = ConvertTo-SecureString $passwordText -AsPlainText -Force

try {
    Export-PfxCertificate -Cert $certificate -FilePath $temporaryPfx -Password $password | Out-Null
    & $signTool.FullName sign /fd SHA256 /f $temporaryPfx /p $passwordText $resolvedMsi
    if ($LASTEXITCODE -ne 0) { throw 'signtool failed to sign the MSI.' }

    $nativePreference = $PSNativeCommandUseErrorActionPreference
    $PSNativeCommandUseErrorActionPreference = $false
    try {
        & $signTool.FullName verify /v /pa $resolvedMsi
        $verifyExitCode = $LASTEXITCODE
    }
    finally {
        $PSNativeCommandUseErrorActionPreference = $nativePreference
    }
    if ($verifyExitCode -ne 0) {
        $signature = Get-AuthenticodeSignature -LiteralPath $resolvedMsi
        if ($signature.SignatureType -eq 'None' -or $signature.SignerCertificate.Thumbprint -ne $certificate.Thumbprint) {
            throw 'The development MSI signature could not be verified.'
        }
    }

    Write-Host "Development signature verified: $($certificate.Thumbprint)"
}
finally {
    if (Test-Path -LiteralPath $temporaryPfx) { Remove-Item -LiteralPath $temporaryPfx -Force }
    Remove-Item -LiteralPath "Cert:\CurrentUser\My\$($certificate.Thumbprint)" -Force
}

