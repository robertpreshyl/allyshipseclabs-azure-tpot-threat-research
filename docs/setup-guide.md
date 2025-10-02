# T-Pot Honeypot Setup Guide with NetBird Integration

This guide provides step-by-step instructions for deploying a T-Pot honeypot on Azure with enhanced security controls via NetBird and Elastic Fleet integration.

## Prerequisites

- Azure subscription with appropriate permissions
- NetBird infrastructure (see [NetBird Integration Guide](security-enhancements/netbird-integration.md))
- Local Security Onion instance (optional but recommended)
- Basic understanding of Linux administration and network security

## Table of Contents

1. [Azure VM Setup](#azure-vm-setup)
2. [Network Security Group Configuration](#network-security-group-configuration)
3. [T-Pot Installation](#t-pot-installation)
4. [NetBird Integration](#netbird-integration)
5. [SSL Configuration with Let's Encrypt](#ssl-configuration-with-lets-encrypt)
6. [Elastic Fleet Agent Deployment](#elastic-fleet-agent-deployment)
7. [Verification and Testing](#verification-and-testing)

## Azure VM Setup

Use the selection checklist and Azure quickstart to provision the VM:
- VM selection and notes: [VM Configuration](azure-configuration/vm-configuration.md)
- Azure Portal quickstart (Ubuntu): `https://learn.microsoft.com/azure/virtual-machines/linux/quick-create-portal`
[![VM Configuration](assets/screenshots/vm-configuration.png)](assets/screenshots/vm-configuration.png)

## Network Security Group Configuration

Follow best practices and examples here:
- NSG guidance for T-Pot: [NSG Rules](azure-configuration/nsg-rules.md)

[![NSG Configuration](assets/screenshots/nsg-config.png)](assets/screenshots/nsg-config.png)

### 3. Associate NSG with VM

```bash
# Get network interface name
NIC_NAME=$(az vm show --resource-group tpot-research-rg --name tpot-honeypot --query networkProfile.networkInterfaces[0].id -o tsv | cut -d'/' -f9)

# Associate NSG with network interface
az network nic update \
  --resource-group tpot-research-rg \
  --name $NIC_NAME \
  --network-security-group tpot-nsg
```

## T-Pot Installation

### 1. Connect to VM via NetBird

```bash
# Connect using NetBird (replace with your NetBird peer IP)
ssh azureuser@<NETBIRD_PEER_IP> -p 64295
```

### 2. Update System and Install Dependencies

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y curl wget git htop

# Install Docker (required for T-Pot)
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
```

### 3. Download and Install T-Pot

```bash
# Download T-Pot installer
wget https://github.com/dtag-dev-sec/tpotce/releases/latest/download/tpot.iso

# Create installation directory
sudo mkdir -p /opt/tpot
cd /opt/tpot

# Extract T-Pot
sudo 7z x /home/azureuser/tpot.iso
```

### 4. Configure T-Pot

```bash
# Edit T-Pot configuration
sudo nano /opt/tpot/etc/tpot.yml

# Key configuration settings:
# - Set admin password
# - Configure Elasticsearch settings
# - Set up log retention policies
# - Configure honeypot services
```

[![T-Pot Installation](assets/screenshots/installation-process.png)](assets/screenshots/installation-process.png)

### 5. Start T-Pot Services

```bash
# Start T-Pot
cd /opt/tpot
sudo docker-compose up -d

# Verify services are running
sudo docker-compose ps
```

## NetBird Integration

Use the official guide (self-hosted) and environment notes here:
- Reference: [NetBird Integration](security-enhancements/netbird-integration.md)

## SSL Configuration with Let's Encrypt

Follow the dedicated guide:
- [SSL Configuration](azure-configuration/ssl-configuration.md)

## Elastic Fleet Agent Deployment

### 1. Download Elastic Fleet Agent

```bash
# Download agent
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.11.0-linux-x86_64.tar.gz

# Extract agent
tar xzvf elastic-agent-8.11.0-linux-x86_64.tar.gz
cd elastic-agent-8.11.0-linux-x86_64
```

### 2. Configure Agent

```bash
# Create agent configuration
sudo ./elastic-agent install \
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

## Next Steps

After successful installation:

1. [Configure Security Enhancements](security-enhancements/)
2. [Set up Research Monitoring](research-findings/)
3. [Review Compliance Requirements](compliance/)
4. [Begin Data Collection and Analysis](research-findings/attack-analysis.md)

---

*For additional support, refer to the [T-Pot Documentation](https://github.com/dtag-dev-sec/tpotce) and [NetBird Documentation](https://docs.netbird.io/).*
