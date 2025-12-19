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
    
    try {
        # Verify parent path exists
        try {
            $null = Get-ADObject -Identity $Path -ErrorAction Stop
        } catch {
            Write-Host "Parent path does not exist: $Path" -ForegroundColor Red
            return $null
        }
        
        # Check if OU already exists
        $existing = Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -ErrorAction SilentlyContinue
        if ($existing) {
            Write-Host "OU already exists: $Name" -ForegroundColor Yellow
            return $existing
        }
        
        # Create the OU
        New-ADOrganizationalUnit -Name $Name -Path $Path -Description $Description -ProtectedFromAccidentalDeletion $false -ErrorAction Stop
        Write-Host "Created OU: $Name" -ForegroundColor Green
        return (Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path)
    } catch {
        if ($_.Exception.Message -like "*already in use*" -or $_.Exception.Message -like "*already exists*") {
            Write-Host "OU already exists: $Name" -ForegroundColor Yellow
            return (Get-ADOrganizationalUnit -Filter "Name -eq '$Name'" -SearchBase $Path -ErrorAction SilentlyContinue)
        } else {
            Write-Host "Error creating OU $Name : $($_.Exception.Message)" -ForegroundColor Red
            return $null
        }
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

# Create Lab parent OU first (avoids conflicts with built-in containers)
Write-Host "Creating Lab parent OU..." -ForegroundColor Cyan
$LabOU = New-OUIfNotExists -Name "Lab" -Path $DomainDN -Description "Lab organizational structure"
if (-not $LabOU) {
    $LabOU = Get-ADOrganizationalUnit -Filter "Name -eq 'Lab'" -SearchBase $DomainDN -ErrorAction SilentlyContinue
}

if (-not $LabOU) {
    Write-Host "ERROR: Could not create or find Lab OU! Exiting." -ForegroundColor Red
    exit 1
}

$LabOUPath = $LabOU.DistinguishedName
Write-Host "Lab OU Path: $LabOUPath" -ForegroundColor Green
Write-Host ""

# Create OU structure under Lab OU
$UsersOUPath = "OU=Users,$LabOUPath"
$ComputersOUPath = "OU=Computers,$LabOUPath"

$UsersOU = New-OUIfNotExists -Name "Users" -Path $LabOUPath -Description "User accounts"
$ComputersOU = New-OUIfNotExists -Name "Computers" -Path $LabOUPath -Description "Computer accounts"

# Get actual DistinguishedNames for child OU creation
if (-not $UsersOU) {
    $UsersOU = Get-ADOrganizationalUnit -Filter "Name -eq 'Users'" -SearchBase $LabOUPath -ErrorAction SilentlyContinue
}
if (-not $ComputersOU) {
    $ComputersOU = Get-ADOrganizationalUnit -Filter "Name -eq 'Computers'" -SearchBase $LabOUPath -ErrorAction SilentlyContinue
}

if (-not $UsersOU -or -not $ComputersOU) {
    Write-Host "ERROR: Could not create Users or Computers OUs! Exiting." -ForegroundColor Red
    exit 1
}

$UsersOUPath = $UsersOU.DistinguishedName
$ComputersOUPath = $ComputersOU.DistinguishedName

# Department OUs under Users
New-OUIfNotExists -Name "IT Department" -Path $UsersOUPath -Description "IT Department users"
New-OUIfNotExists -Name "Sales Department" -Path $UsersOUPath -Description "Sales Department users"
New-OUIfNotExists -Name "HR Department" -Path $UsersOUPath -Description "HR Department users"
New-OUIfNotExists -Name "Management" -Path $UsersOUPath -Description "Management users"
New-OUIfNotExists -Name "Service Accounts" -Path $UsersOUPath -Description "Service accounts"
New-OUIfNotExists -Name "Security Team" -Path $UsersOUPath -Description "Security team users"
New-OUIfNotExists -Name "Test Accounts" -Path $UsersOUPath -Description "Test accounts"

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
    -Password "Password123!" -Path "OU=IT Department,$UsersOUPath" -Description "IT Administrator with domain admin privileges (Gnomeregan)" `
    -Groups @("Domain Admins", "IT Department", "Administrators") -Email "gelbin@goldshire.local"

New-UserIfNotExists -SamAccountName "tinkmaster" -Name "Tinkmaster Overspark" -GivenName "Tinkmaster" -Surname "Overspark" -DisplayName "Tinkmaster Overspark" `
    -Password "Welcome2024!" -Path "OU=IT Department,$UsersOUPath" -Description "IT Support Technician (Gnomeregan)" `
    -Groups @("Help Desk", "IT Department") -Email "tinkmaster@goldshire.local"

New-UserIfNotExists -SamAccountName "khazmodan" -Name "Khaz Modan" -GivenName "Khaz" -Surname "Modan" -DisplayName "Khaz Modan" `
    -Password "NetAdmin123" -Path "OU=IT Department,$UsersOUPath" -Description "Network Administrator (Dwarf region)" `
    -Groups @("Network Operators", "IT Department") -Email "khazmodan@goldshire.local"

# Sales Department Users
New-UserIfNotExists -SamAccountName "gallywix" -Name "Trade Prince Gallywix" -GivenName "Trade Prince" -Surname "Gallywix" -DisplayName "Trade Prince Gallywix" `
    -Password "Sales2024!" -Path "OU=Sales Department,$UsersOUPath" -Description "Sales Department Manager (Goblin)" `
    -Groups @("Sales Department", "Managers") -Email "gallywix@goldshire.local"

New-UserIfNotExists -SamAccountName "gazlowe" -Name "Gazlowe" -GivenName "Gazlowe" -Surname "" -DisplayName "Gazlowe" `
    -Password "password" -Path "OU=Sales Department,$UsersOUPath" -Description "Sales Representative (Goblin Engineer)" `
    -Groups @("Sales Department") -Email "gazlowe@goldshire.local"

New-UserIfNotExists -SamAccountName "tradewind" -Name "Tradewind" -GivenName "Tradewind" -Surname "" -DisplayName "Tradewind" `
    -Password "12345678" -Path "OU=Sales Department,$UsersOUPath" -Description "Sales Representative (Goblin Trader)" `
    -Groups @("Sales Department") -Email "tradewind@goldshire.local"

# HR Department Users
New-UserIfNotExists -SamAccountName "jaina" -Name "Jaina Proudmoore" -GivenName "Jaina" -Surname "Proudmoore" -DisplayName "Jaina Proudmoore" `
    -Password "HRDirector1!" -Path "OU=HR Department,$UsersOUPath" -Description "Human Resources Director (Lord Admiral)" `
    -Groups @("HR Department", "Managers", "HR Admins") -Email "jaina@goldshire.local"

New-UserIfNotExists -SamAccountName "turalyon" -Name "Turalyon" -GivenName "Turalyon" -Surname "" -DisplayName "Turalyon" `
    -Password "hr2024" -Path "OU=HR Department,$UsersOUPath" -Description "HR Assistant (Alliance Commander)" `
    -Groups @("HR Department") -Email "turalyon@goldshire.local"

# Management Users
New-UserIfNotExists -SamAccountName "anduin" -Name "Anduin Wrynn" -GivenName "Anduin" -Surname "Wrynn" -DisplayName "Anduin Wrynn" `
    -Password "CEO2024!" -Path "OU=Management,$UsersOUPath" -Description "Chief Executive Officer (King of Stormwind)" `
    -Groups @("Executives", "Managers") -Email "anduin@goldshire.local"

New-UserIfNotExists -SamAccountName "genn" -Name "Genn Greymane" -GivenName "Genn" -Surname "Greymane" -DisplayName "Genn Greymane" `
    -Password "Finance2024!" -Path "OU=Management,$UsersOUPath" -Description "Chief Financial Officer (King of Gilneas)" `
    -Groups @("Executives", "Finance", "Managers") -Email "genn@goldshire.local"

# Service Accounts
# Note: IIS_IUSRS is a local machine group, not a domain group, so it's removed
# Add manually to local machine after IIS installation if needed
New-UserIfNotExists -SamAccountName "svc_azeroth" -Name "Azeroth Service Account" -GivenName "Azeroth" -Surname "Service" -DisplayName "Azeroth Service Account" `
    -Password "ServiceAccount1!" -Path "OU=Service Accounts,$UsersOUPath" -Description "Service account for web applications (Azeroth)" `
    -Groups @() -PasswordNeverExpires $true -CannotChangePassword $true -Email "svc_azeroth@goldshire.local"

# Note: Backup Operators is a built-in group that requires DistinguishedName reference
# For simplicity, removed from script - add manually if needed: CN=Backup Operators,CN=Builtin,$DomainDN
New-UserIfNotExists -SamAccountName "svc_dalaran" -Name "Dalaran Service Account" -GivenName "Dalaran" -Surname "Service" -DisplayName "Dalaran Service Account" `
    -Password "Backup123!" -Path "OU=Service Accounts,$UsersOUPath" -Description "Service account for backup operations (Dalaran)" `
    -Groups @() -PasswordNeverExpires $true -CannotChangePassword $true -Email "svc_dalaran@goldshire.local"

# Security Team Users
# Note: Event Log Readers is a built-in group that requires DistinguishedName reference
# For simplicity, removed from script - add manually if needed: CN=Event Log Readers,CN=Builtin,$DomainDN
New-UserIfNotExists -SamAccountName "maiev" -Name "Maiev Shadowsong" -GivenName "Maiev" -Surname "Shadowsong" -DisplayName "Maiev Shadowsong" `
    -Password "Security2024!" -Path "OU=Security Team,$UsersOUPath" -Description "Security Analyst (Warden)" `
    -Groups @("Security Team") -Email "maiev@goldshire.local"

# Test/Compromised Accounts
New-UserIfNotExists -SamAccountName "arthas" -Name "Arthas Menethil" -GivenName "Arthas" -Surname "Menethil" -DisplayName "Arthas Menethil" `
    -Password "P@ssw0rd" -Path "OU=Test Accounts,$UsersOUPath" -Description "Pre-compromised account for attack simulation (Fallen Prince)" `
    -Groups @() -Email "arthas@goldshire.local"

New-UserIfNotExists -SamAccountName "varian" -Name "Varian Wrynn" -GivenName "Varian" -Surname "Wrynn" -DisplayName "Varian Wrynn" `
    -Password "OldPassword123!" -Path "OU=Test Accounts,$UsersOUPath" -Description "Disabled account for enumeration testing (Former King)" `
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

