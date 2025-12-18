# Lab 01: Basic Active Directory Management

## Objective

Learn fundamental Active Directory administration tasks including user management, group management, and organizational unit (OU) structure.

## Prerequisites

- Domain Controller is installed and configured
- You have domain administrator credentials
- Access to Domain Controller (DC01)

## Lab Tasks

### Task 1: Create Organizational Units

**Objective:** Create a proper OU structure for organizing users and computers.

**Steps:**

1. Log in to DC01 as `CORP\Administrator`
2. Open **Active Directory Users and Computers**
3. Create the following OU structure:

```
corp.local
├── Computers
│   ├── Servers
│   └── Workstations
├── Users
│   ├── IT
│   ├── Sales
│   └── Management
└── Groups
    ├── Security Groups
    └── Distribution Groups
```

4. Verify OUs are created correctly

**Expected Result:** OU structure matches the diagram above.

### Task 2: Create User Accounts

**Objective:** Create user accounts for different departments.

**Steps:**

1. In **AD Users and Computers**, navigate to **Users > IT**
2. Create the following users:

| Username | Full Name | Department | Password |
|----------|-----------|------------|----------|
| itadmin | IT Administrator | IT | P@ssw0rd123! |
| itsupport | IT Support | IT | P@ssw0rd123! |

3. Navigate to **Users > Sales**
4. Create users:

| Username | Full Name | Department | Password |
|----------|-----------|------------|----------|
| sales1 | Sales Rep 1 | Sales | P@ssw0rd123! |
| sales2 | Sales Rep 2 | Sales | P@ssw0rd123! |

5. Navigate to **Users > Management**
6. Create user:

| Username | Full Name | Department | Password |
|----------|-----------|------------|----------|
| manager1 | Manager One | Management | P@ssw0rd123! |

7. Set all users to **"User must change password at next logon"**

**Expected Result:** All users created in appropriate OUs.

### Task 3: Create Security Groups

**Objective:** Create security groups and assign users.

**Steps:**

1. Navigate to **Groups > Security Groups**
2. Create the following groups:

| Group Name | Type | Description |
|------------|------|-------------|
| IT_Admins | Security - Global | IT Administrators |
| IT_Support | Security - Global | IT Support Staff |
| Sales_Team | Security - Global | Sales Department |
| Managers | Security - Global | Management Team |

3. Add users to appropriate groups:
   - **IT_Admins:** itadmin
   - **IT_Support:** itsupport
   - **Sales_Team:** sales1, sales2
   - **Managers:** manager1

**Expected Result:** Groups created and users assigned.

### Task 4: Test User Authentication

**Objective:** Verify users can authenticate to the domain.

**Steps:**

1. Log in to CLIENT01
2. Log out current user
3. Log in as `CORP\sales1`
4. Verify authentication succeeds
5. Verify user profile is created
6. Log out
7. Repeat with `CORP\itadmin`

**Expected Result:** Users can successfully authenticate.

### Task 5: Move Computer Objects

**Objective:** Organize computer objects into appropriate OUs.

**Steps:**

1. In **AD Users and Computers**, go to **Computers** container
2. Move computer objects to appropriate OUs:
   - **DC01** → **Computers > Servers**
   - **WEB01** → **Computers > Servers**
   - **CLIENT01** → **Computers > Workstations**

**Expected Result:** Computer objects organized in OUs.

### Task 6: Configure User Properties

**Objective:** Configure additional user account properties.

**Steps:**

1. Select user `itadmin`
2. Right-click > **Properties**
3. Configure:
   - **General:** Add description, office location
   - **Account:** Set account expiration (optional)
   - **Profile:** Configure profile path (optional)
   - **Member Of:** Verify group membership
4. Repeat for other users as needed

**Expected Result:** User properties configured.

## Verification

### Check Your Work

1. **OU Structure:**
   ```powershell
   Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName
   ```

2. **User Accounts:**
   ```powershell
   Get-ADUser -Filter * | Select-Object Name, SamAccountName, DistinguishedName
   ```

3. **Security Groups:**
   ```powershell
   Get-ADGroup -Filter * | Select-Object Name, GroupCategory, DistinguishedName
   ```

4. **Group Membership:**
   ```powershell
   Get-ADGroupMember -Identity "IT_Admins"
   Get-ADGroupMember -Identity "Sales_Team"
   ```

## Challenges

### Challenge 1: Bulk User Creation

Create 10 additional users using PowerShell:

```powershell
# Example: Create users from CSV
$users = Import-Csv -Path "C:\users.csv"
foreach ($user in $users) {
    New-ADUser -Name $user.Name `
        -SamAccountName $user.SamAccountName `
        -Path "OU=Users,DC=corp,DC=local" `
        -AccountPassword (ConvertTo-SecureString $user.Password -AsPlainText -Force) `
        -Enabled $true
}
```

### Challenge 2: Delegation

Delegate permissions to IT_Support group to reset passwords for Sales users.

## Learning Objectives Achieved

- [ ] Understand OU structure and organization
- [ ] Create and manage user accounts
- [ ] Create and manage security groups
- [ ] Assign users to groups
- [ ] Organize computer objects
- [ ] Configure user properties

## Next Lab

[Lab 02: GPO Configuration](./lab-02-gpo-configuration.md)

## Additional Resources

- [Microsoft AD User Management](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-active-directory-users)
- [AD Group Management](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/manage/understand-active-directory-groups)

