# Network Diagram and IP Addressing

## Network Topology

```
┌─────────────────────────────────────────────────────────────────┐
│                    VMware Workstation Host                      │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              VMnet (Custom Network)                      │  │
│  │                                                           │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │         pfSense Firewall (Gateway)                   │  │  │
│  │  │         192.168.100.1                               │  │  │
│  │  │         WAN: NAT to Host                            │  │  │
│  │  │         LAN: 192.168.100.0/24                       │  │  │
│  │  │         OPT1: 192.168.101.0/24 (DMZ)                │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │                        │                                   │  │
│  │        ┌───────────────┼───────────────┐                 │  │
│  │        │               │               │                 │  │
│  │  ┌─────▼─────┐  ┌─────▼─────┐  ┌─────▼─────┐          │  │
│  │  │ Internal   │  │ Internal   │  │ Internal  │          │  │
│  │  │ Network    │  │ Network    │  │ Network   │          │  │
│  │  │            │  │            │  │           │          │  │
│  │  │ ┌────────┐ │  │ ┌────────┐ │  │ ┌───────┐ │          │  │
│  │  │ │   DC   │ │  │ │ Wazuh  │ │  │ │Client │ │          │  │
│  │  │ │ .100.10│ │  │ │.100.20 │ │  │ │.100.50│ │          │  │
│  │  │ └────────┘ │  │ └────────┘ │  │ └───────┘ │          │  │
│  │  └───────────┘  └────────────┘  └───────────┘          │  │
│  │                                                        │  │
│  │  ┌──────────────────────────────────────────────────┐ │  │
│  │  │              DMZ Network                         │ │  │
│  │  │                                                  │ │  │
│  │  │  ┌────────────────────────────────────────────┐ │ │  │
│  │  │  │         Web Server                         │ │ │  │
│  │  │  │         192.168.101.10                     │ │ │  │
│  │  │  │         IIS, Domain Member                 │ │ │  │
│  │  │  └────────────────────────────────────────────┘ │ │  │
│  │  └──────────────────────────────────────────────────┘ │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

## IP Addressing Scheme

### Internal Network (192.168.100.0/24)

| IP Address | Hostname | Role | Description |
|------------|----------|------|-------------|
| 192.168.100.1 | pfsense | Gateway | pfSense firewall/router |
| 192.168.100.10 | DC01.goldshire.local | Domain Controller | AD DS, DNS, DHCP |
| 192.168.100.20 | wazuh.goldshire.local | SIEM | Wazuh manager and dashboard |
| 192.168.100.50 | CLIENT01.goldshire.local | Workstation | Windows client for testing |
| 192.168.100.100-199 | - | DHCP Pool | Reserved for DHCP clients |
| 192.168.100.200-254 | - | Reserved | Future expansion |

### DMZ Network (192.168.101.0/24)

| IP Address | Hostname | Role | Description |
|------------|----------|------|-------------|
| 192.168.101.1 | - | Gateway | pfSense OPT1 interface |
| 192.168.101.10 | WEB01.goldshire.local | Web Server | IIS web server |
| 192.168.101.100-254 | - | Reserved | Future expansion |

## Subnet Masks

- **Internal Network:** 255.255.255.0 (/24)
- **DMZ Network:** 255.255.255.0 (/24)

## Default Gateway

- **Internal Network:** 192.168.100.1 (pfSense LAN)
- **DMZ Network:** 192.168.101.1 (pfSense OPT1)

## DNS Configuration

### Primary DNS Server
- **Internal Network:** 192.168.100.10 (Domain Controller)
- **DMZ Network:** 192.168.100.10 (Domain Controller)

### Secondary DNS Server
- **Internal Network:** 192.168.100.1 (pfSense - forwards to DC)
- **DMZ Network:** 192.168.100.1 (pfSense - forwards to DC)

## DHCP Configuration

### Scope Details
- **Network:** 192.168.100.0/24
- **Range:** 192.168.100.100 - 192.168.100.199
- **Default Gateway:** 192.168.100.1
- **DNS Servers:** 192.168.100.10, 192.168.100.1
- **Domain Name:** goldshire.local
- **Lease Duration:** 8 days

### Reserved Addresses
- 192.168.100.10 - Domain Controller (static)
- 192.168.100.20 - Wazuh SIEM (static)
- 192.168.100.50 - Client Workstation (static)
- 192.168.101.10 - Web Server (static)

## Firewall Rules

### Internal Network → Internet
- **Action:** Allow
- **Protocol:** All
- **Source:** 192.168.100.0/24
- **Destination:** Any
- **NAT:** Enabled

### Internal Network → DMZ
- **Action:** Allow
- **Protocol:** HTTP, HTTPS
- **Source:** 192.168.100.0/24
- **Destination:** 192.168.101.0/24

### DMZ → Internal Network
- **Action:** Block (default)
- **Protocol:** All
- **Source:** 192.168.101.0/24
- **Destination:** 192.168.100.0/24
- **Exception:** Allow DNS queries to 192.168.100.10

### DMZ → Internet
- **Action:** Allow
- **Protocol:** HTTP, HTTPS, DNS
- **Source:** 192.168.101.0/24
- **Destination:** Any
- **NAT:** Enabled

### Internet → DMZ
- **Action:** Block (default)
- **Protocol:** All
- **Source:** Any
- **Destination:** 192.168.101.0/24
- **Note:** Can be configured for specific port forwarding if needed

## Port Requirements

### Domain Controller (192.168.100.10)
- **53/UDP, TCP** - DNS
- **88/UDP, TCP** - Kerberos
- **135/TCP** - RPC Endpoint Mapper
- **389/UDP, TCP** - LDAP
- **445/TCP** - SMB
- **636/TCP** - LDAPS
- **3268/TCP** - Global Catalog
- **3269/TCP** - Global Catalog SSL
- **49152-65535/TCP** - Dynamic RPC

### Wazuh SIEM (192.168.100.20)
- **1514/UDP** - Wazuh agent communication
- **1515/TCP** - Wazuh agent communication
- **55000/TCP** - Wazuh API
- **5601/TCP** - Wazuh Dashboard (Kibana)

### Web Server (192.168.101.10)
- **80/TCP** - HTTP
- **443/TCP** - HTTPS
- **1514/UDP** - Wazuh agent communication
- **1515/TCP** - Wazuh agent communication

### pfSense (192.168.100.1)
- **53/UDP, TCP** - DNS (forwarder)
- **80/TCP** - Web interface (internal only)
- **443/TCP** - Web interface HTTPS (internal only)
- **514/UDP** - Syslog (to Wazuh)

## VLAN Configuration (Optional)

If using VLANs in a more advanced setup:

| VLAN ID | Name | Network | Description |
|---------|------|---------|-------------|
| 100 | Internal | 192.168.100.0/24 | Internal network |
| 101 | DMZ | 192.168.101.0/24 | DMZ network |

## Network Services

### DNS Zones
- **goldshire.local** - Primary forward lookup zone
- **100.168.192.in-addr.arpa** - Reverse lookup zone for internal network
- **101.168.192.in-addr.arpa** - Reverse lookup zone for DMZ network

### DHCP Options
- **Option 003** - Router (192.168.100.1)
- **Option 006** - DNS Servers (192.168.100.10, 192.168.100.1)
- **Option 015** - Domain Name (goldshire.local)
- **Option 044** - WINS Servers (if configured)

## Network Monitoring

### SNMP (Optional)
- **Community String:** public (change in production)
- **Trap Destination:** 192.168.100.20 (Wazuh)
- **Port:** 161/UDP (SNMP), 162/UDP (SNMP Trap)

### Syslog
- **Destination:** 192.168.100.20:514 (Wazuh)
- **Protocol:** UDP
- **Sources:** pfSense, Windows Event Forwarding

## Connectivity Testing

Use these commands to verify network connectivity:

```powershell
# Test connectivity to gateway
Test-Connection -ComputerName 192.168.100.1

# Test DNS resolution
Resolve-DnsName -Name DC01.goldshire.local

# Test domain controller connectivity
Test-Connection -ComputerName DC01.goldshire.local

# Test Wazuh connectivity
Test-NetConnection -ComputerName 192.168.100.20 -Port 5601
```

```bash
# Test connectivity (Linux)
ping -c 4 192.168.100.1
ping -c 4 192.168.100.10
ping -c 4 192.168.100.20

# Test DNS resolution
nslookup DC01.goldshire.local 192.168.100.10

# Test port connectivity
nc -zv 192.168.100.20 5601
```

## Network Troubleshooting

### Common Issues

1. **Cannot reach gateway**
   - Check VMnet configuration in VMware
   - Verify pfSense interface configuration
   - Check firewall rules

2. **DNS resolution fails**
   - Verify DNS server is running on DC
   - Check DNS forwarders configuration
   - Verify client DNS settings

3. **Cannot join domain**
   - Verify DNS resolution works
   - Check time synchronization
   - Verify firewall allows required ports

4. **Wazuh agents cannot connect**
   - Check firewall rules (1514/UDP, 1515/TCP)
   - Verify Wazuh manager is running
   - Check agent configuration

