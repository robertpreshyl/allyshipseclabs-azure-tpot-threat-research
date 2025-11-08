# NetBird Integration (Reference + Environment Notes)

This project links to the official NetBird documentation rather than re-documenting each step. Use these references for setup, operations, and reverse-proxy guidance.

## Authoritative Documentation
- Self-hosted guide: `https://docs.netbird.io/selfhosted/selfhosted-guide`
- Managed service: `https://app.netbird.io`

## My environment notes
- Control plane: Self-hosted on AWS
- Identity provider: OIDC per the self-hosted guide
- Exposure: Signal/Management/Relay behind TLS per reverse-proxy guidance in the official docs
- Access policies:
  - Admin: SSH and dashboards to the Azure T-Pot host over WireGuard overlay only
  - Logging: Allow Elastic/OSQuery traffic between T-Pot and Security Onion via overlay
- Transport: Prefer QUIC or WebSocket relay as supported by NetBird

## Tips
- Keep management endpoints private; use DNS + ACME per the guide
- Use groups and tags to scope least-privilege policies
- Backups and upgrades: follow the backup and upgrade sections in the self-hosted guide

For complete install, backup, upgrade, reverse-proxy and troubleshooting steps, follow the official NetBird self-hosted guide above.

