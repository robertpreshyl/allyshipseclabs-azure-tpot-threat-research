# Network Security Group (NSG) Configuration for T-Pot on Azure

> **Last Updated**: October 2, 2025

This guide provides comprehensive NSG configuration for T-Pot honeypot deployment on Azure, focusing on security best practices while enabling proper honeypot functionality.

## 🎯 Security Principles

- **Selective Exposure**: Expose only ports required by your selected T-Pot profile/version
- **Management Security**: Keep management/admin access off public internet (use NetBird overlay)
- **Default Deny**: Default deny all other inbound traffic not explicitly allowed
- **Version Validation**: Always validate against T-Pot's official documentation for your release
- **Principle of Least Privilege**: Grant minimum necessary network access

> **Authoritative Reference**: [T-Pot GitHub Repository](https://github.com/dtag-dev-sec/tpotce)

## 🔒 NSG Rule Categories

### Management Ports (Restricted Access)

These ports should be restricted to your management IP or NetBird overlay network:

| Priority | Rule Name                              | Port  | Protocol | Source IP            | Purpose              |
|----------|----------------------------------------|-------|----------|----------------------|----------------------|
| 310      | AllowCidrBlockCustom64295Inbound       | 64295 | TCP      | `<YOUR_PUBLIC_IP>`   | SSH Management       |
| 320      | AllowMyIpAddressCustom64297Inbound     | 64297 | TCP      | `<YOUR_PUBLIC_IP>`   | T-Pot Web Interface  |

> **⚠️ Security Warning**: Replace `<YOUR_PUBLIC_IP>` with your actual public IP or NetBird network CIDR. Never use `*` (any) for management ports.

### Honeypot Ports (Open to Internet)

These ports are intentionally exposed to attract attackers:

| Priority | Rule Name                  | Ports                    | Protocol | Source | Honeypot Services           |
|----------|----------------------------|--------------------------|----------|--------|-----------------------------||
| 330      | AllowSSHInbound            | 22                       | TCP      | Any    | SSH Honeypot (Cowrie)       |
| 340      | AllowHTTPInbound           | 80                       | TCP      | Any    | HTTP Honeypots              |
| 350      | AllowHTTPSInbound          | 443                      | TCP      | Any    | HTTPS Honeypots             |
| 360      | AllowDNSUDPInbound         | 53                       | UDP      | Any    | DNS Honeypot                |
| 370      | AllowTelnetInbound         | 23                       | TCP      | Any    | Telnet Honeypot (Heralding) |
| 380      | AllowFTPInbound            | 21                       | TCP      | Any    | FTP Honeypot                |
| 390      | AllowSMTPInbound           | 25                       | TCP      | Any    | SMTP Honeypot               |
| 400      | AllowIMAPPOPInbound        | 110, 143, 993, 995       | TCP      | Any    | Email Honeypots             |
| 410      | AllowRDPInbound            | 3389                     | TCP      | Any    | RDP Honeypot                |
| 420      | AllowMySQLInbound          | 3306                     | TCP      | Any    | MySQL Honeypot (Dionaea)    |
| 430      | AllowMSSQLInbound          | 1433                     | TCP      | Any    | MSSQL Honeypot              |
| 440      | AllowOracleInbound         | 1521                     | TCP      | Any    | Oracle Honeypot             |
| 450      | AllowRedisInbound          | 6379                     | TCP      | Any    | Redis Honeypot              |
| 460      | AllowSIPUDPInbound         | 5060                     | UDP      | Any    | SIP Honeypot (SentryPeer)   |
| 470      | AllowModbusInbound         | 502                      | TCP      | Any    | Modbus ICS Honeypot         |
| 480      | AllowS7Inbound             | 102                      | TCP      | Any    | Siemens S7 ICS Honeypot     |
| 490      | AllowBACnetInbound         | 47808                    | TCP      | Any    | BACnet ICS Honeypot         |
| 500      | AllowTelnetAltInbound      | 42, 135, 1723            | TCP      | Any    | Alternative Service Ports   |
| 510      | AllowHTTPAltInbound        | 8080, 8443               | TCP      | Any    | Alternative Web Ports       |
| 520      | AllowMiscUDPInbound        | 19, 123, 1900            | UDP      | Any    | Miscellaneous UDP Services  |

> **📝 Note**: Honeypot ports are intentionally open to `Any` source to mimic real-world accessible services and attract attackers.

## 📤 Outbound Rules

### Required Outbound Access

| Purpose                    | Destination           | Ports      | Protocol | Justification                    |
|----------------------------|-----------------------|------------|----------|----------------------------------|
| OS/Package Updates         | Ubuntu Repositories   | 80, 443    | TCP      | System security updates          |
| Docker Hub Access          | Docker Registry       | 443        | TCP      | Container image downloads        |
| DNS Resolution             | DNS Servers           | 53         | UDP/TCP  | Domain name resolution           |
| NTP Synchronization        | NTP Servers           | 123        | UDP      | Time synchronization             |
| Security Onion Telemetry   | Security Onion IP     | 9200       | TCP      | Log forwarding (via NetBird)     |
| Let's Encrypt ACME         | Let's Encrypt         | 80, 443    | TCP      | SSL certificate validation       |

### Security Recommendations

- **Prefer NetBird Overlay**: Route Security Onion telemetry via NetBird for enhanced security
- **Block Unnecessary Egress**: Implement explicit deny rules for non-essential outbound traffic
- **Monitor Outbound Traffic**: Log and monitor all outbound connections for anomalies

## 🔧 NSG Implementation

### 1. Create NSG

```bash
# Create Network Security Group
az network nsg create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --name tpot-nsg \
  --location <YOUR_LOCATION>
```

### 2. Add Management Rules

```bash
# SSH Management Port (restrict to your IP)
az network nsg rule create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name tpot-nsg \
  --name AllowCidrBlockCustom64295Inbound \
  --priority 310 \
  --source-address-prefixes '<YOUR_PUBLIC_IP>' \
  --destination-port-ranges 64295 \
  --protocol Tcp \
  --access Allow

# T-Pot Web Interface (restrict to your IP)
az network nsg rule create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name tpot-nsg \
  --name AllowMyIpAddressCustom64297Inbound \
  --priority 320 \
  --source-address-prefixes '<YOUR_PUBLIC_IP>' \
  --destination-port-ranges 64297 \
  --protocol Tcp \
  --access Allow
```

### 3. Add Honeypot Rules

```bash
# SSH Honeypot
az network nsg rule create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name tpot-nsg \
  --name AllowSSHInbound \
  --priority 330 \
  --source-address-prefixes '*' \
  --destination-port-ranges 22 \
  --protocol Tcp \
  --access Allow

# HTTP/HTTPS Honeypots
az network nsg rule create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name tpot-nsg \
  --name AllowHTTPInbound \
  --priority 340 \
  --source-address-prefixes '*' \
  --destination-port-ranges 80 \
  --protocol Tcp \
  --access Allow

az network nsg rule create \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --nsg-name tpot-nsg \
  --name AllowHTTPSInbound \
  --priority 350 \
  --source-address-prefixes '*' \
  --destination-port-ranges 443 \
  --protocol Tcp \
  --access Allow

# Add additional honeypot rules as needed...
```

### 4. Associate NSG with VM

```bash
# Get network interface name
NIC_NAME=$(az vm show --resource-group <YOUR_RESOURCE_GROUP> --name <YOUR_VM_NAME> --query networkProfile.networkInterfaces[0].id -o tsv | cut -d'/' -f9)

# Associate NSG with network interface
az network nic update \
  --resource-group <YOUR_RESOURCE_GROUP> \
  --name $NIC_NAME \
  --network-security-group tpot-nsg
```

## 🛡️ Security Best Practices

### Rule Management
- **Regular Review**: Periodically review and audit NSG rules
- **Principle of Least Privilege**: Only open ports that are absolutely necessary
- **Source Restrictions**: Always restrict management ports to specific IPs
- **Documentation**: Document the purpose of each rule

### Monitoring and Logging
- **Enable NSG Flow Logs**: Monitor network traffic patterns
- **Set up Alerts**: Configure alerts for suspicious traffic patterns
- **Regular Audits**: Conduct regular security audits of NSG configurations

### Compliance Considerations
- **Azure Policy**: Ensure NSG configurations comply with organizational policies
- **Regulatory Requirements**: Meet any applicable regulatory requirements
- **Change Management**: Implement proper change management for NSG modifications

## 🔍 Validation and Testing

### Port Scanning Validation

```bash
# Test management ports (should be accessible only from your IP)
nmap -p 64295,64297 <AZURE_VM_PUBLIC_IP>

# Test honeypot ports (should be accessible from anywhere)
nmap -p 22,80,443,25,3389 <AZURE_VM_PUBLIC_IP>

# Test blocked ports (should be filtered/closed)
nmap -p 8080,9200,5601 <AZURE_VM_PUBLIC_IP>
```

### Connectivity Testing

```bash
# Test SSH honeypot
telnet <AZURE_VM_PUBLIC_IP> 22

# Test HTTP honeypot
curl -I http://<AZURE_VM_PUBLIC_IP>

# Test HTTPS honeypot
curl -I -k https://<AZURE_VM_PUBLIC_IP>
```

## 📚 Additional Resources

- **[Azure NSG Documentation](https://docs.microsoft.com/azure/virtual-network/network-security-groups-overview)** - Official Azure NSG documentation
- **[T-Pot Port Reference](https://github.com/dtag-dev-sec/tpotce)** - Official T-Pot port documentation
- **[Azure Security Best Practices](https://docs.microsoft.com/azure/security/)** - Azure security guidelines
- **[Network Security Best Practices](../security-enhancements/)** - Advanced security configurations

---

> **⚠️ Important**: Always verify port requirements against the specific T-Pot release/profile you deploy. Port requirements may vary between different T-Pot editions and versions.

*For the complete NSG configuration reference, see: [NSG JSON Configuration](T-Port/AllyshipGlobalLtd-NEU-nsg.md)*
