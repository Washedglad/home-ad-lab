# Lab 06: Incident Response

## Objective

Learn incident response procedures using the Home AD Lab environment, including detection, analysis, containment, and documentation.

## Prerequisites

- All lab components are configured
- Wazuh SIEM is operational
- Understanding of security concepts
- Previous labs completed

## Lab Tasks

### Task 1: Detect Security Incident

**Objective:** Identify a security incident from logs and alerts.

**Steps:**

1. **In Wazuh Dashboard:**
   - Review recent security events
   - Identify suspicious activity
   - Check for alerts

2. **Analyze Indicators:**
   - Failed login attempts
   - Unusual access patterns
   - Anomalous network traffic
   - File integrity changes

3. **Document Initial Findings:**
   - Incident type
   - Affected systems
   - Initial indicators
   - Severity assessment

**Expected Result:** Security incident identified and documented.

### Task 2: Investigate Incident

**Objective:** Conduct thorough investigation of the incident.

**Steps:**

1. **Gather Evidence:**
   - Collect relevant logs
   - Review event timelines
   - Check system configurations
   - Review firewall logs

2. **Analyze Timeline:**
   - Create chronological event timeline
   - Identify attack progression
   - Determine initial entry point
   - Map affected systems

3. **Identify Impact:**
   - Affected systems
   - Compromised accounts
   - Data accessed/modified
   - Network segments affected

**Expected Result:** Comprehensive investigation completed.

### Task 3: Contain Incident

**Objective:** Implement containment measures.

**Steps:**

1. **Isolate Affected Systems:**
   - Disconnect from network (if needed)
   - Disable affected accounts
   - Block malicious IPs in firewall

2. **Implement Controls:**
   - Update firewall rules
   - Modify GPOs for additional security
   - Enable additional logging
   - Reset compromised credentials

3. **Verify Containment:**
   - Confirm malicious activity stopped
   - Verify controls are effective
   - Monitor for continued activity

**Expected Result:** Incident is contained.

### Task 4: Document Incident

**Objective:** Create comprehensive incident report.

**Steps:**

1. **Create Incident Report:**
   - Executive summary
   - Incident timeline
   - Affected systems
   - Actions taken
   - Recommendations

2. **Include Evidence:**
   - Screenshots of events
   - Log excerpts
   - Configuration changes
   - Network diagrams

3. **Document Lessons Learned:**
   - What worked well
   - What could be improved
   - Recommendations for future

**Expected Result:** Complete incident report created.

## Verification

### Check Your Work

1. **Incident Detection:**
   - Incident was properly identified
   - Indicators were documented
   - Severity was assessed

2. **Investigation:**
   - Evidence was collected
   - Timeline was created
   - Impact was assessed

3. **Containment:**
   - Containment measures implemented
   - Incident was stopped
   - Systems are secure

4. **Documentation:**
   - Report is complete
   - Evidence is included
   - Recommendations are provided

## Learning Objectives Achieved

- [ ] Detect security incidents
- [ ] Investigate security events
- [ ] Implement containment measures
- [ ] Document incidents properly
- [ ] Understand incident response process

## Additional Resources

- [NIST Incident Response Guide](https://csrc.nist.gov/publications/detail/sp/800-61/rev-2/final)
- [SANS Incident Response](https://www.sans.org/reading-room/whitepapers/incident/incident-handlers-handbook-33901)
- [Incident Response Best Practices](https://www.cisa.gov/incident-response)

