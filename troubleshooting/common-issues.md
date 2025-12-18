# Common Issues and Solutions

This guide addresses common problems encountered during Home AD Lab setup and operation.

## Network Issues

### Problem: VMs Cannot Communicate

**Symptoms:**
- Cannot ping between VMs
- Network connectivity fails
- VMs cannot reach gateway

**Solutions:**

1. **Check VMware Network Settings:**
   - Verify all VMs use the same VMnet (VMnet2)
   - Check VMnet configuration in Virtual Network Editor
   - Verify VMnet is enabled

2. **Check Network Adapter Settings:**
   - In VMware, verify network adapter is connected
   - Check adapter type (should be NAT or Host-only)
   - Verify adapter is enabled in VM settings

3. **Check IP Configuration:**
   - Verify static IPs are configured correctly
   - Check subnet masks match
   - Verify default gateway is correct

4. **Check Firewall:**
   - Verify Windows Firewall allows ICMP (for ping)
   - Check pfSense firewall rules
   - Temporarily disable firewalls for testing

5. **Check Network Adapter on Host:**
   - Verify VMware network adapter is enabled
   - Check network adapter status in Windows
   - Restart VMware network adapters if needed

### Problem: Cannot Access Internet

**Symptoms:**
- VMs cannot reach external websites
- DNS resolution fails for external domains
- Cannot download updates

**Solutions:**

1. **Check pfSense NAT:**
   - Verify NAT is enabled on WAN interface
   - Check outbound NAT rules
   - Verify WAN interface has internet access

2. **Check DNS Forwarders:**
   - Verify DNS forwarders are configured on DC
   - Test DNS resolution: `nslookup google.com`
   - Check DNS service is running

3. **Check Gateway:**
   - Verify default gateway is set correctly
   - Test gateway connectivity: `ping 192.168.100.1`
   - Verify routing table

4. **Check Host Internet:**
   - Verify host has internet access
   - Check host network adapter
   - Restart host network if needed

## Active Directory Issues

### Problem: Cannot Join Domain

**Symptoms:**
- Domain join fails with error
- "The specified domain either does not exist or could not be contacted"
- Timeout errors

**Solutions:**

1. **Check DNS Resolution:**
   - Verify DNS points to DC: `nslookup DC01.goldshire.local`
   - Check DNS service is running on DC
   - Verify forward lookup zone exists

2. **Check Time Synchronization:**
   - Verify time is synchronized: `w32tm /query /status`
   - Sync time if needed: `w32tm /resync`
   - Check time zone settings

3. **Check Network Connectivity:**
   - Verify DC is accessible: `ping 192.168.100.10`
   - Test required ports: `Test-NetConnection -ComputerName 192.168.100.10 -Port 389`
   - Check firewall rules

4. **Check Credentials:**
   - Verify domain administrator credentials
   - Use FQDN format: `GOLDSHIRE\Administrator`
   - Check account is not locked

5. **Check Domain Controller:**
   - Verify AD DS service is running
   - Check event logs for errors
   - Verify domain controller is accessible

### Problem: DNS Resolution Fails

**Symptoms:**
- Cannot resolve domain names
- "Name resolution failed" errors
- External DNS works but internal fails

**Solutions:**

1. **Check DNS Service:**
   - Verify DNS service is running: `Get-Service DNS`
   - Restart DNS service if needed
   - Check DNS event logs

2. **Check DNS Zones:**
   - Verify forward lookup zones exist
   - Check zone is active
   - Verify records exist

3. **Check DNS Forwarders:**
   - Verify forwarders are configured
   - Test forwarder connectivity
   - Add alternative forwarders if needed

4. **Check Client DNS Settings:**
   - Verify DNS server is set correctly
   - Check primary DNS is DC (192.168.100.10)
   - Flush DNS cache: `ipconfig /flushdns`

5. **Check Firewall:**
   - Verify firewall allows DNS (port 53)
   - Check both UDP and TCP ports
   - Test port connectivity

### Problem: DHCP Not Working

**Symptoms:**
- Clients not receiving IP addresses
- "No DHCP server available" errors
- Clients get APIPA addresses (169.254.x.x)

**Solutions:**

1. **Check DHCP Service:**
   - Verify service is running: `Get-Service DHCPServer`
   - Start service if stopped
   - Check service startup type

2. **Check DHCP Authorization:**
   - Verify DHCP server is authorized in AD
   - Authorize if needed: `Add-DhcpServerInDC`

3. **Check DHCP Scope:**
   - Verify scope is activated
   - Check scope range is correct
   - Verify scope options (gateway, DNS)

4. **Check Network:**
   - Verify DHCP relay is configured (if using)
   - Check network connectivity
   - Verify no conflicting DHCP servers

5. **Check Reservations:**
   - Verify reservations are correct
   - Check MAC addresses match
   - Remove conflicting reservations

## Wazuh Issues

### Problem: Wazuh Agents Not Connecting

**Symptoms:**
- Agents show as "Disconnected" in dashboard
- No events from agents
- Agent service errors

**Solutions:**

1. **Check Agent Service:**
   - Verify service is running: `Get-Service WazuhSvc`
   - Start service if stopped
   - Check service logs

2. **Check Network Connectivity:**
   - Verify manager IP is correct (192.168.100.20)
   - Test connectivity: `Test-NetConnection -ComputerName 192.168.100.20 -Port 1515`
   - Check firewall rules (1514/UDP, 1515/TCP)

3. **Check Agent Configuration:**
   - Verify manager IP in agent config
   - Check agent registration
   - Review agent logs: `C:\Program Files (x86)\ossec-agent\logs\ossec.log`

4. **Check Wazuh Manager:**
   - Verify manager service is running
   - Check manager logs
   - Verify manager is accessible

5. **Re-register Agent:**
   - Uninstall and reinstall agent
   - Verify registration during installation
   - Check agent appears in dashboard

### Problem: No Events in Wazuh Dashboard

**Symptoms:**
- Dashboard shows no events
- Agents are connected but no logs
- Events not appearing

**Solutions:**

1. **Check Agent Connectivity:**
   - Verify agents are connected
   - Check agent status in dashboard
   - Verify last keep-alive time

2. **Generate Test Events:**
   - Create test events on Windows machines
   - Check if events appear
   - Verify event collection rules

3. **Check Log Collection Rules:**
   - Verify rules are configured
   - Check rule filters
   - Review rule configuration

4. **Check Time Range:**
   - Verify time range in dashboard
   - Check time zone settings
   - Adjust time range if needed

5. **Check Wazuh Manager:**
   - Verify manager is processing events
   - Check manager logs
   - Restart manager if needed

### Problem: Cannot Access Wazuh Dashboard

**Symptoms:**
- Dashboard URL not accessible
- Connection timeout
- SSL certificate errors

**Solutions:**

1. **Check Dashboard Service:**
   - Verify service is running: `sudo systemctl status wazuh-dashboard`
   - Start service if stopped
   - Check service logs

2. **Check Network:**
   - Verify IP address is correct
   - Test connectivity: `ping 192.168.100.20`
   - Check port 5601 is open

3. **Check Firewall:**
   - Verify firewall allows port 5601
   - Check both host and VM firewalls
   - Test port connectivity

4. **Check SSL Certificate:**
   - Accept self-signed certificate
   - Check certificate validity
   - Clear browser cache if needed

5. **Check Dashboard Configuration:**
   - Verify dashboard is configured correctly
   - Check configuration files
   - Restart dashboard service

## pfSense Issues

### Problem: Cannot Access pfSense Web Interface

**Symptoms:**
- Cannot connect to web interface
- Connection refused
- Timeout errors

**Solutions:**

1. **Check pfSense Service:**
   - Verify pfSense is running
   - Check console for errors
   - Restart pfSense if needed

2. **Check IP Address:**
   - Verify LAN IP is correct (192.168.100.1)
   - Check from console: `ifconfig`
   - Verify network configuration

3. **Check Network:**
   - Verify VM network adapter is connected
   - Check VMnet configuration
   - Test connectivity: `ping 192.168.100.1`

4. **Check Web Interface:**
   - Verify web interface is enabled
   - Check port (80/443)
   - Try HTTP and HTTPS

5. **Check Firewall:**
   - Verify firewall allows web interface
   - Check anti-lockout rules
   - Review firewall rules

### Problem: Firewall Rules Not Working

**Symptoms:**
- Traffic blocked when it should be allowed
- Traffic allowed when it should be blocked
- Rules not taking effect

**Solutions:**

1. **Check Rule Order:**
   - Verify rules are in correct order
   - Rules are processed top to bottom
   - Move specific rules above general rules

2. **Check Rule Configuration:**
   - Verify source and destination addresses
   - Check protocol and port settings
   - Verify action (Pass/Block)

3. **Apply Changes:**
   - Click "Apply Changes" after modifications
   - Verify changes are saved
   - Check rule is active

4. **Check Logs:**
   - Review firewall logs
   - Check if traffic is being logged
   - Verify rule is matching traffic

5. **Test Rules:**
   - Test from different sources
   - Verify rule matches expected traffic
   - Check for conflicting rules

## General Troubleshooting Tips

### Check Logs

Always check logs when troubleshooting:

- **Windows Event Logs:** Event Viewer
- **Wazuh Logs:** Dashboard or `/var/ossec/logs/`
- **pfSense Logs:** Web interface or console
- **VMware Logs:** VM log files

### Verify Services

Check that required services are running:

- **Windows:** `Get-Service | Where-Object Status -eq Running`
- **Linux:** `systemctl status <service>`

### Test Connectivity

Use these commands to test connectivity:

- **Ping:** `ping <IP>`
- **Test-NetConnection:** `Test-NetConnection -ComputerName <IP> -Port <Port>`
- **Telnet:** `Test-NetConnection -ComputerName <IP> -Port <Port>`

### Restart Services

When in doubt, restart services:

- **Windows:** `Restart-Service <ServiceName>`
- **Linux:** `sudo systemctl restart <service>`

### Check Configuration

Verify configuration files:

- **Windows:** Check registry, GPOs, config files
- **Linux:** Check `/etc/` configuration files
- **pfSense:** Check via web interface

## Getting Additional Help

If issues persist:

1. Review component-specific documentation
2. Check component logs for detailed errors
3. Search component forums and knowledge bases
4. Review setup guides for missed steps
5. Verify all prerequisites are met

## Additional Resources

- [Windows Server Troubleshooting](https://docs.microsoft.com/en-us/windows-server/troubleshoot/)
- [Wazuh Troubleshooting](https://documentation.wazuh.com/current/user-manual/troubleshooting/)
- [pfSense Troubleshooting](https://docs.netgate.com/pfsense/en/latest/troubleshooting/)

