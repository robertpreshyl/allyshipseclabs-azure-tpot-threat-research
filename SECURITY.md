# Security Policy

## No secrets in the repository
- Do not commit credentials, API keys, tokens, SSH keys, certificates, or connection strings.
- Use environment variables, Azure Key Vault, or short-lived SAS tokens for access.
- Documentation must use placeholders only (e.g., `<AZURE_STORAGE_ACCOUNT_NAME>`, `<SAS_TOKEN>`).

## Reporting a security issue
If you find a security issue in this repository, please open a private issue or contact the maintainers. Do not open public PRs containing sensitive data.

## Secret scanning and push protection
This repo uses GitHub Secret Scanning/Push Protection and gitleaks CI to prevent credentials from being committed.
