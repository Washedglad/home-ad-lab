# Domain Controller Setup

This guide covers the installation and configuration of Active Directory Domain Services (AD DS) on Windows Server 2019/2022.

## Prerequisites

- VMware Workstation configured
- pfSense firewall running
- Windows Server 2019/2022 ISO downloaded
  - Download from [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)
  - Evaluation key available on download page (180-day evaluation)
- Network plan completed

## Step 1: Create Domain Controller VM

### VM Specifications

- **Name:** DomainController or DC01
- **OS Type:** Windows Server 2019/2022 (64-bit)
- **RAM:** 4GB - 8GB
- **vCPU:** 2
- **Disk:** 60GB (thin provisioned)
- **Network Adapter:** 1 (Internal network - VMnet2)

### Create VM in VMware

1. Open VMware Workstation
2. Click **Create a New Virtual Machine**
3. Select **Typical** configuration
4. Choose **I will install the operating system later** (recommended) OR use Easy Install
5. Select **Microsoft Windows Server 2019/2022**
6. Name: `DC01` or `DomainController`
7. Location: Choose your lab folder
8. Disk size: 60GB
9. **If using Easy Install:**
   - **Windows product key:** Enter evaluation key from [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)
   - **Version:** Windows Server 2019 Datacenter (or Standard)
   - **Full name:** (optional)
   - **Password:** Set administrator password
10. Click **Customize Hardware** before finishing

### Configure Network Adapter

1. In Hardware settings:
   - **Network Adapter:** Custom (VMnet2)
2. Click **Finish**

## Step 2: Install Windows Server

### Mount ISO and Boot

1. Right-click DC01 VM
2. **Settings > CD/DVD**
3. Browse to Windows Server ISO
4. Check **Connect at power on**
5. Power on VM

### Installation Process

1. Boot from ISO
2. Select language, time, keyboard
3. Click **Install Now**
4. **Product Key:**
   - **Option 1 (Evaluation - No Key):** Click **I don't have a product key** to use 180-day evaluation
   - **Option 2 (Evaluation Key):** Get evaluation key from [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2019)
     - Select Windows Server 2019 (or 2022)
     - Register and download evaluation ISO
     - Evaluation key is provided on the download page
     - Valid for 180 days, can be rearmed up to 5 times (total ~3 years)
   - **Option 3 (VMware Easy Install):** If using VMware's Easy Install, enter evaluation key in the wizard
5. Select **Windows Server 2019/2022 Standard (Desktop Experience)** or **Datacenter**
6. Accept license terms
7. Select **Custom: Install Windows only**
8. Select disk and click **Next**
9. Wait for installation (20-30 minutes)
10. Set administrator password when prompted

### Initial Configuration

1. Set administrator password (use strong password)
2. Log in as Administrator
3. Install VMware Tools (important for performance)

## Step 3: Configure Network Settings

### Set Static IP Address

1. Open **Server Manager**
2. Click **Local Server**
3. Click on **Ethernet** link
4. Right-click network adapter > **Properties**
5. Select **Internet Protocol Version 4 (TCP/IPv4)**
6. Click **Properties**
7. Configure:
   - **IP Address:** 192.168.100.10
   - **Subnet Mask:** 255.255.255.0
   - **Default Gateway:** 192.168.100.1
   - **Preferred DNS:** 127.0.0.1 (will be DC itself)
   - **Alternate DNS:** 192.168.100.1 (pfSense)
8. Click **OK**

### Rename Computer

1. In **Server Manager > Local Server**
2. Click **Computer name**
3. Click **Change**
4. Computer name: `DC01`
5. Click **OK** (restart required)

### Configure Windows Firewall

1. Open **Windows Defender Firewall with Advanced Security**
2. For lab purposes, you can disable firewall or configure rules
3. Recommended: Configure rules to allow required ports

## Step 4: Install Active Directory Domain Services

### Install AD DS Role

1. Open **Server Manager**
2. Click **Add roles and features**
3. **Before You Begin:** Click **Next**
4. **Installation Type:** Role-based or feature-based > **Next**
5. **Server Selection:** Select local server > **Next**
6. **Server Roles:** Check **Active Directory Domain Services**
7. Click **Add Features** when prompted
8. Click **Next**
9. **Features:** Click **Next** (no additional features needed)
10. **AD DS:** Review information > **Next**
11. **Confirmation:** Click **Install**
12. Wait for installation to complete
13. Click **Close**

### Promote to Domain Controller

1. In **Server Manager**, click **Notifications** (flag icon)
2. Click **Promote this server to a domain controller**
3. **Deployment Configuration:**
   - **Deployment Operation:** Add a new forest
   - **Root domain name:** `goldshire.local`
4. Click **Next**
5. **Domain Controller Options:**
   - **Forest functional level:** Windows Server 2016 or 2019
   - **Domain functional level:** Windows Server 2016 or 2019
   - **Domain Name System (DNS) server:** ✅ Checked
   - **Global Catalog (GC):** ✅ Checked (default)
   - **Read-only domain controller (RODC):** ❌ Unchecked
   - **DSRM Password:** Set strong password
6. Click **Next**
7. **DNS Options:** Warning about delegation - Click **Next** (OK for lab)
8. **Additional Options:** NetBIOS name: `GOLDSHIRE` (default) > **Next**
9. **Paths:** Accept defaults or customize > **Next**
10. **Review Options:** Review configuration > **Next**
11. **Prerequisites Check:** Should pass > Click **Install**
12. Server will restart automatically

### Verify Domain Controller

1. After restart, log in as `GOLDSHIRE\Administrator`
2. Open **Server Manager**
3. Verify **AD DS** role is installed
4. Open **Active Directory Users and Computers**
5. Verify domain `goldshire.local` is visible

## Step 5: Configure DNS

### Verify DNS Installation

1. Open **Server Manager > Tools > DNS**
2. Verify `DC01.goldshire.local` is listed
3. Verify forward lookup zone `goldshire.local` exists
4. Verify reverse lookup zone exists

### Create DNS Records

1. In **DNS Manager**, expand **DC01 > Forward Lookup Zones > goldshire.local**
2. Right-click **goldshire.local > New Host (A or AAAA)**
3. Create records:
   - **wazuh:** 192.168.100.20
   - **CLIENT01:** 192.168.100.50
   - **WEB01:** 192.168.101.10
   - **pfsense:** 192.168.100.1 (optional)

### Configure DNS Forwarders

1. In **DNS Manager**, right-click **DC01 > Properties**
2. Go to **Forwarders** tab
3. Click **Edit**
4. Add forwarders:
   - 8.8.8.8 (Google)
   - 1.1.1.1 (Cloudflare)
5. Click **OK**

### Create Reverse Lookup Zones

1. In **DNS Manager**, right-click **Reverse Lookup Zones**
2. **New Zone**
3. **Zone Type:** Primary zone > **Next**
4. **Active Directory Zone Replication Scope:** To all DNS servers > **Next**
5. **Reverse Lookup Zone Name:** IPv4 Reverse Lookup Zone > **Next**
6. **Network ID:** 192.168.100 > **Next**
7. **Dynamic Update:** Allow both > **Next**
8. **Finish**
9. Repeat for 192.168.101.0/24 network

## Step 6: Configure DHCP

### Install DHCP Role

1. Open **Server Manager**
2. Click **Add roles and features**
3. Follow wizard:
   - **Server Roles:** Check **DHCP Server**
   - Click **Add Features** when prompted
4. Complete installation

### Configure DHCP

1. Open **Server Manager > Tools > DHCP**
2. Right-click **DC01.goldshire.local > Authorize** (if needed)
3. Expand **DC01 > IPv4**
4. Right-click **IPv4 > New Scope**
5. **Scope Wizard:**
   - **Name:** Internal Network
   - **Description:** DHCP scope for internal network
   - **IP Address Range:** 192.168.100.100 - 192.168.100.199
   - **Subnet Mask:** 255.255.255.0
   - **Exclusions:** None (or exclude specific IPs)
   - **Lease Duration:** 8 days
   - **Router (Default Gateway):** 192.168.100.1
   - **Domain Name:** goldshire.local
   - **DNS Servers:** 192.168.100.10
   - **WINS Servers:** None
   - **Activate scope:** Yes
6. Complete wizard

### Create Reservations

1. In **DHCP Manager**, expand **Scope > Reservations**
2. Right-click **Reservations > New Reservation**
3. Create reservations:
   - **wazuh:** 192.168.100.20 (MAC address from VM)
   - **CLIENT01:** 192.168.100.50 (MAC address from VM)
   - **WEB01:** 192.168.101.10 (MAC address from VM)

## Step 7: Create Organizational Units

### Create OU Structure

1. Open **Active Directory Users and Computers**
2. Right-click **goldshire.local > New > Organizational Unit**
3. Create OUs:
   - **Computers**
     - **Servers**
     - **Workstations**
   - **Users**
     - **IT**
     - **Sales**
     - **Management**
   - **Groups**

### Move Default Containers (Optional)

1. Right-click **Computers** container > **Move**
2. Move to **Computers > Servers** or **Workstations**

## Step 8: Create Users and Groups

### Create User Accounts

1. In **AD Users and Computers**, navigate to **Users** OU
2. Right-click **Users > New > User**
3. Create sample users:
   - **IT Users:**
     - `itadmin` - IT Administrator
     - `itsupport` - IT Support
   - **Sales Users:**
     - `sales1` - Sales Representative
     - `sales2` - Sales Representative
   - **Management:**
     - `manager1` - Manager

### Create Security Groups

1. Right-click **Groups > New > Group**
2. Create groups:
   - **IT_Admins** - IT Administrators
   - **IT_Support** - IT Support Staff
   - **Sales_Team** - Sales Department
   - **Managers** - Management Team
   - **Domain_Users** - All domain users

### Add Users to Groups

1. Right-click group > **Properties > Members**
2. Add appropriate users to groups

## Step 9: Configure Group Policy (Basic)

### Create GPO

1. Open **Group Policy Management**
2. Right-click **goldshire.local > Create a GPO in this domain, and Link it here**
3. Name: `Default Domain Policy - Lab`
4. Right-click GPO > **Edit**

### Configure Basic Settings

1. **Computer Configuration > Policies > Administrative Templates:**
   - Configure password policy
   - Configure account lockout policy
2. **User Configuration:**
   - Configure desktop settings
   - Configure software restrictions

### Link GPO to OUs

1. Right-click OU > **Link an Existing GPO**
2. Select GPO to link

## Step 10: Time Synchronization

### Configure Time Service

1. Open PowerShell as Administrator
2. Run:
```powershell
w32tm /config /manualpeerlist:"pool.ntp.org" /syncfromflags:manual /reliable:YES /update
w32tm /resync
```

### Verify Time Sync

```powershell
w32tm /query /status
```

## Step 11: Verification

### Test DNS Resolution

```powershell
# Test forward lookup
Resolve-DnsName -Name DC01.goldshire.local

# Test reverse lookup
Resolve-DnsName -Name 192.168.100.10 -Type PTR
```

### Test Domain Services

```powershell
# Test domain controller
Test-ComputerSecureChannel -Verbose

# Get domain info
Get-ADDomain

# List domain controllers
Get-ADDomainController
```

### Test DHCP

1. Create test VM or use existing
2. Configure to get IP via DHCP
3. Verify IP in range 192.168.100.100-199
4. Verify DNS settings are correct

## Troubleshooting

### Cannot Promote to Domain Controller

**Problem:** Prerequisites check fails

**Solutions:**
- Verify static IP is configured
- Verify DNS points to 127.0.0.1
- Check time synchronization
- Verify no duplicate domain names
- Check disk space

### DNS Not Working

**Problem:** Cannot resolve domain names

**Solutions:**
- Verify DNS service is running
- Check DNS forwarders are configured
- Verify DNS zones are created
- Check firewall allows DNS (port 53)
- Test with `nslookup`

### DHCP Not Working

**Problem:** Clients not getting IP addresses

**Solutions:**
- Verify DHCP service is running
- Authorize DHCP server in AD
- Verify scope is activated
- Check scope options (gateway, DNS)
- Verify no conflicts with pfSense DHCP

### Cannot Join Domain

**Problem:** Other machines cannot join domain

**Solutions:**
- Verify DNS resolution works
- Check time synchronization
- Verify firewall allows required ports
- Check domain controller is accessible
- Verify credentials are correct

## Next Steps

Now that Domain Controller is configured:

1. ✅ Windows Server installed
2. ✅ AD DS installed and configured
3. ✅ DNS configured
4. ✅ DHCP configured
5. ✅ Basic OUs, users, and groups created

**Next Guide:** [05-wazuh-setup.md](./05-wazuh-setup.md) - Install and configure Wazuh SIEM.

## Additional Resources

- [Microsoft AD DS Documentation](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)
- [DNS Configuration Guide](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/reviewing-dns-concepts)
- [DHCP Configuration Guide](https://docs.microsoft.com/en-us/windows-server/networking/technologies/dhcp/dhcp-top)

