# Azure VM Configuration for T-Pot Honeypot

This document details the Azure Virtual Machine configuration for the T-Pot honeypot deployment, including security hardening and optimization settings.

## VM Specifications

### Recommended Configuration

| Component | Specification | Rationale |
|-----------|---------------|-----------|
| **Size** | Standard_D2s_v3 | 2 vCPUs, 8GB RAM - sufficient for T-Pot services |
| **OS** | Ubuntu 22.04 LTS | Latest LTS with long-term support |
| **Storage** | 128GB Premium SSD | Fast I/O for log processing |
| **Network** | Standard Public IP | Required for honeypot exposure |

### Cost Optimization

For research purposes, consider:
- **Spot Instances**: Up to 90% cost savings (with risk of interruption)
- **Reserved Instances**: 1-3 year commitment for significant savings
- **Auto-shutdown**: Configure automatic shutdown during non-research hours

## Security Hardening

### 1. System Updates

```bash
# Update package lists
sudo apt update

# Install security updates
sudo apt upgrade -y

# Enable automatic security updates
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
```

### 2. Firewall Configuration

```bash
# Install and configure UFW
sudo apt install -y ufw

# Default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow NetBird management (adjust IP range as needed)
sudo ufw allow from <NETBIRD_IP_RANGE> to any port 64295
sudo ufw allow from <NETBIRD_IP_RANGE> to any port 64297

# Enable firewall
sudo ufw enable
```

### 3. SSH Hardening

```bash
# Edit SSH configuration
sudo nano /etc/ssh/sshd_config

# Key security settings:
# Port 64295 (non-standard)
# PermitRootLogin no
# PasswordAuthentication no
# PubkeyAuthentication yes
# MaxAuthTries 3
# ClientAliveInterval 300
# ClientAliveCountMax 2

# Restart SSH service
sudo systemctl restart sshd
```

### 4. User Management

```bash
# Create dedicated user for T-Pot
sudo useradd -m -s /bin/bash tpotuser
sudo usermod -aG docker tpotuser

# Set up SSH keys
sudo mkdir -p /home/tpotuser/.ssh
sudo cp /home/azureuser/.ssh/authorized_keys /home/tpotuser/.ssh/
sudo chown -R tpotuser:tpotuser /home/tpotuser/.ssh
sudo chmod 700 /home/tpotuser/.ssh
sudo chmod 600 /home/tpotuser/.ssh/authorized_keys
```

## Performance Optimization

### 1. System Limits

```bash
# Edit limits configuration
sudo nano /etc/security/limits.conf

# Add performance limits:
# * soft nofile 65536
# * hard nofile 65536
# * soft nproc 32768
# * hard nproc 32768
```

### 2. Kernel Parameters

```bash
# Edit sysctl configuration
sudo nano /etc/sysctl.conf

# Add performance tuning:
# net.core.rmem_max = 16777216
# net.core.wmem_max = 16777216
# net.ipv4.tcp_rmem = 4096 65536 16777216
# net.ipv4.tcp_wmem = 4096 65536 16777216
# vm.max_map_count = 262144

# Apply changes
sudo sysctl -p
```

### 3. Docker Optimization

```bash
# Configure Docker daemon
sudo nano /etc/docker/daemon.json

# Add optimization settings:
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m",
    "max-file": "3"
  },
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}

# Restart Docker
sudo systemctl restart docker
```

## Monitoring and Logging

### 1. System Monitoring

```bash
# Install monitoring tools
sudo apt install -y htop iotop nethogs

# Configure log rotation
sudo nano /etc/logrotate.d/tpot

# Add log rotation rules:
# /var/log/tpot/*.log {
#     daily
#     missingok
#     rotate 7
#     compress
#     delaycompress
#     notifempty
#     create 644 root root
# }
```

### 2. Azure Monitoring

```bash
# Install Azure CLI
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Configure monitoring
az monitor diagnostic-settings create \
  --resource-group tpot-research-rg \
  --resource tpot-honeypot \
  --name tpot-monitoring \
  --logs '[{"category": "AllLogs", "enabled": true}]' \
  --metrics '[{"category": "AllMetrics", "enabled": true}]'
```

## Backup Configuration

### 1. Automated Backups

```bash
# Create backup script
sudo nano /usr/local/bin/tpot-backup.sh

#!/bin/bash
# T-Pot backup script
BACKUP_DIR="/opt/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup T-Pot configuration
tar -czf $BACKUP_DIR/tpot-config-$DATE.tar.gz /opt/tpot/etc/

# Backup Docker volumes
docker run --rm -v tpot_data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/tpot-data-$DATE.tar.gz -C /data .

# Cleanup old backups (keep 7 days)
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

# Make script executable
sudo chmod +x /usr/local/bin/tpot-backup.sh

# Add to crontab (daily at 2 AM)
echo "0 2 * * * /usr/local/bin/tpot-backup.sh" | sudo crontab -
```

### 2. Azure Backup Integration

```bash
# Create recovery services vault
az backup vault create \
  --resource-group tpot-research-rg \
  --name tpot-backup-vault \
  --location eastus

# Enable backup for VM
az backup protection enable-for-vm \
  --resource-group tpot-research-rg \
  --vault-name tpot-backup-vault \
  --vm tpot-honeypot \
  --policy-name DefaultPolicy
```

## Network Configuration

### 1. DNS Configuration

```bash
# Configure DNS resolvers
sudo nano /etc/systemd/resolved.conf

# Add DNS servers:
# DNS=8.8.8.8 8.8.4.4 1.1.1.1

# Restart DNS service
sudo systemctl restart systemd-resolved
```

### 2. Network Interface Optimization

```bash
# Configure network interface
sudo nano /etc/netplan/50-cloud-init.yaml

# Add performance settings:
# network:
#   version: 2
#   ethernets:
#     eth0:
#       dhcp4: true
#       dhcp6: false
#       optional: true

# Apply network configuration
sudo netplan apply
```

## Security Considerations

### 1. Regular Security Audits

```bash
# Install security audit tools
sudo apt install -y lynis chkrootkit rkhunter

# Run security audit
sudo lynis audit system

# Check for rootkits
sudo chkrootkit
sudo rkhunter --check
```

### 2. Intrusion Detection

```bash
# Install AIDE (Advanced Intrusion Detection Environment)
sudo apt install -y aide

# Initialize AIDE database
sudo aideinit

# Move database to proper location
sudo mv /var/lib/aide/aide.db.new /var/lib/aide/aide.db

# Create daily check script
sudo nano /usr/local/bin/aide-check.sh

#!/bin/bash
aide --check | mail -s "AIDE Report for $(hostname)" admin@yourdomain.com

# Make executable and schedule
sudo chmod +x /usr/local/bin/aide-check.sh
echo "0 6 * * * /usr/local/bin/aide-check.sh" | sudo crontab -
```

## Troubleshooting

### Common Issues

1. **High CPU Usage**
   ```bash
   # Check running processes
   top
   
   # Check Docker container resource usage
   docker stats
   ```

2. **Memory Issues**
   ```bash
   # Check memory usage
   free -h
   
   # Check swap usage
   swapon -s
   ```

3. **Network Connectivity**
   ```bash
   # Test network connectivity
   ping 8.8.8.8
   
   # Check network interfaces
   ip addr show
   ```

### Performance Monitoring

```bash
# Create monitoring script
sudo nano /usr/local/bin/system-monitor.sh

#!/bin/bash
# System monitoring script
echo "=== System Status $(date) ===" >> /var/log/system-monitor.log
echo "CPU Usage:" >> /var/log/system-monitor.log
top -bn1 | grep "Cpu(s)" >> /var/log/system-monitor.log
echo "Memory Usage:" >> /var/log/system-monitor.log
free -h >> /var/log/system-monitor.log
echo "Disk Usage:" >> /var/log/system-monitor.log
df -h >> /var/log/system-monitor.log
echo "Docker Status:" >> /var/log/system-monitor.log
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" >> /var/log/system-monitor.log
echo "================================" >> /var/log/system-monitor.log

# Make executable and schedule (every 15 minutes)
sudo chmod +x /usr/local/bin/system-monitor.sh
echo "*/15 * * * * /usr/local/bin/system-monitor.sh" | sudo crontab -
```

## Next Steps

After VM configuration:

1. [Configure Network Security Groups](nsg-rules.md)
2. [Set up SSL/TLS Configuration](ssl-configuration.md)
3. [Install and Configure T-Pot](../setup-guide.md)
4. [Integrate with NetBird](../security-enhancements/netbird-integration.md)

---

*For additional Azure-specific guidance, refer to the [Azure Virtual Machines Documentation](https://docs.microsoft.com/en-us/azure/virtual-machines/).*
