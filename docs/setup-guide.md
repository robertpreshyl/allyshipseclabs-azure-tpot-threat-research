# T-Pot Honeypot Setup Guide - Azure VM with NetBird Integration

> **Last Updated**: October 2, 2025

This is a comprehensive, step-by-step guide for deploying a T-Pot honeypot on Azure VM with enhanced security controls via NetBird and Elastic Fleet integration. Use this reference to recreate the setup quickly without needing to search through multiple documentation files.

## 📌 Overview

This guide documents the complete process of:

- Creating and configuring an Azure VM
- Configuring Network Security Group (NSG) rules
- Installing T-Pot honeypot platform
- Securing the web interface with Let's Encrypt SSL certificate
- Integrating with NetBird for secure management
- Setting up Elastic Fleet agents for monitoring
- Verifying the complete setup

## ⚙️ Prerequisites

- Azure subscription with appropriate permissions
- Local machine with SSH client
- Domain name (e.g., `yourdomain.com`) with DNS management access
- NetBird infrastructure (see [NetBird Integration Guide](security-enhancements/netbird-integration.md))
- Local Security Onion instance (optional but recommended)
- Basic understanding of Linux administration, network security, and honeypots

## Table of Contents

1. [Azure VM Setup](#azure-vm-setup)
2. [Network Security Group Configuration](#network-security-group-configuration)
3. [Initial VM Configuration](#initial-vm-configuration)
4. [T-Pot Installation](#t-pot-installation)
5. [SSL Configuration with Let's Encrypt](#ssl-configuration-with-lets-encrypt)
6. [NetBird Integration](#netbird-integration)
7. [Elastic Fleet Agent Deployment](#elastic-fleet-agent-deployment)
8. [Verification and Testing](#verification-and-testing)
9. [Security Best Practices](#security-best-practices)
10. [Troubleshooting](#troubleshooting)

## 🖥️ Azure VM Setup

### 1. Create Azure VM

**Recommended Specifications:**
- **OS**: Ubuntu 24.04 LTS
- **Size**: Standard B4ms (4 vCPUs, 16 GB memory)
- **Disk**: 128 GB Premium SSD
- **Authentication**: SSH public key
- **Public IP**: Standard (required for honeypot exposure)

**Creation Steps:**
1. Navigate to Azure Portal
2. Create new Virtual Machine
3. Select Ubuntu 24.04 LTS as the OS
4. Choose Standard B4ms size (or larger based on requirements)
5. Configure SSH public key authentication
6. Enable boot diagnostics
7. Configure availability zone (recommended: Zone 2)

> **Note**: Size up if you plan to enable many honeypots/dashboards. For detailed VM configuration, see: [VM Configuration Guide](azure-configuration/vm-configuration.md)

### 2. Initial Connection

```bash
# Connect to VM via SSH (initial connection)
ssh -i ~/.ssh/your_private_key azureuser@<AZURE_VM_PUBLIC_IP>

# Set user password (required for sudo operations)
sudo passwd azureuser
# Enter and confirm a strong password
```

## 🔒 Network Security Group Configuration

Configure NSG rules to secure management access while exposing honeypot ports.

### Management Ports (Restrict to Your IP)

| Rule # | Name                                 | Port   | Protocol | Source IP            | Action |
|--------|--------------------------------------|--------|----------|----------------------|--------|
| 310    | AllowCidrBlockCustom64295Inbound     | 64295  | TCP      | `<YOUR_PUBLIC_IP>`   | Allow  |
| 320    | AllowMyIpAddressCustom64297Inbound   | 64297  | TCP      | `<YOUR_PUBLIC_IP>`   | Allow  |

> **Important**: Replace `<YOUR_PUBLIC_IP>` with your actual public or VPN IP address.

### Honeypot Ports (Open to Any)

| Rule # | Name                  | Ports                             | Protocol   | Source | Action |
|--------|-----------------------|------------------------------------|------------|--------|---------|
| 330    | AllowSSHInbound        | 22                                 | TCP        | Any    | Allow  |
| 340    | AllowHTTPInbound       | 80                                 | TCP        | Any    | Allow  |
| 350    | AllowHTTPSInbound      | 443                                | TCP        | Any    | Allow  |
| 360    | AllowDNSUDPInbound     | 53                                 | UDP        | Any    | Allow  |
| 370    | AllowTelnetInbound     | 23                                 | TCP        | Any    | Allow  |
| 380    | AllowFTPInbound        | 21                                 | TCP        | Any    | Allow  |
| 390    | AllowSMTPInbound       | 25                                 | TCP        | Any    | Allow  |
| 400    | AllowIMAPPOPInbound    | 110, 143, 993, 995                 | TCP        | Any    | Allow  |
| 410    | AllowRDPInbound        | 3389                               | TCP        | Any    | Allow  |
| 420    | AllowMySQLInbound      | 3306                               | TCP        | Any    | Allow  |
| 430    | AllowMSSQLInbound      | 1433                               | TCP        | Any    | Allow  |
| 440    | AllowOracleInbound     | 1521                               | TCP        | Any    | Allow  |
| 450    | AllowRedisInbound      | 6379                               | TCP        | Any    | Allow  |
| 460    | AllowSIPUDPInbound     | 5060                               | UDP        | Any    | Allow  |
| 470    | AllowModbusInbound     | 502                                | TCP        | Any    | Allow  |
| 480    | AllowS7Inbound         | 102                                | TCP        | Any    | Allow  |
| 490    | AllowBACnetInbound     | 47808                              | TCP        | Any    | Allow  |
| 500    | AllowTelnetAltInbound  | 42, 135, 1723                      | TCP        | Any    | Allow  |
| 510    | AllowHTTPAltInbound    | 8080, 8443                         | TCP        | Any    | Allow  |
| 520    | AllowICMPInbound       | 19, 123, 1900                      | UDP        | Any    | Allow  |

### Associate NSG with VM

```bash
# Get network interface name
NIC_NAME=$(az vm show --resource-group <YOUR_RESOURCE_GROUP> --name <YOUR_VM_NAME> --query networkProfile.networkInterfaces[0].id -o tsv | cut -d'/' -f9)

# Associate NSG with network interface
az network nic update \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --name $NIC_NAME \
  --network-security-group <YOUR_NSG_NAME>
```

> **Security Note**: Honeypot ports are intentionally open to any source to mimic real-world accessible services. Management ports are restricted to your IP for security.

For detailed NSG configuration guidance, see: [NSG Rules Documentation](azure-configuration/nsg-rules.md)

## 💻 Initial VM Configuration

### 1. System Updates and Dependencies

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install -y curl wget git htop nano certbot
```

### 2. Configure SSH Keys (if not done during VM creation)

```bash
# Create .ssh directory
mkdir -p ~/.ssh

# Set proper permissions
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys

# Add your public key to authorized_keys
# Replace <YOUR_PUBLIC_SSH_KEY_HERE> with your actual public key
echo "<YOUR_PUBLIC_SSH_KEY_HERE>" >> ~/.ssh/authorized_keys
```

### 3. Review Port Conflicts

Check for potential port conflicts before T-Pot installation:

```bash
# Check active listening ports
sudo netstat -tulpn | grep LISTEN

# Pay attention to ports that T-Pot will use:
# - 22 (SSH honeypot)
# - 80/443 (HTTP/HTTPS honeypots)
# - 25 (SMTP honeypot)
# - Other service ports as configured
```

## 🐝 T-Pot Installation

### 1. Run T-Pot Installer

```bash
# Download and run the official T-Pot installer
env bash -c "$(curl -sL https://github.com/telekom-security/tpotce/raw/master/install.sh)"
```

### 2. Installation Configuration

During installation:
1. **Enter your user password** when prompted
2. **Create a strong web user and password** for the web interface
3. **Pay attention to port conflict warnings**
4. **Select appropriate T-Pot edition** (Standard recommended)

### 3. Post-Installation Steps

```bash
# Reboot the system
sudo reboot

# Reconnect via SSH on the new port (64295)
ssh -i ~/.ssh/your_private_key azureuser@<AZURE_VM_PUBLIC_IP> -p 64295

# Verify T-Pot is running
dps  # T-Pot alias for docker ps
# Should show all containers with status "Up"
```

## 🔐 SSL Configuration with Let's Encrypt

### 1. DNS Configuration

Create an A record for your domain:
```
# Example DNS record
Record Type: A
Name: tpot (or your preferred subdomain)
Value: <AZURE_VM_PUBLIC_IP>
TTL: 300 (or your preferred value)
```

### 2. Temporary NSG Rule for Certificate Validation

Add temporary rule to allow HTTP traffic for Let's Encrypt validation:

```bash
# Add rule for port 80 (temporary)
az network nsg rule create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name <YOUR_NSG_NAME> \
  --name AllowHTTP80Temp \
  --priority 380 \
  --source-address-prefixes '*' \
  --destination-port-ranges 80 \
  --protocol Tcp \
  --access Allow
```

### 3. Obtain SSL Certificate

```bash
# Stop T-Pot temporarily
sudo systemctl stop tpot

# Obtain certificate using Certbot standalone mode
sudo certbot certonly --standalone -d tpot.yourdomain.com
# Follow prompts:
# - Enter email address
# - Agree to terms
# - Optional: Share email with EFF
```

### 4. Install Certificate in T-Pot

```bash
# Copy certificate files to T-Pot directory
sudo cp /etc/letsencrypt/live/tpot.yourdomain.com/fullchain.pem ~/tpotce/data/nginx/cert/nginx.crt
sudo cp /etc/letsencrypt/live/tpot.yourdomain.com/privkey.pem ~/tpotce/data/nginx/cert/nginx.key

# Set proper ownership and permissions
sudo chown tpot:tpot ~/tpotce/data/nginx/cert/nginx.crt ~/tpotce/data/nginx/cert/nginx.key
sudo chmod 600 ~/tpotce/data/nginx/cert/nginx.key
```

### 5. Optional: Change to Standard HTTPS Port

```bash
# Edit T-Pot environment file
sudo nano ~/tpotce/.env

# Change from:
# TPOT_HTTPS_PORT=64297
# To:
# TPOT_HTTPS_PORT=443

# Update NSG rules accordingly if changing to port 443
```

### 6. Restart T-Pot

```bash
# Start T-Pot with new SSL configuration
sudo systemctl start tpot

# Remove temporary HTTP rule (optional)
az network nsg rule delete \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name <YOUR_NSG_NAME> \
  --name AllowHTTP80Temp
```

## 🔗 NetBird Integration

For secure management access, integrate with NetBird:

### 1. NetBird Setup

Refer to the comprehensive NetBird integration guide:
- **Reference**: [NetBird Integration Guide](security-enhancements/netbird-integration.md)

### 2. Management Access via NetBird

Once NetBird is configured:

```bash
# Connect via NetBird overlay network
ssh azureuser@<NETBIRD_PEER_IP> -p 64295

# Access T-Pot web interface securely
https://<NETBIRD_PEER_IP>:64297
```

### 3. Security Benefits

- **Zero-Trust Access**: All management traffic encrypted via WireGuard
- **Dynamic IP Support**: Works with changing IP addresses
- **Policy-Based Access**: Granular access control policies
- **Audit Trail**: Complete logging of network connections

## 📋 Elastic Fleet Agent Deployment

### 1. Download and Install Elastic Fleet Agent

```bash
# Download the latest Elastic Agent
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.11.0-linux-x86_64.tar.gz

# Extract the agent
tar xzvf elastic-agent-8.11.0-linux-x86_64.tar.gz
cd elastic-agent-8.11.0-linux-x86_64
```

### 2. Install and Configure Agent

```bash
# Install Elastic Agent with Fleet Server configuration
sudo ./elastic-agent install \
  --url=https://<SECURITY_ONION_IP>:8220 \
  --enrollment-token=<ENROLLMENT_TOKEN> \
  --fleet-server-es=https://<SECURITY_ONION_IP>:9200 \
  --fleet-server-service-token=<FLEET_SERVICE_TOKEN>
```

### 3. Verify Agent Installation

```bash
# Check agent status
sudo elastic-agent status

# View agent logs
sudo journalctl -u elastic-agent -f
```

For detailed Elastic Fleet configuration, see: [Elastic Fleet Setup Guide](security-enhancements/elastic-fleet-setup.md)
  --url=https://your-security-onion-instance:9200 \
  --enrollment-token=<YOUR_ENROLLMENT_TOKEN> \
  --fleet-server-es=https://your-security-onion-instance:9200 \
  --fleet-server-service-token=<YOUR_SERVICE_TOKEN>
```

### 3. Verify Agent Status

```bash
# Check agent status
sudo ./elastic-agent status

# View agent logs
sudo journalctl -u elastic-agent -f
```

## Verification and Testing

### 1. Test Honeypot Functionality

```bash
# Test SSH honeypot
ssh root@<YOUR_VM_IP> -p 22

# Test HTTP honeypot
curl -I http://<YOUR_VM_IP>

# Check T-Pot logs
sudo docker-compose logs -f
```

### 2. Verify NetBird Connectivity

```bash
# Test NetBird connection
ping <SECURITY_ONION_IP>

# Test log forwarding
sudo netstat -tulpn | grep 9200
```

### 3. Access Kibana Dashboard

Navigate to `https://<YOUR_VM_IP>:64297` and verify:
- Attack data is being captured
- Dashboards are displaying correctly
- Log forwarding to Security Onion is working

## Common Issues and Solutions

### Port Conflicts
If you encounter port conflicts during installation:

```bash
# Check for conflicting services
sudo netstat -tulpn | grep :<PORT>

# Stop conflicting services
sudo systemctl stop <SERVICE_NAME>
```

### NetBird Connection Issues
If NetBird fails to connect:

```bash
# Check NetBird status
sudo netbird status

# Restart NetBird service
sudo systemctl restart netbird

# Check firewall rules
sudo ufw status
```

### T-Pot Service Issues
If T-Pot services fail to start:

```bash
# Check Docker status
sudo systemctl status docker

# Restart T-Pot services
cd /opt/tpot
sudo docker-compose down
sudo docker-compose up -d
```

## Security Considerations

- **Regular Updates**: Keep all components updated
- **Access Monitoring**: Monitor NetBird access logs
- **Data Retention**: Implement appropriate log retention policies
- **Backup Strategy**: Regular backups of configuration and data
- **Incident Response**: Have procedures for handling detected attacks

## 🚀 Next Steps

After successful installation and verification:

1. **[Configure Security Enhancements](security-enhancements/)** - Implement zero-trust architecture
2. **[Set up Research Monitoring](research-findings/)** - Configure comprehensive monitoring
3. **[Review Compliance Requirements](compliance/)** - Ensure regulatory compliance
4. **[Begin Data Collection and Analysis](research-findings/attack-analysis.md)** - Start threat research

### Additional Resources

- **[T-Pot Documentation](https://github.com/dtag-dev-sec/tpotce)** - Official T-Pot documentation
- **[NetBird Documentation](https://docs.netbird.io/)** - NetBird setup and configuration
- **[Azure VM Documentation](https://docs.microsoft.com/azure/virtual-machines/)** - Azure VM management
- **[Let's Encrypt Documentation](https://letsencrypt.org/docs/)** - SSL certificate management
- **[Security Best Practices](security-enhancements/)** - Advanced security configurations

### Support and Community

- **GitHub Issues**: Report issues and get community support
- **Security Research**: Share findings with the cybersecurity community
- **Documentation Updates**: Contribute to improving this guide

---

> **📝 Note**: This guide is continuously updated based on community feedback and new T-Pot releases. Please check for updates regularly and contribute improvements where possible.

*Last Updated: October 2, 2025*
