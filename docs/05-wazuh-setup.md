# Wazuh SIEM Setup

This guide covers the installation and configuration of Wazuh SIEM on Ubuntu 22.04 LTS.

## Prerequisites

- VMware Workstation configured
- Domain Controller configured and running
- Ubuntu 22.04 LTS ISO downloaded
- Network connectivity verified
- Understanding of basic Linux commands

## Step 1: Create Wazuh VM

### VM Specifications

- **Name:** Wazuh
- **OS Type:** Ubuntu 64-bit
- **RAM:** 4GB - 8GB
- **vCPU:** 2
- **Disk:** 40GB (thin provisioned)
- **Network Adapter:** 1 (Internal network - VMnet2)

### Create VM in VMware

1. Open VMware Workstation
2. Click **Create a New Virtual Machine**
3. Select **Typical** configuration
4. Choose **I will install the operating system later**
5. Select **Ubuntu 64-bit**
6. Name: `Wazuh`
7. Location: Choose your lab folder
8. Disk size: 40GB
9. Click **Customize Hardware** before finishing

### Configure Network Adapter

1. In Hardware settings:
   - **Network Adapter:** Custom (VMnet2)
2. Click **Finish**

## Step 2: Install Ubuntu Server

### Mount ISO and Boot

1. Right-click Wazuh VM
2. **Settings > CD/DVD**
3. Browse to Ubuntu 22.04 LTS ISO
4. Check **Connect at power on**
5. Power on VM

### Installation Process

1. Boot from ISO
2. Select **Install Ubuntu Server**
3. **Keyboard:** Select your layout
4. **Network:** Configure if needed (will use DHCP initially)
5. **Proxy:** Leave blank
6. **Archive mirror:** Use default
7. **Storage:** Use entire disk
8. **Profile setup:**
   - **Name:** wazuh (or your choice)
   - **Server name:** wazuh
   - **Username:** wazuh (or your choice)
   - **Password:** Set strong password
9. **SSH Setup:** Install OpenSSH server (recommended)
10. **Snaps:** Select or skip
11. Wait for installation
12. Reboot when prompted

### Initial Configuration

1. Log in with created user
2. Update system:
```bash
sudo apt update
sudo apt upgrade -y
```

## Step 3: Configure Network Settings

### Set Static IP Address

1. Edit network configuration:
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

2. Configure (adjust interface name if needed):
```yaml
network:
  version: 2
  renderer: networkd
  ethernets:
    ens33:  # Change to your interface name (use ip a to check)
      dhcp4: no
      addresses:
        - 192.168.100.20/24
      routes:
        - to: default
          via: 192.168.100.1
      nameservers:
        addresses:
          - 192.168.100.10
          - 192.168.100.1
```

3. Apply configuration:
```bash
sudo netplan apply
```

4. Verify IP address:
```bash
ip addr show
```

### Configure Hostname

1. Edit hostname:
```bash
sudo hostnamectl set-hostname wazuh
```

2. Add to hosts file:
```bash
sudo nano /etc/hosts
```

3. Add line:
```
192.168.100.20 wazuh wazuh.corp.local
```

## Step 4: Install Wazuh Manager

### Add Wazuh Repository

1. Install prerequisites:
```bash
sudo apt-get install curl apt-transport-https lsb-release gnupg2 -y
```

2. Add Wazuh repository:
```bash
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | sudo gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import && sudo chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | sudo tee -a /etc/apt/sources.list.d/wazuh.list
```

3. Update package list:
```bash
sudo apt-get update
```

### Install Wazuh Manager

1. Install Wazuh manager:
```bash
sudo WAZUH_MANAGER="192.168.100.20" apt-get install wazuh-manager
```

2. Check service status:
```bash
sudo systemctl status wazuh-manager
```

3. Enable service:
```bash
sudo systemctl enable wazuh-manager
sudo systemctl start wazuh-manager
```

## Step 5: Install Wazuh Dashboard

### Install Wazuh Dashboard

1. Install Wazuh dashboard:
```bash
sudo WAZUH_MANAGER="192.168.100.20" apt-get install wazuh-dashboard
```

2. Start and enable service:
```bash
sudo systemctl daemon-reload
sudo systemctl enable wazuh-dashboard
sudo systemctl start wazuh-dashboard
```

3. Check status:
```bash
sudo systemctl status wazuh-dashboard
```

### Access Dashboard

1. Open web browser
2. Navigate to: `https://192.168.100.20:5601`
3. Accept self-signed certificate
4. Default credentials:
   - **Username:** admin
   - **Password:** admin
5. **Change password immediately**

## Step 6: Configure Wazuh

### Configure Wazuh Manager

1. Edit main configuration:
```bash
sudo nano /var/ossec/etc/ossec.conf
```

2. Key settings to verify:
   - `<remote>` section for agent communication
   - `<alerts>` section for alerting
   - `<logging>` section for logging

3. Restart service after changes:
```bash
sudo systemctl restart wazuh-manager
```

### Configure Syslog Reception

1. Edit configuration:
```bash
sudo nano /var/ossec/etc/ossec.conf
```

2. Add or verify syslog section:
```xml
<remote>
  <connection>syslog</connection>
  <port>514</port>
  <protocol>udp</protocol>
  <allowed-ips>192.168.100.0/24</allowed-ips>
  <allowed-ips>192.168.101.0/24</allowed-ips>
</remote>
```

3. Restart service:
```bash
sudo systemctl restart wazuh-manager
```

### Configure Firewall Rules

1. Allow required ports:
```bash
sudo ufw allow 1514/udp
sudo ufw allow 1515/tcp
sudo ufw allow 55000/tcp
sudo ufw allow 5601/tcp
sudo ufw allow 514/udp
sudo ufw enable
```

## Step 7: Install Wazuh Agents on Windows

### Download Windows Agent

1. From Wazuh dashboard or download page
2. Download Windows agent installer
3. Or use PowerShell to download:
```powershell
Invoke-WebRequest -Uri "https://packages.wazuh.com/4.x/windows/wazuh-agent-4.7.0-1.msi" -OutFile "wazuh-agent.msi"
```

### Install Agent on Domain Controller

1. Run installer: `wazuh-agent-4.7.0-1.msi`
2. During installation:
   - **Wazuh manager IP:** 192.168.100.20
   - **Registration port:** 1515
3. Complete installation
4. Start service:
```powershell
Start-Service WazuhSvc
```

5. Verify agent is registered in Wazuh dashboard

### Install Agent on Web Server

1. Follow same steps as Domain Controller
2. Ensure agent connects to manager

### Install Agent on Client Workstation

1. Follow same steps as Domain Controller
2. Ensure agent connects to manager

## Step 8: Configure Windows Event Log Forwarding

### Configure on Domain Controller

1. Open **Event Viewer**
2. Right-click **Subscriptions > Create Subscription**
3. Configure:
   - **Subscription name:** Security Events
   - **Description:** Forward security events to Wazuh
   - **Destination log:** Forwarded Events
4. Add computers: Select domain computers
5. Select events: Security events (or all)
6. Configure advanced settings

### Alternative: Use Wazuh Agent

Wazuh agent automatically collects Windows Event Logs. Verify in Wazuh dashboard that events are being received.

## Step 9: Configure Log Collection Rules

### Windows Event Log Rules

1. Access Wazuh dashboard
2. Navigate to **Management > Rules**
3. Review Windows-specific rules
4. Customize as needed

### Create Custom Rules

1. In Wazuh dashboard, go to **Management > Rules**
2. Create custom rules for your environment
3. Test rules with sample events

## Step 10: Configure Alerts

### Set Up Email Alerts (Optional)

1. Edit Wazuh configuration:
```bash
sudo nano /var/ossec/etc/ossec.conf
```

2. Configure email settings:
```xml
<global>
  <email_notification>yes</email_notification>
  <email_to>your-email@example.com</email_to>
  <smtp_server>smtp.example.com</smtp_server>
  <email_from>wazuh@corp.local</email_from>
</global>
```

3. Restart service:
```bash
sudo systemctl restart wazuh-manager
```

### Configure Alert Levels

1. In Wazuh dashboard, configure alert thresholds
2. Set up alert rules based on severity
3. Test alerting functionality

## Step 11: Verification

### Check Wazuh Manager Status

```bash
sudo systemctl status wazuh-manager
sudo systemctl status wazuh-dashboard
```

### Check Agent Connections

1. Access Wazuh dashboard
2. Navigate to **Agents**
3. Verify all agents are connected:
   - Domain Controller
   - Web Server
   - Client Workstation

### Test Log Collection

1. Generate test event on Windows machine
2. Check Wazuh dashboard for event
3. Verify event appears in logs

### Test Dashboard Access

1. Access: `https://192.168.100.20:5601`
2. Verify dashboard loads
3. Check for recent events
4. Verify agents are visible

## Troubleshooting

### Wazuh Manager Not Starting

**Problem:** Service fails to start

**Solutions:**
- Check logs: `sudo tail -f /var/ossec/logs/ossec.log`
- Verify configuration: `sudo /var/ossec/bin/verify-agent-conf`
- Check disk space
- Verify ports are not in use

### Agents Cannot Connect

**Problem:** Agents show as disconnected

**Solutions:**
- Verify manager IP is correct
- Check firewall rules (1514/UDP, 1515/TCP)
- Verify agent service is running
- Check network connectivity
- Review agent logs

### Dashboard Not Accessible

**Problem:** Cannot access web interface

**Solutions:**
- Verify dashboard service is running
- Check firewall allows port 5601
- Verify IP address is correct
- Check for certificate issues
- Review dashboard logs

### No Events Appearing

**Problem:** Events not showing in dashboard

**Solutions:**
- Verify agents are connected
- Check agent configuration
- Verify log collection rules
- Check agent logs
- Verify Windows Event Log service

## Next Steps

Now that Wazuh is configured:

1. ✅ Wazuh server installed
2. ✅ Dashboard accessible
3. ✅ Agents installed on Windows machines
4. ✅ Log collection configured

**Next Guide:** [06-web-server-setup.md](./06-web-server-setup.md) - Install and configure IIS web server.

## Additional Resources

- [Wazuh Documentation](https://documentation.wazuh.com/)
- [Wazuh Installation Guide](https://documentation.wazuh.com/current/installation-guide/)
- [Wazuh Windows Agent](https://documentation.wazuh.com/current/user-manual/agent/windows-agent.html)

