#!/bin/bash
# Wazuh Server Installation Script
# Installs Wazuh manager and dashboard on Ubuntu 22.04

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
WAZUH_MANAGER_IP="192.168.100.20"

echo -e "${GREEN}Starting Wazuh Server Installation...${NC}"

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

# Update system
echo -e "${YELLOW}Updating system packages...${NC}"
apt-get update
apt-get upgrade -y

# Install prerequisites
echo -e "${YELLOW}Installing prerequisites...${NC}"
apt-get install -y curl apt-transport-https lsb-release gnupg2

# Add Wazuh repository
echo -e "${YELLOW}Adding Wazuh repository...${NC}"
curl -s https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --no-default-keyring --keyring gnupg-ring:/usr/share/keyrings/wazuh.gpg --import
chmod 644 /usr/share/keyrings/wazuh.gpg
echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" | tee -a /etc/apt/sources.list.d/wazuh.list

# Update package list
apt-get update

# Install Wazuh Manager
echo -e "${YELLOW}Installing Wazuh Manager...${NC}"
WAZUH_MANAGER="$WAZUH_MANAGER_IP" apt-get install wazuh-manager -y

# Start and enable Wazuh Manager
systemctl daemon-reload
systemctl enable wazuh-manager
systemctl start wazuh-manager

# Check status
if systemctl is-active --quiet wazuh-manager; then
    echo -e "${GREEN}Wazuh Manager is running${NC}"
else
    echo -e "${RED}Wazuh Manager failed to start${NC}"
    exit 1
fi

# Install Wazuh Dashboard
echo -e "${YELLOW}Installing Wazuh Dashboard...${NC}"
WAZUH_MANAGER="$WAZUH_MANAGER_IP" apt-get install wazuh-dashboard -y

# Start and enable Wazuh Dashboard
systemctl daemon-reload
systemctl enable wazuh-dashboard
systemctl start wazuh-dashboard

# Check status
if systemctl is-active --quiet wazuh-dashboard; then
    echo -e "${GREEN}Wazuh Dashboard is running${NC}"
else
    echo -e "${RED}Wazuh Dashboard failed to start${NC}"
    exit 1
fi

# Configure firewall
echo -e "${YELLOW}Configuring firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 1514/udp
    ufw allow 1515/tcp
    ufw allow 55000/tcp
    ufw allow 5601/tcp
    ufw allow 514/udp
    echo -e "${GREEN}Firewall rules added${NC}"
fi

# Display information
echo -e "${GREEN}Wazuh Server Installation Complete!${NC}"
echo -e "${YELLOW}Wazuh Manager IP: ${WAZUH_MANAGER_IP}${NC}"
echo -e "${YELLOW}Dashboard URL: https://${WAZUH_MANAGER_IP}:5601${NC}"
echo -e "${YELLOW}Default credentials: admin/admin${NC}"
echo -e "${YELLOW}Please change the default password after first login!${NC}"

