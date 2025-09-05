# Network Security Group (NSG) Configuration

This document details the Network Security Group configuration for the T-Pot honeypot deployment, implementing a defense-in-depth approach with proper network segmentation.

## NSG Design Principles

### Security Zones

The NSG configuration implements three distinct security zones:

1. **Management Zone**: Restricted access via NetBird IP ranges
2. **Honeypot Zone**: Open access to attract attackers
3. **Internal Zone**: Restricted internal communication

### Rule Priority Structure

| Priority Range | Purpose | Description |
|----------------|---------|-------------|
| 100-199 | Management Access | NetBird and administrative access |
| 200-299 | Honeypot Services | Public-facing honeypot ports |
| 300-399 | Internal Services | Inter-service communication |
| 400-499 | Monitoring | Logging and monitoring access |
| 1000+ | Deny Rules | Default deny policies |

## Management Zone Rules

### NetBird SSH Access (Priority 100)

```bash
# Allow SSH access via NetBird
az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-netbird-ssh \
  --priority 100 \
  --source-address-prefixes <NETBIRD_IP_RANGE> \
  --destination-port-ranges 64295 \
  --access Allow \
  --protocol Tcp \
  --description "SSH access via NetBird management network"
```

### NetBird Web Interface (Priority 101)

```bash
# Allow web interface access via NetBird
az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-netbird-web \
  --priority 101 \
  --source-address-prefixes <NETBIRD_IP_RANGE> \
  --destination-port-ranges 64297 \
  --access Allow \
  --protocol Tcp \
  --description "Kibana web interface via NetBird"
```

### NetBird Log Forwarding (Priority 102)

```bash
# Allow log forwarding to Security Onion
az network nsg rule create \
  --resource-group tpot-research-rg \
  --nsg-name tpot-nsg \
  --name allow-log-forwarding \
  --priority 102 \
  --source-address-prefixes <NETBIRD_IP_RANGE> \
  --destination-port-ranges 9200 \
  --access Allow \
  --protocol Tcp \
  --description "Elasticsearch log forwarding to Security Onion"
```

## Honeypot Zone Rules

### SSH Honeypot (Priority 200)

```bash
# Allow SSH attacks from anywhere
az network ns
```
