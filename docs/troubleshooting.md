# T-Pot Honeypot Troubleshooting Guide

> **Last Updated**: October 2, 2025

This comprehensive troubleshooting guide addresses common issues encountered during T-Pot honeypot deployment, configuration, and operation on Azure.

## 🚨 Emergency Quick Fixes

### T-Pot Services Not Starting
```bash
# Quick diagnostic commands
sudo systemctl status tpot
sudo journalctl -u tpot -n 50 --no-pager
dps  # T-Pot docker ps alias

# Quick restart
sudo systemctl stop tpot
sleep 10
sudo systemctl start tpot
```

### Cannot Access Web Interface
```bash
# Check if service is running
sudo netstat -tulpn | grep 64297

# Test local connectivity
curl -k https://localhost:64297

# Check SSL certificate
ls -la ~/tpotce/data/nginx/cert/
```

### SSH Access Issues
```bash
# Check SSH service
sudo systemctl status ssh
sudo netstat -tulpn | grep 64295

# Test SSH configuration
sudo sshd -t
```

## 🔧 Systematic Troubleshooting

### 1. T-Pot Installation Issues

#### Problem: Installation Script Fails
```bash
# Check system requirements
df -h  # Ensure sufficient disk space (>100GB free)
free -m  # Ensure sufficient RAM (>8GB)
nproc  # Check CPU cores (>2 recommended)

# Check internet connectivity
ping -c 3 8.8.8.8
curl -I https://github.com

# Retry installation with verbose output
env bash -c "$(curl -sL https://github.com/telekom-security/tpotce/raw/master/install.sh)" 2>&1 | tee tpot-install.log
```

#### Problem: Docker Installation Fails
```bash
# Remove conflicting Docker packages
sudo apt remove docker docker-engine docker.io containerd runc

# Install Docker manually
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Test Docker installation
docker run hello-world
```

#### Problem: Port Conflicts During Installation
```bash
# Identify conflicting services
sudo netstat -tulpn | grep -E ':(22|80|443|25|3389|3306|1433|6379|5060)\s'

# Stop conflicting services
sudo systemctl stop apache2  # Example for Apache
sudo systemctl stop mysql    # Example for MySQL
sudo systemctl disable apache2  # Prevent auto-start

# Check for other honeypot installations
ps aux | grep -E '(cowrie|dionaea|glastopf|honeytrap)'
```

### 2. Network Connectivity Issues

#### Problem: Cannot Connect to Honeypot Services
```bash
# Check Azure NSG rules
az network nsg rule list \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name <YOUR_NSG_NAME> \
  --output table

# Test port connectivity from external host
nmap -p 22,80,443,25,3389 <AZURE_VM_PUBLIC_IP>

# Check local firewall (UFW)
sudo ufw status verbose

# Check iptables rules
sudo iptables -L -n -v
```

#### Problem: Management Ports Not Accessible
```bash
# Verify your current public IP
curl -s ifconfig.me

# Check NSG rules for management ports
az network nsg rule show \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name <YOUR_NSG_NAME> \
  --name AllowCidrBlockCustom64295Inbound

# Update NSG rule with correct IP
az network nsg rule update \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name <YOUR_NSG_NAME> \
  --name AllowCidrBlockCustom64295Inbound \
  --source-address-prefixes "$(curl -s ifconfig.me)/32"
```

#### Problem: NetBird Connectivity Issues
```bash
# Check NetBird status
sudo netbird status

# Check NetBird service
sudo systemctl status netbird

# View NetBird logs
sudo journalctl -u netbird -f

# Restart NetBird service
sudo systemctl restart netbird

# Test NetBird connectivity
ping <NETBIRD_PEER_IP>
```

### 3. SSL Certificate Issues

#### Problem: Let's Encrypt Certificate Fails
```bash
# Check DNS resolution
nslookup tpot.yourdomain.com
dig tpot.yourdomain.com

# Ensure port 80 is temporarily open
sudo ufw allow 80/tcp
# Or update NSG rule temporarily

# Check Certbot logs
sudo tail -f /var/log/letsencrypt/letsencrypt.log

# Test certificate renewal
sudo certbot renew --dry-run
```

#### Problem: Certificate Not Loading in T-Pot
```bash
# Verify certificate files exist and have correct permissions
ls -la ~/tpotce/data/nginx/cert/
sudo chown tpot:tpot ~/tpotce/data/nginx/cert/nginx.crt ~/tpotce/data/nginx/cert/nginx.key
sudo chmod 644 ~/tpotce/data/nginx/cert/nginx.crt
sudo chmod 600 ~/tpotce/data/nginx/cert/nginx.key

# Check certificate validity
openssl x509 -in ~/tpotce/data/nginx/cert/nginx.crt -text -noout | grep -A 2 "Validity"

# Restart T-Pot after certificate changes
sudo systemctl restart tpot
```

#### Problem: SSL Certificate Expired
```bash
# Check certificate expiration
echo | openssl s_client -connect tpot.yourdomain.com:64297 2>/dev/null | openssl x509 -noout -dates

# Renew certificate
sudo systemctl stop tpot
sudo certbot renew
sudo cp /etc/letsencrypt/live/tpot.yourdomain.com/fullchain.pem ~/tpotce/data/nginx/cert/nginx.crt
sudo cp /etc/letsencrypt/live/tpot.yourdomain.com/privkey.pem ~/tpotce/data/nginx/cert/nginx.key
sudo chown tpot:tpot ~/tpotce/data/nginx/cert/nginx.crt ~/tpotce/data/nginx/cert/nginx.key
sudo chmod 600 ~/tpotce/data/nginx/cert/nginx.key
sudo systemctl start tpot
```

### 4. Performance and Resource Issues

#### Problem: High CPU Usage
```bash
# Monitor system resources
htop
top -p $(pgrep -d, -f tpot)

# Check Docker container resource usage
docker stats

# Identify resource-heavy containers
docker stats --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}" --no-stream | sort -k2 -hr

# Optimize T-Pot configuration
sudo nano ~/tpotce/.env
# Consider reducing enabled honeypots or log retention
```

#### Problem: Disk Space Issues
```bash
# Check disk usage
df -h
du -sh ~/tpotce/data/*

# Clean up old logs
sudo find ~/tpotce/data -name "*.log*" -mtime +7 -delete
sudo find ~/tpotce/data -name "*.gz" -mtime +30 -delete

# Configure log rotation
sudo nano /etc/logrotate.d/tpot
# Add appropriate log rotation rules

# Clean Docker system
docker system prune -af
```

#### Problem: Memory Issues
```bash
# Check memory usage
free -m
cat /proc/meminfo

# Check swap usage
swapon --show

# Add swap if needed (temporary solution)
sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile

# Monitor memory usage by container
docker stats --format "table {{.Container}}\t{{.MemUsage}}\t{{.MemPerc}}" --no-stream | sort -k3 -hr
```

### 5. Data Collection and Logging Issues

#### Problem: No Attack Data Appearing
```bash
# Check if honeypots are actually listening
sudo netstat -tulpn | grep -E ':(22|80|443|25|3389|3306|1433|6379|5060)\s'

# Test honeypot services manually
telnet <AZURE_VM_PUBLIC_IP> 22  # Should show SSH banner
curl -I http://<AZURE_VM_PUBLIC_IP>  # Should get HTTP response

# Check Elasticsearch status
curl -k https://localhost:9200/_cluster/health

# Check honeypot container logs
docker logs tpotce_cowrie_1
docker logs tpotce_dionaea_1
docker logs tpotce_glastopf_1
```

#### Problem: Kibana Dashboard Issues
```bash
# Check Kibana service
curl -k https://localhost:5601/status

# Check Kibana logs
docker logs tpotce_kibana_1

# Restart Kibana container
docker restart tpotce_kibana_1

# Clear browser cache and try accessing again
# https://<AZURE_VM_PUBLIC_IP>:64297
```

#### Problem: Log Forwarding to Security Onion Fails
```bash
# Check network connectivity to Security Onion
ping <SECURITY_ONION_IP>
nc -zv <SECURITY_ONION_IP> 9200

# Check Elastic Agent status
sudo elastic-agent status

# View Elastic Agent logs
sudo journalctl -u elastic-agent -f

# Test Elasticsearch connectivity
curl -k -u elastic:<PASSWORD> https://<SECURITY_ONION_IP>:9200/_cluster/health
```

### 6. Azure-Specific Issues

#### Problem: VM Performance Issues
```bash
# Check Azure VM metrics
az vm get-instance-view --resource-group <YOUR_RESOURCE_GROUP> --name <YOUR_VM_NAME>

# Monitor VM performance
az monitor metrics list --resource <VM_RESOURCE_ID> --metric "Percentage CPU"

# Consider VM resizing
az vm resize --resource-group <YOUR_RESOURCE_GROUP> --name <YOUR_VM_NAME> --size Standard_B8ms
```

#### Problem: Network Security Group Issues
```bash
# List all NSG rules
az network nsg rule list --resource-group <YOUR_RESOURCE_GROUP> --nsg-name <YOUR_NSG_NAME> --output table

# Check effective security rules
az network nic list-effective-nsg --resource-group <YOUR_RESOURCE_GROUP> --name <NIC_NAME>

# Update NSG rule priority if conflicts exist
az network nsg rule update --resource-group <YOUR_RESOURCE_GROUP> --nsg-name <YOUR_NSG_NAME> --name <RULE_NAME> --priority <NEW_PRIORITY>
```

#### Problem: Storage Issues
```bash
# Check disk performance
iostat -x 1 5

# Check Azure disk metrics
az monitor metrics list --resource <DISK_RESOURCE_ID> --metric "Disk Read Bytes"

# Consider upgrading to Premium SSD
az vm update --resource-group <YOUR_RESOURCE_GROUP> --name <YOUR_VM_NAME> --set storageProfile.osDisk.managedDisk.storageAccountType=Premium_LRS
```

## 🔍 Diagnostic Tools and Commands

### System Information Collection
```bash
#!/bin/bash
# T-Pot Diagnostic Script
echo "=== T-Pot Diagnostic Information ===" > tpot-diagnostic.log
echo "Date: $(date)" >> tpot-diagnostic.log
echo "" >> tpot-diagnostic.log

echo "=== System Information ===" >> tpot-diagnostic.log
uname -a >> tpot-diagnostic.log
lsb_release -a >> tpot-diagnostic.log
uptime >> tpot-diagnostic.log
echo "" >> tpot-diagnostic.log

echo "=== Resource Usage ===" >> tpot-diagnostic.log
free -m >> tpot-diagnostic.log
df -h >> tpot-diagnostic.log
echo "" >> tpot-diagnostic.log

echo "=== T-Pot Status ===" >> tpot-diagnostic.log
sudo systemctl status tpot >> tpot-diagnostic.log
dps >> tpot-diagnostic.log
echo "" >> tpot-diagnostic.log

echo "=== Network Status ===" >> tpot-diagnostic.log
sudo netstat -tulpn | grep LISTEN >> tpot-diagnostic.log
echo "" >> tpot-diagnostic.log

echo "=== Recent Logs ===" >> tpot-diagnostic.log
sudo journalctl -u tpot -n 20 --no-pager >> tpot-diagnostic.log

echo "Diagnostic information saved to tpot-diagnostic.log"
```

### Performance Monitoring Script
```bash
#!/bin/bash
# Continuous performance monitoring
while true; do
  echo "$(date): CPU: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}'), MEM: $(free | grep Mem | awk '{printf("%.1f%%", $3/$2 * 100.0)}'), DISK: $(df -h / | awk 'NR==2{print $5}')"
  sleep 60
done
```

## 📞 Getting Additional Help

### Community Support
- **T-Pot GitHub Issues**: [Report bugs and get community help](https://github.com/dtag-dev-sec/tpotce/issues)
- **T-Pot Discussions**: [Community discussions and Q&A](https://github.com/dtag-dev-sec/tpotce/discussions)
- **Security Community**: [Reddit r/netsec](https://reddit.com/r/netsec) and other security forums

### Professional Support
- **Azure Support**: [Azure support portal](https://azure.microsoft.com/support/) for Azure-specific issues
- **Docker Support**: [Docker community forums](https://forums.docker.com/) for Docker-related issues
- **Security Consulting**: Consider professional security consulting for complex deployments

### Documentation Resources
- **[T-Pot Official Documentation](https://github.com/dtag-dev-sec/tpotce)**
- **[Azure Virtual Machines Documentation](https://docs.microsoft.com/azure/virtual-machines/)**
- **[Docker Documentation](https://docs.docker.com/)**
- **[Let's Encrypt Documentation](https://letsencrypt.org/docs/)**

## 📝 Reporting Issues

When reporting issues, please include:

1. **System Information**: OS version, VM size, Azure region
2. **T-Pot Version**: Output of `dps` command
3. **Error Messages**: Exact error messages and log entries
4. **Steps to Reproduce**: Detailed steps that led to the issue
5. **Configuration**: Relevant configuration files (with sensitive data redacted)
6. **Diagnostic Output**: Output from diagnostic scripts above

---

> **💡 Pro Tip**: Most issues can be resolved by carefully reviewing the logs and following the systematic troubleshooting steps above. Take time to understand the error messages before applying fixes.

*For additional troubleshooting resources, see the [Documentation Index](README.md) or consult the [Setup Guide](setup-guide.md) for detailed configuration information.*
