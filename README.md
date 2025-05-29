# 🧹 Remove-Bloatware.ps1

A PowerShell script to **safely remove built-in (preinstalled) Microsoft Store apps** from Windows 10/11 for all users and future users. Supports verbose output, simulation mode, logging, and custom app lists.

---

## 🔍 Features

- Removes **Appx packages** for current and all users
- Removes **provisioned packages** so apps don't return for new users
- Supports `-WhatIf` mode (safe dry-run)
- Allows **custom app list input**
- Generates detailed log file for audit/troubleshooting
- Admin check and friendly messaging

---

## ⚙️ Usage

> **Run this script as Administrator**. Standard users will be blocked.

### ▶️ Default Run

```powershell
.\Remove-Bloatware.ps1
```
🔍 Verbose Mode
```powershell
.\Remove-Bloatware.ps1 -Verbose
```
💡 Simulation (WhatIf)
```powershell
.\Remove-Bloatware.ps1 -WhatIf
```
📋 Use a Custom App List
Provide a .txt file with one Appx package name per line (e.g., Microsoft.XboxApp):

```powershell
.\Remove-Bloatware.ps1 -AppList "C:\Path\apps_to_remove.txt"
```
📄 Log-Only (No changes)
Just log what would be removed, no actual actions taken:

```powershell
.\Remove-Bloatware.ps1 -LogOnly
```
📁 Output
Logs are saved to the script directory as:
AppRemovalLog_yyyyMMdd_HHmmss.txt

🔐 Admin Privileges
This script requires elevation. If you're not running PowerShell as Administrator, it will exit.

🧪 Example Apps Removed
```bash
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
```
## 📌 Notes
Remove-AppxPackage does not reliably remove apps for other users unless you also remove the provisioned package.

Provisioned apps must be removed with Remove-AppxProvisionedPackage to stop them from reinstalling.

For enterprise or Intune use, this script can be adapted for deployment.

---

## ✅ Tested On
Windows 10 Pro (21H2, 22H2)

Windows 11 Pro (22H2)

PowerShell 5.1 and 7+

---

## 📫 Contributing
Have improvements? Found an app that needs to be added to the list? Submit a pull request or open an issue.

---

## ⚠️ Disclaimer
Use this script at your own risk. Always test in a non-production environment first. Some apps may have dependencies in your organization.

