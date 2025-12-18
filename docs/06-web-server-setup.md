# Web Server Setup

This guide covers the installation and configuration of IIS web server on Windows Server 2019/2022 in the DMZ network.

## Prerequisites

- VMware Workstation configured
- Domain Controller configured and running
- pfSense firewall configured with DMZ
- Windows Server 2019/2022 ISO downloaded
- Wazuh server configured

## Step 1: Create Web Server VM

### VM Specifications

- **Name:** WebServer or WEB01
- **OS Type:** Windows Server 2019/2022 (64-bit)
- **RAM:** 2GB - 4GB
- **vCPU:** 1-2
- **Disk:** 40GB (thin provisioned)
- **Network Adapter:** 1 (DMZ network - VMnet2, will configure in pfSense)

### Create VM in VMware

1. Open VMware Workstation
2. Click **Create a New Virtual Machine**
3. Select **Typical** configuration
4. Choose **I will install the operating system later**
5. Select **Microsoft Windows Server 2019/2022**
6. Name: `WEB01` or `WebServer`
7. Location: Choose your lab folder
8. Disk size: 40GB
9. Click **Customize Hardware** before finishing

### Configure Network Adapter

1. In Hardware settings:
   - **Network Adapter:** Custom (VMnet2)
   - **Note:** We'll configure this as DMZ in pfSense
2. Click **Finish**

## Step 2: Install Windows Server

### Mount ISO and Boot

1. Right-click WEB01 VM
2. **Settings > CD/DVD**
3. Browse to Windows Server ISO
4. Check **Connect at power on**
5. Power on VM

### Installation Process

1. Boot from ISO
2. Select language, time, keyboard
3. Click **Install Now**
4. Enter product key (or skip for evaluation)
5. Select **Windows Server 2019/2022 Standard (Desktop Experience)**
6. Accept license terms
7. Select **Custom: Install Windows only**
8. Select disk and click **Next**
9. Wait for installation
10. Set administrator password

### Initial Configuration

1. Set administrator password
2. Log in as Administrator
3. Install VMware Tools

## Step 3: Configure Network Settings

### Set Static IP Address

1. Open **Server Manager**
2. Click **Local Server**
3. Click on **Ethernet** link
4. Right-click network adapter > **Properties**
5. Select **Internet Protocol Version 4 (TCP/IPv4)**
6. Click **Properties**
7. Configure:
   - **IP Address:** 192.168.101.10
   - **Subnet Mask:** 255.255.255.0
   - **Default Gateway:** 192.168.101.1
   - **Preferred DNS:** 192.168.100.10 (Domain Controller)
   - **Alternate DNS:** 192.168.100.1 (pfSense)
8. Click **OK**

### Rename Computer

1. In **Server Manager > Local Server**
2. Click **Computer name**
3. Click **Change**
4. Computer name: `WEB01`
5. Click **OK** (restart required)

## Step 4: Join Domain

### Join to goldshire.local Domain

1. After restart, in **Server Manager > Local Server**
2. Click **Workgroup** link
3. Click **Change**
4. Select **Domain**
5. Enter: `goldshire.local`
6. Enter domain administrator credentials:
   - **Username:** GOLDSHIRE\Administrator
   - **Password:** (DC admin password)
7. Click **OK**
8. Restart when prompted

### Verify Domain Join

1. After restart, log in as `GOLDSHIRE\Administrator`
2. Open **Server Manager**
3. Verify domain shows as `goldshire.local`
4. Verify computer appears in AD:
   - On DC, open **AD Users and Computers**
   - Navigate to **Computers** container
   - Verify WEB01 is listed

## Step 5: Install IIS

### Install IIS Role

1. Open **Server Manager**
2. Click **Add roles and features**
3. **Before You Begin:** Click **Next**
4. **Installation Type:** Role-based or feature-based > **Next**
5. **Server Selection:** Select local server > **Next**
6. **Server Roles:** Check **Web Server (IIS)**
7. Click **Add Features** when prompted
8. Click **Next**
9. **Features:** Click **Next**
10. **Web Server Role (IIS):** Click **Next**
11. **Role Services:** Select:
    - ✅ **Web Server**
    - ✅ **Common HTTP Features**
      - ✅ Default Document
      - ✅ Directory Browsing
      - ✅ HTTP Errors
      - ✅ Static Content
    - ✅ **Health and Diagnostics**
      - ✅ HTTP Logging
    - ✅ **Performance**
      - ✅ Static Content Compression
    - ✅ **Security**
      - ✅ Request Filtering
      - ✅ Windows Authentication (optional)
    - ✅ **Application Development**
      - ✅ ASP.NET (if needed)
12. Click **Next**
13. **Confirmation:** Click **Install**
14. Wait for installation
15. Click **Close**

### Verify IIS Installation

1. Open web browser
2. Navigate to: `http://localhost`
3. Should see IIS default page

## Step 6: Configure IIS

### Access IIS Manager

1. Open **Server Manager > Tools > Internet Information Services (IIS) Manager**

### Create Test Website

1. In IIS Manager, expand server node
2. Right-click **Sites > Add Website**
3. Configure:
   - **Site name:** TestSite
   - **Application pool:** DefaultAppPool (or create new)
   - **Physical path:** C:\inetpub\wwwroot\TestSite
   - **Binding:**
     - **Type:** http
     - **IP address:** All Unassigned (or 192.168.101.10)
     - **Port:** 80
     - **Host name:** (leave blank)
4. Click **OK**

### Create Test Page

1. Create folder: `C:\inetpub\wwwroot\TestSite`
2. Create file: `index.html`
3. Add content:
```html
<!DOCTYPE html>
<html>
<head>
    <title>Goldshire Consulting - Internal Portal</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        h1 { color: #2c3e50; }
        .info { color: #7f8c8d; margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Goldshire Consulting</h1>
        <p>Internal Employee Portal</p>
        <div class="info">
            <p><strong>Server:</strong> WEB01.goldshire.local</p>
            <p><strong>IP:</strong> 192.168.101.10</p>
            <p><strong>Domain:</strong> goldshire.local</p>
        </div>
    </div>
</body>
</html>
```

4. Test: Navigate to `http://192.168.101.10`

### Configure Logging

1. In IIS Manager, select website
2. Double-click **Logging**
3. Configure:
   - **Format:** W3C
   - **Directory:** C:\inetpub\logs\LogFiles
   - **Log File Rollover:** Daily
4. Click **Apply**

## Step 7: Configure Windows Firewall

### Allow HTTP/HTTPS

1. Open **Windows Defender Firewall with Advanced Security**
2. Click **Inbound Rules**
3. Verify rules exist:
   - **World Wide Web Services (HTTP Traffic-In)**
   - **World Wide Web Services (HTTPS Traffic-In)**
4. If not, create new rules:
   - **Rule Type:** Port
   - **Protocol:** TCP
   - **Port:** 80, 443
   - **Action:** Allow
   - **Profile:** Domain, Private

## Step 8: Install Wazuh Agent

### Download and Install Agent

1. Download Wazuh Windows agent (see Wazuh setup guide)
2. Run installer: `wazuh-agent-4.7.0-1.msi`
3. Configure:
   - **Wazuh manager IP:** 192.168.100.20
   - **Registration port:** 1515
4. Complete installation

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

4. Verify agent is registered in Wazuh dashboard

## Step 9: Configure IIS Log Forwarding

### Enable IIS Logging

1. In IIS Manager, select website
2. Ensure **Logging** is enabled
3. Verify log format is W3C

### Configure Wazuh to Monitor IIS Logs

1. On Wazuh server, edit configuration:
```bash
sudo nano /var/ossec/etc/ossec.conf
```

2. Add or verify log monitoring:
```xml
<localfile>
  <log_format>iis</log_format>
  <location>C:\inetpub\logs\LogFiles\W3SVC*\*.log</location>
</localfile>
```

3. Restart Wazuh manager:
```bash
sudo systemctl restart wazuh-manager
```

**Note:** This configuration is typically done on the Wazuh server, but log paths need to be accessible.

## Step 10: Configure pfSense Firewall Rules

### Allow Internal to DMZ

1. On pfSense, go to **Firewall > Rules > LAN**
2. Verify rule exists:
   - **Action:** Pass
   - **Protocol:** TCP
   - **Source:** LAN net
   - **Destination:** OPT1 net
   - **Port:** HTTP (80), HTTPS (443)

### Allow DMZ to Internet

1. On pfSense, go to **Firewall > Rules > OPT1**
2. Verify rule exists:
   - **Action:** Pass
   - **Protocol:** Any
   - **Source:** OPT1 net
   - **Destination:** Any

### Block DMZ to Internal

1. Verify default block rule exists
2. Add exception for DNS if needed:
   - **Action:** Pass
   - **Protocol:** UDP
   - **Source:** OPT1 net
   - **Destination:** 192.168.100.10
   - **Port:** DNS (53)

## Step 11: Test Web Server

### Test from Internal Network

1. From client workstation or DC
2. Open web browser
3. Navigate to: `http://192.168.101.10`
4. Should see test page

### Test from DMZ

1. From web server itself
2. Test: `http://localhost`
3. Should see test page

### Test DNS Resolution

1. From any domain-joined machine:
```powershell
Resolve-DnsName -Name WEB01.goldshire.local
```

2. Should resolve to 192.168.101.10

### Test Wazuh Log Collection

1. Access Wazuh dashboard
2. Navigate to **Agents**
3. Verify WEB01 agent is connected
4. Check for IIS log events

## Step 12: Additional Configuration (Optional)

### Configure HTTPS

1. Install certificate (self-signed or from CA)
2. In IIS Manager, select website
3. Click **Bindings**
4. Add HTTPS binding:
   - **Type:** https
   - **Port:** 443
   - **SSL certificate:** Select certificate
5. Click **OK**

### Create Additional Websites

1. Create additional websites as needed
2. Configure bindings appropriately
3. Set up application pools

### Configure Application Pools

1. In IIS Manager, select **Application Pools**
2. Configure:
   - **.NET CLR Version**
   - **Managed Pipeline Mode**
   - **Identity**

## Troubleshooting

### Cannot Join Domain

**Problem:** Domain join fails

**Solutions:**
- Verify DNS points to DC (192.168.100.10)
- Check time synchronization
- Verify DC is accessible
- Check firewall rules
- Verify credentials

### Cannot Access Website

**Problem:** Website not accessible

**Solutions:**
- Verify IIS service is running
- Check website is started
- Verify firewall rules allow traffic
- Check binding configuration
- Verify network connectivity

### Wazuh Agent Not Connecting

**Problem:** Agent shows as disconnected

**Solutions:**
- Verify manager IP is correct
- Check firewall rules (1514/UDP, 1515/TCP)
- Verify agent service is running
- Check network connectivity
- Review agent logs

### DNS Resolution Fails

**Problem:** Cannot resolve WEB01.goldshire.local

**Solutions:**
- Verify DNS record exists on DC
- Check DNS forwarders
- Verify DNS service is running
- Test with nslookup

## Next Steps

Now that Web Server is configured:

1. ✅ Windows Server installed
2. ✅ Joined to domain
3. ✅ IIS installed and configured
4. ✅ Wazuh agent installed
5. ✅ Website accessible

**Next Guide:** [07-client-setup.md](./07-client-setup.md) - Install and configure client workstation.

## Additional Resources

- [IIS Documentation](https://docs.microsoft.com/en-us/iis/)
- [IIS Configuration Guide](https://docs.microsoft.com/en-us/iis/configuration/)
- [Windows Server Networking](https://docs.microsoft.com/en-us/windows-server/networking/)

