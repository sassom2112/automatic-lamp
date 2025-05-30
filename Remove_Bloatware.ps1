function Show-GreenBanner {
    $ascii = @'
 ____    ____             _____   __  __  ____                                   
/\  _`\ /\  _`\   /'\_/`\/\  __`\/\ \/\ \/\  _`\                                 
\ \ \L\ \ \ \L\_\/\      \ \ \/\ \ \ \ \ \ \ \L\_\                                
 \ \ ,  /\ \  _\L\ \ \__\ \ \ \ \ \ \ \ \ \ \  _\L                                
  \ \ \\ \\ \ \L\ \ \ \_/\ \ \ \_\ \ \ \_/ \ \ \L\ \                              
   \ \_\ \_\ \____/\ \_\\ \_\ \_____\ `\___/\ \____/                              
    \/_/\/_/\/___/  \/_/ \/_/\/_____/`\/__/  \/___/                               
                                                                                 
                                                                                 
 ____     __       _____   ______  ______  __      __  ______  ____    ____      
/\  _`\  /\ \     /\  __`\/\  _  \/\__  _\/\ \  __/\ \/\  _  \/\  _`\ /\  _`\    
\ \ \L\ \\ \ \    \ \ \/\ \ \ \L\ \/_/\ \/\ \ \/\ \ \ \ \L\ \ \ \L\ \ \ \L\_\  
 \ \  _ <'\ \ \  __\ \ \ \ \ \  __ \ \ \ \ \ \ \ \ \ \ \  __ \ \ ,  /\ \  _\L  
  \ \ \L\ \\ \ \L\ \\ \ \_\ \ \ \/\ \ \ \ \ \ \ \_/ \_\ \ \ \/\ \ \ \\ \\ \ \L\ \
   \ \____/ \ \____/ \ \_____\ \_\ \_\ \ \_\ \ `\___x___/\ \_\ \_\ \_\ \_\ \____/
    \/___/   \/___/   \/_____/\/_/\/_/  \/_/  '\/__//__/  \/_/\/_/\/_/\_/\/___/                                                 
'@
    foreach ($line in $ascii -split "`n") {
        Write-Host $line -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "Remove-Bloatware.ps1 by Mike & Rick" -ForegroundColor Green
    Write-Host ""
}

function Remove-Bloatware {
    Show-GreenBanner

    param (
        [string]$AppList,
        [switch]$WhatIf,
        [switch]$Verbose,
        [switch]$LogOnly
    )

    if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Error "Eh braddah, run dis as Admin kine, no can otherwise."
        return
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $logPath = "$PSScriptRoot\AppRemovalLog_$timestamp.txt"
    Start-Transcript -Path $logPath

    try {
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

        if ($AppList) {
            if (Test-Path $AppList) {
                $UninstallPackages = Get-Content $AppList | Where-Object { $_ -and $_ -notmatch '^#' }
                Write-Host "Custom kine app list from: $AppList" -ForegroundColor Green
            } else {
                Write-Warning "Eh no can find app list at: $AppList. We goin use default."
            }
        }

        $InstalledPackages = Get-AppxPackage -AllUsers | Where-Object { $UninstallPackages -contains $_.Name }
        $ProvisionedPackages = Get-AppxProvisionedPackage -Online | Where-Object { $UninstallPackages -contains $_.DisplayName }

        foreach ($ProvPackage in $ProvisionedPackages) {
            $msg = "Removing provisioned package: $($ProvPackage.DisplayName)"
            if ($Verbose) { Write-Host $msg -ForegroundColor Green }

            if ($WhatIf) {
                Write-Host "WhatIf: $msg" -ForegroundColor Green
                continue
            }

            if (-not $LogOnly) {
                try {
                    Remove-AppxProvisionedPackage -PackageName $ProvPackage.PackageName -Online -ErrorAction Stop
                    Write-Host "Removed provisioned: $($ProvPackage.DisplayName)" -ForegroundColor Green
                } catch {
                    Write-Warning "Brah, failed to remove: $($ProvPackage.DisplayName)"
                }
            } else {
                Write-Host "LogOnly: $msg" -ForegroundColor Green
            }
        }

        foreach ($AppxPackage in $InstalledPackages) {
            $msg = "Removing Appx package: $($AppxPackage.Name)"
            if ($Verbose) { Write-Host $msg -ForegroundColor Green }

            if ($WhatIf) {
                Write-Host "WhatIf: $msg" -ForegroundColor Green
                continue
            }

            if (-not $LogOnly) {
                try {
                    Remove-AppxPackage -Package $AppxPackage.PackageFullName -ErrorAction Stop
                    Write-Host "Removed Appx: $($AppxPackage.Name)" -ForegroundColor Green
                } catch {
                    Write-Warning "No can remove: $($AppxPackage.Name)"
                }
            } else {
                Write-Host "LogOnly: $msg" -ForegroundColor Green
            }
        }

        Write-Host "Pau already, script done." -ForegroundColor Green
        Write-Host "Output file stay here: $logPath" -ForegroundColor Green
        Write-Host "Total apps targeted: $($UninstallPackages.Count)" -ForegroundColor Green
    }
    finally {
        Stop-Transcript
        Write-Host "Transcript pau, output inside: $logPath" -ForegroundColor Green
    }
}
