# pfSense Firewall Setup

This guide covers the installation and configuration of pfSense firewall for the Home AD Lab.

## Prerequisites

- VMware Workstation configured
- pfSense ISO downloaded
- Network plan completed
- Understanding of basic firewall concepts

## Step 1: Create pfSense VM

### VM Specifications

- **Name:** pfSense
- **OS Type:** FreeBSD 12.x 64-bit
- **RAM:** 512MB - 1GB
- **vCPU:** 1
- **Disk:** 8GB (thin provisioned)
- **Network Adapters:** 3 (WAN, LAN, OPT1)

### Create VM in VMware

1. Open VMware Workstation
2. Click **Create a New Virtual Machine**
3. Select **Typical** configuration
4. Choose **I will install the operating system later**
5. Select **FreeBSD 12.x 64-bit**
6. Name: `pfSense`
7. Location: Choose your lab folder
8. Disk size: 8GB, **Split virtual disk** (optional)
9. Click **Customize Hardware** before finishing

### Configure Network Adapters

1. In Hardware settings:
   - **Network Adapter 1:** NAT - This will be WAN (for internet access during installation)
   - **Network Adapter 2:** Custom (VMnet2) - This will be LAN
   - **Network Adapter 3:** Custom (VMnet2) - This will be OPT1 (DMZ)
2. Click **Finish**

**Note:** We'll configure which interface is which during pfSense installation.

### Lab Network Isolation (Optional)

For complete lab isolation, you can disable the NAT adapter after installation:

1. **After pfSense installation is complete:**
   - Shut down pfSense VM
   - In VMware, go to **Settings > Network Adapter**
   - Uncheck **"Connected"** for the NAT adapter (Network Adapter 1)
   - This isolates the lab from your host network

2. **To restore internet access:**
   - Shut down pfSense VM
   - In VMware, go to **Settings > Network Adapter**
   - Check **"Connected"** for the NAT adapter
   - Power on pfSense
   - WAN interface will get internet access via NAT

## Step 2: Install pfSense

### Mount ISO and Boot

1. Right-click pfSense VM
2. **Settings > CD/DVD**
3. Browse to pfSense ISO
4. Check **Connect at power on**
5. Power on VM

### Installation Process (GUI Installer)

The newer pfSense installer uses a graphical interface. Follow these steps:

#### Connectivity Check

1. Installer will attempt to verify internet connection
2. **Note:** On host-only networks, this will timeout (expected)
3. Wait 2-3 minutes for timeout, or press Enter/Esc to skip
4. If it asks to check network settings, you can continue anyway

#### Subscription Validation

1. Dialog appears: "Active Subscription Validation"
2. Select **[ Install CE ]** (pfSense Community Edition - free)
3. Click **OK**

#### Installation Options

1. **File System:** Select **ZFS (recommended default)**
2. **Partition Scheme:** Select **GPT (compatible with MBR)**
3. Select **Continue** and click **OK**

#### ZFS Virtual Device Type

1. Select **Stripe - No Redundancy**
   - This is fine for lab VMs (single disk, no redundancy needed)
2. Click **OK**

#### Disk Selection

1. Select **da0** (your VMware virtual disk, typically 8GB)
2. Click **OK**

#### Confirmation

1. Warning appears: "Are you sure you want to destroy the current contents?"
2. Click **[ Yes ]** to proceed
3. Installation will begin (may take several minutes)

#### Software Version Selection

1. Select **"000-2_8_1 Current Stable Version (2.8.1)"** (or latest available)
2. Click **OK**
3. Wait for installation to complete (may take 10-15 minutes)
4. **Important:** Do not interrupt the installation process
5. Installation will automatically reboot when complete

### Post-Installation Reboot

After installation completes:
1. System will automatically reboot
2. Remove or unmount the ISO in VMware (to prevent booting from ISO again)
3. System should boot from the installed ZFS filesystem
4. If you see `mountroot>` prompt, see troubleshooting section below

### Initial Interface Configuration (GUI Installer)

After reboot, the installer will continue and configure network interfaces:

#### Interface Assignment

1. Dialog: "Interface Assignment and Configuration"
2. Installer may auto-detect interfaces
3. **Important:** Verify assignments are correct:
   - **WAN:** Should be `em0`
   - **LAN:** Should be `em1`
   - **OPT1:** Should be `em2` (may show as "WAN" - this is a bug)
4. If assignments are wrong, click **[Assign/Configure]** to fix
5. Otherwise, click **[ Continue ]**

#### WAN Interface (em0) Configuration

1. Dialog: "WAN (em0) Network Mode Setup"
2. Settings:
   - **Interface Mode:** DHCP (client) ✓
   - **VLAN Settings:** VLAN Tagging disabled ✓
   - **Use local resolver:** false ✓
3. Select **Continue** and click **OK**

#### LAN Interface (em1) Configuration

1. Dialog: "LAN (em1) Network Mode Setup"
2. **Important:** Change these settings:
   - Press `I` (IP Address) → Enter: `192.168.100.1/24`
   - Press `D` (DHCPD Enabled) → Set to `false` (we'll use AD DHCP)
   - **Interface Mode:** STATIC ✓
   - **VLAN Settings:** VLAN Tagging disabled ✓
3. Select **Continue** and click **OK**

#### OPT1 Interface (em2) Configuration - DMZ

1. Dialog: "WAN (em2) Network Mode Setup" (installer may mislabel it as WAN)
2. **Important:** Configure for DMZ:
   - Press `I` (IP Address) → Enter: `192.168.101.1/24`
   - Press `G` (Default Gateway) → Leave **blank** (will show warning - this is OK)
   - Press `D` (DNS Server) → Enter: `192.168.100.10` (Domain Controller)
   - **Interface Mode:** STATIC ✓
   - **VLAN Settings:** VLAN Tagging disabled ✓
3. Click **OK** on gateway warning (OPT1 doesn't need a gateway)
4. Select **Continue** and click **OK**

**Note:** If you encounter issues with OPT1 configuration, you can skip it and configure via web interface later.

### After Interface Configuration

1. Installer will complete setup
2. System will be ready to use
3. Note the LAN IP address (should be 192.168.100.1)
4. You can now access the web interface (see Step 3 below)

### Alternative: Text-Based Installer

If you're using an older pfSense version with text-based installer:

1. Boot menu appears - select **Install**
2. Accept license agreement
3. Select keyboard layout (default is fine)
4. Select installation type: **Auto (UFS)**
5. Select disk: **da0** (or your disk)
6. Partitioning: **Guided Disk Setup**
7. Confirm installation
8. Wait for installation to complete
9. Reboot when prompted

After reboot, text-based setup wizard:
1. **Should VLANs be set up?** - **n** (No)
2. **Enter WAN interface name:** `em0`
3. **Enter LAN interface name:** `em1`
4. **Enter OPT1 interface name:** `em2`
5. Configuration complete

**Note:** Interface names vary. Use `ifconfig` to see available interfaces if unsure.

## Step 3: Configure Network Interfaces

### Access Web Interface

1. Note the LAN IP address shown (usually 192.168.1.1)
2. From host or another VM, access: `https://192.168.1.1`
3. Accept self-signed certificate
4. Default credentials:
   - **Username:** admin
   - **Password:** pfsense

### Change Default Password

1. After login, change admin password immediately
2. Go to **System > User Manager > admin**
3. Set strong password
4. Save

### Configure WAN Interface

1. Go to **Interfaces > WAN**
2. Configure:
   - **IPv4 Configuration Type:** DHCP (or Static if needed)
   - **Block private networks:** ✅ Checked
   - **Block bogon networks:** ✅ Checked
3. Save
4. Apply changes

### Configure LAN Interface

1. Go to **Interfaces > LAN**
2. Configure:
   - **IPv4 Configuration Type:** Static IPv4
   - **IPv4 Address:** 192.168.100.1
   - **Subnet:** 24 (255.255.255.0)
   - **Description:** Internal Network
3. Save
4. Apply changes

**Note:** You may need to reconnect to new IP: `https://192.168.100.1`

### Configure OPT1 Interface (DMZ)

1. Go to **Interfaces > Assignments**
2. Find **OPT1** interface
3. Click **+** to enable it
4. Go to **Interfaces > OPT1**
5. Enable interface: ✅ **Enable interface**
6. Configure:
   - **IPv4 Configuration Type:** Static IPv4
   - **IPv4 Address:** 192.168.101.1
   - **Subnet:** 24 (255.255.255.0)
   - **Description:** DMZ Network
7. Save
8. Apply changes

## Step 4: Configure Firewall Rules

### Internal Network Rules

1. Go to **Firewall > Rules > LAN**
2. Create rule for internet access:
   - **Action:** Pass
   - **Interface:** LAN
   - **Protocol:** Any
   - **Source:** LAN net (see note about source addresses below)
   - **Destination:** Any
   - **Description:** Allow Internal to Internet
3. Save
4. Apply changes

**Note on Source Addresses:**
- Always use **"LAN net"** or **"LAN subnets"** (not "LAN address")
- "LAN net" allows all devices on the network
- "LAN address" only allows the router itself

### DMZ Network Rules

1. Go to **Firewall > Rules > OPT1**
2. Create rule for internet access:
   - **Action:** Pass
   - **Interface:** OPT1
   - **Protocol:** Any
   - **Source:** OPT1 net
   - **Destination:** Any
   - **Description:** Allow DMZ to Internet
3. Save

### Internal to DMZ Rules

1. Go to **Firewall > Rules > LAN**
2. Create rule for web access:
   - **Action:** Pass
   - **Interface:** LAN
   - **Protocol:** TCP
   - **Source:** LAN net (see important note below)
   - **Destination:** OPT1 net
   - **Destination Port:** HTTP (80), HTTPS (443)
   - **Description:** Allow Internal to DMZ Web
3. Save
4. Apply changes

**Important - Source Address Selection:**
- **LAN net** = Entire LAN network (192.168.100.0/24) - Use this for allowing all devices
- **LAN address** = Only the pfSense router's IP (192.168.100.1) - Don't use this
- In the dropdown, select "LAN net" or "LAN subnets"
- If not available, select "Network" and enter `192.168.100.0/24`

### Block DMZ to Internal (Default)

DMZ to Internal is blocked by default. This means there's no rule allowing it, so it's automatically blocked.

**Important:** You won't see an explicit "Block" rule - that's normal! Firewalls block by default unless there's an explicit "Pass" rule.

**Verify blocking:**
1. Go to **Firewall > Rules > OPT1**
2. You should see "Allow DMZ to Internet" rule (this is correct)
3. There should be NO rule allowing DMZ to Internal - this means it's blocked ✓

**Add exception for DNS (optional, only if needed):**
If the web server needs to query DNS on the Domain Controller:
1. Click **Add** button in OPT1 rules
2. Create rule:
   - **Action:** Pass
   - **Interface:** OPT1
   - **Protocol:** UDP
   - **Source:** OPT1 net
   - **Destination:** 192.168.100.10 (DC)
   - **Destination Port:** DNS (53)
   - **Description:** Allow DMZ DNS to DC
3. Save
4. Apply changes

**Note:** This DNS exception is optional and can be added later if the web server needs DNS resolution.

## Step 5: Configure NAT

### Outbound NAT

1. Go to **Firewall > NAT > Outbound**
2. Mode: **Automatic outbound NAT**
3. This enables NAT for internet access
4. Save

### Port Forwarding (Optional)

If you need to access services from host:

1. Go to **Firewall > NAT > Port Forward**
2. Add rule:
   - **Interface:** WAN
   - **Protocol:** TCP
   - **Destination Port:** 8080 (example)
   - **Redirect Target IP:** 192.168.101.10
   - **Redirect Target Port:** 80
   - **Description:** Forward to Web Server
3. Save
4. Add corresponding firewall rule
5. Apply changes

## Step 6: Configure DNS

### DNS Forwarder

1. Go to **Services > DNS Resolver > General Settings**
2. Enable: ✅ **Enable DNS Resolver**
3. Configure:
   - **Network Interfaces:** **All** (must include localhost - see important note below)
   - **Outgoing Network Interfaces:** WAN
4. Save

**Important:** If you see an error "This system is configured to use the DNS Resolver as its DNS server, so Localhost or All must be selected in Network Interfaces":
- Select **"All"** in Network Interfaces (not just LAN and OPT1)
- This is required because pfSense itself needs to use the DNS Resolver
- "All" includes LAN, OPT1, and localhost, allowing pfSense to query itself

### DNS Forwarder Settings

1. Go to **Services > DNS Resolver > General Settings**
2. Scroll down to **"DNS Query Forwarding"** section
3. Add forwarders (optional, but recommended):
   - Click **Add** button
   - Enter: `8.8.8.8` (Google)
   - Click **Add** again
   - Enter: `1.1.1.1` (Cloudflare)
4. Save

**Note:** Primary DNS will be the Domain Controller (192.168.100.10) once configured. The forwarders are used for external DNS queries.

## Step 7: Configure DHCP Relay (Optional)

If not using AD DHCP, configure pfSense DHCP:

1. Go to **Services > DHCP Server > LAN**
2. Enable: ✅ **Enable DHCP server**
3. Configure:
   - **Range:** 192.168.100.100 - 192.168.100.199
   - **Default Gateway:** 192.168.100.1
   - **DNS Servers:** 192.168.100.10 (once DC is configured)
   - **Domain Name:** corp.local
4. Save

**Note:** We'll use AD DHCP, so this is optional.

## Step 8: Configure Logging to Wazuh

### Syslog Configuration

1. Go to **Status > System Logs > Settings**
2. Scroll to **Remote Logging Options**
3. Configure:
   - **Enable Remote Logging:** ✅ Checked
   - **Remote Syslog Server:** 192.168.100.20 (Wazuh)
   - **Remote Syslog Contents:** Select what to log
4. Save

**Note:** Configure this after Wazuh is set up.

## Step 9: Additional Configuration

### Time Synchronization

1. Go to **System > General Setup**
2. Configure:
   - **Timezone:** Your timezone
   - **Primary NTP Server:** pool.ntp.org
   - **Secondary NTP Server:** time.google.com
3. Save

### Hostname and Domain

1. Go to **System > General Setup**
2. Configure:
   - **Hostname:** pfsense
   - **Domain:** corp.local
3. Save

### Web Interface Settings

1. Go to **System > Advanced > Admin Access**
2. Configure:
   - **WebGUI Protocol:** HTTPS
   - **TCP Port:** 443 (default)
   - **Maximum Sessions:** 4
3. Save

## Step 10: Verification

### Test Connectivity

1. From host, ping: `ping 192.168.100.1`
2. From internal VM, ping gateway: `ping 192.168.100.1`
3. From internal VM, test internet: `ping 8.8.8.8`

### Test Firewall Rules

1. Verify internal can access internet
2. Verify DMZ can access internet
3. Verify internal can access DMZ (web ports)
4. Verify DMZ cannot access internal (except DNS)

### Check Logs

1. Go to **Status > System Logs > Firewall**
2. Verify rules are being applied
3. Check for blocked traffic

## Troubleshooting

### Cannot Access Web Interface

**Problem:** Cannot connect to pfSense web interface

**Solutions:**
- Verify VM is running
- Check IP address: `ifconfig` in pfSense console
- Verify network adapter settings in VMware
- Check firewall on host system
- Try HTTP instead of HTTPS

### Interfaces Not Showing

**Problem:** Expected interfaces not available

**Solutions:**
- Verify network adapters configured in VMware
- Check interface assignments: `Interfaces > Assignments`
- Use `ifconfig` in console to see available interfaces
- Reassign interfaces if needed

### Cannot Access Internet

**Problem:** VMs cannot access internet through pfSense

**Solutions:**
- Verify WAN interface has IP (check with `ifconfig`)
- Check NAT rules are configured
- Verify firewall rules allow traffic
- Check WAN interface is configured correctly
- Test from pfSense console: `ping 8.8.8.8`

### Firewall Rules Not Working

**Problem:** Traffic blocked when it should be allowed

**Solutions:**
- Check rule order (rules processed top to bottom)
- Verify source and destination addresses
- Check protocol and port settings
- Review firewall logs
- Ensure "Apply" was clicked after changes

### Connectivity Check Timeout

**Problem:** Installer hangs on "Trying to reach the Netgate Servers"

**Solutions:**
- This is normal on host-only networks (no internet access)
- Wait 2-3 minutes for timeout
- Press Enter or Esc to skip
- Installer will continue despite connectivity failure
- You can also temporarily switch VM network adapter to NAT during installation

### Gateway Warning for OPT1

**Problem:** "Cannot set WAN interface Default Gateway" warning for OPT1 (em2)

**Solutions:**
- This is expected - OPT1/DMZ doesn't need a default gateway
- Click OK on the warning
- Leave Default Gateway blank for OPT1
- Configure OPT1 properly via web interface after installation if needed

### Interface Assignment Issues

**Problem:** Installer assigns wrong interfaces (e.g., em2 as WAN instead of OPT1)

**Solutions:**
- Click **[Assign/Configure]** during installation to manually assign
- Or complete installation and fix via web interface: **Interfaces > Assignments**
- Reassign interfaces correctly:
  - em0 → WAN
  - em1 → LAN
  - em2 → OPT1

### Installation Fails or mountroot> Prompt Appears

**Problem:** Installation fails with "Child process terminated abnormally: Killed" or system shows `mountroot>` prompt after reboot

**Causes:**
- Out of memory (OOM killer) - most common
- Installation didn't complete successfully
- ZFS filesystem wasn't created properly

**Solutions:**

1. **Check VM Resources:**
   - Ensure VM has at least 1GB RAM (2GB recommended)
   - Verify disk has at least 8GB free space
   - Check CPU allocation

2. **If mountroot> Prompt Appears:**
   - This means installation failed and system can't find root filesystem
   - Press Enter at prompt to abort
   - Reboot and reinstall from ISO

3. **Reinstall Steps:**
   - Shut down VM completely
   - Delete the VM's virtual disk (`.vmdk` file) in VMware
   - Create new VM with fresh disk
   - Increase RAM to 2GB if it was less
   - Boot from ISO and start installation over
   - Ensure installation completes fully before rebooting

4. **Prevent Future Issues:**
   - Allocate sufficient RAM (2GB recommended)
   - Don't interrupt installation process
   - Wait for "Installation complete" message before rebooting
   - Ensure ISO is unmounted after installation to boot from disk

## Network Adapter Management

### Lab Isolation

For complete lab isolation from your host network:

**pfSense:**
- Disable the NAT adapter (Network Adapter 1) by unchecking "Connected" in VMware
- This isolates the lab network from your host
- Lab VMs can still communicate with each other via VMnet2

**Kali Linux or Other Tools:**
- If using Kali Linux for lab activities, configure it to use VMnet2 (lab network)
- Disable any NAT adapters to keep it isolated
- This ensures all traffic stays within the lab environment

### Restoring Internet Access

When you need internet access for activities like TryHackMe, CTF challenges, or updates:

**pfSense:**
1. Shut down pfSense VM
2. In VMware: **Settings > Network Adapter** (Adapter 1)
3. Check **"Connected"** for the NAT adapter
4. Power on pfSense
5. WAN interface will automatically get internet via NAT

**Kali Linux:**
1. Shut down Kali VM
2. In VMware: **Settings > Network Adapter**
3. Change from **Custom (VMnet2)** to **NAT**
4. Or add a second adapter set to **NAT** (keep VMnet2 for lab access)
5. Power on Kali
6. Configure network settings for internet access

**Note:** You can have both adapters active - one for lab (VMnet2) and one for internet (NAT). This allows you to access both the lab and internet simultaneously.

## Next Steps

Now that pfSense is configured:

1. ✅ pfSense installed and running
2. ✅ Network interfaces configured
3. ✅ Firewall rules created
4. ✅ NAT configured

**Next Guide:** [04-domain-controller-setup.md](./04-domain-controller-setup.md) - Install and configure Active Directory Domain Controller.

## Additional Resources

- [pfSense Documentation](https://docs.netgate.com/pfsense/)
- [pfSense Firewall Rules Guide](https://docs.netgate.com/pfsense/en/latest/firewall/)
- [pfSense NAT Configuration](https://docs.netgate.com/pfsense/en/latest/nat/)

