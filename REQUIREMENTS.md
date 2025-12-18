# Requirements

## Hardware Requirements

### Minimum (Low Resources)
- **RAM:** 16GB total system RAM
- **CPU:** 4-6 cores (physical or logical)
- **Storage:** 200GB free disk space (SSD recommended)
- **Network:** Ethernet adapter (for internet access)

### Recommended (Medium Resources)
- **RAM:** 24-32GB total system RAM
- **CPU:** 6-8 cores (physical or logical)
- **Storage:** 250GB free disk space (SSD recommended)
- **Network:** Gigabit Ethernet adapter

### Optimal (High Resources)
- **RAM:** 32GB+ total system RAM
- **CPU:** 8+ cores (physical or logical)
- **Storage:** 300GB+ free disk space (NVMe SSD recommended)
- **Network:** Gigabit Ethernet adapter

## Software Requirements

### Host Operating System
- **Windows 10/11** (64-bit) - Recommended
- **Linux** (Ubuntu 20.04+, Fedora, etc.) - Supported
- **macOS** - Supported (VMware Fusion)

### Virtualization Software
- **VMware Workstation Pro 16+** (Windows/Linux)
- **VMware Workstation Player 16+** (free alternative, limited features)
- **VMware Fusion 12+** (macOS)

### Guest Operating Systems

#### Windows Server 2019/2022
- **Edition:** Standard or Datacenter
- **ISO:** Download from Microsoft Evaluation Center
- **License:** Evaluation license (180 days) or valid license
- **RAM:** 4GB minimum, 8GB recommended for DC
- **Disk:** 60GB minimum

#### Windows 10/11
- **Edition:** Enterprise or Pro
- **ISO:** Download from Microsoft
- **License:** Evaluation or valid license
- **RAM:** 2GB minimum, 4GB recommended
- **Disk:** 40GB minimum

#### Ubuntu 22.04 LTS
- **Edition:** Server or Desktop
- **ISO:** Download from Ubuntu website
- **License:** Free and open-source
- **RAM:** 4GB minimum, 8GB recommended
- **Disk:** 40GB minimum

#### pfSense
- **Version:** 2.7+ (CE or Plus)
- **ISO:** Download from pfSense website
- **License:** Free (CE) or paid (Plus)
- **RAM:** 512MB minimum, 1GB recommended
- **Disk:** 8GB minimum

## Resource Allocation per VM

### pfSense Firewall
- **RAM:** 512MB - 1GB
- **vCPU:** 1
- **Disk:** 8GB (thin provisioned)
- **Network:** 2 adapters (WAN, LAN, OPT1)

### Domain Controller
- **RAM:** 4GB - 8GB
- **vCPU:** 2
- **Disk:** 60GB (thin provisioned)
- **Network:** 1 adapter (internal)

### Wazuh SIEM
- **RAM:** 4GB - 8GB
- **vCPU:** 2
- **Disk:** 40GB (thin provisioned)
- **Network:** 1 adapter (internal)

### Web Server
- **RAM:** 2GB - 4GB
- **vCPU:** 1-2
- **Disk:** 40GB (thin provisioned)
- **Network:** 1 adapter (DMZ)

### Client Workstation
- **RAM:** 2GB - 4GB
- **vCPU:** 1
- **Disk:** 40GB (thin provisioned)
- **Network:** 1 adapter (internal)

### Total Resource Summary
- **Total RAM:** ~12.5GB - 25GB (depending on allocation)
- **Total vCPU:** 7-9 cores
- **Total Disk:** ~188GB (thin provisioned)

## Network Requirements

### Internet Connection
- **Speed:** Broadband connection (for downloading ISOs and updates)
- **Bandwidth:** Not critical for lab operation (mostly internal traffic)

### Network Adapter
- **Type:** Ethernet adapter (wired recommended)
- **Speed:** 100Mbps minimum, 1Gbps recommended

### VMware Network Configuration
- **VMnet Type:** Custom VMnet (host-only or NAT)
- **Subnet:** 192.168.100.0/24 (configurable)
- **DHCP:** Disabled (using AD DHCP)

## Software Downloads Required

### Operating System ISOs
1. **Windows Server 2019/2022**
   - Download from: [Microsoft Evaluation Center](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2022)
   - Size: ~5GB

2. **Windows 10/11**
   - Download from: [Microsoft](https://www.microsoft.com/en-us/software-download)
   - Size: ~5GB

3. **Ubuntu 22.04 LTS**
   - Download from: [Ubuntu](https://ubuntu.com/download/server)
   - Size: ~2GB

4. **pfSense**
   - Download from: [pfSense](https://www.pfsense.org/download/)
   - Size: ~700MB

### Additional Software
1. **VMware Workstation**
   - Download from: [VMware](https://www.vmware.com/products/workstation-pro.html)
   - License: Trial or purchased

2. **Wazuh**
   - Installed via package manager (instructions in setup guide)
   - No separate download needed

## Prerequisites Knowledge

### Recommended Skills
- Basic understanding of Windows Server administration
- Familiarity with networking concepts (IP addressing, subnets, routing)
- Basic Linux command line knowledge
- Understanding of Active Directory concepts
- Basic firewall concepts

### Learning Resources
- Microsoft Learn (Active Directory)
- pfSense documentation
- Wazuh documentation
- VMware Workstation documentation

## Time Requirements

### Initial Setup
- **VMware Configuration:** 30 minutes
- **pfSense Setup:** 1-2 hours
- **Domain Controller Setup:** 2-3 hours
- **Wazuh Setup:** 1-2 hours
- **Web Server Setup:** 1 hour
- **Client Setup:** 30 minutes
- **Integration & Testing:** 1-2 hours

**Total:** 7-11 hours for complete setup

### Ongoing Maintenance
- **Updates:** 1-2 hours per month
- **Backup:** 30 minutes per week
- **Monitoring:** 30 minutes per week

## Storage Considerations

### Disk Space Planning
- **OS Installations:** ~50GB
- **System Files:** ~30GB
- **Logs:** ~20GB (grows over time)
- **Snapshots:** ~50GB (if using)
- **Temporary Files:** ~10GB
- **Buffer:** ~30GB

**Total Recommended:** 250GB+ free space

### Disk Type Recommendations
- **SSD (SATA):** Good performance, reasonable cost
- **NVMe SSD:** Best performance, higher cost
- **HDD:** Not recommended (slow VM performance)

### Snapshot Strategy
- Create snapshots before major changes
- Limit snapshot depth (2-3 levels)
- Regularly consolidate snapshots
- Monitor snapshot disk usage

## Performance Optimization Tips

### Host System
- Close unnecessary applications
- Disable unnecessary services
- Use SSD for VM storage
- Allocate adequate RAM
- Enable hardware virtualization in BIOS

### VMware Settings
- Enable hardware acceleration
- Allocate appropriate resources
- Use thin provisioning for disks
- Enable memory ballooning
- Use paravirtualized network adapters

### Guest VMs
- Install VMware Tools
- Disable unnecessary services
- Optimize Windows services
- Regular cleanup of temp files
- Monitor resource usage

## Compatibility Notes

### Windows Server Versions
- Windows Server 2019: Fully supported
- Windows Server 2022: Fully supported
- Windows Server 2016: Supported but not recommended

### Windows Client Versions
- Windows 10: Fully supported
- Windows 11: Fully supported

### Linux Versions
- Ubuntu 22.04 LTS: Recommended
- Ubuntu 20.04 LTS: Supported
- Other Debian-based: May work with modifications

### VMware Versions
- VMware Workstation 16+: Recommended
- VMware Workstation 15: Supported
- Older versions: Not recommended

## Security Considerations

### Lab Isolation
- Keep lab network isolated from production
- Use separate network adapter if possible
- Disable host file sharing with VMs
- Use strong passwords for all accounts

### Credential Management
- Document credentials securely
- Use password manager
- Never commit credentials to repository
- Rotate passwords periodically

### Updates
- Keep host OS updated
- Keep VMware Workstation updated
- Keep all guest VMs updated
- Regular security patches

## Backup Requirements

### What to Backup
- VM configuration files (.vmx)
- VM disk files (.vmdk)
- Configuration exports (pfSense, AD, etc.)
- Documentation and notes

### Backup Strategy
- Full VM backups before major changes
- Configuration exports regularly
- Document changes and modifications
- Test restore procedures

## Support and Resources

### Documentation
- This repository
- Component-specific documentation
- VMware knowledge base

### Communities
- Reddit: r/homelab, r/activedirectory
- Discord: Homelab communities
- Forums: VMware, pfSense, Wazuh

### Professional Resources
- Microsoft Learn
- VMware Learning
- Cybersecurity training platforms

