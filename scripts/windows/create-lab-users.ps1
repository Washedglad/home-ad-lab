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
New-UserIfNotExists -SamAccountName "gelbin" -Name "Gelbin Mekkatorque" -GivenName "Gelbin" -Surname "Mekkatorque" -DisplayName "Gelbin Mekkatorque" `
    -Password "Password123!" -Path "OU=IT Department,$UsersOU" -Description "IT Administrator with domain admin privileges (Gnomeregan)" `
    -Groups @("Domain Admins", "IT Department", "Administrators") -Email "gelbin@goldshire.local"

New-UserIfNotExists -SamAccountName "tinkmaster" -Name "Tinkmaster Overspark" -GivenName "Tinkmaster" -Surname "Overspark" -DisplayName "Tinkmaster Overspark" `
    -Password "Welcome2024!" -Path "OU=IT Department,$UsersOU" -Description "IT Support Technician (Gnomeregan)" `
    -Groups @("Help Desk", "IT Department") -Email "tinkmaster@goldshire.local"

New-UserIfNotExists -SamAccountName "khazmodan" -Name "Khaz Modan" -GivenName "Khaz" -Surname "Modan" -DisplayName "Khaz Modan" `
    -Password "NetAdmin123" -Path "OU=IT Department,$UsersOU" -Description "Network Administrator (Dwarf region)" `
    -Groups @("Network Operators", "IT Department") -Email "khazmodan@goldshire.local"

# Sales Department Users
New-UserIfNotExists -SamAccountName "gallywix" -Name "Trade Prince Gallywix" -GivenName "Trade Prince" -Surname "Gallywix" -DisplayName "Trade Prince Gallywix" `
    -Password "Sales2024!" -Path "OU=Sales Department,$UsersOU" -Description "Sales Department Manager (Goblin)" `
    -Groups @("Sales Department", "Managers") -Email "gallywix@goldshire.local"

New-UserIfNotExists -SamAccountName "gazlowe" -Name "Gazlowe" -GivenName "Gazlowe" -Surname "" -DisplayName "Gazlowe" `
    -Password "password" -Path "OU=Sales Department,$UsersOU" -Description "Sales Representative (Goblin Engineer)" `
    -Groups @("Sales Department") -Email "gazlowe@goldshire.local"

New-UserIfNotExists -SamAccountName "tradewind" -Name "Tradewind" -GivenName "Tradewind" -Surname "" -DisplayName "Tradewind" `
    -Password "12345678" -Path "OU=Sales Department,$UsersOU" -Description "Sales Representative (Goblin Trader)" `
    -Groups @("Sales Department") -Email "tradewind@goldshire.local"

# HR Department Users
New-UserIfNotExists -SamAccountName "jaina" -Name "Jaina Proudmoore" -GivenName "Jaina" -Surname "Proudmoore" -DisplayName "Jaina Proudmoore" `
    -Password "HRDirector1!" -Path "OU=HR Department,$UsersOU" -Description "Human Resources Director (Lord Admiral)" `
    -Groups @("HR Department", "Managers", "HR Admins") -Email "jaina@goldshire.local"

New-UserIfNotExists -SamAccountName "turalyon" -Name "Turalyon" -GivenName "Turalyon" -Surname "" -DisplayName "Turalyon" `
    -Password "hr2024" -Path "OU=HR Department,$UsersOU" -Description "HR Assistant (Alliance Commander)" `
    -Groups @("HR Department") -Email "turalyon@goldshire.local"

# Management Users
New-UserIfNotExists -SamAccountName "anduin" -Name "Anduin Wrynn" -GivenName "Anduin" -Surname "Wrynn" -DisplayName "Anduin Wrynn" `
    -Password "CEO2024!" -Path "OU=Management,$UsersOU" -Description "Chief Executive Officer (King of Stormwind)" `
    -Groups @("Executives", "Managers") -Email "anduin@goldshire.local"

New-UserIfNotExists -SamAccountName "genn" -Name "Genn Greymane" -GivenName "Genn" -Surname "Greymane" -DisplayName "Genn Greymane" `
    -Password "Finance2024!" -Path "OU=Management,$UsersOU" -Description "Chief Financial Officer (King of Gilneas)" `
    -Groups @("Executives", "Finance", "Managers") -Email "genn@goldshire.local"

# Service Accounts
New-UserIfNotExists -SamAccountName "svc_azeroth" -Name "Azeroth Service Account" -GivenName "Azeroth" -Surname "Service" -DisplayName "Azeroth Service Account" `
    -Password "ServiceAccount1!" -Path "OU=Service Accounts,$UsersOU" -Description "Service account for web applications (Azeroth)" `
    -Groups @("IIS_IUSRS") -PasswordNeverExpires $true -CannotChangePassword $true -Email "svc_azeroth@goldshire.local"

New-UserIfNotExists -SamAccountName "svc_dalaran" -Name "Dalaran Service Account" -GivenName "Dalaran" -Surname "Service" -DisplayName "Dalaran Service Account" `
    -Password "Backup123!" -Path "OU=Service Accounts,$UsersOU" -Description "Service account for backup operations (Dalaran)" `
    -Groups @("Backup Operators") -PasswordNeverExpires $true -CannotChangePassword $true -Email "svc_dalaran@goldshire.local"

# Security Team Users
New-UserIfNotExists -SamAccountName "maiev" -Name "Maiev Shadowsong" -GivenName "Maiev" -Surname "Shadowsong" -DisplayName "Maiev Shadowsong" `
    -Password "Security2024!" -Path "OU=Security Team,$UsersOU" -Description "Security Analyst (Warden)" `
    -Groups @("Security Team", "Event Log Readers") -Email "maiev@goldshire.local"

# Test/Compromised Accounts
New-UserIfNotExists -SamAccountName "arthas" -Name "Arthas Menethil" -GivenName "Arthas" -Surname "Menethil" -DisplayName "Arthas Menethil" `
    -Password "P@ssw0rd" -Path $UsersOU -Description "Pre-compromised account for attack simulation (Fallen Prince)" `
    -Groups @() -Email "arthas@goldshire.local"

New-UserIfNotExists -SamAccountName "varian" -Name "Varian Wrynn" -GivenName "Varian" -Surname "Wrynn" -DisplayName "Varian Wrynn" `
    -Password "OldPassword123!" -Path $UsersOU -Description "Disabled account for enumeration testing (Former King)" `
    -Groups @() -Enabled $false -Email "varian@goldshire.local"

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

