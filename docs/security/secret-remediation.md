# Secret Remediation Runbook

- 2025-10-02: Removed a public SSH key from `docs/azure-configuration/T-Port/T-Port/T-pot Honey pot.md` and replaced with `<YOUR_PUBLIC_SSH_KEY_HERE>`.
- If any connection strings or access keys are later found, rotate them immediately in the cloud provider and replace with env/Key Vault references.

## History purge (if required)
If a real credential was committed in past history, purge with `git filter-repo`:

```bash
pipx install git-filter-repo
# Example: remove a committed file across history
git filter-repo --force --path docs/azure-configuration/T-Port/T-Port/T-pot\ Honey\ pot.md --invert-paths
# Or replace a literal string
git filter-repo --force --replace-text <(echo 'OLD_SECRET==>REDACTED')
# Force-push after coordination
git push --force origin main
```

Coordinate with collaborators before force-pushing.
