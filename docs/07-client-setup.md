# Client Workstation Setup

This guide covers the installation and configuration of a Windows 10/11 client workstation for the Home AD Lab.

## Prerequisites

- VMware Workstation configured
- Domain Controller configured and running
- Wazuh server configured
- Windows 10/11 ISO downloaded
- Network connectivity verified

## Step 1: Create Client VM

### VM Specifications

- **Name:** CLIENT01 or ClientWorkstation
- **OS Type:** Windows 10/11 (64-bit)
- **RAM:** 2GB - 4GB
- **vCPU:** 1
- **Disk:** 40GB (thin provisioned)
- **Network Adapter:** 1 (Internal network - VMnet2)

### Create VM in VMware

1. Open VMware Workstation
2. Click **Create a New Virtual Machine**
3. Select **Typical** configuration
4. Choose **I will install the operating system later**
5. Select **Microsoft Windows 10/11**
6. Name: `CLIENT01` or `ClientWorkstation`
7. Location: Choose your lab folder
8. Disk size: 40GB
9. Click **Customize Hardware** before finishing

### Configure Network Adapter

1. In Hardware settings:
   - **Network Adapter:** Custom (VMnet2)
2. Click **Finish**

## Step 2: Install Windows 10/11

### Mount ISO and Boot

1. Right-click CLIENT01 VM
2. **Settings > CD/DVD**
3. Browse to Windows 10/11 ISO
4. Check **Connect at power on**
5. Power on VM

### Installation Process

1. Boot from ISO
2. Select language, time, keyboard
3. Click **Install Now**
4. Enter product key (or skip for evaluation)
5. Select **Windows 10/11 Pro** or **Enterprise**
6. Accept license terms
7. Select **Custom: Install Windows only**
8. Select disk and click **Next**
9. Wait for installation
10. Complete initial setup (OOBE)

### Initial Configuration

1. Set up user account (local admin)
2. Complete Windows setup
3. Install VMware Tools (important)

## Step 3: Configure Network Settings

### Configure for DHCP

1. Open **Settings > Network & Internet > Ethernet**
2. Click **Change adapter options**
3. Right-click network adapter > **Properties**
4. Select **Internet Protocol Version 4 (TCP/IPv4)**
5. Click **Properties**
6. Select **Obtain an IP address automatically**
7. Select **Obtain DNS server address automatically**
8. Click **OK**

**Note:** If DHCP is configured on DC, client should get IP automatically.

### Verify Network Configuration

1. Open PowerShell
2. Check IP configuration:
```powershell
ipconfig /all
```

3. Verify:
   - IP in range: 192.168.100.100-199 (or static if reserved)
   - Default Gateway: 192.168.100.1
   - DNS: 192.168.100.10

### Test Connectivity

```powershell
# Test gateway
Test-Connection -ComputerName 192.168.100.1

# Test DNS
Test-Connection -ComputerName 192.168.100.10

# Test domain resolution
Resolve-DnsName -Name DC01.goldshire.local
```

## Step 4: Join Domain

### Join to goldshire.local Domain

1. Open **Settings > Accounts > Access work or school**
2. Click **Connect**
3. Click **Join this device to a local Active Directory domain**
4. Enter domain: `goldshire.local`
5. Enter domain administrator credentials:
   - **Username:** GOLDSHIRE\Administrator
   - **Password:** (DC admin password)
6. Click **OK**
7. Restart when prompted

### Alternative: Join via System Properties

1. Right-click **This PC > Properties**
2. Click **Change settings**
3. Click **Change**
4. Select **Domain**
5. Enter: `goldshire.local`
6. Enter credentials
7. Restart

### Verify Domain Join

1. After restart, log in as `GOLDSHIRE\Administrator` or domain user
2. Open **Settings > Accounts**
3. Verify domain shows as `goldshire.local`
4. Verify computer appears in AD:
   - On DC, open **AD Users and Computers**
   - Navigate to **Computers** container
   - Verify CLIENT01 is listed

## Step 5: Install Wazuh Agent

### Download Windows Agent

1. Download Wazuh Windows agent installer
2. Or use PowerShell:
```powershell
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.0-1.msi" -OutFile "$env:TEMP\wazuh-agent.msi"
```

### Install Agent

1. Run installer: `wazuh-agent-4.7.0-1.msi`
2. During installation:
   - **Wazuh manager IP:** 192.168.100.20
   - **Registration port:** 1515
3. Complete installation

### Start Agent Service

1. Open PowerShell as Administrator
2. Start service:
```powershell
Start-Service WazuhSvc
```

3. Verify service is running:
```powershell
Get-Service WazuhSvc
```

4. Set service to auto-start:
```powershell
Set-Service -Name WazuhSvc -StartupType Automatic
```

### Verify Agent Registration

1. Access Wazuh dashboard
2. Navigate to **Agents**
3. Verify CLIENT01 agent is connected
4. Check agent status is "Active"

## Step 6: Configure User Account

### Create Test User (Optional)

1. On Domain Controller, create test user
2. Log in to CLIENT01 with test user
3. Verify user profile is created
4. Test user permissions

### Configure Local Settings

1. Configure Windows Update settings
2. Configure Windows Defender (if needed)
3. Install common applications (optional)
4. Configure display settings

## Step 7: Test Domain Functionality

### Test Authentication

1. Log out
2. Log in with domain user
3. Verify authentication works
4. Verify user profile loads

### Test Group Policy

1. Verify GPOs are applied:
```powershell
gpresult /r
```

2. Check applied policies
3. Verify settings from GPO

### Test Network Resources

1. Test access to web server:
   - Open browser
   - Navigate to: `http://192.168.101.10`
   - Should load website

2. Test DNS resolution:
```powershell
Resolve-DnsName -Name WEB01.goldshire.local
Resolve-DnsName -Name DC01.goldshire.local
Resolve-DnsName -Name wazuh.goldshire.local
```

### Test File Sharing (if configured)

1. Access shared folder on DC or file server
2. Verify permissions work correctly

## Step 8: Verify Wazuh Log Collection

### Generate Test Events

1. Perform various activities:
   - Log in/log out
   - Access web resources
   - Run applications
   - Create/modify files

### Check Wazuh Dashboard

1. Access Wazuh dashboard
2. Navigate to **Security Events** or **Overview**
3. Verify events from CLIENT01 appear
4. Check event details

### Verify Windows Event Logs

1. Open **Event Viewer**
2. Check **Windows Logs > Security**
3. Verify events are being generated
4. Verify Wazuh agent is collecting events

## Step 9: Additional Configuration (Optional)

### Install Additional Software

1. Install browsers (Chrome, Firefox)
2. Install productivity software
3. Install security tools (optional)
4. Install development tools (optional)

### Configure Windows Features

1. Enable/disable Windows features as needed
2. Configure Windows Update
3. Configure Windows Defender

### Create Test Data

1. Create sample documents
2. Create test folders
3. Generate test files for scenarios

## Step 10: Create Snapshots

### Baseline Snapshot

1. In VMware, right-click CLIENT01 VM
2. **Snapshot > Take Snapshot**
3. Name: `Baseline - Domain Joined`
4. Description: Initial configuration with domain join and Wazuh agent

### Use Snapshots for Testing

1. Create snapshots before testing scenarios
2. Restore snapshots after testing
3. Maintain clean baseline

## Troubleshooting

### Cannot Join Domain

**Problem:** Domain join fails

**Solutions:**
- Verify DNS points to DC (192.168.100.10)
- Check time synchronization
- Verify DC is accessible
- Check firewall rules
- Verify credentials
- Check network connectivity

### Cannot Get IP from DHCP

**Problem:** Client not receiving IP address

**Solutions:**
- Verify DHCP service is running on DC
- Check DHCP scope is activated
- Verify network adapter is enabled
- Check network connectivity
- Verify reservation if using static IP

### Wazuh Agent Not Connecting

**Problem:** Agent shows as disconnected

**Solutions:**
- Verify manager IP is correct (192.168.100.20)
- Check firewall rules (1514/UDP, 1515/TCP)
- Verify agent service is running
- Check network connectivity
- Review agent logs: `C:\Program Files (x86)\ossec-agent\logs\ossec.log`

### DNS Resolution Fails

**Problem:** Cannot resolve domain names

**Solutions:**
- Verify DNS server is configured correctly
- Check DNS forwarders on DC
- Verify DNS service is running
- Test with nslookup
- Flush DNS cache: `ipconfig /flushdns`

### Group Policy Not Applying

**Problem:** GPOs not taking effect

**Solutions:**
- Force GPO update: `gpupdate /force`
- Check GPO link to OU
- Verify GPO is enabled
- Check GPO permissions
- Review GPO results: `gpresult /h report.html`

## Next Steps

Now that Client Workstation is configured:

1. ✅ Windows 10/11 installed
2. ✅ Joined to domain
3. ✅ Wazuh agent installed
4. ✅ Domain functionality tested

**Next Guide:** [08-integration.md](./08-integration.md) - Integrate all components and verify end-to-end functionality.

## Additional Resources

- [Windows 10/11 Documentation](https://docs.microsoft.com/en-us/windows/)
- [Active Directory Client Configuration](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/install-active-directory-domain-services--level-100-)
- [Wazuh Windows Agent](https://documentation.wazuh.com/current/user-manual/agent/windows-agent.html)

