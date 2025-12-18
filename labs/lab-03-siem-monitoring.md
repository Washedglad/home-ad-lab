# Lab 03: SIEM Monitoring with Wazuh

## Objective

Learn to use Wazuh SIEM for security monitoring, log analysis, and incident detection.

## Prerequisites

- Wazuh server is installed and running
- Wazuh agents are installed on all Windows machines
- Access to Wazuh dashboard (https://192.168.100.20:5601)
- Domain administrator credentials

## Lab Tasks

### Task 1: Access Wazuh Dashboard

**Objective:** Familiarize yourself with the Wazuh dashboard interface.

**Steps:**

1. Open web browser
2. Navigate to: `https://192.168.100.20:5601`
3. Log in with credentials (change default if needed)
4. Explore the dashboard:
   - **Overview:** General security overview
   - **Agents:** Connected agents
   - **Security Events:** Security-related events
   - **Integrity Monitoring:** File integrity events
   - **Vulnerabilities:** Detected vulnerabilities

**Expected Result:** Dashboard is accessible and you can navigate between sections.

### Task 2: Verify Agent Connectivity

**Objective:** Verify all agents are connected and reporting.

**Steps:**

1. In Wazuh dashboard, navigate to **Agents**
2. Verify all agents show as "Active":
   - DC01 (Domain Controller)
   - WEB01 (Web Server)
   - CLIENT01 (Client Workstation)
3. Check agent details:
   - Last keep-alive time
   - Agent version
   - Operating system
4. If any agent shows as "Disconnected", troubleshoot:
   - Check agent service is running
   - Verify network connectivity
   - Check firewall rules

**Expected Result:** All agents show as "Active" and reporting.

### Task 3: Generate Test Events

**Objective:** Generate various events to see them in Wazuh.

**Steps:**

1. **On CLIENT01:**
   - Log in as a domain user
   - Create a test file
   - Access a website
   - Run some applications

2. **On DC01:**
   - Create a new user account
   - Modify a group
   - Check event logs

3. **On WEB01:**
   - Access the website
   - Check IIS logs

4. **In Wazuh Dashboard:**
   - Navigate to **Security Events**
   - Filter by agent (CLIENT01, DC01, WEB01)
   - Observe events appearing in real-time

**Expected Result:** Events from all agents appear in Wazuh dashboard.

### Task 4: Analyze Security Events

**Objective:** Analyze different types of security events.

**Steps:**

1. In Wazuh dashboard, go to **Security Events**
2. Filter events by:
   - **Agent:** Select specific agent
   - **Rule:** Filter by rule ID or name
   - **Time Range:** Last hour, day, week
3. Analyze event details:
   - Click on an event to see details
   - Review event description
   - Check source IP, user, process
4. Look for:
   - Failed login attempts
   - Successful logins
   - File modifications
   - Process executions

**Expected Result:** You can filter and analyze security events.

### Task 5: Create Custom Dashboard

**Objective:** Create a custom dashboard for monitoring.

**Steps:**

1. In Wazuh dashboard, go to **Dashboard**
2. Click **Create** or **Add**
3. Create visualizations:
   - **Events over time:** Line chart
   - **Top agents by events:** Pie chart
   - **Event types:** Bar chart
   - **Recent security events:** Table
4. Save dashboard with name: "Lab Monitoring Dashboard"

**Expected Result:** Custom dashboard created with visualizations.

### Task 6: Configure Alerts

**Objective:** Set up alerts for specific events.

**Steps:**

1. In Wazuh dashboard, go to **Management > Rules**
2. Search for rules related to:
   - Failed login attempts
   - Unauthorized access
   - File integrity changes
3. Review rule details and severity
4. Create custom rule (optional):
   - Go to **Management > Rules > Add new rule**
   - Define rule conditions
   - Set alert level
5. Configure alert thresholds:
   - Set up alerts for multiple failed logins
   - Configure alerts for suspicious activity

**Expected Result:** Alerts configured for important events.

### Task 7: Monitor Windows Event Logs

**Objective:** Analyze Windows Event Logs in Wazuh.

**Steps:**

1. **On CLIENT01:**
   - Generate test events:
     ```powershell
     # Generate test event
     Write-EventLog -LogName Application -Source "Test" -EventID 9999 -EntryType Information -Message "Test event for Wazuh"
     ```

2. **In Wazuh Dashboard:**
   - Navigate to **Security Events**
   - Filter by agent: CLIENT01
   - Look for the test event
   - Review event details

3. **Analyze Security Log:**
   - Filter for Security log events
   - Look for:
     - Account logon events
     - Account management events
     - Object access events

**Expected Result:** Windows Event Logs are visible in Wazuh.

### Task 8: File Integrity Monitoring

**Objective:** Monitor file integrity changes.

**Steps:**

1. **On CLIENT01:**
   - Create a test file: `C:\Test\important.txt`
   - Add content to the file
   - Modify the file
   - Delete the file

2. **In Wazuh Dashboard:**
   - Navigate to **Integrity Monitoring**
   - Filter by agent: CLIENT01
   - Look for file integrity events
   - Review what changes were detected

**Expected Result:** File integrity changes are detected and logged.

### Task 9: Vulnerability Detection

**Objective:** Review vulnerability information.

**Steps:**

1. In Wazuh dashboard, navigate to **Vulnerabilities**
2. Review detected vulnerabilities:
   - Operating system vulnerabilities
   - Application vulnerabilities
   - Missing patches
3. Filter by:
   - Agent
   - Severity
   - CVE ID
4. Review vulnerability details:
   - Description
   - CVSS score
   - Remediation steps

**Expected Result:** You can view and analyze vulnerabilities.

### Task 10: Create Incident Report

**Objective:** Document a security incident.

**Steps:**

1. Generate a simulated incident:
   - Multiple failed login attempts
   - Unauthorized file access
   - Suspicious process execution

2. In Wazuh dashboard:
   - Identify related events
   - Create timeline of events
   - Document findings

3. Create incident report:
   - Event IDs
   - Timestamps
   - Affected systems
   - Recommended actions

**Expected Result:** Incident report created with relevant information.

## Verification

### Check Your Work

1. **Agent Status:**
   - All agents should show as "Active"
   - Last keep-alive should be recent

2. **Event Collection:**
   - Events should appear from all agents
   - Events should have correct timestamps

3. **Dashboard:**
   - Custom dashboard should be saved
   - Visualizations should display data

## Challenges

### Challenge 1: Advanced Filtering

Create complex filters to find:
- All failed login attempts in the last 24 hours
- All file modifications on WEB01
- All process executions by specific user

### Challenge 2: Custom Rules

Create custom rules for:
- Detecting specific application launches
- Monitoring registry changes
- Alerting on network connections

### Challenge 3: Correlation

Identify correlated events:
- Multiple failed logins followed by successful login
- File creation followed by network connection
- Process execution followed by file modification

## Learning Objectives Achieved

- [ ] Navigate Wazuh dashboard
- [ ] Verify agent connectivity
- [ ] Analyze security events
- [ ] Create custom dashboards
- [ ] Configure alerts
- [ ] Monitor Windows Event Logs
- [ ] Understand file integrity monitoring
- [ ] Review vulnerabilities
- [ ] Create incident reports

## Next Lab

[Lab 04: Firewall Rules](./lab-04-firewall-rules.md)

## Additional Resources

- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Wazuh User Manual](https://documentation.wazuh.com/current/user-manual/)
- [SIEM Best Practices](https://documentation.wazuh.com/current/user-manual/capabilities/)

