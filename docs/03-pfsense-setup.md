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
   - **Network Adapter 1:** Custom (VMnet2) - This will be WAN
   - **Network Adapter 2:** Custom (VMnet2) - This will be LAN
   - **Network Adapter 3:** Custom (VMnet2) - This will be OPT1 (DMZ)
2. Click **Finish**

**Note:** We'll configure which interface is which during pfSense installation.

## Step 2: Install pfSense

### Mount ISO and Boot

1. Right-click pfSense VM
2. **Settings > CD/DVD**
3. Browse to pfSense ISO
4. Check **Connect at power on**
5. Power on VM

### Installation Process

1. Boot menu appears - select **Install**
2. Accept license agreement
3. Select keyboard layout (default is fine)
4. Select installation type: **Auto (UFS)**
5. Select disk: **da0** (or your disk)
6. Partitioning: **Guided Disk Setup**
7. Confirm installation
8. Wait for installation to complete
9. Reboot when prompted

### Initial Configuration

After reboot, pfSense will start the setup wizard:

1. **Should VLANs be set up?** - **n** (No)
2. **Enter WAN interface name:** 
   - Type: `em0` (or check what interfaces are available)
   - Common: `em0`, `vtnet0`, or `hn0`
3. **Enter LAN interface name:**
   - Type: `em1` (next interface)
4. **Enter OPT1 interface name:**
   - Type: `em2` (third interface)
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
   - **Source:** LAN net
   - **Destination:** Any
   - **Description:** Allow Internal to Internet
3. Save
4. Apply changes

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
   - **Source:** LAN net
   - **Destination:** OPT1 net
   - **Destination Port:** HTTP (80), HTTPS (443)
   - **Description:** Allow Internal to DMZ Web
3. Save
4. Apply changes

### Block DMZ to Internal (Default)

DMZ to Internal is blocked by default. Verify:

1. Go to **Firewall > Rules > OPT1**
2. Default rule should be **Block**
3. Add exception for DNS if needed:
   - **Action:** Pass
   - **Interface:** OPT1
   - **Protocol:** UDP
   - **Source:** OPT1 net
   - **Destination:** 192.168.100.10 (DC)
   - **Destination Port:** DNS (53)
   - **Description:** Allow DMZ DNS to DC
4. Save
5. Apply changes

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

1. Go to **Services > DNS Resolver**
2. Enable: ✅ **Enable DNS Resolver**
3. Configure:
   - **Network Interfaces:** LAN, OPT1
   - **Outgoing Network Interfaces:** WAN
4. Save

### DNS Forwarder Settings

1. Go to **Services > DNS Resolver > General Settings**
2. Add forwarders (optional):
   - 8.8.8.8 (Google)
   - 1.1.1.1 (Cloudflare)
3. Save

**Note:** Primary DNS will be the Domain Controller (192.168.100.10) once configured.

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

