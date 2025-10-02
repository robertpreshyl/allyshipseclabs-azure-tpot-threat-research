T-Pot Honeypot Setup Guide - Azure VM

Last updated: September 4, 2025

This is a comprehensive step-by-step guide for setting up T-Pot honeypot on Azure VM. Use this reference to recreate the setup quickly without needing to search through documentation again.

 📌 Overview

This guide documents the complete process of:

Creating an Azure VM
Configuring Network Security Group (NSG) rules
Installing T-Pot honeypot platform
Securing the web interface with Let's Encrypt SSL certificate
Verifying the setup
 ⚙️ Prerequisites

Azure account with subscription
Local machine with SSH client
Domain name (e.g., allyshipglobal.com) with DNS management access
Basic understanding of honeypots and network security
 🖥️ Azure VM Setup

1. Create Azure VM

OS: Ubuntu 24.04 LTS
Size: Standard B4ms (4 vCPUs, 16 GB memory)
Disk: 128 GB SSD
Authentication type: SSH public key
SSH public key: Use your existing key or generate new one
 2. Connect to VM via SSH

 `ssh -i ~/.ssh/id_ed25519_github azureuser@<your_vm_public_ip>`

 3. Set user password (required for sudo operations
	)
	`sudo passwd azureuser
#Enter and confirm a strong password`

🔒 Network Security Group (NSG) Configuration

Management Ports (Restrict to your IP)





#  Network Security Group (NSG) Configuration

## Management Ports (Restrict to your IP)
| Rule # | Name                                 | Port   | Protocol | Source IP      | Action |
|--------|--------------------------------------|--------|----------|----------------|--------|
| 310    | AllowCidrBlockCustom64295Inbound     | 64295  | TCP      | 31.22.11.69    | Allow  |
| 320    | AllowMyIpAddressCustom64297Inbound   | 64297  | TCP      | 31.22.11.69    | Allow  |

> **Note:** Replace `31.22.11.69` with your actual public or VPN IP address.

---

## Honeypot Ports (Open to Any)
| Rule # | Name                  | Ports                             | Protocol   | Source | Action |
|--------|-----------------------|------------------------------------|------------|--------|--------|
| 330    | AllowSSHInbound        | 22                                 | TCP        | Any    | Allow  |
| 340    | AllowHTTPInbound       | 80                                 | TCP        | Any    | Allow  |
| 350    | AllowHTTPSInbound      | 443                                | TCP        | Any    | Allow  |
| 360    | AllowDNSUDPInbound     | 53                                 | UDP        | Any    | Allow  |
| 370    | AllowTelnetInbound     | 23                                 | TCP        | Any    | Allow  |
| 380    | AllowFTPInbound        | 21                                 | TCP        | Any    | Allow  |
| 390    | AllowSMTPInbound       | 25                                 | TCP        | Any    | Allow  |
| 400    | AllowIMAPPOPInbound    | 110, 143, 993, 995                 | TCP        | Any    | Allow  |
| 410    | AllowRDPInbound        | 3389                               | TCP        | Any    | Allow  |
| 420    | AllowConpotInbound     | 502, 102, 2404, 47808              | TCP        | Any    | Allow  |
| 430    | AllowSNMPInbound       | 161                                | UDP        | Any    | Allow  |
| 440    | AllowMySQLInbound      | 3306                               | TCP        | Any    | Allow  |
| 450    | AllowMSSQLInbound      | 1433                               | TCP        | Any    | Allow  |
| 460    | AllowOracleInbound     | 1521                               | TCP        | Any    | Allow  |
| 470    | AllowRedisInbound      | 6379                               | TCP        | Any    | Allow  |
| 480    | AllowSIPInbound        | 5060                               | TCP/UDP    | Any    | Allow  |
| 490    | AllowIPPInbound        | 631                                | TCP        | Any    | Allow  |
| 500    | AllowTelnetAltInbound  | 42, 135, 1723                      | TCP        | Any    | Allow  |
| 510    | AllowHTTPAltInbound    | 8080, 8443                         | TCP        | Any    | Allow  |
| 520    | AllowICMPInbound       | 19, 123, 1900                      | UDP        | Any    | Allow  |

---

###  Important
- Replace the placeholder IP (`31.22.11.69`) with your actual IP or VPN IP to restrict management access.
- Honeypot ports are open to any source—this is intentional to mimic real-world accessible services.
- Make sure the configuration aligns with your risk profile and that you monitor traffic to these open ports.

---

*Context: This setup is based on the T-Pot honeypot installation guide from GitHub. It enables incoming traffic to honeypot services while restricting management interfaces for enhanced security.*  








🐝 T-Pot Installation

1. Update system and install curl

`sudo apt update && sudo apt install -y curl`

2. Run T-Pot installer

`env bash -c "$(curl -sL https://github.com/telekom-security/tpotce/raw/master/install.sh)"`

3. During installation:

Enter your user password when prompted
Create a strong <WEB_USER> and password for the web interface
Pay attention to port conflict warnings
 
 4. Reboot the VM

 `sudo reboot`

 5. Reconnect via SSH on new port

`ssh -i ~/.ssh/id_ed25519_github azureuser@<your_vm_public_ip> -p 64295`

6. Verify T-Pot is running

```
dps
#Should show all containers with status "Up"
```


 
🔐 Let's Encrypt SSL Certificate Setup

1. Add DNS record for your domain

Create A record: asltpot.allyshipglobal.com → <your_vm_public_ip>
Set to DNS only (grey cloud) in Cloudflare
 2. Open port 80 in Azure NSG

Priority: 380
Name: AllowHTTP80Inbound
Port: 80
Protocol: TCP
Source: Any
Action: Allow
 3. Install Certbot

 `sudo apt update && sudo apt install -y certbot`

 4. Stop T-Pot service
```

sudo systemctl stop tpot

```
5. Obtain certificate

```
sudo certbot certonly --standalone -d asltpot.allyshipglobal.com
# Enter email when prompted
# Agree to terms
# Optional: Share email with EFF
```

6. Copy certificate to T-Pot directory

`sudo cp /etc/letsencrypt/live/asltpot.allyshipglobal.com/fullchain.pem ~/tpotce/data/nginx/cert/nginx.crt
sudo cp /etc/letsencrypt/live/asltpot.allyshipglobal.com/privkey.pem ~/tpotce/data/nginx/cert/nginx.key`

7. Set proper permissions
```

   sudo chown tpot:tpot ~/tpotce/data/nginx/cert/nginx.crt ~/tpotce/data/nginx/cert/nginx.key
sudo chmod 600 ~/tpotce/data/nginx/cert/nginx.key
```

8. Restart T-Pot
```

  ` sudo systemctl start tpot`
```

  9. (Optional) Change to standard HTTPS port

```
	  sudo micro ~/tpotce/.env
# Change TPOT_HTTPS_PORT=64297 to TPOT_HTTPS_PORT=443
```


10. Update NSG rules

Delete rule for port 64297
Create new rule for port 443 (Priority 320, TCP, Any source)
 ✅ Verification Steps

1. Clear browser cache

Hard refresh: Ctrl+Shift+R (Windows) or Cmd+Shift+R (Mac)
Clear HSTS cache:
Chrome/Edge: chrome://net-internals/#hsts → Delete domain security policy
 2. Access secured web interface

```
 `https://asltpot.allyshipglobal.com:64297
# Or without port if using 443
https://asltpot.allyshipglobal.com`
```


3. Verify secure connection

Check for padlock icon in browser
Certificate should be issued by "Let's Encrypt"
 4. Verify honeypot services

Check attack attempts in Kibana dashboard
Monitor dps command for active containers
 ⚠️ Important Notes & Considerations

Azure Compliance

T-Pot setup is compliant with Azure terms as long as:
Only passively receiving and logging connection attempts
Not generating excessive outbound traffic
Management ports restricted to trusted IPs
 GDPR Compliance (EU)

IP addresses are considered personal data under GDPR
For 7-day research:
Document research purpose clearly
Only retain data for necessary period (30 days max for analysis)
Anonymize attacker IPs in any public reports
 Data Storage Options

Azure Blob Storage (Free Tier):
```

sudo tar -czvf tpot-research-$(date +%Y%m%d).tar.gz /home/azureuser/tpotce/data
# Upload via Azure Portal
```


   Local Download:
```

   # From local machine
mkdir ~/tpot-research && cd ~/tpot-research
scp -P 64295 azureuser@<your_vm_ip>:/home/azureuser/tpotce/data ./tpot-data
```


# Back up and copy

`sudo systemctl stop tpot
`

`cd ~
tar -czvf tpot-backup-$(date +%Y%m%d-%H%M%S).tar.gz tpotce/data`


`scp -i ~/.ssh/id_ed25519_github -P 64295 azureuser@20.107.170.231:~/tpot-backup-*.tar.gz ~/Documents/T-Pot-Research/`
Security Best Practices

Keep SSH access (port 64295) restricted to your IP
Use SSH keys for authentication (not passwords)
Keep OS updated: sudo apt update && sudo apt upgrade
Never store sensitive data on honeypot
Enable blackhole feature: TPOT_BLACKHOLE=ENABLED in ~/tpotce/.env


📚 References

T-Pot GitHub
Azure Network Security Groups
Let's Encrypt Documentation

 
 Note: This documentation is for personal reference only. Always verify commands against current documentation before use.