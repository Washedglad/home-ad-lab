#!/bin/bash
# Wazuh Configuration Script
# Configures Wazuh manager for syslog reception and basic settings

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration file
OSSEC_CONF="/var/ossec/etc/ossec.conf"

echo -e "${GREEN}Configuring Wazuh...${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

# Backup original configuration
if [ -f "$OSSEC_CONF" ]; then
    cp "$OSSEC_CONF" "${OSSEC_CONF}.backup.$(date +%Y%m%d_%H%M%S)"
    echo -e "${GREEN}Configuration backed up${NC}"
fi

# Check if syslog remote section exists
if grep -q "<remote>" "$OSSEC_CONF"; then
    echo -e "${YELLOW}Remote syslog configuration already exists${NC}"
else
    echo -e "${YELLOW}Adding syslog remote configuration...${NC}"
    # This is a simplified approach - in production, use proper XML editing
    echo "Note: Manual configuration of syslog reception may be required"
    echo "Edit $OSSEC_CONF and add:"
    echo "<remote>"
    echo "  <connection>syslog</connection>"
    echo "  <port>514</port>"
    echo "  <protocol>udp</protocol>"
    echo "  <allowed-ips>192.168.100.0/24</allowed-ips>"
    echo "  <allowed-ips>192.168.101.0/24</allowed-ips>"
    echo "</remote>"
fi

# Restart Wazuh Manager
echo -e "${YELLOW}Restarting Wazuh Manager...${NC}"
systemctl restart wazuh-manager

if systemctl is-active --quiet wazuh-manager; then
    echo -e "${GREEN}Wazuh Manager restarted successfully${NC}"
else
    echo -e "${RED}Wazuh Manager failed to restart${NC}"
    exit 1
fi

echo -e "${GREEN}Wazuh configuration complete${NC}"
echo -e "${YELLOW}Please verify configuration in Wazuh dashboard${NC}"

