# This script is intended to be run on initial setup of the dotfile-repo
# It should be possible to run in multiple times (IaC-style), but using the
# sync-script is generally recomended as the inital setup checks are slow.

# Windows 10 Setup Script
# Run this script in PowerShell

# -----------------------------------------------------------------------------
# Self elevate administrative permissions in this script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

function Check-Command($cmdname) {
  return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# -----------------------------------------------------------------------------
# Set a new computer name
# $computerName = Read-Host 'Enter New Computer Name'
# Write-Host "Renaming this computer to: " $computerName  -ForegroundColor Yellow
# Rename-Computer -NewName $computerName

# -----------------------------------------------------------------------------
# Remove a few pre-installed UWP applications
# To list all appx packages:
# Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
Write-Host "Removing UWP Rubbish..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
$uwpRubbishApps = @(
  "king.com.CandyCrushFriends",
  "Microsoft.3DBuilder",
  "Microsoft.Print3D",
  "Microsoft.BingNews",
  "Microsoft.OneConnect",
  "Microsoft.Microsoft3DViewer",
  "HolographicFirstRun",
  "Microsoft.MixedReality.Portal"
  "Microsoft.MicrosoftSolitaireCollection",
  "Microsoft.Getstarted",
  "Microsoft.WindowsFeedbackHub",
  "Microsoft.XboxApp",
  "Fitbit.FitbitCoach",
  "4DF9E0F8.Netflix")

foreach ($uwp in $uwpRubbishApps) {
  Get-AppxPackage -Name $uwp | Remove-AppxPackage
}

# -----------------------------------------------------------------------------
# Install Chocolatey and some apps
if (Check-Command -cmdname 'choco') {
  Write-Host "Choco is already installed, skip installation."
}
else {
  Write-Host ""
  Write-Host "Installing Chocolatey for Windows..." -ForegroundColor Green
  Write-Host "------------------------------------" -ForegroundColor Green
  Set-ExecutionPolicy Bypass -Scope Process -Force; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
}

Write-Host ""
Write-Host "Installing Applications..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green

# -----------------------------------------------------------------------------
# Git is installed outside the package to allow cloning the dotfiles-repo
# before running the package manger
if (Check-Command -cmdname 'git') {
  Write-Host "Git is already installed, checking new version..."
  choco upgrade git -y
}
else {
  Write-Host ""
  Write-Host "Installing Git for Windows..." -ForegroundColor Green
  choco install git --params "/NoShellIntegration /NoAutoCrlf /SChannel /WindowsTerminal" -y
}

# -----------------------------------------------------------------------------
# Clone the dotfiles repo

# TODO: Clone dotfiles into rootdir
$dotfilesRepo = "$HOME/dotfiles"
if (Test-Path -Path $dotfilesRepo) {
  Write-Host "Dotfiles already exists..."
}
else {
  Write-Host ""
  Write-Host "Cloning dotfiles repository into " $dotfilesRepo -ForegroundColor Green
  git clone "https://github.com/andeki92/dotfiles" $dotfilesRepo
}


# -----------------------------------------------------------------------------
# Install packages: choco
Write-Host "Installing Apps via chocolatey package manager..." -ForegroundColor Green

choco install "$dotFilesRepo/configs/choco/choco.packages.config" --yes

# -----------------------------------------------------------------------------
# Install modules and change Set-ExecutionPolicy to "Unrestricted"
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -AllowClobber Get-ChildItemColor
Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

# -----------------------------------------------------------------------------
# Set Profile locations for PowerShell
Write-Host ""
Write-Host "Configuring PowerShell profile locations..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
New-ItemProperty `
  'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders' `
  Personal -Value '$HOME\.config\Microsoft.PowerShell_profile.ps1' -Type ExpandString -Force

# -----------------------------------------------------------------------------
# Install WSL
Write-Host ""
Write-Host "Installing WSL..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform

# Suggest WSL Distro
Write-Host ""
Write-Host "Install WSL Distro (Action Required)..." -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Green
Write-Host "After restarting your computer, install an up to date WSL distro."
Write-Host "Use `wsl install -d Ubuntu-22.04`"

# -----------------------------------------------------------------------------
# Restart Windows
Write-Host "------------------------------------" -ForegroundColor Green
Read-Host -Prompt "Setup is done, restart is needed, press [ENTER] to restart computer."
#Restart-Computer
