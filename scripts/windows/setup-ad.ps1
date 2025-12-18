# Active Directory Domain Services Setup Script
# This script automates the installation and initial configuration of AD DS

#Requires -RunAsAdministrator

param(
    [Parameter(Mandatory=$true)]
    [string]$DomainName = "corp.local",
    
    [Parameter(Mandatory=$true)]
    [string]$SafeModePassword,
    
    [string]$ForestMode = "Win2016",
    [string]$DomainMode = "Win2016"
)

Write-Host "Starting Active Directory Domain Services Setup..." -ForegroundColor Green

# Check if running on Windows Server
$osVersion = (Get-CimInstance Win32_OperatingSystem).Caption
if (-not $osVersion -like "*Server*") {
    Write-Error "This script must be run on Windows Server"
    exit 1
}

# Check if AD DS is already installed
$adFeature = Get-WindowsFeature -Name AD-Domain-Services
if ($adFeature.Installed) {
    Write-Warning "AD DS is already installed. Skipping installation."
} else {
    Write-Host "Installing AD DS role..." -ForegroundColor Yellow
    Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install AD DS role"
        exit 1
    }
    
    Write-Host "AD DS role installed successfully." -ForegroundColor Green
}

# Check if server is already a domain controller
$isDC = (Get-CimInstance Win32_ComputerSystem).DomainRole -ge 4
if ($isDC) {
    Write-Warning "Server is already a domain controller. Skipping promotion."
    exit 0
}

# Convert password to secure string
$SecurePassword = ConvertTo-SecureString -String $SafeModePassword -AsPlainText -Force

# Install AD DS Forest
Write-Host "Promoting server to Domain Controller..." -ForegroundColor Yellow
try {
    Install-ADDSForest `
        -DomainName $DomainName `
        -SafeModeAdministratorPassword $SecurePassword `
        -ForestMode $ForestMode `
        -DomainMode $DomainMode `
        -InstallDns:$true `
        -CreateDnsDelegation:$false `
        -DatabasePath "C:\Windows\NTDS" `
        -LogPath "C:\Windows\NTDS" `
        -SysvolPath "C:\Windows\SYSVOL" `
        -Force:$true
        
    Write-Host "Domain Controller promotion initiated. Server will restart." -ForegroundColor Green
    Write-Host "After restart, run the post-installation script." -ForegroundColor Yellow
} catch {
    Write-Error "Failed to promote server to Domain Controller: $_"
    exit 1
}

Write-Host "Setup complete. Server will restart in 60 seconds." -ForegroundColor Green

