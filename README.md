# Home Active Directory Lab

A comprehensive, production-like Active Directory lab environment built on VMware Workstation. This lab includes Active Directory Domain Services, Wazuh SIEM, pfSense firewall, and web server components for cybersecurity learning and practice.

## 🎯 Lab Overview

This lab environment provides a realistic enterprise network setup for:
- Active Directory administration and management
- Security Information and Event Management (SIEM) with Wazuh
- Network security and firewall configuration with pfSense
- Web server administration and security
- Cybersecurity attack simulation and incident response
- Hands-on learning and skill development

## 🏗️ Architecture

The lab consists of the following components:

- **pfSense Firewall** (192.168.100.1) - Network gateway and security appliance
- **Domain Controller** (192.168.100.10) - Windows Server 2019 with AD DS, DNS, and DHCP
- **Wazuh SIEM** (192.168.100.20) - Security monitoring and log analysis
- **Web Server** (192.168.101.10) - Windows Server 2019 with IIS in DMZ
- **Client Workstation** (192.168.100.50) - Windows 10/11 for testing

**Domain:** `corp.local`

## 📋 Quick Start

1. **Review Requirements**: Check [REQUIREMENTS.md](./REQUIREMENTS.md) for hardware and software prerequisites
2. **Read Architecture**: Understand the setup with [ARCHITECTURE.md](./ARCHITECTURE.md) and [NETWORK_DIAGRAM.md](./NETWORK_DIAGRAM.md)
3. **Follow Setup Guide**: Use [SETUP_GUIDE.md](./SETUP_GUIDE.md) for step-by-step installation
4. **Run Verification**: Complete [docs/09-verification.md](./docs/09-verification.md) to ensure everything works

## 📚 Documentation Structure

### Core Documentation
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Detailed architecture and component relationships
- [NETWORK_DIAGRAM.md](./NETWORK_DIAGRAM.md) - Network topology and IP addressing
- [REQUIREMENTS.md](./REQUIREMENTS.md) - Hardware and software requirements
- [SETUP_GUIDE.md](./SETUP_GUIDE.md) - Master setup guide with component links

### Setup Guides (docs/)
1. [VMware Workstation Setup](./docs/01-vmware-setup.md)
2. [Network Configuration](./docs/02-network-setup.md)
3. [pfSense Firewall Setup](./docs/03-pfsense-setup.md)
4. [Domain Controller Setup](./docs/04-domain-controller-setup.md)
5. [Wazuh SIEM Setup](./docs/05-wazuh-setup.md)
6. [Web Server Setup](./docs/06-web-server-setup.md)
7. [Client Workstation Setup](./docs/07-client-setup.md)
8. [Component Integration](./docs/08-integration.md)
9. [Verification & Testing](./docs/09-verification.md)

### Lab Exercises (labs/)
- [Lab 01: Basic AD Management](./labs/lab-01-basic-ad.md)
- [Lab 02: GPO Configuration](./labs/lab-02-gpo-configuration.md)
- [Lab 03: SIEM Monitoring](./labs/lab-03-siem-monitoring.md)
- [Lab 04: Firewall Rules](./labs/lab-04-firewall-rules.md)
- [Lab 05: Attack Simulation](./labs/lab-05-attack-simulation.md)
- [Lab 06: Incident Response](./labs/lab-06-incident-response.md)

### Troubleshooting
- [Common Issues](./troubleshooting/common-issues.md)
- [Performance Tuning](./troubleshooting/performance-tuning.md)

## 🛠️ Automation Scripts

The `scripts/` directory contains automation scripts for:
- **Windows**: PowerShell scripts for AD, DNS, Wazuh agent, and IIS configuration
- **Linux**: Bash scripts for Wazuh server installation and configuration
- **pfSense**: Configuration templates and XML exports

## ⚙️ Resource Requirements

**Minimum (Low Resources):**
- 16GB RAM
- 4-6 vCPUs
- 200GB free disk space

**Recommended (Medium Resources):**
- 24-32GB RAM
- 6-8 vCPUs
- 250GB free disk space

**Optimal (High Resources):**
- 32GB+ RAM
- 8+ vCPUs
- 300GB+ free disk space

## 🔒 Security Notes

- This lab is for **educational purposes only**
- Keep the lab isolated from production networks
- Use strong, unique passwords (document securely)
- Regularly update all VMs and software
- Do not expose lab to the internet without proper security measures

## 📝 Lab Scenarios

This lab supports various cybersecurity scenarios:
- Active Directory enumeration and exploitation
- Lateral movement techniques
- SIEM log analysis and alerting
- Firewall rule creation and testing
- Incident response procedures
- Web application security testing

## 🤝 Contributing

Feel free to submit issues, improvements, or additional lab scenarios. This is a learning resource meant to grow with the community.

## 📄 License

This project is provided as-is for educational purposes. Use responsibly and ethically.

## 🔗 Useful Resources

- [Microsoft Active Directory Documentation](https://docs.microsoft.com/en-us/windows-server/identity/active-directory)
- [Wazuh Documentation](https://documentation.wazuh.com/)
- [pfSense Documentation](https://docs.netgate.com/pfsense/)
- [VMware Workstation Documentation](https://docs.vmware.com/en/VMware-Workstation-Pro/)

---

**Last Updated:** December 2024  
**Lab Version:** 1.0

