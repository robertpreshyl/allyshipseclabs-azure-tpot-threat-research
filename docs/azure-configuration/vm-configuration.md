# Azure VM Configuration for T-Pot Honeypot

> **Last Updated**: October 2, 2025

This guide provides detailed specifications and configuration steps for provisioning an Azure VM optimized for T-Pot honeypot deployment.

## 🖥️ Recommended VM Specifications

### Minimum Requirements
- **vCPUs**: 4 cores (recommended minimum)
- **RAM**: 16 GB (recommended minimum) 
- **Storage**: 128 GB Premium SSD
- **OS**: Ubuntu 24.04 LTS (latest supported)
- **Public IP**: Standard SKU (required for honeypot exposure)
- **Availability**: Single availability zone (Zone 2 recommended)

### Production Recommendations
- **vCPUs**: 8 cores (for high-traffic deployments)
- **RAM**: 32 GB (for comprehensive logging and multiple honeypots)
- **Storage**: 256 GB Premium SSD (for extended log retention)
- **Backup**: Enable automated backups
- **Monitoring**: Enable boot diagnostics and performance monitoring

> **📝 Note**: Scale up resources if you plan to enable many honeypots, extensive logging, or real-time dashboards.

## 🚀 VM Creation Process

### Method 1: Azure Portal (Recommended for Beginners)

1. **Navigate to Azure Portal**
   - Go to [Azure Portal](https://portal.azure.com)
   - Click "Create a resource" > "Virtual Machine"

2. **Basic Configuration**
   - **Subscription**: Select your Azure subscription
   - **Resource Group**: Create new or select existing
   - **VM Name**: Choose descriptive name (e.g., `tpot-honeypot-vm`)
   - **Region**: Select appropriate region (North Europe recommended)
   - **Availability Zone**: Zone 2 (for better performance)

3. **Image and Size**
   - **Image**: Ubuntu Server 24.04 LTS - x64 Gen2
   - **Size**: Standard_B4ms (4 vCPUs, 16 GiB memory) or larger
   - **Authentication**: SSH public key (recommended)

4. **Networking Configuration**
   - **Virtual Network**: Create new or use existing
   - **Subnet**: Default subnet is acceptable
   - **Public IP**: Create new (Standard SKU)
   - **NIC NSG**: Create new (will be configured later)
   - **Accelerated Networking**: Enable if supported

5. **Management Options**
   - **Boot Diagnostics**: Enable
   - **Auto-shutdown**: Configure if desired
   - **Backup**: Enable Azure Backup (recommended)
   - **Monitoring**: Enable basic monitoring

### Method 2: Azure CLI (Advanced Users)

```bash
# Set variables
RESOURCE_GROUP="tpot-research-rg"
VM_NAME="tpot-honeypot-vm"
LOCATION="northeurope"
ADMIN_USERNAME="azureuser"
SSH_KEY_PATH="~/.ssh/id_rsa.pub"

# Create resource group
az group create --name $RESOURCE_GROUP --location $LOCATION

# Create VM
az vm create \
  --resource-group $RESOURCE_GROUP \
  --name $VM_NAME \
  --location $LOCATION \
  --size Standard_B4ms \
  --image Ubuntu2404 \
  --admin-username $ADMIN_USERNAME \
  --ssh-key-values @$SSH_KEY_PATH \
  --public-ip-sku Standard \
  --storage-sku Premium_LRS \
  --os-disk-size-gb 128 \
  --zone 2 \
  --enable-agent true \
  --enable-auto-update true
```

## 🔒 Initial Security Configuration

### SSH Key Setup (if not configured during creation)

```bash
# Generate SSH key pair (if needed)
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/tpot_key

# Copy public key to VM
ssh-copy-id -i ~/.ssh/tpot_key.pub azureuser@<VM_PUBLIC_IP>
```

### Post-Creation Security Steps

```bash
# Connect to VM
ssh -i ~/.ssh/tpot_key azureuser@<VM_PUBLIC_IP>

# Update system
sudo apt update && sudo apt upgrade -y

# Set user password (required for sudo operations)
sudo passwd azureuser

# Configure automatic security updates
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure -plow unattended-upgrades
```

## 🛡️ Security Considerations

### Network Security
- **NSG Configuration**: Implement strict NSG rules before T-Pot installation
- **SSH Access**: Restrict SSH access to management networks only
- **Public IP**: Use Standard SKU for better DDoS protection
- **Monitoring**: Enable network monitoring and logging

### System Security
- **OS Hardening**: Apply security hardening guidelines
- **Automatic Updates**: Enable automatic security updates
- **Backup Strategy**: Implement regular backup procedures
- **Access Control**: Use SSH keys instead of passwords

### Compliance and Legal
- **Azure Terms**: Ensure compliance with Azure Terms of Service
- **Data Protection**: Implement appropriate data protection measures
- **Logging**: Enable comprehensive logging for audit purposes
- **Incident Response**: Prepare incident response procedures

## 📋 Management Approach

### Recommended Management Strategy
- **Primary Access**: Use NetBird overlay network for secure management
- **Backup Access**: Configure emergency access procedures
- **Monitoring**: Implement comprehensive monitoring and alerting
- **Automation**: Use infrastructure as code for reproducible deployments

### NetBird Integration Benefits
- **Zero-Trust Access**: All management traffic encrypted via WireGuard
- **Dynamic IP Support**: Works with changing public IP addresses
- **Policy-Based Control**: Granular access control policies
- **Audit Trail**: Complete logging of all network connections

## 📊 Monitoring and Performance

### Azure Monitor Integration

```bash
# Enable Azure Monitor Agent (optional)
az vm extension set \
  --resource-group $RESOURCE_GROUP \
  --vm-name $VM_NAME \
  --name AzureMonitorLinuxAgent \
  --publisher Microsoft.Azure.Monitor
```

### Performance Monitoring
- **CPU Usage**: Monitor CPU utilization during attack periods
- **Memory Usage**: Track memory consumption of honeypot services
- **Disk I/O**: Monitor disk performance for log writing
- **Network Traffic**: Track inbound attack traffic patterns

## 🔧 Troubleshooting Common Issues

### VM Performance Issues
```bash
# Check system resources
htop
df -h
free -m
iostat -x 1
```

### Network Connectivity Issues
```bash
# Test network connectivity
ping 8.8.8.8
nslookup google.com
netstat -tulpn | grep LISTEN
```

### SSH Access Issues
```bash
# Check SSH service status
sudo systemctl status ssh

# View SSH logs
sudo journalctl -u ssh -f

# Test SSH configuration
sudo sshd -t
```

## 🚀 Next Steps

After VM provisioning and initial configuration:

1. **[Configure Network Security Groups](nsg-rules.md)** - Set up proper firewall rules
2. **[Install T-Pot Honeypot](../setup-guide.md)** - Deploy the honeypot platform
3. **[Configure SSL/TLS](ssl-configuration.md)** - Secure web interfaces
4. **[Integrate with NetBird](../security-enhancements/netbird-integration.md)** - Enable secure management
5. **[Set up Monitoring](../security-enhancements/elastic-fleet-setup.md)** - Configure comprehensive monitoring

## 📚 Additional Resources

- **[Azure VM Documentation](https://docs.microsoft.com/azure/virtual-machines/)** - Official Azure VM documentation
- **[Ubuntu Server Guide](https://ubuntu.com/server/docs)** - Ubuntu server configuration
- **[Azure Security Best Practices](https://docs.microsoft.com/azure/security/)** - Azure security guidelines
- **[T-Pot Requirements](https://github.com/dtag-dev-sec/tpotce)** - Official T-Pot system requirements

---

> **📝 Note**: This configuration guide is optimized for T-Pot honeypot deployment. Adjust specifications based on your specific requirements and expected attack volume.
