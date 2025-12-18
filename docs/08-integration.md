# Component Integration

This guide covers integrating all lab components and ensuring they work together seamlessly.

## Overview

After installing all individual components, this guide helps you:
- Verify all components communicate correctly
- Configure log forwarding to Wazuh
- Test end-to-end functionality
- Ensure proper integration between components

## Integration Checklist

- [ ] All VMs are running
- [ ] Network connectivity verified
- [ ] Domain services working
- [ ] Wazuh agents connected
- [ ] Log forwarding configured
- [ ] Firewall rules verified
- [ ] DNS resolution working
- [ ] End-to-end tests passing

## Step 1: Verify Network Connectivity

### Test from Each Component

**From Domain Controller:**
```powershell
# Test gateway
Test-Connection -ComputerName 192.168.100.1

# Test Wazuh
Test-Connection -ComputerName 192.168.100.20

# Test Web Server
Test-Connection -ComputerName 192.168.101.10

# Test Client
Test-Connection -ComputerName 192.168.100.50
```

**From Wazuh Server:**
```bash
# Test gateway
ping -c 4 192.168.100.1

# Test Domain Controller
ping -c 4 192.168.100.10

# Test Web Server
ping -c 4 192.168.101.10

# Test Client
ping -c 4 192.168.100.50
```

**From Web Server:**
```powershell
# Test gateway
Test-Connection -ComputerName 192.168.101.1

# Test Domain Controller (DNS)
Test-Connection -ComputerName 192.168.100.10

# Test Wazuh
Test-Connection -ComputerName 192.168.100.20
```

**From Client:**
```powershell
# Test all components
Test-Connection -ComputerName 192.168.100.1
Test-Connection -ComputerName 192.168.100.10
Test-Connection -ComputerName 192.168.100.20
Test-Connection -ComputerName 192.168.101.10
```

## Step 2: Configure pfSense DNS (Post-AD Setup)

After your Domain Controller is installed and AD DS is configured, you need to update pfSense to use the DC as its DNS server. This ensures pfSense can resolve domain names and forward queries correctly.

### Why This Is Important

- **Active Directory requires DNS:** AD uses DNS for service discovery, authentication, and domain resolution
- **pfSense needs DNS:** pfSense itself needs DNS to resolve names and forward queries
- **Client DNS:** Clients get DNS settings from AD DHCP, but pfSense needs manual configuration

### Step 2.1: Configure pfSense's DNS Servers

1. **Access pfSense Web Interface:**
   - Navigate to: `https://192.168.100.1`
   - Log in with admin credentials

2. **Go to System > General Setup:**
   - Scroll down to **DNS Server Settings** section

3. **Configure DNS Servers:**
   - **DNS Server 1:** `192.168.100.10` (Domain Controller)
   - **DNS Server 2:** `8.8.8.8` (Google - fallback for external DNS)
   - **DNS Server 3:** `1.1.1.1` (Cloudflare - optional fallback)
   - **DNS Server 4:** (leave blank)

4. **Optional Settings:**
   - Uncheck **"Allow DNS server list to be overridden by DHCP/PPP on WAN"** (keeps DC as primary)
   - This prevents WAN DHCP from changing your DNS settings

5. **Save** the configuration

**What this does:** Makes pfSense use the Domain Controller for DNS queries. pfSense will query the DC for internal domain names (like `goldshire.local`) and forward external queries to the DC, which then forwards to external DNS servers.

### Step 2.2: Configure DNS Resolver (if not already done)

1. **Go to Services > DNS Resolver > General Settings**

2. **Enable DNS Resolver:**
   - ✅ **Enable DNS Resolver** (check the box)

3. **Configure Network Interfaces:**
   - **Network Interfaces:** Select **"All"** (important!)
   - This includes LAN, OPT1, and localhost
   - **Why:** pfSense needs to query its own DNS Resolver

4. **Configure Outgoing Interfaces:**
   - **Outgoing Network Interfaces:** WAN (or leave default)
   - This is where external queries go

5. **Configure DNS Query Forwarding:**
   - Scroll to **"DNS Query Forwarding"** section
   - Click **Add** button
   - Enter: `8.8.8.8` (Google DNS)
   - Click **Add** again
   - Enter: `1.1.1.1` (Cloudflare DNS)
   - These forward external queries while DC handles internal queries

6. **Save** the configuration

**Important Note:** If you see an error "This system is configured to use the DNS Resolver as its DNS server, so Localhost or All must be selected in Network Interfaces":
- Change **Network Interfaces** to **"All"** (not just specific interfaces)
- This is required because pfSense uses its own DNS Resolver

### Step 2.3: Verify DNS Configuration

1. **Test from pfSense Console:**
   - Access pfSense console (VM console or SSH)
   - Type `8` for Shell
   - Test DNS resolution:
     ```bash
     nslookup DC01.goldshire.local 192.168.100.10
     nslookup google.com
     ```

2. **Test from Web Interface:**
   - Go to **Diagnostics > DNS Lookup**
   - Test internal domain: `DC01.goldshire.local`
   - Should resolve to `192.168.100.10`
   - Test external domain: `google.com`
   - Should resolve to Google's IP

3. **Check DNS Resolver Status:**
   - Go to **Status > Services**
   - Verify **unbound** (DNS Resolver) service is running

### Step 2.4: Add DNS Records for Web Server (Optional)

If you want to access your web server by name instead of IP:

1. **On Domain Controller:**
   - Open **DNS Manager** (dnsmgmt.msc)
   - Navigate to **Forward Lookup Zones > goldshire.local**
   - Right-click → **New Host (A or AAAA)**
   - **Name:** `www` (or `web`, `portal`, etc.)
   - **IP Address:** `192.168.101.10` (your web server IP)
   - Check **"Create associated pointer (PTR) record"** (optional)
   - Click **Add Host**

2. **Test from pfSense:**
   - Go to **Diagnostics > DNS Lookup**
   - Test: `www.goldshire.local`
   - Should resolve to `192.168.101.10`

3. **Test from Client:**
   ```powershell
   Resolve-DnsName -Name www.goldshire.local
   ```

### Summary

After completing this step:
- ✅ pfSense uses DC (192.168.100.10) as primary DNS
- ✅ DNS Resolver is enabled and forwarding external queries
- ✅ pfSense can resolve internal domain names (goldshire.local)
- ✅ pfSense can resolve external domain names (via forwarders)
- ✅ Optional: Web server accessible by name (www.goldshire.local)

**Note:** Client VMs get DNS settings automatically from AD DHCP, so they don't need manual configuration. Only pfSense needs this manual DNS configuration.

## Step 3: Verify DNS Resolution

### Test DNS from All Machines

**From Domain Controller:**
```powershell
Resolve-DnsName -Name DC01.goldshire.local
Resolve-DnsName -Name wazuh.goldshire.local
Resolve-DnsName -Name WEB01.goldshire.local
Resolve-DnsName -Name CLIENT01.goldshire.local
```

**From Wazuh Server:**
```bash
nslookup DC01.goldshire.local 192.168.100.10
nslookup WEB01.goldshire.local 192.168.100.10
nslookup CLIENT01.goldshire.local 192.168.100.10
```

**From Web Server:**
```powershell
Resolve-DnsName -Name DC01.goldshire.local
Resolve-DnsName -Name wazuh.goldshire.local
```

**From Client:**
```powershell
Resolve-DnsName -Name DC01.goldshire.local
Resolve-DnsName -Name WEB01.goldshire.local
Resolve-DnsName -Name wazuh.goldshire.local
```

### Verify Reverse DNS

```powershell
Resolve-DnsName -Name 192.168.100.10 -Type PTR
Resolve-DnsName -Name 192.168.100.20 -Type PTR
Resolve-DnsName -Name 192.168.101.10 -Type PTR
```

## Step 4: Verify Domain Services

### Test Domain Authentication

1. **From Client:**
   - Log out
   - Log in with domain user
   - Verify authentication works
   - Verify user profile loads

2. **From Web Server:**
   - Verify domain join status
   - Test domain authentication

### Test Group Policy

1. **From Client:**
```powershell
# Force GPO update
gpupdate /force

# Check applied policies
gpresult /r

# Generate HTML report
gpresult /h C:\gpresult.html
```

2. Verify GPOs are applying correctly

### Test Domain Resources

1. **Access shared resources** (if configured)
2. **Test domain user permissions**
3. **Verify OU structure**

## Step 5: Configure Wazuh Agent Integration

### Verify All Agents Are Connected

1. Access Wazuh dashboard: `https://192.168.100.20:5601`
2. Navigate to **Agents**
3. Verify all agents show as "Active":
   - DC01 (Domain Controller)
   - WEB01 (Web Server)
   - CLIENT01 (Client Workstation)

### Configure Agent Groups (Optional)

1. In Wazuh dashboard, go to **Management > Groups**
2. Create groups:
   - **Windows Servers** (DC01, WEB01)
   - **Windows Clients** (CLIENT01)
3. Assign agents to groups

### Verify Log Collection

1. In Wazuh dashboard, go to **Security Events**
2. Verify events from all agents appear
3. Check event details and timestamps

## Step 6: Configure Log Forwarding

### Windows Event Log Forwarding

**On Domain Controller:**
1. Verify Wazuh agent is collecting events
2. Check agent configuration if needed

**On Web Server:**
1. Verify IIS logs are accessible
2. Configure Wazuh to monitor IIS logs (if not automatic)

**On Client:**
1. Verify Windows Event Logs are being collected
2. Test by generating test events

### pfSense Syslog Forwarding

1. **On pfSense:**
   - Go to **Status > System Logs > Settings**
   - Configure remote logging to 192.168.100.20:514
   - Enable syslog forwarding

2. **On Wazuh Server:**
   - Verify syslog reception is configured
   - Check for pfSense logs in dashboard

### Verify Log Flow

1. Generate test events on each system
2. Verify events appear in Wazuh dashboard
3. Check event correlation works
4. Verify alerts are generated (if configured)

## Step 7: Configure Firewall Integration

### Verify Firewall Rules

1. **On pfSense:**
   - Review all firewall rules
   - Verify rules are working as expected
   - Check firewall logs

2. **Test Firewall Rules:**
   - Internal → Internet: Should work
   - Internal → DMZ: Should work (web ports)
   - DMZ → Internal: Should be blocked (except DNS)
   - DMZ → Internet: Should work

### Configure Firewall Logging

1. **On pfSense:**
   - Enable logging for all rules
   - Configure syslog forwarding to Wazuh
   - Verify logs appear in Wazuh

2. **In Wazuh:**
   - Verify firewall logs are being received
   - Create rules for firewall events
   - Set up alerts for suspicious activity

## Step 8: Test End-to-End Scenarios

### Scenario 1: User Authentication Flow

1. User logs in to CLIENT01
2. Authentication request goes to DC01
3. DC01 validates credentials
4. User session established
5. Events logged to Wazuh

**Verify:**
- Authentication succeeds
- Events appear in Wazuh
- User can access resources

### Scenario 2: Web Access Flow

1. User on CLIENT01 accesses WEB01
2. Request goes through pfSense
3. pfSense allows (internal to DMZ rule)
4. WEB01 serves content
5. IIS logs event
6. Event forwarded to Wazuh

**Verify:**
- Website is accessible
- Firewall allows traffic
- Logs appear in Wazuh

### Scenario 3: DNS Resolution Flow

1. CLIENT01 requests DNS resolution
2. Request goes to DC01 (DNS server)
3. DC01 resolves or forwards
4. Response returned to CLIENT01

**Verify:**
- DNS resolution works
- Forwarders work correctly
- Reverse DNS works

### Scenario 4: Log Collection Flow

1. Event occurs on any system
2. Wazuh agent collects event
3. Agent forwards to Wazuh manager
4. Manager processes and stores
5. Dashboard displays event

**Verify:**
- Events are collected
- Events appear in dashboard
- Timestamps are correct
- Event details are complete

## Step 9: Configure Monitoring and Alerts

### Set Up Wazuh Alerts

1. **In Wazuh Dashboard:**
   - Navigate to **Management > Rules**
   - Review default rules
   - Create custom rules as needed

2. **Configure Alert Thresholds:**
   - Set up alerts for failed logins
   - Configure alerts for suspicious activity
   - Set up alerts for system changes

### Create Custom Dashboards

1. **In Wazuh Dashboard:**
   - Create custom visualizations
   - Build dashboards for specific scenarios
   - Set up monitoring views

### Configure Email Alerts (Optional)

1. **On Wazuh Server:**
   - Configure email settings
   - Test email alerts
   - Verify alerts are sent

## Step 10: Performance Verification

### Check Resource Usage

1. **On Each VM:**
   - Monitor CPU usage
   - Monitor RAM usage
   - Monitor disk usage
   - Monitor network usage

2. **Optimize if Needed:**
   - Adjust resource allocation
   - Clean up unnecessary files
   - Optimize services

### Test Under Load

1. Generate test traffic
2. Monitor system performance
3. Verify all systems handle load
4. Check for bottlenecks

## Step 11: Security Verification

### Verify Security Posture

1. **Check Firewall Rules:**
   - Verify rules are restrictive
   - Check for unnecessary open ports
   - Verify logging is enabled

2. **Check Authentication:**
   - Verify strong passwords
   - Check account lockout policies
   - Verify GPO security settings

3. **Check Monitoring:**
   - Verify all systems are monitored
   - Check alerting is configured
   - Verify log retention

## Troubleshooting Integration Issues

### Common Issues

1. **Agents Not Connecting:**
   - Check firewall rules
   - Verify network connectivity
   - Check agent configuration

2. **Logs Not Appearing:**
   - Verify agent is connected
   - Check log collection rules
   - Verify service is running

3. **DNS Resolution Fails:**
   - Check DNS service
   - Verify forwarders
   - Check firewall rules

4. **Authentication Fails:**
   - Verify time synchronization
   - Check DNS resolution
   - Verify DC is accessible

## Next Steps

Now that all components are integrated:

1. ✅ All components communicating
2. ✅ Log forwarding configured
3. ✅ End-to-end tests passing
4. ✅ Monitoring configured

**Next Guide:** [09-verification.md](./09-verification.md) - Complete verification and testing checklist.

## Additional Resources

- [Wazuh Integration Guide](https://documentation.wazuh.com/current/user-manual/capabilities/)
- [Active Directory Integration](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/)
- [Network Troubleshooting](https://docs.microsoft.com/en-us/windows-server/networking/)

