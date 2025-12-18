# VMware Workstation Setup

This guide covers the installation and configuration of VMware Workstation for the Home AD Lab environment.

## Prerequisites

- Windows 10/11 (64-bit) or Linux host system
- Administrator/root access
- Minimum 16GB RAM (24GB+ recommended)
- 250GB+ free disk space
- Internet connection for downloads

## Step 1: Install VMware Workstation

### Download VMware Workstation

1. Visit [VMware Workstation Pro](https://www.vmware.com/products/workstation-pro.html)
2. Download the latest version (16+ recommended)
3. Choose appropriate version:
   - **Windows:** VMware Workstation Pro for Windows
   - **Linux:** VMware Workstation Pro for Linux

### Installation Steps (Windows)

1. Run the installer as Administrator
2. Follow the installation wizard
3. Accept the license agreement
4. Choose installation location (default is fine)
5. Select features:
   - ✅ Enhanced Keyboard Driver
   - ✅ Visual Studio Plugin (if using)
6. Complete installation
7. Restart if prompted

### Installation Steps (Linux)

```bash
# Make installer executable
chmod +x VMware-Workstation-*.bundle

# Run installer (requires root)
sudo ./VMware-Workstation-*.bundle

# Follow installation wizard
# Accept license agreement
# Choose installation location
```

### Verify Installation

1. Launch VMware Workstation
2. Check version: **Help > About VMware Workstation**
3. Verify license status (trial or licensed)

## Step 2: Configure Virtual Network

### Access Network Settings

1. Open VMware Workstation
2. Go to **Edit > Virtual Network Editor**
3. Click **Change Settings** (requires admin privileges)
4. You'll see default VMnet configurations

### Create Custom VMnet

We'll use VMnet2 for our lab network. If VMnet2 is already in use, choose another available VMnet.

1. In Virtual Network Editor, select **VMnet2** (or available VMnet)
2. Configure settings:
   - **Type:** Host-only
   - **Subnet IP:** 192.168.100.0
   - **Subnet Mask:** 255.255.255.0
3. Click **Apply**
4. Note the VMnet name (e.g., "VMnet2")

### Alternative: Use NAT Network

If you prefer NAT instead of host-only:

1. Select **VMnet8** (NAT) or create new NAT network
2. Configure:
   - **Subnet IP:** 192.168.100.0
   - **Subnet Mask:** 255.255.255.0
   - **Enable NAT:** Yes
3. Click **NAT Settings** to configure gateway (192.168.100.1)
4. Click **Apply**

### Verify Network Configuration

1. Check network adapter on host:
   - **Windows:** Network Connections should show VMware Network Adapter VMnet2
   - **Linux:** `ip addr show` should show vmnet2 interface
2. Verify IP range: 192.168.100.0/24
3. Note: We'll disable DHCP as we'll use AD DHCP

## Step 3: Configure VM Settings

### General VM Settings

Before creating VMs, configure default settings:

1. Go to **Edit > Preferences**
2. Configure:
   - **Workspace:** Choose default VM location (ensure enough space)
   - **Memory:** Set appropriate allocation (leave headroom for host)
   - **Processors:** Configure based on host CPU
   - **Updates:** Configure update preferences

### Enable Hardware Virtualization

1. In **Edit > Preferences > Processors**
2. Enable:
   - ✅ Virtualize Intel VT-x/EPT or AMD-V/RVI
   - ✅ Virtualize CPU performance counters
3. Click **OK**

**Note:** If these options are grayed out, enable virtualization in BIOS/UEFI.

## Step 4: Prepare for VM Creation

### Create Lab Folder Structure

Organize your VMs:

```
VMware VMs/
└── Home-AD-Lab/
    ├── pfSense/
    ├── DomainController/
    ├── Wazuh/
    ├── WebServer/
    └── Client/
```

1. Create folder: `Home-AD-Lab` in your VM directory
2. Create subfolders for each VM (optional but recommended)

### Download Required ISOs

Before creating VMs, download all required ISOs:

1. **Windows Server 2019/2022**
   - Download from [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022)
   - Save to: `ISOs/Windows Server 2022.iso`

2. **Windows 10/11**
   - Download from [Microsoft](https://www.microsoft.com/en-us/software-download)
   - Save to: `ISOs/Windows 11.iso`

3. **Ubuntu 22.04 LTS**
   - Download from [Ubuntu](https://ubuntu.com/download/server)
   - Save to: `ISOs/ubuntu-22.04-server-amd64.iso`

4. **pfSense**
   - Download from [pfSense](https://www.pfsense.org/download/)
   - Choose: AMD64 (64-bit) CD image
   - Save to: `ISOs/pfSense-CE-2.7.x-amd64.iso`

### Organize ISO Storage

Create an `ISOs` folder and organize downloads:

```
ISOs/
├── Windows Server 2022.iso
├── Windows 11.iso
├── ubuntu-22.04-server-amd64.iso
└── pfSense-CE-2.7.x-amd64.iso
```

## Step 5: Verify Configuration

### Test Network Connectivity

1. Create a test VM (any OS)
2. Configure network adapter to use VMnet2
3. Start VM and verify:
   - VM can get IP (if DHCP enabled temporarily)
   - Host can ping VM (if host-only)
   - VM can access internet (if NAT)

### Check Resource Availability

Verify you have sufficient resources:

```powershell
# Windows - Check available RAM
Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory

# Windows - Check disk space
Get-PSDrive C | Select-Object Used, Free
```

```bash
# Linux - Check available RAM
free -h

# Linux - Check disk space
df -h
```

## Step 6: Best Practices

### Performance Optimization

1. **Allocate Resources Wisely**
   - Don't overallocate RAM (leave 4GB+ for host)
   - Use 1-2 vCPUs per VM initially
   - Monitor and adjust as needed

2. **Storage Optimization**
   - Use thin provisioning for disks
   - Store VMs on fast storage (SSD)
   - Regularly clean up snapshots

3. **Network Optimization**
   - Use VMXNET3 network adapters (when available)
   - Disable unnecessary network services in VMs

### Snapshot Strategy

1. **Before Major Changes**
   - Create snapshot before OS installation
   - Create snapshot after successful configuration
   - Name snapshots descriptively

2. **Snapshot Management**
   - Limit snapshot depth (2-3 levels)
   - Regularly consolidate snapshots
   - Delete old/unnecessary snapshots

### Backup Strategy

1. **VM Configuration Files**
   - Backup `.vmx` files
   - Backup `.vmdk` files (or use VM export)

2. **Configuration Exports**
   - Export pfSense config
   - Export AD configuration
   - Document all changes

## Troubleshooting

### Virtual Network Editor Won't Open

**Problem:** "You do not have sufficient privileges" error

**Solution:**
- Run VMware Workstation as Administrator
- On Linux, use `sudo vmware-netcfg`

### Cannot Create Custom Network

**Problem:** VMnet already in use or conflicts

**Solution:**
- Use different VMnet number
- Remove unused VMnets
- Restart VMware services

### VMs Cannot Communicate

**Problem:** VMs on same network cannot ping each other

**Solution:**
- Verify all VMs use same VMnet
- Check firewall rules on host
- Verify network adapter is enabled
- Check VM network adapter settings

### Poor Performance

**Problem:** VMs run slowly

**Solution:**
- Check host resource usage
- Reduce VM resource allocation
- Enable hardware acceleration
- Use SSD for VM storage
- Close unnecessary host applications

### BIOS Virtualization Not Enabled

**Problem:** Cannot enable VT-x/AMD-V in VMware

**Solution:**
1. Restart computer
2. Enter BIOS/UEFI settings
3. Enable:
   - Intel Virtualization Technology (Intel)
   - AMD-V (AMD)
   - Virtualization Technology (generic)
4. Save and exit
5. Restart and try again

## Next Steps

Now that VMware Workstation is configured:

1. ✅ VMware Workstation installed and configured
2. ✅ Virtual network created (VMnet2)
3. ✅ ISOs downloaded and organized
4. ✅ Ready to create VMs

**Next Guide:** [02-network-setup.md](./02-network-setup.md) - Review network planning, then proceed to [03-pfsense-setup.md](./03-pfsense-setup.md) to create the pfSense firewall VM.

## Additional Resources

- [VMware Workstation Documentation](https://docs.vmware.com/en/VMware-Workstation-Pro/)
- [VMware Network Configuration](https://docs.vmware.com/en/VMware-Workstation-Pro/16.0/com.vmware.ws.using.doc/GUID-0F6E45C4-3CF5-4EC5-9C3A-0CF537F6B5B0.html)
- [VMware Performance Best Practices](https://kb.vmware.com/s/article/1008114)

