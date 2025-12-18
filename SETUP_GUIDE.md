# Setup Guide

This is the master setup guide that provides an overview of the entire lab setup process. Follow the guides in order for a complete installation.

## Setup Overview

The lab setup is divided into phases. Each phase builds upon the previous one. Follow the guides in the order listed below.

## Setup Phases

### Phase 1: Foundation Setup

#### 1. VMware Workstation Configuration
**Guide:** [docs/01-vmware-setup.md](./docs/01-vmware-setup.md)

**What you'll do:**
- Install VMware Workstation (if not already installed)
- Create custom VMnet for lab network
- Configure network settings
- Prepare for VM creation

**Time:** 30 minutes

**Prerequisites:**
- VMware Workstation installed
- Administrator access

---

#### 2. Network Planning
**Guide:** [docs/02-network-setup.md](./docs/02-network-setup.md)

**What you'll do:**
- Review network topology
- Document IP addressing scheme
- Plan network segments
- Prepare network documentation

**Time:** 15 minutes

**Prerequisites:**
- Understanding of IP addressing
- Network diagram reviewed

---

### Phase 2: Core Infrastructure

#### 3. pfSense Firewall Setup
**Guide:** [docs/03-pfsense-setup.md](./docs/03-pfsense-setup.md)

**What you'll do:**
- Create pfSense VM
- Install pfSense
- Configure network interfaces
- Set up firewall rules
- Configure NAT and routing

**Time:** 1-2 hours

**Prerequisites:**
- VMware Workstation configured
- Network plan completed
- pfSense ISO downloaded

---

#### 4. Domain Controller Setup
**Guide:** [docs/04-domain-controller-setup.md](./docs/04-domain-controller-setup.md)

**What you'll do:**
- Create Windows Server VM
- Install Windows Server 2019/2022
- Promote to Domain Controller
- Configure DNS
- Configure DHCP
- Create initial OUs, users, and groups

**Time:** 2-3 hours

**Prerequisites:**
- pfSense configured and running
- Windows Server ISO downloaded
- Valid license or evaluation key

---

### Phase 3: Security & Monitoring

#### 5. Wazuh SIEM Setup
**Guide:** [docs/05-wazuh-setup.md](./docs/05-wazuh-setup.md)

**What you'll do:**
- Create Ubuntu VM
- Install Ubuntu 22.04 LTS
- Install Wazuh server
- Configure Wazuh dashboard
- Set up initial rules and alerts

**Time:** 1-2 hours

**Prerequisites:**
- Domain Controller configured
- Ubuntu ISO downloaded
- Network connectivity verified

---

#### 6. Web Server Setup
**Guide:** [docs/06-web-server-setup.md](./docs/06-web-server-setup.md)

**What you'll do:**
- Create Windows Server VM
- Install Windows Server 2019/2022
- Join to domain
- Install IIS
- Configure web applications
- Set up logging

**Time:** 1 hour

**Prerequisites:**
- Domain Controller configured
- pfSense DMZ configured
- Windows Server ISO downloaded

---

### Phase 4: Client & Integration

#### 7. Client Workstation Setup
**Guide:** [docs/07-client-setup.md](./docs/07-client-setup.md)

**What you'll do:**
- Create Windows 10/11 VM
- Install Windows
- Join to domain
- Install Wazuh agent
- Configure for testing

**Time:** 30 minutes

**Prerequisites:**
- Domain Controller configured
- Wazuh server configured
- Windows 10/11 ISO downloaded

---

#### 8. Component Integration
**Guide:** [docs/08-integration.md](./docs/08-integration.md)

**What you'll do:**
- Install Wazuh agents on Windows machines
- Configure log forwarding
- Set up firewall logging to Wazuh
- Verify all components communicate
- Test end-to-end functionality

**Time:** 1-2 hours

**Prerequisites:**
- All components installed
- All VMs running

---

### Phase 5: Verification

#### 9. Verification & Testing
**Guide:** [docs/09-verification.md](./docs/09-verification.md)

**What you'll do:**
- Verify network connectivity
- Test domain authentication
- Verify DNS resolution
- Test Wazuh log collection
- Verify firewall rules
- Create baseline documentation

**Time:** 1-2 hours

**Prerequisites:**
- All components installed and integrated

---

## Quick Setup Checklist

Use this checklist to track your progress:

- [ ] Phase 1: Foundation
  - [ ] VMware Workstation configured
  - [ ] Network plan documented
- [ ] Phase 2: Core Infrastructure
  - [ ] pfSense firewall installed and configured
  - [ ] Domain Controller installed and configured
- [ ] Phase 3: Security & Monitoring
  - [ ] Wazuh SIEM installed and configured
  - [ ] Web Server installed and configured
- [ ] Phase 4: Client & Integration
  - [ ] Client Workstation installed and configured
  - [ ] All components integrated
- [ ] Phase 5: Verification
  - [ ] All systems verified and tested
  - [ ] Documentation completed

## Setup Tips

### Before You Start
1. **Read all guides first** - Understand the full process before beginning
2. **Download all ISOs** - Have all installation media ready
3. **Allocate time** - Plan for 7-11 hours total setup time
4. **Take notes** - Document any deviations or issues
5. **Create snapshots** - Take snapshots before major changes

### During Setup
1. **Follow order** - Don't skip steps or change order
2. **Verify each step** - Test connectivity after each component
3. **Document credentials** - Keep track of all passwords securely
4. **Take breaks** - Don't rush through setup
5. **Use automation** - Leverage provided scripts when possible

### After Setup
1. **Create baseline snapshot** - Snapshot all VMs after successful setup
2. **Test everything** - Complete verification guide thoroughly
3. **Document issues** - Note any problems and solutions
4. **Backup configurations** - Export configs from all components
5. **Start learning** - Begin with lab exercises

## Common Setup Issues

### Network Issues
- **Problem:** VMs cannot communicate
- **Solution:** Check VMnet configuration, verify firewall rules

### DNS Issues
- **Problem:** Cannot resolve domain names
- **Solution:** Verify DNS server is running, check forwarders

### Domain Join Issues
- **Problem:** Cannot join machines to domain
- **Solution:** Verify DNS resolution, check time sync, verify ports

### Wazuh Agent Issues
- **Problem:** Agents cannot connect to manager
- **Solution:** Check firewall rules, verify manager is running

See [troubleshooting/common-issues.md](./troubleshooting/common-issues.md) for more detailed solutions.

## Automation Scripts

Several automation scripts are provided to speed up setup:

### Windows Scripts
- `scripts/windows/setup-ad.ps1` - AD DS installation
- `scripts/windows/configure-dns.ps1` - DNS configuration
- `scripts/windows/install-wazuh-agent.ps1` - Wazuh agent installation
- `scripts/windows/configure-iis.ps1` - IIS configuration

### Linux Scripts
- `scripts/linux/install-wazuh-server.sh` - Wazuh server installation
- `scripts/linux/configure-wazuh.sh` - Wazuh configuration

Review scripts before running and modify as needed for your environment.

## Next Steps

After completing setup:

1. **Complete Verification** - Follow [docs/09-verification.md](./docs/09-verification.md)
2. **Start Learning** - Begin with [labs/lab-01-basic-ad.md](./labs/lab-01-basic-ad.md)
3. **Explore Components** - Familiarize yourself with each component
4. **Create Snapshots** - Take baseline snapshots of all VMs
5. **Document Your Setup** - Note any customizations or changes

## Getting Help

If you encounter issues:

1. **Check Troubleshooting Guide** - [troubleshooting/common-issues.md](./troubleshooting/common-issues.md)
2. **Review Component Documentation** - Check individual setup guides
3. **Verify Prerequisites** - Ensure all prerequisites are met
4. **Check Logs** - Review component logs for errors
5. **Community Resources** - Check component-specific forums

## Additional Resources

- [Architecture Documentation](./ARCHITECTURE.md)
- [Network Diagram](./NETWORK_DIAGRAM.md)
- [Requirements](./REQUIREMENTS.md)
- [Lab Exercises](./labs/)

---

**Ready to begin?** Start with [docs/01-vmware-setup.md](./docs/01-vmware-setup.md)

