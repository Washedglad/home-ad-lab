# Verification and Testing

This guide provides comprehensive verification checklists and testing procedures to ensure your Home AD Lab is fully functional.

## Verification Overview

Use this guide to systematically verify:
- All components are installed correctly
- Network connectivity works
- Services are running
- Integration is complete
- Security is configured
- Monitoring is operational

## Pre-Verification Checklist

Before starting verification:

- [ ] All VMs are powered on
- [ ] All services are started
- [ ] Network adapters are connected
- [ ] Recent snapshots are available (for rollback if needed)

## Phase 1: Network Verification

### 1.1 Basic Connectivity

**Test from each VM:**

- [ ] **pfSense Gateway (192.168.100.1)**
  - [ ] Ping from DC: `Test-Connection 192.168.100.1`
  - [ ] Ping from Wazuh: `ping 192.168.100.1`
  - [ ] Ping from Client: `Test-Connection 192.168.100.1`
  - [ ] Ping from Web Server: `Test-Connection 192.168.100.1`

- [ ] **Domain Controller (192.168.100.10)**
  - [ ] Ping from Wazuh: `ping 192.168.100.10`
  - [ ] Ping from Client: `Test-Connection 192.168.100.10`
  - [ ] Ping from Web Server: `Test-Connection 192.168.100.10`

- [ ] **Wazuh SIEM (192.168.100.20)**
  - [ ] Ping from DC: `Test-Connection 192.168.100.20`
  - [ ] Ping from Client: `Test-Connection 192.168.100.20`
  - [ ] Ping from Web Server: `Test-Connection 192.168.100.20`

- [ ] **Web Server (192.168.101.10)**
  - [ ] Ping from DC: `Test-Connection 192.168.101.10`
  - [ ] Ping from Client: `Test-Connection 192.168.101.10`

- [ ] **Client Workstation (192.168.100.50)**
  - [ ] Ping from DC: `Test-Connection 192.168.100.50`
  - [ ] Ping from Wazuh: `ping 192.168.100.50`

### 1.2 Internet Connectivity

- [ ] **From Internal Network:**
  - [ ] Ping 8.8.8.8 from DC
  - [ ] Ping 8.8.8.8 from Client
  - [ ] Test DNS: `nslookup google.com`

- [ ] **From DMZ:**
  - [ ] Ping 8.8.8.8 from Web Server
  - [ ] Test DNS resolution

### 1.3 Port Connectivity

**Test required ports:**

- [ ] **Domain Controller Ports:**
  - [ ] Port 53 (DNS): `Test-NetConnection -ComputerName 192.168.100.10 -Port 53`
  - [ ] Port 389 (LDAP): `Test-NetConnection -ComputerName 192.168.100.10 -Port 389`
  - [ ] Port 445 (SMB): `Test-NetConnection -ComputerName 192.168.100.10 -Port 445`

- [ ] **Wazuh Ports:**
  - [ ] Port 1514 (UDP): `Test-NetConnection -ComputerName 192.168.100.20 -Port 1514 -Udp`
  - [ ] Port 1515 (TCP): `Test-NetConnection -ComputerName 192.168.100.20 -Port 1515`
  - [ ] Port 5601 (Dashboard): `Test-NetConnection -ComputerName 192.168.100.20 -Port 5601`

- [ ] **Web Server Ports:**
  - [ ] Port 80 (HTTP): `Test-NetConnection -ComputerName 192.168.101.10 -Port 80`
  - [ ] Port 443 (HTTPS): `Test-NetConnection -ComputerName 192.168.101.10 -Port 443`

## Phase 2: DNS Verification

### 2.1 Forward Lookup

**Test from each machine:**

- [ ] **DC01.corp.local**
  - [ ] Resolves to 192.168.100.10
  - [ ] `Resolve-DnsName DC01.corp.local` (Windows)
  - [ ] `nslookup DC01.corp.local` (Linux)

- [ ] **wazuh.corp.local**
  - [ ] Resolves to 192.168.100.20
  - [ ] `Resolve-DnsName wazuh.corp.local`

- [ ] **WEB01.corp.local**
  - [ ] Resolves to 192.168.101.10
  - [ ] `Resolve-DnsName WEB01.corp.local`

- [ ] **CLIENT01.corp.local**
  - [ ] Resolves to 192.168.100.50
  - [ ] `Resolve-DnsName CLIENT01.corp.local`

### 2.2 Reverse Lookup

- [ ] **192.168.100.10** → DC01.corp.local
- [ ] **192.168.100.20** → wazuh.corp.local
- [ ] **192.168.101.10** → WEB01.corp.local
- [ ] **192.168.100.50** → CLIENT01.corp.local

### 2.3 External DNS Resolution

- [ ] Resolve external domains (google.com, microsoft.com)
- [ ] Verify forwarders are working
- [ ] Test from multiple machines

## Phase 3: Active Directory Verification

### 3.1 Domain Services

**On Domain Controller:**

- [ ] **AD DS Service:**
  - [ ] Service is running: `Get-Service NTDS`
  - [ ] Service is set to Automatic

- [ ] **DNS Service:**
  - [ ] Service is running: `Get-Service DNS`
  - [ ] Forward lookup zones exist
  - [ ] Reverse lookup zones exist

- [ ] **DHCP Service:**
  - [ ] Service is running: `Get-Service DHCPServer`
  - [ ] Scope is activated
  - [ ] Scope is authorized

### 3.2 Domain Information

```powershell
# Run on Domain Controller
Get-ADDomain
Get-ADDomainController
Get-ADForest
```

- [ ] Domain name is `corp.local`
- [ ] Domain functional level is correct
- [ ] Forest functional level is correct
- [ ] Domain controller is listed

### 3.3 Domain Join Verification

**On Web Server and Client:**

- [ ] Computer is domain joined
- [ ] Computer appears in AD Users and Computers
- [ ] Can authenticate with domain credentials
- [ ] Group Policy is applying

### 3.4 User and Group Verification

**On Domain Controller:**

- [ ] Test users exist
- [ ] Security groups exist
- [ ] Users are in correct groups
- [ ] OUs are created correctly

## Phase 4: DHCP Verification

### 4.1 DHCP Service

- [ ] DHCP service is running
- [ ] Scope is activated
- [ ] Scope is authorized in AD

### 4.2 DHCP Functionality

**Test with new VM or release/renew:**

```powershell
# Release IP
ipconfig /release

# Renew IP
ipconfig /renew

# Check configuration
ipconfig /all
```

- [ ] Client receives IP in range 192.168.100.100-199
- [ ] Default gateway is 192.168.100.1
- [ ] DNS server is 192.168.100.10
- [ ] Domain name is corp.local

### 4.3 Reservations

- [ ] Reserved IPs are configured
- [ ] Reservations match MAC addresses
- [ ] Reserved devices get correct IPs

## Phase 5: Wazuh SIEM Verification

### 5.1 Wazuh Services

**On Wazuh Server:**

```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-dashboard
```

- [ ] Wazuh manager is running
- [ ] Wazuh dashboard is running
- [ ] Services are enabled to start on boot

### 5.2 Dashboard Access

- [ ] Dashboard is accessible: `https://192.168.100.20:5601`
- [ ] Can log in with credentials
- [ ] Dashboard loads correctly
- [ ] No errors in browser console

### 5.3 Agent Connectivity

**In Wazuh Dashboard:**

- [ ] Navigate to **Agents**
- [ ] All agents show as "Active":
  - [ ] DC01 (Domain Controller)
  - [ ] WEB01 (Web Server)
  - [ ] CLIENT01 (Client Workstation)

### 5.4 Log Collection

**Generate test events and verify:**

- [ ] Windows Event Logs are being collected
- [ ] Events appear in dashboard
- [ ] Event timestamps are correct
- [ ] Event details are complete

**Test on each Windows machine:**

```powershell
# Generate test event
Write-EventLog -LogName Application -Source "Test" -EventID 9999 -EntryType Information -Message "Test event for Wazuh"
```

- [ ] Event appears in Wazuh within reasonable time

## Phase 6: Web Server Verification

### 6.1 IIS Service

**On Web Server:**

- [ ] IIS service is running: `Get-Service W3SVC`
- [ ] Default website is started
- [ ] Test website is accessible

### 6.2 Website Access

**From Client:**

- [ ] Can access: `http://192.168.101.10`
- [ ] Can access: `http://WEB01.corp.local`
- [ ] Website loads correctly
- [ ] No errors in browser

### 6.3 IIS Logging

- [ ] IIS logging is enabled
- [ ] Logs are being created
- [ ] Logs are accessible to Wazuh (if configured)

## Phase 7: Firewall Verification

### 7.1 pfSense Firewall Rules

**On pfSense:**

- [ ] Review firewall rules
- [ ] Rules are in correct order
- [ ] Rules match network plan
- [ ] Logging is enabled

### 7.2 Firewall Functionality

**Test firewall rules:**

- [ ] Internal → Internet: Allowed
- [ ] Internal → DMZ (web): Allowed
- [ ] DMZ → Internal: Blocked (except DNS)
- [ ] DMZ → Internet: Allowed

### 7.3 Firewall Logging

- [ ] Firewall logs are being generated
- [ ] Logs are forwarded to Wazuh (if configured)
- [ ] Logs appear in Wazuh dashboard

## Phase 8: Integration Verification

### 8.1 End-to-End Scenarios

**Scenario 1: User Login**

- [ ] User logs in to CLIENT01
- [ ] Authentication succeeds
- [ ] User profile loads
- [ ] Events logged to Wazuh

**Scenario 2: Web Access**

- [ ] User accesses WEB01 from CLIENT01
- [ ] Website loads
- [ ] Firewall allows traffic
- [ ] IIS logs event
- [ ] Event appears in Wazuh

**Scenario 3: DNS Query**

- [ ] Client queries DNS
- [ ] DC resolves query
- [ ] Response returned correctly
- [ ] Query logged (if configured)

### 8.2 Log Flow Verification

- [ ] Events from all systems appear in Wazuh
- [ ] Log timestamps are synchronized
- [ ] Event correlation works
- [ ] Alerts are generated (if configured)

## Phase 9: Security Verification

### 9.1 Authentication Security

- [ ] Strong passwords are set
- [ ] Account lockout policy is configured
- [ ] Password policy is configured
- [ ] Domain authentication works

### 9.2 Network Security

- [ ] Firewall rules are restrictive
- [ ] Unnecessary ports are closed
- [ ] Network segmentation works
- [ ] DMZ is isolated from internal network

### 9.3 Monitoring Security

- [ ] All systems are monitored
- [ ] Security events are logged
- [ ] Alerts are configured
- [ ] Log retention is configured

## Phase 10: Performance Verification

### 10.1 Resource Usage

**Check on each VM:**

- [ ] CPU usage is reasonable (< 80%)
- [ ] RAM usage is reasonable
- [ ] Disk usage is reasonable
- [ ] Network usage is normal

### 10.2 Service Performance

- [ ] Services respond quickly
- [ ] No service timeouts
- [ ] No error messages in logs
- [ ] System is stable

## Verification Report Template

Document your verification results:

```markdown
# Lab Verification Report

**Date:** [Date]
**Verified By:** [Your Name]

## Network Verification
- [ ] All connectivity tests passed
- [ ] DNS resolution working
- [ ] Internet access working

## Active Directory Verification
- [ ] Domain services running
- [ ] Domain join working
- [ ] GPOs applying

## Wazuh Verification
- [ ] All agents connected
- [ ] Logs being collected
- [ ] Dashboard accessible

## Integration Verification
- [ ] End-to-end scenarios working
- [ ] All components integrated

## Issues Found
[List any issues found]

## Resolution
[How issues were resolved]
```

## Troubleshooting Failed Tests

### If Network Tests Fail

1. Check VM network adapter settings
2. Verify VMnet configuration
3. Check firewall rules
4. Verify IP addresses
5. Check routing tables

### If DNS Tests Fail

1. Verify DNS service is running
2. Check DNS zones exist
3. Verify forwarders are configured
4. Check firewall allows DNS (port 53)
5. Flush DNS cache

### If AD Tests Fail

1. Verify AD DS service is running
2. Check domain controller is accessible
3. Verify time synchronization
4. Check DNS resolution
5. Review event logs

### If Wazuh Tests Fail

1. Verify Wazuh services are running
2. Check agent connectivity
3. Verify firewall rules
4. Check agent configuration
5. Review Wazuh logs

## Next Steps

After successful verification:

1. ✅ Create baseline snapshots
2. ✅ Document any customizations
3. ✅ Export configurations
4. ✅ Begin lab exercises

**Start Learning:** [labs/lab-01-basic-ad.md](../labs/lab-01-basic-ad.md)

## Additional Resources

- [Windows Server Verification](https://docs.microsoft.com/en-us/windows-server/)
- [Wazuh Verification](https://documentation.wazuh.com/current/user-manual/)
- [Network Troubleshooting](https://docs.microsoft.com/en-us/windows-server/networking/)

