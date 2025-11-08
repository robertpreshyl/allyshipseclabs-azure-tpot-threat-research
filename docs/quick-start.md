# T-Pot Honeypot Quick Start Guide

> **Last Updated**: October 2, 2025  
> **Audience**: Experienced system administrators and security professionals  
> **Time Required**: 2-3 hours

This quick start guide provides a streamlined deployment process for experienced users familiar with Azure, Linux administration, and honeypot technologies.

## ⚡ Prerequisites Checklist

- [ ] Azure subscription with VM creation permissions
- [ ] SSH key pair generated and ready
- [ ] Domain name with DNS management access
- [ ] Basic understanding of T-Pot, Docker, and network security
- [ ] NetBird infrastructure (optional but recommended)

## 🚀 Rapid Deployment

### Step 1: Azure VM Creation (10 minutes)

```bash
# Set deployment variables
export RESOURCE_GROUP="tpot-research-rg"
export VM_NAME="tpot-honeypot-vm"
export LOCATION="northeurope"
export ADMIN_USERNAME="azureuser"
export SSH_KEY_PATH="~/.ssh/id_rsa.pub"

# Create resource group and VM
az group create --name $RESOURCE_GROUP --location $LOCATION
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
  --zone 2
```

### Step 2: NSG Configuration (15 minutes)

```bash
# Create NSG with essential rules
az network nsg create --resource-group $RESOURCE_GROUP --name tpot-nsg --location $LOCATION

# Management ports (restrict to your IP)
export YOUR_IP="$(curl -s ifconfig.me)/32"
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name tpot-nsg \
  --name AllowSSHManagement --priority 310 --source-address-prefixes $YOUR_IP \
  --destination-port-ranges 64295 --protocol Tcp --access Allow

az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name tpot-nsg \
  --name AllowWebManagement --priority 320 --source-address-prefixes $YOUR_IP \
  --destination-port-ranges 64297 --protocol Tcp --access Allow

# Honeypot ports (open to internet)
HONEYPOT_PORTS="22 80 443 23 25 21 3389 3306 1433 6379 5060"
PRIORITY=330
for PORT in $HONEYPOT_PORTS; do
  az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name tpot-nsg \
    --name "AllowHoneypot${PORT}" --priority $PRIORITY --source-address-prefixes '*' \
    --destination-port-ranges $PORT --protocol Tcp --access Allow
  ((PRIORITY+=10))
done

# Associate NSG with VM
NIC_NAME=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --query networkProfile.networkInterfaces[0].id -o tsv | cut -d'/' -f9)
az network nic update --resource-group $RESOURCE_GROUP --name $NIC_NAME --network-security-group tpot-nsg
```

### Step 3: T-Pot Installation (30 minutes)

```bash
# Get VM public IP
VM_IP=$(az vm show --resource-group $RESOURCE_GROUP --name $VM_NAME --show-details --query publicIps -o tsv)

# Connect and install T-Pot
ssh -i ~/.ssh/id_rsa azureuser@$VM_IP << 'EOF'
# Set password for sudo
sudo passwd azureuser

# Update system
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl certbot

# Install T-Pot
env bash -c "$(curl -sL https://github.com/telekom-security/tpotce/raw/master/install.sh)"

# Reboot required
sudo reboot
EOF

# Wait for reboot and reconnect on new port
sleep 60
ssh -i ~/.ssh/id_rsa -p 64295 azureuser@$VM_IP 'dps'  # Verify T-Pot is running
```

### Step 4: SSL Configuration (20 minutes)

```bash
# Configure DNS record first (manual step)
echo "Create DNS A record: tpot.yourdomain.com -> $VM_IP"
read -p "Press enter when DNS is configured..."

# Connect and configure SSL
ssh -i ~/.ssh/id_rsa -p 64295 azureuser@$VM_IP << 'EOF'
# Temporarily allow HTTP for certificate validation
sudo ufw allow 80/tcp

# Stop T-Pot and obtain certificate
sudo systemctl stop tpot
sudo certbot certonly --standalone -d tpot.yourdomain.com

# Install certificate in T-Pot
sudo cp /etc/letsencrypt/live/tpot.yourdomain.com/fullchain.pem ~/tpotce/data/nginx/cert/nginx.crt
sudo cp /etc/letsencrypt/live/tpot.yourdomain.com/privkey.pem ~/tpotce/data/nginx/cert/nginx.key
sudo chown tpot:tpot ~/tpotce/data/nginx/cert/nginx.crt ~/tpotce/data/nginx/cert/nginx.key
sudo chmod 600 ~/tpotce/data/nginx/cert/nginx.key

# Start T-Pot
sudo systemctl start tpot

# Remove temporary HTTP rule
sudo ufw delete allow 80/tcp
EOF
```

### Step 5: Verification (10 minutes)

```bash
# Test honeypot services
echo "Testing honeypot services..."
nmap -p 22,80,443,25,3389 $VM_IP

# Test web interface
curl -k https://$VM_IP:64297

# Test SSL certificate
echo | openssl s_client -connect tpot.yourdomain.com:64297 2>/dev/null | openssl x509 -noout -dates

echo "✅ Quick deployment complete!"
echo "🌐 Web Interface: https://tpot.yourdomain.com:64297"
echo "🔐 SSH Access: ssh -p 64295 azureuser@$VM_IP"
```

## 🔧 Optional Enhancements

### NetBird Integration (Advanced)
```bash
# Install NetBird client (if infrastructure exists)
curl -fsSL https://pkgs.netbird.io/install.sh | sh
sudo netbird up --setup-key <YOUR_SETUP_KEY>
```

### Elastic Fleet Agent (Monitoring)
```bash
# Download and install Elastic Agent
curl -L -O https://artifacts.elastic.co/downloads/beats/elastic-agent/elastic-agent-8.11.0-linux-x86_64.tar.gz
tar xzvf elastic-agent-8.11.0-linux-x86_64.tar.gz
cd elastic-agent-8.11.0-linux-x86_64

# Install with your Security Onion configuration
sudo ./elastic-agent install \
  --url=https://<SECURITY_ONION_IP>:8220 \
  --enrollment-token=<ENROLLMENT_TOKEN>
```

## 🎯 Post-Deployment Checklist

- [ ] Web interface accessible at `https://tpot.yourdomain.com:64297`
- [ ] SSH access working on port 64295
- [ ] Honeypot services responding (ports 22, 80, 443, etc.)
- [ ] SSL certificate valid and trusted
- [ ] Attack data being collected in dashboards
- [ ] System monitoring and logging operational

## 🔍 Troubleshooting Quick Fixes

### T-Pot Won't Start
```bash
sudo systemctl status tpot
sudo journalctl -u tpot -n 50
sudo netstat -tulpn | grep LISTEN  # Check for port conflicts
```

### SSL Issues
```bash
ls -la ~/tpotce/data/nginx/cert/
openssl x509 -in ~/tpotce/data/nginx/cert/nginx.crt -text -noout
```

### Network Connectivity
```bash
az network nsg rule list --resource-group $RESOURCE_GROUP --nsg-name tpot-nsg --output table
nc -zv $VM_IP 22 80 443 64295 64297
```

## 📚 Next Steps

For detailed configuration and advanced features, see:

- **[Complete Setup Guide](setup-guide.md)** - Comprehensive deployment documentation
- **[Security Enhancements](security-enhancements/)** - Advanced security configurations
- **[Research Analysis](research-findings/)** - Attack analysis and findings
- **[Troubleshooting Guide](troubleshooting.md)** - Detailed troubleshooting procedures

## ⚠️ Security Reminders

- **Change default credentials** immediately after installation
- **Restrict management ports** to your IP address only
- **Enable automatic updates** for security patches
- **Monitor attack logs** regularly for suspicious activity
- **Backup configurations** before making changes
- **Review compliance** requirements for your environment

---

> **🚀 Success!** Your T-Pot honeypot is now operational and ready to capture attack data. Monitor the dashboards and logs to begin your security research.

*For support and additional resources, see the [Documentation Index](README.md) or [Community Resources](../CONTRIBUTING.md).*
