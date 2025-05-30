# 🧹 Remove-Bloatware.ps1

A PowerShell script that defines a reusable function `Remove-Bloatware` to safely remove built-in (preinstalled) Microsoft Store apps from Windows 10/11 for all users and future users. Supports verbose output, simulation mode, logging, and custom app lists.

---
<p align="center">
  <img src="https://img.shields.io/badge/PowerShell-5.1%20%7C%207+-blue?style=for-the-badge&logo=powershell" alt="PowerShell">
  <img src="https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-lightgrey?style=for-the-badge" alt="Platform">
  <img src="https://img.shields.io/github/license/sassom2112/automatic-lamp?style=for-the-badge" alt="License">
  <img src="https://img.shields.io/github/last-commit/sassom2112/automatic-lamp?style=for-the-badge" alt="Last Commit">
  <img src="https://img.shields.io/github/issues/sassom2112/automatic-lamp?style=for-the-badge" alt="Issues">
</p>


---

## 🔍 Features

- Removes **Appx packages** for current and all users
- Removes **provisioned packages** to prevent apps from returning for new users
- Supports `-WhatIf` mode (safe dry-run)
- Allows **custom app list** input
- Generates detailed **log file** for audit/troubleshooting
- Admin check and friendly messaging
- Defined as a **PowerShell function** for reusability

---

## ⚙️ Usage

> 💡 Before running, open PowerShell **as Administrator** and dot-source the script to load the function into your session.

### ▶️ 1. Load the Function

```powershell
. .\Remove_Bloatware.ps1
```
> 💡 The . followed by a space and the script path (.\Remove_Bloatware.ps1) is called dot-sourcing. This loads the PowerShell script into your current session, allowing you to use the Remove-Bloatware function it defines.

▶️ 2. Use the Function
🧼 Default Run
```powershell
Remove-Bloatware
```

🔍 Verbose Mode
```powershell
Remove-Bloatware -Verbose
```

💡 Simulation Mode (WhatIf)
```powershell
Remove-Bloatware -WhatIf
```

📋 Use a Custom App List
Provide a .txt file with one Appx package name per line:

```powershell
Remove-Bloatware -AppList "C:\Path\apps_to_remove.txt"
```

📄 Log-Only (No changes)
Just log what would be removed, without taking action:

```powershell
Remove-Bloatware -LogOnly
```

📁 Output
Logs are saved to the script directory as:

```bash
AppRemovalLog_yyyyMMdd_HHmmss.txt
```

🔐 Admin Privileges
This script requires elevation. If you're not running PowerShell as Administrator, it will exit automatically.

🧪 Example Apps Removed
```bash
Microsoft.GetHelp
Microsoft.Getstarted
Microsoft.Microsoft3DViewer
Microsoft.MicrosoftOfficeHub
Microsoft.MicrosoftSolitaireCollection
Microsoft.MixedReality.Portal
Microsoft.OneConnect
Microsoft.WindowsFeedbackHub
Microsoft.Xbox.TCUI
Microsoft.XboxApp
Microsoft.XboxGameOverlay
Microsoft.XboxGamingOverlay
Microsoft.XboxIdentityProvider
Microsoft.XboxSpeechToTextOverlay
Microsoft.YourPhone
Microsoft.ZuneMusic
Microsoft.ZuneVideo
```

📌 Notes
Remove-AppxPackage does not reliably remove apps for other users unless the provisioned package is also removed.

Remove-AppxProvisionedPackage ensures the app does not reinstall for new profiles.

This script can be adapted for enterprise use or Intune deployment by modifying the function for automated execution.

✅ Tested On
Windows 10 Pro (21H2, 22H2)

Windows 11 Pro (22H2)

PowerShell 5.1 and 7+

📫 Contributing
Have improvements? Found an app that needs to be added to the list? Submit a pull request or open an issue!

⚠️ Disclaimer
Use this script at your own risk. Always test in a non-production environment first. Some apps may be required in your environment or have downstream dependencies.

yaml
Copy
Edit

---

Let me know if you'd like a badge section (`PowerShell`, `Windows`, `License`, etc.) or want to break this out into a `docs/` folder for a GitHub Pages–friendly layout.
