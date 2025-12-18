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

#### itadmin - IT Administrator
- **Username:** `itadmin`
- **Full Name:** IT Administrator
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

#### itsupport - IT Support Technician
- **Username:** `itsupport`
- **Full Name:** IT Support
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

#### networkadmin - Network Administrator
- **Username:** `networkadmin`
- **Full Name:** Network Administrator
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

#### salesmanager - Sales Manager
- **Username:** `salesmanager`
- **Full Name:** Sales Manager
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

#### sales1 - Sales Representative
- **Username:** `sales1`
- **Full Name:** Sales Representative 1
- **Password:** `password`
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

#### sales2 - Sales Representative
- **Username:** `sales2`
- **Full Name:** Sales Representative 2
- **Password:** `12345678`
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

#### hrdirector - HR Director
- **Username:** `hrdirector`
- **Full Name:** HR Director
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

#### hr1 - HR Assistant
- **Username:** `hr1`
- **Full Name:** HR Assistant
- **Password:** `hr2024`
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

#### ceo - Chief Executive Officer
- **Username:** `ceo`
- **Full Name:** Chief Executive Officer
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

#### cfo - Chief Financial Officer
- **Username:** `cfo`
- **Full Name:** Chief Financial Officer
- **Password:** `Finance2024!`
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

#### svc_web - Web Service Account
- **Username:** `svc_web`
- **Full Name:** Web Service Account
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

#### svc_backup - Backup Service Account
- **Username:** `svc_backup`
- **Full Name:** Backup Service Account
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

#### securityanalyst - Security Analyst
- **Username:** `securityanalyst`
- **Full Name:** Security Analyst
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

#### compromised_user - Compromised Account
- **Username:** `compromised_user`
- **Full Name:** Compromised User
- **Password:** `P@ssw0rd`
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

#### disabled_user - Disabled Account
- **Username:** `disabled_user`
- **Full Name:** Disabled User
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

| Username | Password | Department |
|----------|----------|------------|
| itadmin | Password123! | IT |
| itsupport | Welcome2024! | IT |
| networkadmin | NetAdmin123 | IT |
| salesmanager | Sales2024! | Sales |
| sales1 | password | Sales |
| sales2 | 12345678 | Sales |
| hrdirector | HRDirector1! | HR |
| hr1 | hr2024 | HR |
| ceo | CEO2024! | Management |
| cfo | Finance2024! | Management |
| svc_web | ServiceAccount1! | Service Accounts |
| svc_backup | Backup123! | Service Accounts |
| securityanalyst | Security2024! | Security |
| compromised_user | P@ssw0rd | Test |
| disabled_user | OldPassword123! | Test (Disabled) |

## Cybersecurity Scenarios Enabled

### 1. Weak Password Exploitation
- Multiple users with weak passwords
- Various password patterns (dates, simple words, common passwords)
- Targets: sales1, sales2, hr1, compromised_user

### 2. Privilege Escalation
- Regular users → IT Admin
- Service account → Domain Admin
- Targets: itsupport → itadmin, svc_backup → Domain Admins

### 3. Lateral Movement
- Compromised user → Other department members
- Service account abuse
- Targets: compromised_user, sales1, itsupport

### 4. Phishing Simulation
- Sales and management users as targets
- Credential harvesting scenarios
- Targets: salesmanager, ceo, cfo

### 5. Insider Threat
- HR user accessing sensitive data
- IT support with elevated access
- Targets: hrdirector, hr1, itsupport

### 6. Account Enumeration
- Disabled accounts
- Service accounts discovery
- Targets: disabled_user, svc_web, svc_backup

### 7. High-Value Target Compromise
- Executive-level accounts
- Financial data access
- Targets: ceo, cfo

### 8. Service Account Abuse
- Service account compromise
- Persistence mechanisms
- Targets: svc_web, svc_backup

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

