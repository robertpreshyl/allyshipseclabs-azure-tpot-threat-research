# Network Security Group (NSG) Configuration for T-Pot on Azure

This page focuses specifically on T-Pot exposure on Azure. NetBird is self-hosted on AWS in this project, so do not add NetBird ports to the Azure NSG.

## Principles
- Expose only the ports required by your selected T-Pot profile/version
- Keep management/admin access off the public internet (use NetBird overlay)
- Default deny all other inbound
- Validate against T-Pot’s official documentation for your release

Authoritative reference for services/ports: `https://github.com/dtag-dev-sec/tpotce`

## Common inbound rules (examples)
Confirm against your chosen profile:
- 80/tcp, 443/tcp: Web UI and HTTP(S)-based honeypots
- 22/tcp or 23/tcp: SSH or Telnet honeypots (e.g., Cowrie/Heralding)
- 5060/udp: SIP honeypot (e.g., SentryPeer)
- 3306/tcp: MySQL honeypots (e.g., Dionaea)
- 6379/tcp: Redis honeypot (Redishoneypot)
- Additional ports per ICS/qHoneypots profiles (e.g., 502, 102, 2404, 47808)

Avoid exposing real administrative services (SSH to the host). Manage via NetBird.

## Outbound
- Allow OS/package updates
- Allow telemetry to Security Onion/Elastic (prefer via NetBird overlay)
- Block unnecessary egress

## Associate NSG
- Attach the NSG to the NIC or subnet of the T-Pot VM

## My example categories (from a prior run)
- Open to Any: 80, 443, 23, 53/udp, 3389, 3306, 1433, 1521, 6379, 5060/udp, 42/135/1723, 8080/8443, ICS ports (502/102/2404/47808)
- Deny all else by default

Always verify ports against the specific T-Pot release/profile you deploy: `https://github.com/dtag-dev-sec/tpotce`
