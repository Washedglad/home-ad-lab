# Lab 02: Group Policy Configuration

## Objective

Learn to create and manage Group Policy Objects (GPOs) to enforce security settings and configurations across the domain.

## Prerequisites

- Domain Controller is configured
- Client workstation is domain-joined
- Domain administrator credentials
- Understanding of basic AD concepts

## Lab Tasks

### Task 1: Create Group Policy Object

**Objective:** Create a new GPO for security settings.

**Steps:**

1. Log in to DC01 as `GOLDSHIRE\Administrator`
2. Open **Group Policy Management**
3. Right-click **goldshire.local > Create a GPO in this domain, and Link it here**
4. Name: `Lab Security Policy`
5. Click **OK**

**Expected Result:** GPO created and linked to domain.

### Task 2: Configure Password Policy

**Objective:** Configure password requirements via GPO.

**Steps:**

1. Right-click **Lab Security Policy > Edit**
2. Navigate to **Computer Configuration > Policies > Windows Settings > Security Settings > Account Policies > Password Policy**
3. Configure:
   - **Minimum password length:** 12 characters
   - **Password must meet complexity requirements:** Enabled
   - **Maximum password age:** 90 days
   - **Minimum password age:** 1 day
4. Close Group Policy Editor

**Expected Result:** Password policy configured.

### Task 3: Configure Account Lockout Policy

**Objective:** Configure account lockout settings.

**Steps:**

1. In Group Policy Editor, navigate to **Account Policies > Account Lockout Policy**
2. Configure:
   - **Account lockout threshold:** 5 invalid attempts
   - **Account lockout duration:** 30 minutes
   - **Reset account lockout counter after:** 15 minutes
3. Close Group Policy Editor

**Expected Result:** Account lockout policy configured.

### Task 4: Configure User Rights Assignment

**Objective:** Restrict user rights via GPO.

**Steps:**

1. In Group Policy Editor, navigate to **Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > User Rights Assignment**
2. Configure:
   - **Deny log on locally:** Add Sales_Team group
   - **Allow log on through Remote Desktop Services:** Add IT_Admins group only
3. Close Group Policy Editor

**Expected Result:** User rights configured.

### Task 5: Configure Audit Policy

**Objective:** Enable auditing for security events.

**Steps:**

1. Navigate to **Computer Configuration > Policies > Windows Settings > Security Settings > Local Policies > Audit Policy**
2. Configure:
   - **Audit account logon events:** Success, Failure
   - **Audit account management:** Success, Failure
   - **Audit logon events:** Success, Failure
   - **Audit object access:** Success, Failure
3. Close Group Policy Editor

**Expected Result:** Audit policy configured.

### Task 6: Link GPO to OU

**Objective:** Apply GPO to specific organizational units.

**Steps:**

1. In Group Policy Management, right-click **Users > IT**
2. Click **Link an Existing GPO**
3. Select **Lab Security Policy**
4. Repeat for **Users > Sales** OU
5. Verify GPO links

**Expected Result:** GPO linked to OUs.

### Task 7: Test GPO Application

**Objective:** Verify GPOs are applying correctly.

**Steps:**

1. **On CLIENT01:**
   - Log in as domain user
   - Open PowerShell as Administrator
   - Force GPO update: `gpupdate /force`
   - Check applied policies: `gpresult /r`
   - Generate HTML report: `gpresult /h C:\gpresult.html`

2. **Review Results:**
   - Open HTML report
   - Verify GPO is applied
   - Check policy settings

**Expected Result:** GPO is applied and settings are effective.

### Task 8: Create User-Specific GPO

**Objective:** Create GPO for user configuration.

**Steps:**

1. Create new GPO: `User Desktop Policy`
2. Edit GPO
3. Navigate to **User Configuration > Policies > Administrative Templates > Desktop**
4. Configure:
   - **Remove Recycle Bin icon from desktop:** Enabled
   - **Prohibit user from changing My Documents path:** Enabled
5. Link to **Users** OU

**Expected Result:** User-specific GPO created and linked.

## Verification

### Check Your Work

1. **GPO Status:**
   ```powershell
   Get-GPO -All | Select-Object DisplayName, GpoStatus
   ```

2. **GPO Links:**
   ```powershell
   Get-GPInheritance -Target "OU=Users,DC=corp,DC=local"
   ```

3. **Applied Policies:**
   - On CLIENT01: `gpresult /r`
   - Review applied GPOs
   - Verify settings are effective

## Challenges

### Challenge 1: Software Restriction Policy

Create GPO to restrict execution of specific file types or applications.

### Challenge 2: Folder Redirection

Configure folder redirection for user profiles (Documents, Desktop).

### Challenge 3: GPO Preferences

Use GPO Preferences to configure:
- Drive mappings
- Printer connections
- Registry settings

## Learning Objectives Achieved

- [ ] Create and manage GPOs
- [ ] Configure security policies
- [ ] Link GPOs to OUs
- [ ] Verify GPO application
- [ ] Understand policy precedence
- [ ] Configure user and computer policies

## Next Lab

[Lab 03: SIEM Monitoring](./lab-03-siem-monitoring.md)

## Additional Resources

- [Microsoft Group Policy Documentation](https://docs.microsoft.com/en-us/windows-server/identity/group-policy/group-policy-overview)
- [GPO Best Practices](https://docs.microsoft.com/en-us/windows-server/identity/group-policy/group-policy-best-practices)

