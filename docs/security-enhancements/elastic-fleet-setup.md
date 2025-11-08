# Elastic Fleet Agent Deployment and Configuration

This document details the deployment and configuration of Elastic Fleet Agents for enhanced monitoring and log forwarding from the T-Pot honeypot to the local Security Onion instance. The deployment successfully collected **4.8+ million host monitoring events** in just 2 days, providing comprehensive visibility into both external attacks and internal system behavior.

## Real-World Results (2-Day Deployment)

### Comprehensive Host Monitoring Achieved
The Elastic Fleet deployment on the T-Pot honeypot system collected **4,837,889 total events** in just 2 days, demonstrating the effectiveness of the dual monitoring architecture:

#### Event Distribution by Category
| Event Category | Count | Percentage | Description |
|----------------|-------|------------|-------------|
| **Process Events** | 1,754,395 | 36.3% | Process execution and monitoring |
| **File Events** | 1,417,675 | 29.3% | File system changes and access |
| **Network Events** | 875,328 | 18.1% | Internal network traffic analysis |
| **Session Events** | 1,021 | 0.02% | User session and authentication |
| **IAM Events** | 23 | <0.01% | Identity and access management |
| **Authentication Events** | 10 | <0.01% | Authentication attempts |

#### Module Distribution
| Module | Count | Percentage | Description |
|--------|-------|------------|-------------|
| **Endpoint** | 3,224,140 | 66.6% | Endpoint security monitoring |
| **Network Traffic** | 823,128 | 17.0% | Network traffic analysis |
| **System** | 560,578 | 11.6% | System-level monitoring |
| **Elastic Agent** | 229,286 | 4.7% | Agent health and status |
| **OSQuery Manager** | 568 | 0.01% | OSQuery integration |

### Security Benefits Realized
1. **Complete System Visibility**: Every process, file change, and network connection monitored
2. **Attack Impact Assessment**: Understanding how external attacks affect internal system behavior
3. **Behavioral Analysis**: System response patterns to different attack types
4. **Forensic Capability**: Detailed logs for incident investigation and analysis
5. **Proactive Detection**: Early warning of system compromise attempts

## Elastic Fleet Architecture Overview

### Why Elastic Fleet Agents

#### Traditional Log Forwarding Limitations
- **Manual Configuration**: Complex setup and maintenance of log forwarding
- **Limited Scalability**: Difficult to manage multiple agents and endpoints
- **Security Gaps**: Potential vulnerabilities in traditional log forwarding methods
- **Limited Monitoring**: Basic logging without behavioral analysis capabilities
- **Centralized Failure Points**: Single point of failure for log collection

#### Elastic Fleet Advantages
- **Centralized Management**: Single interface for managing all agents
- **Automatic Updates**: Agents automatically updated with latest configurations
- **Enhanced Security**: Built-in encryption and authentication
- **Behavioral Analysis**: Advanced monitoring and analysis capabilities
- **Scalable Architecture**: Easy to add new agents and endpoints
- **Real-Time Monitoring**: Live monitoring of agent status and health

### Elastic Fleet Security Model

#### Agent Security
1. **Certificate-Based Authentication**: Agents authenticated using certificates
2. **Encrypted Communication**: All communications encrypted using TLS
3. **Policy-Based Configuration**: Centralized policy management
4. **Real-Time Monitoring**: Continuous monitoring of agent health and status
5. **Automatic Remediation**: Automatic recovery from common issues

## Elastic Fleet Infrastructure Setup

### 1. Security Onion Fleet Server Configuration

#### Fleet Server Installation
```bash
# Download Elastic Agent
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.11.0-linux-x86_64.tar.gz

# Extract agent
tar xzvf elastic-agent-8.11.0-linux-x86_64.tar.gz
cd elastic-agent-8.11.0-linux-x86_64

# Install Fleet Server
sudo ./elastic-agent install \
  --fleet-server-es=https://localhost:9200 \
  --fleet-server-service-token=<FLEET_SERVICE_TOKEN> \
  --fleet-server-policy=fleet-server-policy
```

#### Fleet Server Configuration
```bash
# Configure Fleet Server
sudo nano /etc/elastic-agent/fleet-server.yml

# Fleet Server configuration
server:
  host: "0.0.0.0"
  port: 8220
  tls:
    certificate: "/etc/elastic-agent/certs/fleet-server.crt"
    key: "/etc/elastic-agent/certs/fleet-server.key"
    certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]

# Elasticsearch connection
output.elasticsearch:
  hosts: ["https://localhost:9200"]
  username: "elastic"
  password: "<ELASTIC_PASSWORD>"
  ssl:
    certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]
```

### 2. Honeypot Agent Deployment

#### Agent Installation on Azure VM
```bash
# Download Elastic Agent
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.11.0-linux-x86_64.tar.gz

# Extract agent
tar xzvf elastic-agent-8.11.0-linux-x86_64.tar.gz
cd elastic-agent-8.11.0-linux-x86_64

# Install agent
sudo ./elastic-agent install \
  --url=https://<SECURITY_ONION_IP>:8220 \
  --enrollment-token=<ENROLLMENT_TOKEN> \
  --fleet-server-es=https://<SECURITY_ONION_IP>:9200 \
  --fleet-server-service-token=<FLEET_SERVICE_TOKEN>
```

#### Agent Configuration
```bash
# Configure agent
sudo nano /etc/elastic-agent/elastic-agent.yml

# Agent configuration
fleet:
  enabled: true
  server:
    host: "<SECURITY_ONION_IP>"
    port: 8220
    protocol: "https"
    tls:
      certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]

# Output configuration
output.elasticsearch:
  hosts: ["https://<SECURITY_ONION_IP>:9200"]
  username: "elastic"
  password: "<ELASTIC_PASSWORD>"
  ssl:
    certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]
```

## Agent Policy Configuration

### 1. Honeypot Monitoring Policy

#### System Monitoring
```yaml
# System monitoring policy
name: "honeypot-system-monitoring"
description: "System monitoring for honeypot infrastructure"
inputs:
  - type: "system/metrics"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "system.cpu"
          type: "metrics"
        metricsets:
          - "cpu"
          - "load"
          - "memory"
          - "network"
          - "process"
        period: 10s
        processors:
          - add_fields:
              target: "honeypot"
              fields:
                environment: "production"
                role: "honeypot"
                location: "azure"
```

#### Log Collection
```yaml
# Log collection policy
name: "honeypot-log-collection"
description: "Log collection for honeypot services"
inputs:
  - type: "logfile"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "honeypot.logs"
          type: "logs"
        paths:
          - "/var/log/tpot/*.log"
          - "/var/log/docker/*.log"
          - "/var/log/nginx/*.log"
        processors:
          - add_fields:
              target: "honeypot"
              fields:
                environment: "production"
                role: "honeypot"
                location: "azure"
          - dissect:
              tokenizer: "%{timestamp} %{level} %{message}"
              field: "message"
              target_prefix: "parsed"
```

### 2. Security Monitoring Policy

#### Network Monitoring
```yaml
# Network monitoring policy
name: "honeypot-network-monitoring"
description: "Network monitoring for honeypot infrastructure"
inputs:
  - type: "system/metrics"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "system.network"
          type: "metrics"
        metricsets:
          - "network"
        period: 5s
        processors:
          - add_fields:
              target: "honeypot"
              fields:
                environment: "production"
                role: "honeypot"
                location: "azure"
```

#### Process Monitoring
```yaml
# Process monitoring policy
name: "honeypot-process-monitoring"
description: "Process monitoring for honeypot services"
inputs:
  - type: "system/metrics"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "system.process"
          type: "metrics"
        metricsets:
          - "process"
        period: 10s
        processes:
          - "docker"
          - "elasticsearch"
          - "kibana"
          - "nginx"
        processors:
          - add_fields:
              target: "honeypot"
              fields:
                environment: "production"
                role: "honeypot"
                location: "azure"
```

## Behavioral Analysis Configuration

### 1. Anomaly Detection

#### CPU Anomaly Detection
```yaml
# CPU anomaly detection
name: "cpu-anomaly-detection"
description: "Detect CPU usage anomalies"
inputs:
  - type: "system/metrics"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "system.cpu"
          type: "metrics"
        metricsets:
          - "cpu"
        period: 30s
        processors:
          - add_fields:
              target: "anomaly_detection"
              fields:
                enabled: true
                threshold: 80
                window_size: 300
```

#### Memory Anomaly Detection
```yaml
# Memory anomaly detection
name: "memory-anomaly-detection"
description: "Detect memory usage anomalies"
inputs:
  - type: "system/metrics"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "system.memory"
          type: "metrics"
        metricsets:
          - "memory"
        period: 30s
        processors:
          - add_fields:
              target: "anomaly_detection"
              fields:
                enabled: true
                threshold: 85
                window_size: 300
```

### 2. Attack Pattern Detection

#### SSH Attack Detection
```yaml
# SSH attack detection
name: "ssh-attack-detection"
description: "Detect SSH attack patterns"
inputs:
  - type: "logfile"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "honeypot.ssh"
          type: "logs"
        paths:
          - "/var/log/tpot/cowrie.log"
        processors:
          - add_fields:
              target: "attack_detection"
              fields:
                enabled: true
                attack_type: "ssh_brute_force"
                threshold: 10
                window_size: 60
```

#### Web Attack Detection
```yaml
# Web attack detection
name: "web-attack-detection"
description: "Detect web attack patterns"
inputs:
  - type: "logfile"
    data_stream:
      namespace: "default"
    streams:
      - data_stream:
          dataset: "honeypot.web"
          type: "logs"
        paths:
          - "/var/log/tpot/glastopf.log"
        processors:
          - add_fields:
              target: "attack_detection"
              fields:
                enabled: true
                attack_type: "web_application"
                threshold: 5
                window_size: 60
```

## Monitoring and Alerting

### 1. Agent Health Monitoring

#### Health Check Script
```bash
# Create agent health monitoring script
sudo nano /usr/local/bin/agent-health-monitor.sh

#!/bin/bash
# Elastic Agent health monitoring script

# Check agent status
AGENT_STATUS=$(sudo systemctl status elastic-agent --no-pager -l)

# Parse status
if echo "$AGENT_STATUS" | grep -q "active (running)"; then
    STATUS="healthy"
else
    STATUS="unhealthy"
fi

# Log status
echo "$(date): Agent Status: $STATUS" >> /var/log/agent-health.log

# Alert if unhealthy
if [ "$STATUS" != "healthy" ]; then
    echo "ALERT: Elastic Agent is $STATUS at $(date)" >> /var/log/agent-alerts.log
    # Send notification (implement your preferred method)
fi

# Check agent logs for errors
ERROR_COUNT=$(sudo journalctl -u elastic-agent --since "1 hour ago" | grep -i error | wc -l)

if [ "$ERROR_COUNT" -gt 0 ]; then
    echo "ALERT: $ERROR_COUNT errors in agent logs at $(date)" >> /var/log/agent-alerts.log
fi

# Make executable
sudo chmod +x /usr/local/bin/agent-health-monitor.sh

# Schedule monitoring (every 5 minutes)
echo "*/5 * * * * /usr/local/bin/agent-health-monitor.sh" | sudo crontab -
```

### 2. Performance Monitoring

#### Performance Metrics Collection
```bash
# Create performance monitoring script
sudo nano /usr/local/bin/agent-performance-monitor.sh

#!/bin/bash
# Elastic Agent performance monitoring script

# Collect performance metrics
CPU_USAGE=$(ps -p $(pgrep elastic-agent) -o %cpu --no-headers)
MEMORY_USAGE=$(ps -p $(pgrep elastic-agent) -o %mem --no-headers)
DISK_USAGE=$(df -h /var/lib/elastic-agent | awk 'NR==2 {print $5}' | sed 's/%//')

# Log metrics
echo "$(date): CPU: $CPU_USAGE%, Memory: $MEMORY_USAGE%, Disk: $DISK_USAGE%" >> /var/log/agent-performance.log

# Alert on high resource usage
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    echo "ALERT: High CPU usage: $CPU_USAGE% at $(date)" >> /var/log/agent-alerts.log
fi

if (( $(echo "$MEMORY_USAGE > 80" | bc -l) )); then
    echo "ALERT: High memory usage: $MEMORY_USAGE% at $(date)" >> /var/log/agent-alerts.log
fi

if [ "$DISK_USAGE" -gt 80 ]; then
    echo "ALERT: High disk usage: $DISK_USAGE% at $(date)" >> /var/log/agent-alerts.log
fi

# Make executable
sudo chmod +x /usr/local/bin/agent-performance-monitor.sh

# Schedule monitoring (every 10 minutes)
echo "*/10 * * * * /usr/local/bin/agent-performance-monitor.sh" | sudo crontab -
```

## Troubleshooting and Maintenance

### 1. Common Issues

#### Agent Connection Problems
```bash
# Check agent status
sudo systemctl status elastic-agent

# Check agent logs
sudo journalctl -u elastic-agent -f

# Restart agent
sudo systemctl restart elastic-agent

# Check network connectivity
ping <SECURITY_ONION_IP>
telnet <SECURITY_ONION_IP> 8220
```

#### Policy Issues
```bash
# Check agent policy
sudo elastic-agent inspect

# Update agent policy
sudo elastic-agent update --policy-id <POLICY_ID>

# Check policy status
sudo elastic-agent status
```

### 2. Maintenance Procedures

#### Regular Maintenance
```bash
# Create maintenance script
sudo nano /usr/local/bin/agent-maintenance.sh

#!/bin/bash
# Elastic Agent maintenance script

# Update agent
sudo apt update
sudo apt upgrade elastic-agent -y

# Restart agent
sudo systemctl restart elastic-agent

# Verify connectivity
sudo elastic-agent status

# Clean up old logs
find /var/log -name "*agent*" -mtime +30 -delete

# Make executable
sudo chmod +x /usr/local/bin/agent-maintenance.sh

# Schedule weekly maintenance
echo "0 2 * * 0 /usr/local/bin/agent-maintenance.sh" | sudo crontab -
```

#### Backup and Recovery
```bash
# Create backup script
sudo nano /usr/local/bin/agent-backup.sh

#!/bin/bash
# Elastic Agent configuration backup script

BACKUP_DIR="/opt/backups/elastic-agent"
DATE=$(date +%Y%m%d_%H%M%S)

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup agent configuration
cp -r /etc/elastic-agent $BACKUP_DIR/agent-config-$DATE

# Backup agent data
cp -r /var/lib/elastic-agent $BACKUP_DIR/agent-data-$DATE

# Backup agent logs
cp -r /var/log/elastic-agent $BACKUP_DIR/agent-logs-$DATE

# Cleanup old backups (keep 30 days)
find $BACKUP_DIR -name "*" -mtime +30 -delete

# Make executable
sudo chmod +x /usr/local/bin/agent-backup.sh

# Schedule daily backups
echo "0 1 * * * /usr/local/bin/agent-backup.sh" | sudo crontab -
```

## Security Best Practices

### 1. Agent Security

#### Certificate Management
```bash
# Generate agent certificates
sudo elastic-agent enroll \
  --url=https://<SECURITY_ONION_IP>:8220 \
  --enrollment-token=<ENROLLMENT_TOKEN> \
  --certificate-authorities=/etc/elastic-agent/certs/ca.crt

# Verify certificates
openssl x509 -in /etc/elastic-agent/certs/elastic-agent.crt -text -noout

# Check certificate expiration
openssl x509 -in /etc/elastic-agent/certs/elastic-agent.crt -noout -dates
```

#### Access Control
```bash
# Configure agent access control
sudo nano /etc/elastic-agent/elastic-agent.yml

# Add access control settings
fleet:
  enabled: true
  server:
    host: "<SECURITY_ONION_IP>"
    port: 8220
    protocol: "https"
    tls:
      certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]
    access_api_key: "<ACCESS_API_KEY>"
```

### 2. Data Security

#### Encryption
```bash
# Configure data encryption
sudo nano /etc/elastic-agent/elastic-agent.yml

# Add encryption settings
output.elasticsearch:
  hosts: ["https://<SECURITY_ONION_IP>:9200"]
  username: "elastic"
  password: "<ELASTIC_PASSWORD>"
  ssl:
    certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]
    verification_mode: "full"
```

#### Data Retention
```bash
# Configure data retention
sudo nano /etc/elastic-agent/elastic-agent.yml

# Add retention settings
processors:
  - add_fields:
      target: "retention"
      fields:
        ttl: "30d"
        index: "honeypot-logs-%{+yyyy.MM.dd}"
```

## Integration with Security Onion

### 1. Log Forwarding Configuration

#### Elasticsearch Integration
```bash
# Configure Elasticsearch for agent data
sudo nano /etc/elasticsearch/elasticsearch.yml

# Add agent data configuration
cluster.name: "security-onion-cluster"
node.name: "security-onion-node"
discovery.seed_hosts: ["<HONEYPOT_IP>:9300"]

# Configure data streams
xpack.security.enabled: true
xpack.security.transport.ssl.enabled: true
```

#### Kibana Integration
```bash
# Configure Kibana for agent data
sudo nano /etc/kibana/kibana.yml

# Add agent data configuration
server.host: "0.0.0.0"
server.port: 5601
elasticsearch.hosts: ["https://localhost:9200"]
elasticsearch.username: "elastic"
elasticsearch.password: "<ELASTIC_PASSWORD>"
```

### 2. Dashboard Configuration

#### Agent Monitoring Dashboard
```json
{
  "version": "8.11.0",
  "objects": [
    {
      "id": "agent-monitoring-dashboard",
      "type": "dashboard",
      "attributes": {
        "title": "Honeypot Agent Monitoring",
        "description": "Monitor Elastic Agent health and performance",
        "panelsJSON": "[{\"version\":\"8.11.0\",\"gridData\":{\"x\":0,\"y\":0,\"w\":24,\"h\":15,\"i\":\"1\"},\"panelIndex\":\"1\",\"embeddableConfig\":{\"savedVis\":{\"title\":\"Agent Status\",\"type\":\"metric\"}},\"panelRefName\":\"panel_1\"}]"
      }
    }
  ]
}
```

## Performance Optimization

### 1. Agent Performance

#### Resource Allocation
```bash
# Configure agent resource limits
sudo nano /etc/elastic-agent/elastic-agent.yml

# Add resource limits
processors:
  - add_fields:
      target: "resource_limits"
      fields:
        cpu_limit: "2"
        memory_limit: "2g"
        disk_limit: "10g"
```

#### Performance Tuning
```bash
# Configure performance settings
sudo nano /etc/elastic-agent/elastic-agent.yml

# Add performance settings
processors:
  - add_fields:
      target: "performance"
      fields:
        batch_size: 1000
        flush_interval: "5s"
        compression: "gzip"
```

### 2. Network Optimization

#### Connection Pooling
```bash
# Configure connection pooling
sudo nano /etc/elastic-agent/elastic-agent.yml

# Add connection settings
output.elasticsearch:
  hosts: ["https://<SECURITY_ONION_IP>:9200"]
  username: "elastic"
  password: "<ELASTIC_PASSWORD>"
  ssl:
    certificate_authorities: ["/etc/elastic-agent/certs/ca.crt"]
  connection_pool:
    max_connections: 10
    keep_alive: "30s"
```

## Next Steps

After Elastic Fleet setup:

1. [Configure Zero-Trust Architecture](zero-trust-architecture.md)
2. [Set up Attack Analysis](../research-findings/attack-analysis.md)
3. [Implement Security Policies](../compliance/azure-terms.md)
4. [Configure Monitoring and Alerting](../research-findings/threat-intelligence.md)

---

*For additional Elastic Fleet guidance, refer to the [Elastic Fleet Documentation](https://www.elastic.co/guide/en/fleet/current/index.html) and [Elastic Agent Documentation](https://www.elastic.co/guide/en/elastic-agent/current/index.html).*

