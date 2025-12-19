# Goldshire Consulting - Lab User Accounts

This document contains all user accounts for the Goldshire Consulting cybersecurity lab environment. **All passwords are intentionally weak for educational and testing purposes.** Since this is an isolated lab environment, passwords are documented here.

## Important Notes

- **All passwords are intentionally weak** for cybersecurity training scenarios
- This lab is **isolated** and not accessible from external networks
- Passwords are documented for lab setup and attack simulation purposes
- Never use these passwords in production environments
- All accounts use the domain: `goldshire.local`

## User Accounts by Department

### IT Department

**Purpose:** High-privilege accounts for privilege escalation and lateral movement scenarios.

#### gelbin - IT Administrator (Gelbin Mekkatorque - Gnomeregan)
- **Username:** `gelbin`
- **Full Name:** Gelbin Mekkatorque
- **Password:** `Password123!`
- **Email:** itadmin@goldshire.local
- **Groups:** Domain Admins, IT Department, Administrators
- **OU:** IT Department
- **Description:** IT Administrator with domain admin privileges
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Privilege escalation target
  - Credential harvesting
  - Lateral movement to domain admin
  - Golden ticket attack simulation

#### tinkmaster - IT Support Technician (Tinkmaster Overspark - Gnomeregan)
- **Username:** `tinkmaster`
- **Full Name:** Tinkmaster Overspark
- **Password:** `Welcome2024!`
- **Email:** itsupport@goldshire.local
- **Groups:** Help Desk, IT Department, Domain Users
- **OU:** IT Department
- **Description:** IT Support Technician
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Lateral movement from regular user
  - Service account abuse
  - Help desk privilege abuse
  - Credential dumping

#### khazmodan - Network Administrator (Khaz Modan - Dwarf region)
- **Username:** `khazmodan`
- **Full Name:** Khaz Modan
- **Password:** `NetAdmin123`
- **Email:** networkadmin@goldshire.local
- **Groups:** Network Operators, IT Department, Domain Users
- **OU:** IT Department
- **Description:** Network Administrator
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Network access abuse
  - Network configuration changes
  - Lateral movement via network access

---

### Sales Department

**Purpose:** Regular users for phishing, social engineering, and weak password exploitation scenarios.

#### gallywix - Sales Manager (Trade Prince Gallywix - Goblin)
- **Username:** `gallywix`
- **Full Name:** Trade Prince Gallywix
- **Password:** `Sales2024!`
- **Email:** salesmanager@goldshire.local
- **Groups:** Sales Department, Managers, Domain Users
- **OU:** Sales Department
- **Description:** Sales Department Manager
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Phishing target
  - Credential harvesting
  - Social engineering target
  - Manager-level access abuse

#### gazlowe - Sales Representative (Gazlowe - Goblin Engineer)
- **Username:** `gazlowe`
- **Full Name:** Gazlowe
- **Password:** `Password1!`
- **Email:** sales1@goldshire.local
- **Groups:** Sales Department, Domain Users
- **OU:** Sales Department
- **Description:** Sales Representative
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Weak password exploitation
  - Initial access point
  - Brute force target
  - Credential stuffing

#### tradewind - Sales Representative (Tradewind - Goblin Trader)
- **Username:** `tradewind`
- **Full Name:** Tradewind
- **Password:** `Password123!`
- **Email:** sales2@goldshire.local
- **Groups:** Sales Department, Domain Users
- **OU:** Sales Department
- **Description:** Sales Representative
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Very weak password exploitation
  - Brute force target
  - Initial foothold
  - Lateral movement starting point

---

### HR Department

**Purpose:** Sensitive data access scenarios, insider threats, and data exfiltration.

#### jaina - HR Director (Jaina Proudmoore - Lord Admiral)
- **Username:** `jaina`
- **Full Name:** Jaina Proudmoore
- **Password:** `HRDirector1!`
- **Email:** hrdirector@goldshire.local
- **Groups:** HR Department, Managers, HR Admins, Domain Users
- **OU:** HR Department
- **Description:** Human Resources Director
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Data exfiltration
  - Insider threat simulation
  - Sensitive data access
  - PII/PHI access abuse

#### turalyon - HR Assistant (Turalyon - Alliance Commander)
- **Username:** `turalyon`
- **Full Name:** Turalyon
- **Password:** `Hr2024!`
- **Email:** hr1@goldshire.local
- **Groups:** HR Department, Domain Users
- **OU:** HR Department
- **Description:** HR Assistant
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Unauthorized access to sensitive data
  - Weak password exploitation
  - HR data access abuse

---

### Management

**Purpose:** High-value targets for APT simulation, spear phishing, and executive-level attacks.

#### anduin - Chief Executive Officer (Anduin Wrynn - King of Stormwind)
- **Username:** `anduin`
- **Full Name:** Anduin Wrynn
- **Password:** `CEO2024!`
- **Email:** ceo@goldshire.local
- **Groups:** Domain Users, Executives, Managers
- **OU:** Management
- **Description:** Chief Executive Officer
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - High-value target
  - Spear phishing simulation
  - Executive-level compromise
  - Business email compromise (BEC)

#### genn - Chief Financial Officer (Genn Greymane - King of Gilneas)
- **Username:** `genn`
- **Full Name:** Genn Greymane
- **Password:** `Finance2024!`

#### thrall - Chief Operating Officer (Thrall - Former Warchief)
- **Username:** `thrall`
- **Full Name:** Thrall
- **Password:** `Warchief2024!`
- **Email:** cfo@goldshire.local
- **Groups:** Domain Users, Executives, Finance, Managers
- **OU:** Management
- **Description:** Chief Financial Officer
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Financial data access
  - Wire fraud simulation
  - Executive compromise
  - Financial system access

---

### Service Accounts

**Purpose:** Service account abuse, persistence, and credential dumping scenarios.

#### svc_azeroth - Web Service Account (Azeroth - World name)
- **Username:** `svc_azeroth`
- **Full Name:** Azeroth Service Account
- **Password:** `ServiceAccount1!`
- **Email:** svc_web@goldshire.local
- **Groups:** IIS_IUSRS, Domain Users
- **OU:** Service Accounts
- **Description:** Service account for web applications
- **Account Status:** Enabled
- **Password Never Expires:** Yes
- **Cannot Change Password:** Yes
- **Cybersecurity Scenarios:**
  - Service account compromise
  - Persistence mechanisms
  - Application-level access
  - Credential dumping

#### svc_dalaran - Backup Service Account (Dalaran - Floating city)
- **Username:** `svc_dalaran`
- **Full Name:** Dalaran Service Account
- **Password:** `Backup123!`
- **Email:** svc_backup@goldshire.local
- **Groups:** Backup Operators, Domain Users
- **OU:** Service Accounts
- **Description:** Service account for backup operations
- **Account Status:** Enabled
- **Password Never Expires:** Yes
- **Cannot Change Password:** Yes
- **Cybersecurity Scenarios:**
  - Backup abuse
  - Credential dumping
  - Backup data access
  - Privilege escalation via backup operators

---

### Security Team

**Purpose:** Blue team monitoring scenarios and security account compromise.

#### maiev - Security Analyst (Maiev Shadowsong - Warden)
- **Username:** `maiev`
- **Full Name:** Maiev Shadowsong
- **Password:** `Security2024!`
- **Email:** securityanalyst@goldshire.local
- **Groups:** Security Team, Event Log Readers, Domain Users
- **OU:** Security Team
- **Description:** Security Analyst
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Security team account compromise
  - Event log access abuse
  - Blue team evasion
  - Security tool access

---

### Test/Compromised Accounts

**Purpose:** Pre-compromised accounts for attack chain simulation and account enumeration.

#### arthas - Compromised Account (Arthas Menethil - Fallen Prince)
- **Username:** `arthas`
- **Full Name:** Arthas Menethil
- **Password:** `P@ssw0rd`

#### illidan - Compromised Account (Illidan Stormrage - The Betrayer)
- **Username:** `illidan`
- **Full Name:** Illidan Stormrage
- **Password:** `Betrayer123!`
- **Email:** compromised_user@goldshire.local
- **Groups:** Domain Users
- **OU:** Users
- **Description:** Pre-compromised account for attack simulation
- **Account Status:** Enabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Initial foothold
  - Lateral movement starting point
  - Attack chain simulation
  - Credential reuse

#### varian - Disabled Account (Varian Wrynn - Former King, deceased)
- **Username:** `varian`
- **Full Name:** Varian Wrynn
- **Password:** `OldPassword123!`
- **Email:** disabled_user@goldshire.local
- **Groups:** Domain Users
- **OU:** Users
- **Description:** Disabled account for enumeration testing
- **Account Status:** Disabled
- **Password Never Expires:** Yes (for lab)
- **Cybersecurity Scenarios:**
  - Account enumeration
  - Inactive account discovery
  - Account status enumeration
  - Reconnaissance

---

## Organizational Units (OUs)

The following OUs should be created in Active Directory:

```
goldshire.local
├── Users
│   ├── IT Department
│   ├── Sales Department
│   ├── HR Department
│   ├── Management
│   ├── Service Accounts
│   └── Security Team
└── Computers
    ├── Servers
    └── Workstations
```

## Security Groups

The following security groups should be created:

- **IT Department** - All IT staff members
- **Sales Department** - All sales staff members
- **HR Department** - All HR staff members
- **Managers** - Management level users
- **Executives** - C-level executives
- **Security Team** - Security analysts
- **Help Desk** - Support staff
- **Network Operators** - Network administrators
- **HR Admins** - HR staff with elevated access
- **Finance** - Finance department members
- **Backup Operators** - Backup service accounts (Windows built-in)

## Quick Reference - All Passwords

| Username | Password | Department | WoW Character/Location |
|----------|----------|------------|----------------------|
| gelbin | Password123! | IT | Gelbin Mekkatorque (Gnomeregan) |
| tinkmaster | Welcome2024! | IT | Tinkmaster Overspark (Gnomeregan) |
| khazmodan | NetAdmin123 | IT | Khaz Modan (Dwarf region) |
| gallywix | Sales2024! | Sales | Trade Prince Gallywix (Goblin) |
| gazlowe | Password1! | Sales | Gazlowe (Goblin Engineer) |
| tradewind | Password123! | Sales | Tradewind (Goblin Trader) |
| jaina | HRDirector1! | HR | Jaina Proudmoore (Lord Admiral) |
| turalyon | Hr2024! | HR | Turalyon (Alliance Commander) |
| anduin | CEO2024! | Management | Anduin Wrynn (King of Stormwind) |
| genn | Finance2024! | Management | Genn Greymane (King of Gilneas) |
| thrall | Warchief2024! | Management | Thrall (Former Warchief) |
| svc_azeroth | ServiceAccount1! | Service Accounts | Azeroth (World name) |
| svc_dalaran | Backup123! | Service Accounts | Dalaran (Floating city) |
| maiev | Security2024! | Security | Maiev Shadowsong (Warden) |
| arthas | P@ssw0rd | Test | Arthas Menethil (Fallen Prince) |
| illidan | Betrayer123! | Test | Illidan Stormrage (The Betrayer) |
| varian | OldPassword123! | Test (Disabled) | Varian Wrynn (Former King) |

## Cybersecurity Scenarios Enabled

### 1. Weak Password Exploitation
- Multiple users with weak passwords
- Various password patterns (dates, simple words, common passwords)
- Targets: gazlowe, tradewind, turalyon, arthas, illidan

### 2. Privilege Escalation
- Regular users → IT Admin
- Service account → Domain Admin
- Targets: tinkmaster → gelbin, svc_dalaran → Domain Admins

### 3. Lateral Movement
- Compromised user → Other department members
- Service account abuse
- Targets: arthas, gazlowe, tinkmaster

### 4. Phishing Simulation
- Sales and management users as targets
- Credential harvesting scenarios
- Targets: gallywix, anduin, genn

### 5. Insider Threat
- HR user accessing sensitive data
- IT support with elevated access
- Targets: jaina, turalyon, tinkmaster

### 6. Account Enumeration
- Disabled accounts
- Service accounts discovery
- Targets: varian, svc_azeroth, svc_dalaran, illidan

### 7. High-Value Target Compromise
- Executive-level accounts
- Financial data access
- Targets: anduin, genn, thrall

### 8. Service Account Abuse
- Service account compromise
- Persistence mechanisms
- Targets: svc_azeroth, svc_dalaran

## Usage in Lab Exercises

These accounts are designed to support various cybersecurity lab exercises:

- **Lab 01:** Basic AD Management - Create and manage these accounts
- **Lab 02:** GPO Configuration - Apply policies to these users
- **Lab 03:** SIEM Monitoring - Monitor activities from these accounts
- **Lab 05:** Attack Simulation - Use these accounts for attack scenarios
- **Lab 06:** Incident Response - Investigate compromises of these accounts

## Automation

See `scripts/windows/create-lab-users.ps1` for automated creation of all these accounts.

## Notes

- All accounts use the domain: `goldshire.local`
- Passwords are intentionally weak for educational purposes
- Service accounts have "Password Never Expires" and "Cannot Change Password" enabled
- Regular users have "Password Never Expires" enabled for lab convenience
- All email addresses follow the pattern: `username@goldshire.local`
- Account descriptions help identify purpose during lab exercises

