# Wazuh Agent Installation Script
# Downloads and installs Wazuh agent on Windows

#Requires -RunAsAdministrator

param(
    [Parameter(Mandatory=$true)]
    [string]$ManagerIP = "192.168.100.20",
    
    [string]$AgentVersion = "4.7.0",
    [string]$InstallPath = "$env:TEMP"
)

Write-Host "Installing Wazuh Agent..." -ForegroundColor Green

# Check if agent is already installed
$wazuhService = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
if ($wazuhService) {
    Write-Warning "Wazuh agent is already installed."
    $response = Read-Host "Do you want to reinstall? (Y/N)"
    if ($response -ne "Y") {
        exit 0
    }
    Stop-Service -Name "WazuhSvc" -Force -ErrorAction SilentlyContinue
}

# Download Wazuh agent
$agentURL = "https://packages.wazuh.com/4.x/windows/wazuh-agent-$AgentVersion-1.msi"
$agentInstaller = Join-Path $InstallPath "wazuh-agent.msi"

Write-Host "Downloading Wazuh agent..." -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $agentURL -OutFile $agentInstaller -UseBasicParsing
    Write-Host "Download complete." -ForegroundColor Green
} catch {
    Write-Error "Failed to download Wazuh agent: $_"
    exit 1
}

# Install Wazuh agent
Write-Host "Installing Wazuh agent..." -ForegroundColor Yellow
try {
    $installArgs = @(
        "/i",
        "`"$agentInstaller`"",
        "/quiet",
        "/norestart",
        "WAZUH_MANAGER=`"$ManagerIP`"",
        "WAZUH_REGISTRATION_SERVER=`"$ManagerIP`"",
        "WAZUH_REGISTRATION_PORT=`"1515`""
    )
    
    Start-Process -FilePath "msiexec.exe" -ArgumentList $installArgs -Wait -NoNewWindow
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Wazuh agent installed successfully." -ForegroundColor Green
    } else {
        Write-Error "Installation failed with exit code: $LASTEXITCODE"
        exit 1
    }
} catch {
    Write-Error "Failed to install Wazuh agent: $_"
    exit 1
}

# Start Wazuh service
Write-Host "Starting Wazuh service..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

try {
    Start-Service -Name "WazuhSvc" -ErrorAction Stop
    Set-Service -Name "WazuhSvc" -StartupType Automatic
    Write-Host "Wazuh service started and set to automatic." -ForegroundColor Green
} catch {
    Write-Warning "Failed to start Wazuh service: $_"
    Write-Host "Please start the service manually: Start-Service WazuhSvc" -ForegroundColor Yellow
}

# Verify installation
Start-Sleep -Seconds 5
$service = Get-Service -Name "WazuhSvc" -ErrorAction SilentlyContinue
if ($service -and $service.Status -eq "Running") {
    Write-Host "Wazuh agent is running." -ForegroundColor Green
    Write-Host "Manager IP: $ManagerIP" -ForegroundColor Cyan
    Write-Host "Check Wazuh dashboard to verify agent registration." -ForegroundColor Yellow
} else {
    Write-Warning "Wazuh service is not running. Please check the service status."
}

# Cleanup
if (Test-Path $agentInstaller) {
    Remove-Item $agentInstaller -Force
}

Write-Host "Installation complete." -ForegroundColor Green

