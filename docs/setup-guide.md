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

### 1. Create Virtual Machine

```bash
# Create resource group
az group create --name tpot-research-rg --location eastus

# Create virtual machine
az vm create \
  --resource-group tpot-research-rg \
  --name tpot-honeypot \
  --image Ubuntu2204 \
  --size Standard_D2s_v3 \
  --admin-username azureuser \
  --generate-ssh-keys \
  --public-ip-sku Standard
```

### 2. Configure VM Settings

```bash
# Enable boot diagnostics
az vm boot-diagnostics enable \
  --resource-group tpot-research-rg \
  --name tpot-honeypot

# Set up managed identity
az vm identity assign \
  --resource-group tpot-research-rg \
  --name tpot-honeypot
```

[![VM Configuration](assets/screenshots/vm-configuration.png)](assets/screenshots/vm-configuration.png)

## Network Security Group Configuration

### 1. Create NSG Rules for Management

```bash
# Create NSG
az network nsg create \
  --resource-group tpot-research-rg \
  --name tpot-nsg

# Allow NetBird management ports (restricted to NetBird IP)
az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-netbird-ssh \
  --priority 100 \
  --source-address-prefixes <NETBIRD_IP_RANGE> \
  --destination-port-ranges 64295 \
  --access Allow \
  --protocol Tcp

az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-netbird-web \
  --priority 101 \
  --source-address-prefixes <NETBIRD_IP_RANGE> \
  --destination-port-ranges 64297 \
  --access Allow \
  --protocol Tcp
```

### 2. Create NSG Rules for Honeypot Services

```bash
# Allow honeypot ports from anywhere
az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-ssh-honeypot \
  --priority 200 \
  --source-address-prefixes Internet \
  --destination-port-ranges 22 \
  --access Allow \
  --protocol Tcp

az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-http-honeypot \
  --priority 201 \
  --source-address-prefixes Internet \
  --destination-port-ranges 80 \
  --access Allow \
  --protocol Tcp

az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-https-honeypot \
  --priority 202 \
  --source-address-prefixes Internet \
  --destination-port-ranges 443 \
  --access Allow \
  --protocol Tcp

# Additional honeypot ports
az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-honeypot-ports \
  --priority 203 \
  --source-address-prefixes Internet \
  --destination-port-ranges 21,23,25,53,110,143,993,995,1723,3306,3389,5432,5900,8080 \
  --access Allow \
  --protocol Tcp
```

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

### 1. Install NetBird Client

```bash
# Download and install NetBird
curl -fsSL https://pkgs.netbird.io/debian/install.sh | sudo bash

# Start NetBird service
sudo systemctl start netbird
sudo systemctl enable netbird
```

### 2. Configure NetBird Access

```bash
# Join NetBird network (use your setup key)
sudo netbird up --setup-key <YOUR_SETUP_KEY>

# Verify connection
sudo netbird status
```

### 3. Configure Access Policies

Access the NetBird management interface and configure policies:

- **Honeypot Management**: Allow SSH access on port 64295
- **Web Interface**: Allow HTTPS access on port 64297
- **Log Forwarding**: Allow communication with Security Onion

[![NetBird Configuration](assets/screenshots/netbird-config.png)](assets/screenshots/netbird-config.png)

## SSL Configuration with Let's Encrypt

### 1. Install Certbot

```bash
# Install Certbot
sudo apt install -y certbot

# Install Nginx plugin
sudo apt install -y python3-certbot-nginx
```

### 2. Configure Domain and SSL

```bash
# Obtain SSL certificate
sudo certbot --nginx -d your-honeypot-domain.com

# Test certificate renewal
sudo certbot renew --dry-run
```

[![SSL Configuration](assets/screenshots/ssl-config.png)](assets/screenshots/ssl-config.png)

### 3. Configure Automatic Renewal

```bash
# Add to crontab
echo "0 12 * * * /usr/bin/certbot renew --quiet" | sudo crontab -
```

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
