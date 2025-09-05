<div align="center">

<img src="https://github.com/robertpreshyl/allyshipsec-tpot-azure-research/assets/logo/asl-allyship-security-lab-logo.png" alt="ASL Allyship Security Lab Logo" width="400" height="auto">

# 🛡️ Allyship Security Labs: Advanced T-Pot Honeypot with Zero-Trust Architecture

[![Cybersecurity](https://img.shields.io/badge/Cybersecurity-Research-blue?style=for-the-badge&logo=shield&logoColor=white)](https://github.com/topics/cybersecurity)
[![Honeypot](https://img.shields.io/badge/Honeypot-T--Pot-orange?style=for-the-badge&logo=bug&logoColor=white)](https://github.com/dtag-dev-sec/tpotce)
[![Azure](https://img.shields.io/badge/Cloud-Azure-blue?style=for-the-badge&logo=microsoft-azure&logoColor=white)](https://azure.microsoft.com/)
[![Threat Intelligence](https://img.shields.io/badge/Threat-Intelligence-red?style=for-the-badge&logo=search&logoColor=white)](https://github.com/topics/threat-intelligence)
[![Zero Trust](https://img.shields.io/badge/Architecture-Zero%20Trust-green?style=for-the-badge&logo=lock&logoColor=white)](https://github.com/topics/zero-trust)
[![NetBird](https://img.shields.io/badge/NetBird-Integration-purple?style=for-the-badge&logo=network&logoColor=white)](https://netbird.io/)
[![Security Onion](https://img.shields.io/badge/SIEM-Security%20Onion-yellow?style=for-the-badge&logo=monitor&logoColor=white)](https://securityonion.net/)
[![Research Complete](https://img.shields.io/badge/Status-Research%20Complete%20%7C%20Archived-success?style=for-the-badge&logo=check-circle&logoColor=white)](https://github.com/robertpreshyl/allyshipsec-tpot-azure-research)

</div>

---

## 🚀 Project Overview

This research project deployed a **T-Pot honeypot on Azure** with enhanced security controls via **NetBird** and **Elastic Fleet Agents** to capture and analyze real-world cyber attacks while maintaining a **zero-trust architecture**. The project successfully captured **55,000+ attack attempts** from **42+ countries** during a 7-day research period, providing valuable insights into current threat landscapes and attack patterns.

> **🔄 Project Evolution**: This research builds upon my [Allyship Security Lab VPN - Cloud-Local SIEM](https://github.com/yourusername/allyship-securitylab-VpNSIEM) infrastructure, demonstrating the evolution from basic SIEM setup to advanced threat intelligence collection with enhanced security controls.

### 🎯 Key Technologies
- **T-Pot** - The All-In-One Multi Honeypot Platform
- **Azure VM** - Cloud infrastructure hosting
- **Elastic Stack** - Kibana dashboard, Elasticsearch for data storage
- **Let's Encrypt** - SSL/TLS certificate management
- **NetBird** - Zero-trust network access
- **Elastic Fleet Agents** - Behavioral monitoring and log forwarding

## 🏗️ Architecture Evolution

This project represents the **next evolution** of my Allyship Security Labs infrastructure. While my previous project established secure network connectivity between environments using NetBird and Security Onion, this honeypot deployment demonstrates how to securely expose internet-facing services while maintaining complete visibility and control.

### 🔧 Enhanced Architecture Components
- **🔐 NetBird Zero-Trust Access**: Replaced direct SSH access with NetBird-managed WireGuard tunnels
- **📊 Elastic Fleet Integration**: Deployed agents to monitor host behavior and securely forward logs to local Security Onion
- **🎯 Comprehensive Threat Intelligence**: Captured and analyzed real-world attack patterns with behavioral context

## 🎯 Project Highlights

<div align="center">

| Metric | Value | Description |
|--------|-------|-------------|
| 🎯 **Total Attacks** | 55,000+ | Captured from 42+ countries |
| 🌍 **Countries** | 42+ | Global attack distribution |
| 🔐 **Zero-Trust** | ✅ | NetBird-managed access |
| 📊 **Monitoring** | ✅ | Elastic Fleet integration |
| 🛡️ **Compliance** | ✅ | Azure & GDPR compliant |

</div>

### 🚀 Key Achievements
- **🎯 Captured 55,000+ attack attempts** from 42+ countries using a securely isolated honeypot
- **🔐 Implemented zero-trust access model** using NetBird for secure management (replacing direct SSH)
- **📊 Integrated Elastic Fleet Agents** to monitor host behavior and securely forward logs to local Security Onion
- **🔍 Analyzed attack patterns** including SSH brute-forcing (78% of attacks), malware downloads, and port scanning
- **✅ Ensured compliance** with Azure terms of service and GDPR requirements for research data

## 🏛️ Technical Architecture

The enhanced T-Pot deployment features a multi-layered security architecture that goes beyond standard honeypot implementations:

[![Enhanced T-Pot Architecture](assets/diagrams/architecture-diagram.png)](assets/diagrams/architecture-diagram.png)

### 🔄 Architecture Flow
1. **🌐 Attackers** → Target Azure VM (T-Pot honeypots)
2. **🕸️ T-Pot** → Captures and logs all attack attempts
3. **🔐 NetBird** → Provides secure management access via WireGuard tunnels
4. **📊 Elastic Fleet** → Monitors host behavior and forwards logs
5. **🛡️ Security Onion** → Receives and analyzes logs from local instance

### 🧩 Key Components
- **🕸️ Honeypots**: Cowrie (SSH), Dionaea (malware), Honeytrap (network services)
- **📊 Elastic Stack**: Kibana dashboard, Elasticsearch for data storage
- **🔐 NetBird Security Layer**: Zero-trust access control and network segmentation
- **📈 Elastic Fleet Agents**: Behavioral monitoring and secure log forwarding

## 🔍 Key Findings

### 1. 🎯 SSH Brute-Forcing Dominates Attack Patterns
SSH brute-forcing represented **78% of all captured attacks**, with over **1,000 attempts** recorded in the first hour of deployment. This finding highlights the persistent nature of credential-based attacks in the current threat landscape.

[![SSH Attack Patterns](assets/screenshots/ssh-attack-patterns.png)](assets/screenshots/ssh-attack-patterns.png)

### 2. 🌍 Global Attack Distribution
Top attacker countries included **China (34%)**, **United States (28%)**, and **Russia (18%)**, with attacker ASNs primarily showing commercial hosting providers. This distribution suggests the use of compromised infrastructure for attack campaigns.

[![Attack Map](assets/screenshots/attack-map.png)](assets/screenshots/attack-map.png)

### 3. 🔑 Common Credential Patterns
The most frequently attempted credentials were **'root' username with '123456' password (72% of SSH attempts)**, followed by **'admin'/'admin' combinations**. This data supports the importance of strong password policies and multi-factor authentication.

[![Credential Analysis](assets/screenshots/credential-analysis.png)](assets/screenshots/credential-analysis.png)

### 4. 🦠 Malware Capture and Analysis
Successfully captured **3 distinct malware binaries** through the Dionaea honeypot, with behavioral analysis from Elastic Fleet agents providing additional context on execution patterns and network communications.

[![Malware Analysis](assets/screenshots/malware-analysis.png)](assets/screenshots/malware-analysis.png)

## 🔒 Security Enhancements

### 🔐 NetBird Access Control
Replaced direct SSH access with NetBird-managed WireGuard tunnels, implementing granular access policies for different user roles. This approach maintained secure access even when away from the home network while providing complete audit trails.

[![NetBird Dashboard](assets/screenshots/netbird-dashboard.png)](assets/screenshots/netbird-dashboard.png)

**Key Benefits:**
- ✅ Zero-trust network access with proper authentication
- ✅ Granular access policies for honeypot management
- ✅ Secure access from any location without VPN complexity
- ✅ Complete audit trail of all network connections

### 📊 Elastic Fleet Integration
Deployed Elastic Fleet Agents to monitor host behavior and configured secure log forwarding to the local Security Onion instance. This integration provided behavioral analysis of honeypot interactions beyond traditional log analysis.

[![Elastic Fleet Dashboard](assets/screenshots/elastic-fleet.png)](assets/screenshots/elastic-fleet.png)

**Key Benefits:**
- ✅ Real-time behavioral monitoring of honeypot interactions
- ✅ Secure log forwarding to local SIEM infrastructure
- ✅ Enhanced threat detection through behavioral analysis
- ✅ Integration with existing Security Onion deployment

### 🛡️ Zero-Trust Architecture
All devices connected via NetBird with proper access policies, ensuring no direct internet exposure for management interfaces and maintaining complete visibility into all network connections.

## ⚖️ Compliance and Ethical Considerations

This research project was conducted with strict adherence to professional and legal standards:

- **☁️ Azure Terms of Service**: Passive monitoring only, no active engagement with attackers
- **🔒 GDPR Requirements**: Data minimization, limited retention periods, anonymized analysis
- **⚖️ Ethical Standards**: No collection of personal data, focus on attack patterns and techniques
- **📋 Research Ethics**: Transparent methodology, responsible disclosure of findings

The NetBird security layer enhances compliance by providing controlled access and complete audit trails, ensuring all research activities are properly documented and authorized.

## 🚀 Getting Started

To replicate this research setup:

<div align="center">

| Step | Description | Documentation |
|------|-------------|---------------|
| 1️⃣ | Set up NetBird infrastructure | [NetBird Integration](docs/security-enhancements/netbird-integration.md) |
| 2️⃣ | Create Azure VM | [VM Configuration](docs/azure-configuration/vm-configuration.md) |
| 3️⃣ | Configure NSG Rules | [NSG Rules](docs/azure-configuration/nsg-rules.md) |
| 4️⃣ | Install T-Pot | [Setup Guide](docs/setup-guide.md) |
| 5️⃣ | Secure with Let's Encrypt | [SSL Configuration](docs/azure-configuration/ssl-configuration.md) |
| 6️⃣ | Integrate with Elastic Fleet | [Elastic Fleet Setup](docs/security-enhancements/elastic-fleet-setup.md) |

</div>

## 📚 Documentation Links

<div align="center">

| Category | Description | Links |
|----------|-------------|-------|
| 📋 **Setup** | Complete installation and configuration | [Full Setup Guide](docs/setup-guide.md) |
| ☁️ **Azure** | VM setup, NSG rules, and SSL configuration | [Azure Configuration](docs/azure-configuration/) |
| 🔒 **Security** | NetBird and Elastic Fleet integration | [Security Enhancements](docs/security-enhancements/) |
| 🔍 **Research** | Attack analysis and threat intelligence | [Research Findings](docs/research-findings/) |
| ✅ **Compliance** | Legal and ethical considerations | [Compliance Documentation](docs/compliance/) |

</div>

## 🤝 Contributing

This research project is archived but serves as a reference for cybersecurity professionals. For questions about methodology or implementation details, please open an issue or refer to the comprehensive documentation.

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on referencing this research.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Copyright (c) 2024 Allyship Security Labs**

---

<div align="center">

*This research was conducted as part of Allyship Security Labs' ongoing threat intelligence initiatives. All data collection and analysis was performed in compliance with applicable laws and ethical standards.*

**🛡️ Building a More Secure Digital Future**

</div>