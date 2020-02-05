[CMDletBinding()]
Param()

if ((Get-Command -Name 'gitversion' -ErrorAction 'SilentlyContinue' | Measure-Object).Count -eq 0) {
    throw 'gitversion must be installed'
}

$version = gitversion | ConvertFrom-Json
$versionString = $version.NuGetVersion
Write-Information -MessageData "Calculated Module Version: $versionString"

$rawManifest = Get-Content -Path "$PSScriptRoot/PwshZendesk.psd1" -raw
Write-Debug -Message "Raw Manifest:`n$rawManifest"

$updatedManifest = $rawManifest -replace "ModuleVersion\s*=\s*['`"][0-9.]+['`"]", "ModuleVersion = '$versionString'"
Write-Debug -Message "Updated Manifest:`n$updatedManifest"

$updatedManifest | Out-File -Path "$PSScriptRoot/PwshZendesk.psd1" -NoNewline
