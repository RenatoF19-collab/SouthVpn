# 🗺️ South VPN 
> **Fast. Private. Open Source. The Southern Standard.**

[![TikTok](https://img.shields.io/badge/TikTok-%23000000.svg?style=for-the-badge&logo=TikTok&logoColor=white)](https://www.tiktok.com/@renatechs)
![License](https://img.shields.io/github/license/YOUR_USERNAME/south-vpn?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20Windows-orange?style=for-the-badge&logo=linux)

South VPN is a lightweight, high-performance VPN service built on the **WireGuard** protocol. Designed for users who value speed, simplicity, and total privacy.

---

## 🚀 One-Click Installation

## 🛠️ Prerequisites
Before running the installer, ensure your system has the necessary tools. Open your terminal and run:

### 🐧 For Ubuntu / Debian / Kali / Mint
```bash
sudo apt update && sudo apt install -y curl wget
```
For Fedora / CentOs / RHEL
```bash
sudo dnf install -y curl wget
```

### 🐧 For Linux (Ubuntu/Debian/CentOS)
Best for 24/7 cloud servers. Run this in your terminal:
```bash
wget -qO- https://raw.githubusercontent.com/YOUR_USERNAME/south-vpn/main/install.sh | sudo bash
```
## 🪟 WINDOWS INSTALLATION (Fast Track)

### 1. The Command
Open **PowerShell as Administrator** and paste this:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('[https://raw.githubusercontent.com/YOUR_USERNAME/south-vpn/main/windows-install.ps1](https://raw.githubusercontent.com/YOUR_USERNAME/south-vpn/main/windows-install.ps1)'))
