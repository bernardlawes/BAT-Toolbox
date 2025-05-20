# 🧰 Scripted Automation Toolkit (PowerShell + Batch)

A growing collection of **PowerShell** and **Batch (`.bat`) scripts** for automating common Windows workflows — starting with automatic app launching and virtual desktop organization.

---

Scripts are designed for Windows 10+ and tested on Windows 11 with PowerShell 7+

## 🚀 Current Features

### 🖥️ Virtual Desktop Automation
- Create new virtual desktops
- Launch specific applications into designated desktops
- Organize workspaces for productivity (e.g., code editor on Desktop 1, browser on Desktop 2)

### ⚙️ Application Launch Scripts
- Launch apps with predefined window states
- Delay and sequence startup of multiple tools
- Useful for daily bootstrapping of dev environments or focus workflows

---

## 📁 Directory Overview

```plaintext
automation-scripts/
├── launch-apps.bat               # Launch core apps on startup
├── setup-virtual-desktops.ps1    # Create desktops and assign apps
├── README.md

```
Run a .bat script
```cmd
./launch-apps.bat
```
Run a PowerShell script
```powershell
powershell -ExecutionPolicy Bypass -File .\setup-virtual-desktops.ps1
```
🔐 Some scripts may require administrator permissions or PowerShell execution policy adjustments.

🔮 Planned Additions
🧹 Temp file/system cleanup

📦 Bulk software installer (choco-based)

⏲️ Scheduled task automation

🔒 Quick security hardening scripts

📁 Directory structure generator for new projects

💼 Environment setup (Git config, VSCode profiles, etc.)

🤝 Contributing
Ideas and contributions welcome! If you have scripts that simplify your Windows workflow, feel free to fork and PR.

📄 License
MIT License — free to use and modify.

🙋‍♂️ Author
Created by Bernard Lawes
Focused on building fast, repeatable, no-bloat automations for daily dev and productivity tasks.
