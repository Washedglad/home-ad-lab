# Network Setup and Planning

This guide covers network planning and configuration for the Home AD Lab. Review this guide before proceeding with component installation.

## Network Overview

The lab uses a segmented network architecture with:
- **Internal Network:** 192.168.100.0/24 - Domain, SIEM, clients
- **DMZ Network:** 192.168.101.0/24 - Web server
- **Gateway:** 192.168.100.1 (pfSense)

## IP Addressing Scheme

### Internal Network (192.168.100.0/24)

| IP Address | Hostname | Role | Notes |
|------------|----------|------|-------|
| 192.168.100.1 | pfsense | Gateway | pfSense LAN interface |
| 192.168.100.10 | DC01.corp.local | Domain Controller | AD DS, DNS, DHCP |
| 192.168.100.20 | wazuh.corp.local | SIEM | Wazuh manager |
| 192.168.100.50 | CLIENT01.corp.local | Workstation | Windows client |
| 192.168.100.100-199 | - | DHCP Pool | Dynamic assignments |
| 192.168.100.200-254 | - | Reserved | Future expansion |

### DMZ Network (192.168.101.0/24)

| IP Address | Hostname | Role | Notes |
|------------|----------|------|-------|
| 192.168.101.1 | - | Gateway | pfSense OPT1 interface |
| 192.168.101.10 | WEB01.corp.local | Web Server | IIS server |
| 192.168.101.100-254 | - | Reserved | Future expansion |

## Network Configuration Checklist

Before proceeding, document your network plan:

- [ ] Internal network subnet: 192.168.100.0/24
- [ ] DMZ network subnet: 192.168.101.0/24
- [ ] Gateway IP: 192.168.100.1
- [ ] DNS server IP: 192.168.100.10
- [ ] Domain name: corp.local
- [ ] All static IPs documented

## DNS Configuration

### Forward Lookup Zone

**Zone Name:** corp.local
**Primary Server:** DC01.corp.local (192.168.100.10)

### DNS Records to Create

| Record Type | Name | Value | Notes |
|-------------|------|-------|-------|
| A | DC01 | 192.168.100.10 | Domain Controller |
| A | wazuh | 192.168.100.20 | Wazuh SIEM |
| A | CLIENT01 | 192.168.100.50 | Client Workstation |
| A | WEB01 | 192.168.101.10 | Web Server |
| A | pfsense | 192.168.100.1 | Gateway (optional) |

### Reverse Lookup Zones

- **100.168.192.in-addr.arpa** - For 192.168.100.0/24
- **101.168.192.in-addr.arpa** - For 192.168.101.0/24

## DHCP Configuration

### Scope Settings

- **Scope Name:** Internal Network
- **IP Range:** 192.168.100.100 - 192.168.100.199
- **Subnet Mask:** 255.255.255.0
- **Default Gateway:** 192.168.100.1
- **DNS Servers:** 192.168.100.10, 192.168.100.1
- **Domain Name:** corp.local
- **Lease Duration:** 8 days

### Reservations

Create reservations for static IPs:
- 192.168.100.10 - DC01 (Domain Controller)
- 192.168.100.20 - wazuh (Wazuh SIEM)
- 192.168.100.50 - CLIENT01 (Client Workstation)
- 192.168.101.10 - WEB01 (Web Server)

## Firewall Rules Planning

### Internal → Internet
- **Action:** Allow
- **Protocol:** All
- **NAT:** Enabled

### Internal → DMZ
- **Action:** Allow
- **Protocol:** HTTP (80), HTTPS (443)
- **Source:** 192.168.100.0/24
- **Destination:** 192.168.101.0/24

### DMZ → Internal
- **Action:** Block (default)
- **Exception:** DNS queries to 192.168.100.10

### DMZ → Internet
- **Action:** Allow
- **Protocol:** HTTP, HTTPS, DNS

## Port Requirements

Document required ports for each component:

### Domain Controller
- 53/UDP, TCP - DNS
- 88/UDP, TCP - Kerberos
- 389/UDP, TCP - LDAP
- 445/TCP - SMB
- 636/TCP - LDAPS

### Wazuh SIEM
- 1514/UDP - Agent communication
- 1515/TCP - Agent communication
- 55000/TCP - API
- 5601/TCP - Dashboard

### Web Server
- 80/TCP - HTTP
- 443/TCP - HTTPS

### pfSense
- 514/UDP - Syslog (to Wazuh)

## Network Testing Plan

After setup, test the following:

1. **Connectivity Tests**
   - [ ] Ping gateway from all VMs
   - [ ] Ping DC from all VMs
   - [ ] Ping between internal network VMs
   - [ ] Ping from internal to DMZ

2. **DNS Tests**
   - [ ] Resolve DC01.corp.local
   - [ ] Resolve WEB01.corp.local
   - [ ] Reverse DNS lookup works

3. **DHCP Tests**
   - [ ] New VM gets IP from DHCP
   - [ ] DNS settings correct
   - [ ] Gateway setting correct

4. **Firewall Tests**
   - [ ] Internal can access internet
   - [ ] Internal can access DMZ web server
   - [ ] DMZ cannot access internal (except DNS)
   - [ ] Logs forwarded to Wazuh

## Network Documentation Template

Use this template to document your network:

```markdown
# Lab Network Configuration

## Network Segments
- Internal: 192.168.100.0/24
- DMZ: 192.168.101.0/24

## Static IPs
- Gateway: 192.168.100.1
- DC: 192.168.100.10
- Wazuh: 192.168.100.20
- Client: 192.168.100.50
- Web: 192.168.101.10

## DNS
- Primary: 192.168.100.10
- Domain: corp.local

## DHCP
- Range: 192.168.100.100-199
- Gateway: 192.168.100.1
- DNS: 192.168.100.10
```

## Next Steps

Now that network planning is complete:

1. ✅ Network topology understood
2. ✅ IP addresses assigned
3. ✅ DNS structure planned
4. ✅ Firewall rules planned

**Next Guide:** [03-pfsense-setup.md](./03-pfsense-setup.md) - Install and configure pfSense firewall.

## Additional Resources

- [RFC 1918 - Private Address Space](https://tools.ietf.org/html/rfc1918)
- [Subnet Calculator](https://www.subnet-calculator.com/)
- [DNS Best Practices](https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/reviewing-dns-concepts)

