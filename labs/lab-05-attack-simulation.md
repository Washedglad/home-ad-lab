# Lab 05: Attack Simulation

## Objective

Learn to simulate common cybersecurity attacks in a controlled lab environment and observe how security controls detect and respond to these attacks.

## Prerequisites

- All lab components are configured and running
- Wazuh SIEM is monitoring all systems
- Domain administrator credentials
- Understanding of basic security concepts

## ⚠️ Important Security Notice

This lab is for **educational purposes only** in a controlled, isolated environment. Never perform these activities on production systems or networks without explicit authorization.

## Lab Tasks

### Task 1: Simulate Brute Force Attack

**Objective:** Simulate a brute force password attack and observe detection.

**Steps:**

1. **On CLIENT01:**
   - Attempt multiple failed logins with incorrect passwords
   - Use different usernames
   - Generate 10+ failed login attempts

2. **In Wazuh Dashboard:**
   - Monitor for failed login events
   - Check for account lockout events
   - Review event correlation

3. **On DC01:**
   - Check Event Viewer for security events
   - Verify account lockout policy is working
   - Review failed login attempts

**Expected Result:** Failed login attempts are detected and logged.

### Task 2: Simulate Unauthorized Access Attempt

**Objective:** Test access controls and monitoring.

**Steps:**

1. **On CLIENT01:**
   - Attempt to access restricted resources
   - Try to access files without permissions
   - Attempt to run privileged commands

2. **In Wazuh Dashboard:**
   - Monitor for access denied events
   - Check for privilege escalation attempts
   - Review security events

**Expected Result:** Unauthorized access attempts are logged.

### Task 3: Simulate Lateral Movement

**Objective:** Simulate attacker moving through the network.

**Steps:**

1. **From CLIENT01:**
   - Attempt to enumerate domain users
   - Try to access other systems
   - Attempt to access shared resources

2. **In Wazuh Dashboard:**
   - Monitor for enumeration activities
   - Check for network scanning events
   - Review lateral movement indicators

**Expected Result:** Lateral movement attempts are detected.

### Task 4: Analyze Attack Patterns

**Objective:** Analyze attack patterns in Wazuh.

**Steps:**

1. **In Wazuh Dashboard:**
   - Create timeline of attack events
   - Identify attack patterns
   - Correlate related events

2. **Document Findings:**
   - Event IDs and timestamps
   - Affected systems
   - Attack techniques used
   - Recommended mitigations

**Expected Result:** Attack pattern analysis completed.

## Verification

### Check Your Work

1. **Review Events:**
   - All attack simulations generated events
   - Events are visible in Wazuh
   - Events are properly categorized

2. **Check Alerts:**
   - Alerts were generated for suspicious activity
   - Alert severity is appropriate
   - Alerts contain relevant information

## Learning Objectives Achieved

- [ ] Understand attack simulation in lab environment
- [ ] Observe security monitoring in action
- [ ] Analyze attack patterns
- [ ] Review security event correlation
- [ ] Document security incidents

## Next Lab

[Lab 06: Incident Response](./lab-06-incident-response.md)

## Additional Resources

- [MITRE ATT&CK Framework](https://attack.mitre.org/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [Security Event Analysis](https://documentation.wazuh.com/current/user-manual/capabilities/)

