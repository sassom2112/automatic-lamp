<#
.SYNOPSIS
Removes specified built-in Microsoft Store apps from the system for all users and future users.

.DESCRIPTION
This script removes installed and provisioned app packages. Supports logging, verbose output, and simulation mode.

.PARAMETER AppList
Optional path to a text file containing one app name per line to override the default list.

.PARAMETER WhatIf
Simulates actions without making changes.

.PARAMETER Verbose
Displays detailed output of each step.

.PARAMETER LogOnly
Logs actions that would be taken without performing them.

.EXAMPLE
.\Remove-Bloatware.ps1 -AppList "C:\apps.txt" -Verbose
#>

param (
    [string]$AppList,
    [switch]$WhatIf,
    [switch]$Verbose,
    [switch]$LogOnly
)

# === Admin Check ===
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Error "This script must be run as an Administrator."
    exit 1
}

# === Start Transcript ===
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$logPath = "$PSScriptRoot\AppRemovalLog_$timestamp.txt"
Start-Transcript -Path $logPath

# === Default App List ===
$UninstallPackages = @(
    "Microsoft.GetHelp",
    "Microsoft.Getstarted",
    "Microsoft.Microsoft3DViewer",
    "Microsoft.MicrosoftOfficeHub",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.MixedReality.Portal",
    "Microsoft.OneConnect",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.Xbox.TCUI",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.XboxIdentityProvider",
    "Microsoft.XboxSpeechToTextOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo"
)

# === Optional Custom List ===
if ($AppList) {
    if (Test-Path $AppList) {
        $UninstallPackages = Get-Content $AppList | Where-Object { $_ -and $_ -notmatch '^#' }
        Write-Host "Custom app list loaded from: $AppList"
    } else {
        Write-Warning "App list file not found at: $AppList. Reverting to default list."
    }
}

# === Get Installed and Provisioned Packages ===
$InstalledPackages = Get-AppxPackage -AllUsers | Where-Object { $UninstallPackages -contains $_.Name }
$ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object { $UninstallPackages -contains $_.DisplayName }

# === Remove Provisioned Packages ===
foreach ($ProvPackage in $ProvisionedPackages) {
    $msg = "Removing provisioned package: $($ProvPackage.DisplayName)"
    if ($Verbose) { Write-Host $msg }
    if ($WhatIf -or $LogOnly) { Write-Host "WhatIf: $msg"; continue }

    try {
        Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
        Write-Host "Removed provisioned package: $($ProvPackage.DisplayName)"
    } catch {
        Write-Warning "Failed to remove provisioned package: $($ProvPackage.DisplayName)"
    }
}

# === Remove Installed Appx Packages ===
foreach ($AppxPackage in $InstalledPackages) {
    $msg = "Removing Appx package: $($AppxPackage.Name)"
    if ($Verbose) { Write-Host $msg }
    if ($WhatIf -or $LogOnly) { Write-Host "WhatIf: $msg"; continue }

    try {
        Remove-AppxPackage -Package $AppxPackage.PackageFullName -ErrorAction Stop
        Write-Host "Removed Appx package: $($AppxPackage.Name)"
    } catch {
        Write-Warning "Failed to remove Appx package: $($AppxPackage.Name)"
    }
}

# === End Transcript and Summary ===
Stop-Transcript

Write-Host "Script complete."
Write-Host "Log file: $logPath"
Write-Host "Apps targeted for removal: $($UninstallPackages.Count)"
Write-Host "Done."
