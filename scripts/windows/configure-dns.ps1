# DNS Configuration Script
# Configures DNS forwarders and creates initial DNS records

#Requires -RunAsAdministrator

param(
    [string[]]$Forwarders = @("8.8.8.8", "1.1.1.1"),
    [string]$DomainName = "goldshire.local"
)

Write-Host "Configuring DNS..." -ForegroundColor Green

# Check if DNS server is installed
$dnsFeature = Get-WindowsFeature -Name DNS
if (-not $dnsFeature.Installed) {
    Write-Error "DNS Server role is not installed"
    exit 1
}

# Configure DNS Forwarders
Write-Host "Configuring DNS forwarders..." -ForegroundColor Yellow
try {
    $dnsServer = Get-DnsServer
    Set-DnsServerForwarder -IPAddress $Forwarders -PassThru
    Write-Host "DNS forwarders configured: $($Forwarders -join ', ')" -ForegroundColor Green
} catch {
    Write-Warning "Failed to configure forwarders: $_"
}

# Create DNS Records
Write-Host "Creating DNS records..." -ForegroundColor Yellow

$dnsRecords = @(
    @{Name="wazuh"; IP="192.168.100.20"; Zone=$DomainName},
    @{Name="CLIENT01"; IP="192.168.100.50"; Zone=$DomainName},
    @{Name="WEB01"; IP="192.168.101.10"; Zone=$DomainName},
    @{Name="pfsense"; IP="192.168.100.1"; Zone=$DomainName}
)

foreach ($record in $dnsRecords) {
    try {
        # Check if record already exists
        $existing = Get-DnsServerResourceRecord -ZoneName $record.Zone -Name $record.Name -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Host "DNS record $($record.Name) already exists. Skipping." -ForegroundColor Yellow
        } else {
            Add-DnsServerResourceRecordA -ZoneName $record.Zone -Name $record.Name -IPv4Address $record.IP
            Write-Host "Created DNS record: $($record.Name) -> $($record.IP)" -ForegroundColor Green
        }
    } catch {
        Write-Warning "Failed to create DNS record $($record.Name): $_"
    }
}

# Create Reverse Lookup Zones
Write-Host "Creating reverse lookup zones..." -ForegroundColor Yellow

$reverseZones = @(
    @{NetworkID="192.168.100"; ZoneName="100.168.192.in-addr.arpa"},
    @{NetworkID="192.168.101"; ZoneName="101.168.192.in-addr.arpa"}
)

foreach ($zone in $reverseZones) {
    try {
        $existing = Get-DnsServerZone -Name $zone.ZoneName -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Host "Reverse zone $($zone.ZoneName) already exists. Skipping." -ForegroundColor Yellow
        } else {
            Add-DnsServerPrimaryZone -NetworkID "$($zone.NetworkID).0/24" -ReplicationScope Domain
            Write-Host "Created reverse lookup zone: $($zone.ZoneName)" -ForegroundColor Green
        }
    } catch {
        Write-Warning "Failed to create reverse zone $($zone.ZoneName): $_"
    }
}

Write-Host "DNS configuration complete." -ForegroundColor Green

