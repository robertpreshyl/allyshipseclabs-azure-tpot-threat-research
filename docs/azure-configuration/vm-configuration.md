# Azure VM Configuration for T-Pot Honeypot

Use this checklist to select and provision an Azure VM. Follow Microsoft’s quickstart to actually create the VM.

## Recommended specs (align with common T-Pot requirements)
- vCPU: 4+ (recommended)
- RAM: 16 GB+ (recommended)
- Disk: 120 GB+ SSD (Premium SSD preferred)
- OS: Ubuntu 22.04 LTS
- Public IP: Standard (required for exposure)

Notes:
- Size up if you enable many honeypots/dashboards.
- Enable boot diagnostics and optional auto-shutdown.

## Create the VM
- Azure Portal quickstart (Ubuntu): `https://learn.microsoft.com/azure/virtual-machines/linux/quick-create-portal`
- After provisioning, proceed to T-Pot install per T-Pot docs.

## Management approach
- Use NetBird overlay for management (no public SSH needed).

## Next Steps
1. [Configure Network Security Groups](nsg-rules.md)
2. [Set up SSL/TLS Configuration](ssl-configuration.md)
3. [Install and Configure T-Pot](../setup-guide.md)
4. [Integrate with NetBird](../security-enhancements/netbird-integration.md)
