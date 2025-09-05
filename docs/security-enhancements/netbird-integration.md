# NetBird Integration for Zero-Trust Honeypot Management

This document details the integration of NetBird for secure, zero-trust management of the T-Pot honeypot deployment, replacing traditional VPN solutions with a modern, scalable approach.

## NetBird Architecture Overview

### Why NetBird Over Traditional VPNs

#### Traditional VPN Limitations
- **Static IP Dependencies**: Requires static IP addresses for reliable connections
- **Complex Configuration**: Manual setup and maintenance of VPN configurations
- **Limited Scalability**: Difficult to manage multiple endpoints and users
- **Security Gaps**: Potential vulnerabilities in traditional VPN protocols
- **Centralized Failure Points**: Single point of failure for network access

#### NetBird Advantages
- **Dynamic IP Support**: Works seamlessly with dynamic IP addresses
- **Zero-Configuration**: Automatic peer discovery and connection establishment
- **WireGuard Protocol**: Modern, secure, and high-performance VPN protocol
- **Granular Access Control**: Fine-grained policies for different users and resources
- **Distributed Architecture**: No single point of failure
- **Audit Trail**: Complete logging of all network connections and activities

### NetBird Security Model

#### Zero-Trust Principles
1. **Never Trust, Always Verify**: All connections authenticated and authorized
2. **Least Privilege Access**: Users granted minimum necessary permissions
3. **Continuous Monitoring**: All activities logged and monitored
4. **Dynamic Access Control**: Permissions evaluated continuously
5. **Micro-segmentation**: Network traffic segmented at granular levels

## NetBird Infrastructure Setup

### 1. NetBird Server Deployment

#### AWS VPS Configuration
```bash
# Create AWS EC2 instance for NetBird server
aws ec2 run-instances \
  --image-id ami-0c02fb55956c7d316 \
  --instance-type t3.micro \
  --key-name your-key-pair \
  --security-group-ids sg-xxxxxxxxx \
  --subnet-id subnet-xxxxxxxxx \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=netbird-server}]'
```

#### NetBird Server Installation
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install NetBird
curl -fsSL https://pkgs.netbird.io/debian/install.sh | sudo bash

# Configure NetBird server
sudo netbird up --setup-key <YOUR_SETUP_KEY>

# Verify server status
sudo netbird status
```

### 2. NetBird Client Configuration

#### Azure VM Client Setup
```bash
# Install NetBird client on Azure VM
curl -fsSL https://pkgs.netbird.io/debian/install.sh | sudo bash

# Join NetBird network
sudo netbird up --setup-key <YOUR_SETUP_KEY>

# Verify connection
sudo netbird status
```

#### Local Security Onion Client Setup
```bash
# Install NetBird on Security Onion
curl -fsSL https://pkgs.netbird.io/debian/install.sh | sudo bash

# Join NetBird network
sudo netbird up --setup-key <YOUR_SETUP_KEY>

# Verify connection
sudo netbird status
```

## Access Control Policies

### 1. Honeypot Management Policies

#### SSH Access Policy
```yaml
# NetBird policy for SSH access
name: "honeypot-ssh-access"
description: "Allow SSH access to honeypot management interface"
rules:
  - name: "allow-ssh-honeypot"
    action: "accept"
    sources:
      - "admin-users"
    destinations:
      - "honeypot-vm"
    ports:
      - "64295"
    protocols:
      - "tcp"
```

#### Web Interface Access Policy
```yaml
# NetBird policy for web interface access
name: "honeypot-web-access"
description: "Allow web interface access to Kibana dashboard"
rules:
  - name: "allow-kibana-access"
    action: "accept"
    sources:
      - "admin-users"
    destinations:
      - "honeypot-vm"
    ports:
      - "64297"
    protocols:
      - "tcp"
```

### 2. Log Forwarding Policies

#### Elasticsearch Access Policy
```yaml
# NetBird policy for log forwarding
name: "log-forwarding-access"
description: "Allow log forwarding from honeypot to Security Onion"
rules:
  - name: "allow-log-forwarding"
    action: "accept"
    sources:
      - "honeypot-vm"
    destinations:
      - "security-onion"
    ports:
      - "9200"
    protocols:
      - "tcp"
```

### 3. User Role Definitions

#### Admin Users
```yaml
# Admin user group
name: "admin-users"
description: "Administrative users with full access"
users:
  - "admin@yourdomain.com"
  - "security@yourdomain.com"
permissions:
  - "honeypot-ssh-access"
  - "honeypot-web-access"
  - "log-forwarding-access"
```

#### Read-Only Users
```yaml
# Read-only user group
name: "readonly-users"
description: "Read-only users with limited access"
users:
  - "analyst@yourdomain.com"
  - "researcher@yourdomain.com"
permissions:
  - "honeypot-web-access"
```

## Security Configuration

### 1. Network Segmentation

#### Management Network
```bash
# NetBird network configuration for management
netbird network create \
  --name "honeypot-management" \
  --cidr "10.0.1.0/24" \
  --description "Management network for honeypot operations"
```

#### Logging Network
```bash
# NetBird network configuration for logging
netbird network create \
  --name "honeypot-logging" \
  --cidr "10.0.2.0/24" \
  --description "Logging network for Security Onion communication"
```

### 2. Firewall Integration

#### UFW Configuration
```bash
# Configure UFW for NetBird integration
sudo ufw allow from 10.0.1.0/24 to any port 64295
sudo ufw allow from 10.0.1.0/24 to any port 64297
sudo ufw allow from 10.0.2.0/24 to any port 9200
sudo ufw deny from any to any port 22
sudo ufw deny from any to any port 80
sudo ufw deny from any to any port 443
```

#### iptables Configuration
```bash
# Configure iptables for NetBird integration
sudo iptables -A INPUT -s 10.0.1.0/24 -p tcp --dport 64295 -j ACCEPT
sudo iptables -A INPUT -s 10.0.1.0/24 -p tcp --dport 64297 -j ACCEPT
sudo iptables -A INPUT -s 10.0.2.0/24 -p tcp --dport 9200 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j DROP
sudo iptables -A INPUT -p tcp --dport 80 -j DROP
sudo iptables -A INPUT -p tcp --dport 443 -j DROP
```

## Monitoring and Logging

### 1. NetBird Connection Monitoring

#### Connection Status Monitoring
```bash
# Create monitoring script
sudo nano /usr/local/bin/netbird-monitor.sh

#!/bin/bash
# NetBird connection monitoring script

# Check NetBird status
NETBIRD_STATUS=$(sudo netbird status --json)

# Parse connection status
CONNECTED=$(echo $NETBIRD_STATUS | jq -r '.connected')
PEERS=$(echo $NETBIRD_STATUS | jq -r '.peers | length')

# Log status
echo "$(date): NetBird Status - Connected: $CONNECTED, Peers: $PEERS" >> /var/log/netbird-monitor.log

# Alert if disconnected
if [ "$CONNECTED" != "true" ]; then
    echo "ALERT: NetBird disconnected at $(date)" >> /var/log/netbird-alerts.log
    # Send notification (implement your preferred method)
fi

# Make executable
sudo chmod +x /usr/local/bin/netbird-monitor.sh

# Schedule monitoring (every 5 minutes)
echo "*/5 * * * * /usr/local/bin/netbird-monitor.sh" | sudo crontab -
```

### 2. Access Logging

#### NetBird Access Logs
```bash
# Configure NetBird logging
sudo nano /etc/netbird/config.json

{
  "log_level": "info",
  "log_file": "/var/log/netbird/netbird.log",
  "audit_log": "/var/log/netbird/audit.log",
  "audit_events": [
    "connection_established",
    "connection_terminated",
    "policy_evaluation",
    "authentication_attempt"
  ]
}
```

#### Custom Access Logging
```bash
# Create custom access logging script
sudo nano /usr/local/bin/access-logger.sh

#!/bin/bash
# Custom access logging for honeypot management

# Log SSH access attempts
journalctl -u ssh -f | while read line; do
    if echo "$line" | grep -q "Accepted"; then
        echo "$(date): SSH Access: $line" >> /var/log/honeypot-access.log
    fi
done &

# Log web interface access
tail -f /var/log/nginx/access.log | while read line; do
    if echo "$line" | grep -q "64297"; then
        echo "$(date): Web Access: $line" >> /var/log/honeypot-access.log
    fi
done &

# Make executable
sudo chmod +x /usr/local/bin/access-logger.sh

# Start logging service
sudo systemctl enable access-logger
sudo systemctl start access-logger
```

## Troubleshooting and Maintenance

### 1. Common Issues

#### Connection Problems
```bash
# Check NetBird status
sudo netbird status

# Restart NetBird service
sudo systemctl restart netbird

# Check network connectivity
ping <NETBIRD_PEER_IP>

# Check firewall rules
sudo ufw status
sudo iptables -L
```

#### Policy Issues
```bash
# List current policies
netbird policy list

# Test policy evaluation
netbird policy test --source <SOURCE_IP> --destination <DEST_IP> --port <PORT>

# Update policies
netbird policy update --file policies.yaml
```

### 2. Maintenance Procedures

#### Regular Maintenance
```bash
# Create maintenance script
sudo nano /usr/local/bin/netbird-maintenance.sh

#!/bin/bash
# NetBird maintenance script

# Update NetBird
sudo apt update
sudo apt upgrade netbird -y

# Restart NetBird service
sudo systemctl restart netbird

# Verify connectivity
sudo netbird status

# Clean up old logs
find /var/log/netbird -name "*.log" -mtime +30 -delete

# Make executable
sudo chmod +x /usr/local/bin/netbird-maintenance.sh

# Schedule weekly maintenance
echo "0 2 * * 0 /usr/local/bin/netbird-maintenance.sh" | sudo crontab -
```

#### Backup and Recovery
```bash
# Create backup script
sudo nano /usr/local/bin/netbird-backup.sh

#!/bin/bash
# NetBird configuration backup script

BACKUP_DIR="/opt/backups/netbird"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup NetBird configuration
cp -r /etc/netbird $BACKUP_DIR/netbird-config-$DATE

# Backup policies
netbird policy list > $BACKUP_DIR/policies-$DATE.yaml

# Backup network configuration
netbird network list > $BACKUP_DIR/networks-$DATE.yaml

# Cleanup old backups (keep 30 days)
find $BACKUP_DIR -name "*" -mtime +30 -delete

# Make executable
sudo chmod +x /usr/local/bin/netbird-backup.sh

# Schedule daily backups
echo "0 1 * * * /usr/local/bin/netbird-backup.sh" | sudo crontab -
```

## Security Best Practices

### 1. Access Control

#### User Management
- **Regular Access Reviews**: Periodic review of user access permissions
- **Principle of Least Privilege**: Users granted minimum necessary permissions
- **Role-Based Access**: Access based on job function and responsibilities
- **Temporary Access**: Time-limited access for specific tasks

#### Authentication
- **Strong Passwords**: Enforce strong password policies
- **Multi-Factor Authentication**: Implement MFA where possible
- **Certificate-Based Auth**: Use certificates for service-to-service authentication
- **Regular Key Rotation**: Periodic rotation of authentication keys

### 2. Network Security

#### Encryption
- **WireGuard Protocol**: Use NetBird's built-in WireGuard encryption
- **Perfect Forward Secrecy**: Ensure PFS for all communications
- **Strong Cipher Suites**: Use only strong, modern cipher suites
- **Key Management**: Secure storage and management of encryption keys

#### Monitoring
- **Traffic Analysis**: Monitor network traffic for anomalies
- **Connection Logging**: Log all network connections and activities
- **Intrusion Detection**: Implement IDS for network monitoring
- **Regular Audits**: Periodic security audits and assessments

## Integration with Security Onion

### 1. Log Forwarding Configuration

#### NetBird Tunnel for Log Forwarding
```bash
# Configure log forwarding through NetBird tunnel
sudo nano /etc/elasticsearch/elasticsearch.yml

# Add NetBird network configuration
network.host: 0.0.0.0
network.bind_host: 0.0.0.0
network.publish_host: <NETBIRD_IP>

# Configure cluster settings
cluster.name: "honeypot-cluster"
node.name: "honeypot-node"
discovery.seed_hosts: ["<SECURITY_ONION_NETBIRD_IP>:9300"]
```

#### Security Onion Integration
```bash
# Configure Security Onion to receive logs
sudo nano /etc/elasticsearch/elasticsearch.yml

# Add honeypot node configuration
cluster.name: "security-onion-cluster"
node.name: "security-onion-node"
discovery.seed_hosts: ["<HONEYPOT_NETBIRD_IP>:9300"]

# Configure log ingestion
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
```

### 2. Real-Time Monitoring

#### Elasticsearch Cluster Monitoring
```bash
# Create cluster monitoring script
sudo nano /usr/local/bin/cluster-monitor.sh

#!/bin/bash
# Elasticsearch cluster monitoring script

# Check cluster health
CLUSTER_HEALTH=$(curl -s -X GET "localhost:9200/_cluster/health?pretty")

# Parse health status
HEALTH_STATUS=$(echo $CLUSTER_HEALTH | jq -r '.status')

# Log health status
echo "$(date): Cluster Health: $HEALTH_STATUS" >> /var/log/cluster-monitor.log

# Alert if cluster is unhealthy
if [ "$HEALTH_STATUS" != "green" ]; then
    echo "ALERT: Cluster health is $HEALTH_STATUS at $(date)" >> /var/log/cluster-alerts.log
fi

# Make executable
sudo chmod +x /usr/local/bin/cluster-monitor.sh

# Schedule monitoring (every 10 minutes)
echo "*/10 * * * * /usr/local/bin/cluster-monitor.sh" | sudo crontab -
```

## Performance Optimization

### 1. Network Performance

#### WireGuard Optimization
```bash
# Optimize WireGuard performance
sudo nano /etc/netbird/wg0.conf

[Interface]
PrivateKey = <PRIVATE_KEY>
Address = <NETBIRD_IP>/24
DNS = 8.8.8.8, 8.8.4.4
MTU = 1420

[Peer]
PublicKey = <PEER_PUBLIC_KEY>
Endpoint = <PEER_ENDPOINT>:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

#### Network Tuning
```bash
# Optimize network performance
sudo nano /etc/sysctl.conf

# Add performance tuning parameters
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.ipv4.tcp_rmem = 4096 65536 16777216
net.ipv4.tcp_wmem = 4096 65536 16777216
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_window_scaling = 1

# Apply changes
sudo sysctl -p
```

### 2. Resource Management

#### Memory Optimization
```bash
# Configure Elasticsearch memory settings
sudo nano /etc/elasticsearch/jvm.options

# Set heap size (adjust based on available memory)
-Xms2g
-Xmx2g

# Configure garbage collection
-XX:+UseG1GC
-XX:MaxGCPauseMillis=200
```

#### CPU Optimization
```bash
# Configure CPU affinity for NetBird
sudo taskset -cp 0,1 $(pgrep netbird)

# Configure CPU affinity for Elasticsearch
sudo taskset -cp 2,3 $(pgrep java)
```

## Next Steps

After NetBird integration:

1. [Deploy Elastic Fleet Agents](elastic-fleet-setup.md)
2. [Configure Zero-Trust Architecture](zero-trust-architecture.md)
3. [Set up Monitoring and Alerting](../research-findings/attack-analysis.md)
4. [Implement Security Policies](../compliance/azure-terms.md)

---

*For additional NetBird guidance, refer to the [NetBird Documentation](https://docs.netbird.io/) and [WireGuard Documentation](https://www.wireguard.com/).*

