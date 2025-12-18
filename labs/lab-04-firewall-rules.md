# Lab 04: Firewall Rules Configuration

## Objective

Learn to create and manage firewall rules in pfSense to control network traffic and implement network segmentation.

## Prerequisites

- pfSense firewall is installed and configured
- Access to pfSense web interface (https://192.168.100.1)
- Understanding of network concepts
- All lab VMs are running

## Lab Tasks

### Task 1: Review Existing Firewall Rules

**Objective:** Understand current firewall configuration.

**Steps:**

1. Log in to pfSense web interface
2. Navigate to **Firewall > Rules**
3. Review rules for each interface:
   - **WAN:** Outbound rules
   - **LAN:** Internal network rules
   - **OPT1:** DMZ network rules
4. Note rule order and actions (Pass/Block)

**Expected Result:** You understand the current firewall configuration.

### Task 2: Create Allow Rule for Specific Service

**Objective:** Create a rule to allow specific service traffic.

**Steps:**

1. Navigate to **Firewall > Rules > LAN**
2. Click **Add** to create new rule
3. Configure:
   - **Action:** Pass
   - **Interface:** LAN
   - **Protocol:** TCP
   - **Source:** LAN net
   - **Destination:** Single host (192.168.100.20 - Wazuh)
   - **Destination Port:** 5601 (Wazuh Dashboard)
   - **Description:** Allow Internal to Wazuh Dashboard
4. Click **Save**
5. Click **Apply Changes**

**Expected Result:** Rule created and active.

### Task 3: Create Block Rule

**Objective:** Create a rule to block specific traffic.

**Steps:**

1. Navigate to **Firewall > Rules > LAN**
2. Create new rule:
   - **Action:** Block
   - **Interface:** LAN
   - **Protocol:** Any
   - **Source:** Single host (192.168.100.50 - CLIENT01)
   - **Destination:** OPT1 net (DMZ)
   - **Description:** Block CLIENT01 from DMZ
3. **Important:** Place this rule ABOVE the allow rule
4. Save and apply

**Expected Result:** Rule blocks specified traffic.

### Task 4: Test Firewall Rules

**Objective:** Verify firewall rules work as expected.

**Steps:**

1. **From CLIENT01:**
   - Try to access WEB01: `Test-NetConnection -ComputerName 192.168.101.10 -Port 80`
   - Should fail (blocked by rule)

2. **Modify Rule:**
   - Edit the block rule
   - Change action to **Pass** or delete rule
   - Apply changes

3. **Test Again:**
   - From CLIENT01, test access to WEB01
   - Should succeed

**Expected Result:** Firewall rules work as configured.

### Task 5: Create Schedule-Based Rule

**Objective:** Create rule that applies only during specific times.

**Steps:**

1. Navigate to **Firewall > Schedules**
2. Create schedule:
   - **Name:** Business Hours
   - **Description:** 8 AM to 6 PM, Monday-Friday
   - Configure time ranges
3. Create firewall rule:
   - **Action:** Pass
   - **Schedule:** Business Hours
   - **Source:** LAN net
   - **Destination:** OPT1 net
   - **Description:** Allow DMZ access during business hours
4. Save and apply

**Expected Result:** Rule applies only during scheduled times.

### Task 6: Configure Logging

**Objective:** Enable logging for firewall rules.

**Steps:**

1. Edit existing firewall rule
2. Check **Log packets that are handled by this rule**
3. Save and apply
4. Generate test traffic
5. Navigate to **Status > System Logs > Firewall**
6. Review logged traffic

**Expected Result:** Firewall events are logged.

### Task 7: Create Alias

**Objective:** Create aliases for easier rule management.

**Steps:**

1. Navigate to **Firewall > Aliases**
2. Create **Ports** alias:
   - **Name:** Web Ports
   - **Type:** Port(s)
   - **Ports:** 80, 443
3. Create **Hosts** alias:
   - **Name:** Internal Servers
   - **Type:** Host(s)
   - **Hosts:** 192.168.100.10, 192.168.100.20
4. Use aliases in firewall rules

**Expected Result:** Aliases created and used in rules.

### Task 8: Configure NAT Rules

**Objective:** Configure Network Address Translation.

**Steps:**

1. Navigate to **Firewall > NAT > Port Forward**
2. Create port forward rule:
   - **Interface:** WAN
   - **Protocol:** TCP
   - **Destination Port:** 8080
   - **Redirect Target IP:** 192.168.101.10 (WEB01)
   - **Redirect Target Port:** 80
   - **Description:** Forward external port 8080 to web server
3. Create corresponding firewall rule
4. Save and apply

**Expected Result:** NAT rule configured.

## Verification

### Check Your Work

1. **Review Rules:**
   - Verify all rules are in correct order
   - Check rule actions and descriptions
   - Verify logging is enabled where needed

2. **Test Connectivity:**
   - Test allowed traffic works
   - Test blocked traffic is blocked
   - Verify logs show traffic

3. **Check Logs:**
   - Review firewall logs
   - Verify logged events match rules
   - Check for blocked traffic

## Challenges

### Challenge 1: Advanced Rule Set

Create comprehensive rule set:
- Allow specific services only
- Block all other traffic
- Log all blocked attempts

### Challenge 2: VLAN Segmentation

Configure firewall rules for multiple VLANs with different security levels.

### Challenge 3: Intrusion Detection

Configure and test pfSense intrusion detection/prevention features.

## Learning Objectives Achieved

- [ ] Create firewall rules
- [ ] Understand rule order and precedence
- [ ] Configure logging
- [ ] Create aliases
- [ ] Configure NAT rules
- [ ] Test firewall functionality
- [ ] Understand network segmentation

## Next Lab

[Lab 05: Attack Simulation](./lab-05-attack-simulation.md)

## Additional Resources

- [pfSense Firewall Documentation](https://docs.netgate.com/pfsense/en/latest/firewall/)
- [Firewall Best Practices](https://docs.netgate.com/pfsense/en/latest/firewall/best-practices.html)

