# IIS Configuration Script
# Installs and configures IIS with basic settings

#Requires -RunAsAdministrator

param(
    [string]$SiteName = "TestSite",
    [string]$SitePath = "C:\inetpub\wwwroot\TestSite",
    [string]$BindingIP = "*",
    [int]$BindingPort = 80
)

Write-Host "Configuring IIS..." -ForegroundColor Green

# Check if IIS is installed
$iisFeature = Get-WindowsFeature -Name Web-Server
if (-not $iisFeature.Installed) {
    Write-Host "Installing IIS..." -ForegroundColor Yellow
    Install-WindowsFeature -Name Web-Server -IncludeManagementTools
    
    # Install additional features
    Install-WindowsFeature -Name Web-Common-Http, Web-Default-Doc, Web-Dir-Browsing, `
        Web-Http-Errors, Web-Static-Content, Web-Http-Logging, `
        Web-Request-Filtering, Web-Static-Content-Compression
    
    Write-Host "IIS installed successfully." -ForegroundColor Green
} else {
    Write-Host "IIS is already installed." -ForegroundColor Yellow
}

# Import WebAdministration module
Import-Module WebAdministration -ErrorAction SilentlyContinue

# Create site directory
if (-not (Test-Path $SitePath)) {
    New-Item -ItemType Directory -Path $SitePath -Force | Out-Null
    Write-Host "Created directory: $SitePath" -ForegroundColor Green
}

# Create default page
$indexContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Goldshire Consulting - Internal Portal</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        .info { color: #7f8c8d; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Goldshire Consulting</h1>
        <p>Internal Employee Portal</p>
        <div class="info">
            <p><strong>Server:</strong> $env:COMPUTERNAME</p>
            <p><strong>Domain:</strong> $((Get-CimInstance Win32_ComputerSystem).Domain)</p>
            <p><strong>Time:</strong> $(Get-Date)</p>
        </div>
    </div>
</body>
</html>
"@

$indexPath = Join-Path $SitePath "index.html"
Set-Content -Path $indexPath -Value $indexContent -Force
Write-Host "Created default page." -ForegroundColor Green

# Check if site already exists
$existingSite = Get-Website -Name $SiteName -ErrorAction SilentlyContinue
if ($existingSite) {
    Write-Host "Site $SiteName already exists. Removing..." -ForegroundColor Yellow
    Remove-Website -Name $SiteName
}

# Create website
try {
    New-Website -Name $SiteName -PhysicalPath $SitePath -BindingInformation "$($BindingIP):$($BindingPort):" -Force
    Write-Host "Website '$SiteName' created successfully." -ForegroundColor Green
} catch {
    Write-Error "Failed to create website: $_"
    exit 1
}

# Configure logging
Set-WebConfigurationProperty -Filter "system.applicationHost/sites/site[@name='$SiteName']/logFile" `
    -Name "directory" -Value "C:\inetpub\logs\LogFiles" -ErrorAction SilentlyContinue

Set-WebConfigurationProperty -Filter "system.applicationHost/sites/site[@name='$SiteName']/logFile" `
    -Name "logFormat" -Value "W3C" -ErrorAction SilentlyContinue

Write-Host "IIS logging configured." -ForegroundColor Green

# Start website
Start-Website -Name $SiteName
Write-Host "Website started." -ForegroundColor Green

# Configure Windows Firewall
Write-Host "Configuring Windows Firewall..." -ForegroundColor Yellow
$firewallRule = Get-NetFirewallRule -DisplayName "World Wide Web Services (HTTP Traffic-In)" -ErrorAction SilentlyContinue
if (-not $firewallRule) {
    New-NetFirewallRule -DisplayName "World Wide Web Services (HTTP Traffic-In)" `
        -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow | Out-Null
    Write-Host "Firewall rule created for HTTP." -ForegroundColor Green
}

# Test website
Write-Host "Testing website..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "Website is accessible!" -ForegroundColor Green
    }
} catch {
    Write-Warning "Could not test website: $_"
}

Write-Host "IIS configuration complete." -ForegroundColor Green
Write-Host "Website URL: http://localhost" -ForegroundColor Cyan

