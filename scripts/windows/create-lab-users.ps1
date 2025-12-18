# Create Lab Users for Goldshire Consulting
# This script creates all user accounts, OUs, and groups for the cybersecurity lab

# Requires: Domain Administrator privileges
# Domain: goldshire.local

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Goldshire Consulting Lab User Creation" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Import Active Directory module
Import-Module ActiveDirectory -ErrorAction Stop

# Domain information
$DomainDN = (Get-ADDomain).DistinguishedName
$DomainName = (Get-ADDomain).DNSRoot

Write-Host "Domain: $DomainName" -ForegroundColor Green
Write-Host "Domain DN: $DomainDN" -ForegroundColor Green
Write-Host ""

# Function to create OU if it doesn't exist
function New-OUIfNotExists {
    param(
        [string]$Name,
        [string]$Path,
        [string]$Description
    )
    
    if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -ErrorAction SilentlyContinue)) {
        New-ADOrganizationalUnit -Name $Name -Path $Path -Description $Description -ProtectedFromAccidentalDeletion $false
        Write-Host "Created OU: $Name" -ForegroundColor Green
    } else {
        Write-Host "OU already exists: $Name" -ForegroundColor Yellow
    }
}

# Function to create group if it doesn't exist
function New-GroupIfNotExists {
    param(
        [string]$Name,
        [string]$GroupCategory,
        [string]$GroupScope,
        [string]$Path,
        [string]$Description
    )
    
    if (-not (Get-ADGroup -Filter "Name -eq '$Name'" -ErrorAction SilentlyContinue)) {
        New-ADGroup -Name $Name -GroupCategory $GroupCategory -GroupScope $GroupScope -Path $Path -Description $Description
        Write-Host "Created Group: $Name" -ForegroundColor Green
    } else {
        Write-Host "Group already exists: $Name" -ForegroundColor Yellow
    }
}

# Function to create user if it doesn't exist
function New-UserIfNotExists {
    param(
        [string]$SamAccountName,
        [string]$Name,
        [string]$GivenName,
        [string]$Surname,
        [string]$DisplayName,
        [string]$Password,
        [string]$Path,
        [string]$Description,
        [string[]]$Groups,
        [bool]$PasswordNeverExpires = $true,
        [bool]$CannotChangePassword = $false,
        [bool]$Enabled = $true,
        [string]$Email = ""
    )
    
    if (-not (Get-ADUser -Filter "SamAccountName -eq '$SamAccountName'" -ErrorAction SilentlyContinue)) {
        $SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
        
        $UserParams = @{
            SamAccountName = $SamAccountName
            Name = $Name
            GivenName = $GivenName
            Surname = $Surname
            DisplayName = $DisplayName
            UserPrincipalName = "$SamAccountName@$DomainName"
            Path = $Path
            Description = $Description
            AccountPassword = $SecurePassword
            PasswordNeverExpires = $PasswordNeverExpires
            CannotChangePassword = $CannotChangePassword
            Enabled = $Enabled
        }
        
        if ($Email) {
            $UserParams['EmailAddress'] = $Email
        }
        
        New-ADUser @UserParams
        
        # Add to groups
        foreach ($Group in $Groups) {
            try {
                Add-ADGroupMember -Identity $Group -Members $SamAccountName -ErrorAction Stop
                Write-Host "  Added to group: $Group" -ForegroundColor Gray
            } catch {
                Write-Host "  Warning: Could not add to group $Group" -ForegroundColor Yellow
            }
        }
        
        Write-Host "Created User: $SamAccountName" -ForegroundColor Green
    } else {
        Write-Host "User already exists: $SamAccountName" -ForegroundColor Yellow
    }
}

Write-Host "Creating Organizational Units..." -ForegroundColor Cyan
Write-Host ""

# Create OU structure
$UsersOU = "OU=Users,$DomainDN"
$ComputersOU = "OU=Computers,$DomainDN"

New-OUIfNotExists -Name "Users" -Path $DomainDN -Description "User accounts"
New-OUIfNotExists -Name "Computers" -Path $DomainDN -Description "Computer accounts"

# Department OUs
New-OUIfNotExists -Name "IT Department" -Path $UsersOU -Description "IT Department users"
New-OUIfNotExists -Name "Sales Department" -Path $UsersOU -Description "Sales Department users"
New-OUIfNotExists -Name "HR Department" -Path $UsersOU -Description "HR Department users"
New-OUIfNotExists -Name "Management" -Path $UsersOU -Description "Management users"
New-OUIfNotExists -Name "Service Accounts" -Path $UsersOU -Description "Service accounts"
New-OUIfNotExists -Name "Security Team" -Path $UsersOU -Description "Security team users"

Write-Host ""
Write-Host "Creating Security Groups..." -ForegroundColor Cyan
Write-Host ""

# Create security groups
$GroupsPath = "CN=Users,$DomainDN"

New-GroupIfNotExists -Name "IT Department" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "IT Department members"
New-GroupIfNotExists -Name "Sales Department" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Sales Department members"
New-GroupIfNotExists -Name "HR Department" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "HR Department members"
New-GroupIfNotExists -Name "Managers" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Management level users"
New-GroupIfNotExists -Name "Executives" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "C-level executives"
New-GroupIfNotExists -Name "Security Team" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Security team members"
New-GroupIfNotExists -Name "Help Desk" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Help desk support staff"
New-GroupIfNotExists -Name "Network Operators" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Network operators"
New-GroupIfNotExists -Name "HR Admins" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "HR administrators"
New-GroupIfNotExists -Name "Finance" -GroupCategory Security -GroupScope Global -Path $GroupsPath -Description "Finance department"

Write-Host ""
Write-Host "Creating User Accounts..." -ForegroundColor Cyan
Write-Host ""

# IT Department Users
New-UserIfNotExists -SamAccountName "itadmin" -Name "IT Administrator" -GivenName "IT" -Surname "Administrator" -DisplayName "IT Administrator" `
    -Password "Password123!" -Path "OU=IT Department,$UsersOU" -Description "IT Administrator with domain admin privileges" `
    -Groups @("Domain Admins", "IT Department", "Administrators") -Email "itadmin@goldshire.local"

New-UserIfNotExists -SamAccountName "itsupport" -Name "IT Support" -GivenName "IT" -Surname "Support" -DisplayName "IT Support" `
    -Password "Welcome2024!" -Path "OU=IT Department,$UsersOU" -Description "IT Support Technician" `
    -Groups @("Help Desk", "IT Department") -Email "itsupport@goldshire.local"

New-UserIfNotExists -SamAccountName "networkadmin" -Name "Network Administrator" -GivenName "Network" -Surname "Administrator" -DisplayName "Network Administrator" `
    -Password "NetAdmin123" -Path "OU=IT Department,$UsersOU" -Description "Network Administrator" `
    -Groups @("Network Operators", "IT Department") -Email "networkadmin@goldshire.local"

# Sales Department Users
New-UserIfNotExists -SamAccountName "salesmanager" -Name "Sales Manager" -GivenName "Sales" -Surname "Manager" -DisplayName "Sales Manager" `
    -Password "Sales2024!" -Path "OU=Sales Department,$UsersOU" -Description "Sales Department Manager" `
    -Groups @("Sales Department", "Managers") -Email "salesmanager@goldshire.local"

New-UserIfNotExists -SamAccountName "sales1" -Name "Sales Representative 1" -GivenName "Sales" -Surname "Rep1" -DisplayName "Sales Representative 1" `
    -Password "password" -Path "OU=Sales Department,$UsersOU" -Description "Sales Representative" `
    -Groups @("Sales Department") -Email "sales1@goldshire.local"

New-UserIfNotExists -SamAccountName "sales2" -Name "Sales Representative 2" -GivenName "Sales" -Surname "Rep2" -DisplayName "Sales Representative 2" `
    -Password "12345678" -Path "OU=Sales Department,$UsersOU" -Description "Sales Representative" `
    -Groups @("Sales Department") -Email "sales2@goldshire.local"

# HR Department Users
New-UserIfNotExists -SamAccountName "hrdirector" -Name "HR Director" -GivenName "HR" -Surname "Director" -DisplayName "HR Director" `
    -Password "HRDirector1!" -Path "OU=HR Department,$UsersOU" -Description "Human Resources Director" `
    -Groups @("HR Department", "Managers", "HR Admins") -Email "hrdirector@goldshire.local"

New-UserIfNotExists -SamAccountName "hr1" -Name "HR Assistant" -GivenName "HR" -Surname "Assistant" -DisplayName "HR Assistant" `
    -Password "hr2024" -Path "OU=HR Department,$UsersOU" -Description "HR Assistant" `
    -Groups @("HR Department") -Email "hr1@goldshire.local"

# Management Users
New-UserIfNotExists -SamAccountName "ceo" -Name "Chief Executive Officer" -GivenName "Chief" -Surname "Executive" -DisplayName "Chief Executive Officer" `
    -Password "CEO2024!" -Path "OU=Management,$UsersOU" -Description "Chief Executive Officer" `
    -Groups @("Executives", "Managers") -Email "ceo@goldshire.local"

New-UserIfNotExists -SamAccountName "cfo" -Name "Chief Financial Officer" -GivenName "Chief" -Surname "Financial" -DisplayName "Chief Financial Officer" `
    -Password "Finance2024!" -Path "OU=Management,$UsersOU" -Description "Chief Financial Officer" `
    -Groups @("Executives", "Finance", "Managers") -Email "cfo@goldshire.local"

# Service Accounts
New-UserIfNotExists -SamAccountName "svc_web" -Name "Web Service Account" -GivenName "Web" -Surname "Service" -DisplayName "Web Service Account" `
    -Password "ServiceAccount1!" -Path "OU=Service Accounts,$UsersOU" -Description "Service account for web applications" `
    -Groups @("IIS_IUSRS") -PasswordNeverExpires $true -CannotChangePassword $true -Email "svc_web@goldshire.local"

New-UserIfNotExists -SamAccountName "svc_backup" -Name "Backup Service Account" -GivenName "Backup" -Surname "Service" -DisplayName "Backup Service Account" `
    -Password "Backup123!" -Path "OU=Service Accounts,$UsersOU" -Description "Service account for backup operations" `
    -Groups @("Backup Operators") -PasswordNeverExpires $true -CannotChangePassword $true -Email "svc_backup@goldshire.local"

# Security Team Users
New-UserIfNotExists -SamAccountName "securityanalyst" -Name "Security Analyst" -GivenName "Security" -Surname "Analyst" -DisplayName "Security Analyst" `
    -Password "Security2024!" -Path "OU=Security Team,$UsersOU" -Description "Security Analyst" `
    -Groups @("Security Team", "Event Log Readers") -Email "securityanalyst@goldshire.local"

# Test/Compromised Accounts
New-UserIfNotExists -SamAccountName "compromised_user" -Name "Compromised User" -GivenName "Compromised" -Surname "User" -DisplayName "Compromised User" `
    -Password "P@ssw0rd" -Path $UsersOU -Description "Pre-compromised account for attack simulation" `
    -Groups @() -Email "compromised_user@goldshire.local"

New-UserIfNotExists -SamAccountName "disabled_user" -Name "Disabled User" -GivenName "Disabled" -Surname "User" -DisplayName "Disabled User" `
    -Password "OldPassword123!" -Path $UsersOU -Description "Disabled account for enumeration testing" `
    -Groups @() -Enabled $false -Email "disabled_user@goldshire.local"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "User Creation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "- Created all Organizational Units" -ForegroundColor White
Write-Host "- Created all Security Groups" -ForegroundColor White
Write-Host "- Created all User Accounts" -ForegroundColor White
Write-Host ""
Write-Host "See docs/LAB_USER_ACCOUNTS.md for complete user list and passwords." -ForegroundColor Cyan
Write-Host ""

