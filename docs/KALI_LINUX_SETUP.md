# Kali Linux Setup for Lab Access

This guide covers configuring Kali Linux to access the Home AD Lab network and how to switch between lab and internet access.

## Prerequisites

- Kali Linux VM installed
- VMware Workstation configured
- Lab network (VMnet2) configured
- pfSense firewall running

## Step 1: Configure Kali for Lab Network

### Network Adapter Configuration

1. **In VMware:**
   - Select Kali Linux VM
   - Go to **Settings > Network Adapter**
   - Set to **Custom: VMnet2** (lab network)
   - Ensure **"Connected"** is checked

2. **In Kali Linux:**
   - Open Network Settings
   - Create new connection or edit existing
   - Configure:
     - **IPv4 Method:** Manual
     - **Address:** 192.168.100.50 (or any available IP in 192.168.100.0/24)
     - **Netmask:** 255.255.255.0 or /24
     - **Gateway:** 192.168.100.1 (pfSense)
     - **DNS:** 192.168.100.10 (Domain Controller) or 8.8.8.8

3. **Verify Connectivity:**
   ```bash
   ping 192.168.100.1
   ping 192.168.100.10
   ```

### Access Lab Resources

- **pfSense Web Interface:** `https://192.168.100.1`
- **Domain Controller:** `192.168.100.10`
- **Wazuh Dashboard:** `https://192.168.100.20:5601`
- **Web Server:** `http://192.168.101.10`

## Step 2: Switching Between Lab and Internet Access

### Option 1: Single Adapter (Switch Between Networks)

**For Lab Access:**
1. Shut down Kali VM
2. In VMware: **Settings > Network Adapter**
3. Set to **Custom: VMnet2**
4. Power on Kali
5. Configure static IP (192.168.100.50)

**For Internet Access (TryHackMe, CTFs, etc.):**
1. Shut down Kali VM
2. In VMware: **Settings > Network Adapter**
3. Set to **NAT**
4. Power on Kali
5. Configure for DHCP (automatic IP)

### Option 2: Dual Adapters (Access Both Simultaneously)

**Configure Two Network Adapters:**
1. In VMware: **Settings**
2. **Network Adapter 1:** Custom (VMnet2) - Lab network
3. **Network Adapter 2:** NAT - Internet access
4. Click **Add** to add second adapter if needed

**In Kali Linux:**
- **eth0 (VMnet2):** Static IP 192.168.100.50 - Lab access
- **eth1 (NAT):** DHCP - Internet access

**Configure Routes:**
```bash
# Lab network traffic goes through eth0
sudo ip route add 192.168.100.0/24 dev eth0

# Default route for internet goes through eth1
sudo ip route add default via <NAT_GATEWAY> dev eth1
```

## Step 3: Quick Network Switching Script

Create a script to quickly switch between lab and internet:

**Lab Mode Script (`switch-to-lab.sh`):**
```bash
#!/bin/bash
sudo nmcli connection modify "Wired connection 1" ipv4.addresses 192.168.100.50/24
sudo nmcli connection modify "Wired connection 1" ipv4.gateway 192.168.100.1
sudo nmcli connection modify "Wired connection 1" ipv4.method manual
sudo nmcli connection up "Wired connection 1"
echo "Switched to lab network"
```

**Internet Mode Script (`switch-to-internet.sh`):**
```bash
#!/bin/bash
sudo nmcli connection modify "Wired connection 1" ipv4.method auto
sudo nmcli connection up "Wired connection 1"
echo "Switched to internet (NAT)"
```

**Make scripts executable:**
```bash
chmod +x switch-to-lab.sh switch-to-internet.sh
```

## Troubleshooting

### Cannot Ping Lab Resources

**Check:**
- Network adapter is set to VMnet2 in VMware
- Adapter is connected in VMware
- IP address is configured correctly
- Gateway is set to 192.168.100.1

**Verify:**
```bash
ip addr show
ip route show
ping 192.168.100.1
```

### NO-CARRIER Status

**Issue:** Interface shows `NO-CARRIER` or `DOWN` but networking works

**Solution:** This is normal in virtualized environments. If ping and connectivity work, you can ignore this status.

### Cannot Access Internet

**When using VMnet2 only:**
- Lab network is isolated - no internet access
- Switch to NAT adapter for internet
- Or use dual adapters (see Option 2 above)

## Best Practices

1. **Use Dual Adapters:** Best for accessing both lab and internet
2. **Document Your Setup:** Note which adapter is which
3. **Test Connectivity:** Always verify with ping before starting work
4. **Isolate When Needed:** Disable NAT adapter for complete lab isolation

## Additional Resources

- [Kali Linux Documentation](https://www.kali.org/docs/)
- [NetworkManager Documentation](https://networkmanager.dev/docs/)
- [Lab Network Diagram](../NETWORK_DIAGRAM.md)

