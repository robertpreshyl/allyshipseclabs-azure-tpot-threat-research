# SSL/TLS Configuration for T-Pot (Let’s Encrypt)

This guide secures the T-Pot web interface with a Let’s Encrypt certificate, matching the process used in this research.

## Prerequisites
- Public DNS A record for your host, e.g., `asltpot.example.com` → your VM public IP
- Temporarily allow inbound 80/tcp in Azure NSG to complete HTTP validation
- T-Pot already installed and running on your Azure VM

## Steps
1) Stop T-Pot during issuance (standalone mode binds to 80)
```
sudo systemctl stop tpot
```

2) Obtain certificate with Certbot (standalone)
```
sudo apt update && sudo apt install -y certbot
sudo certbot certonly --standalone -d <your_domain>
```

3) Install the certificate into T-Pot’s nginx cert path
```
sudo cp /etc/letsencrypt/live/<your_domain>/fullchain.pem ~/tpotce/data/nginx/cert/nginx.crt
sudo cp /etc/letsencrypt/live/<your_domain>/privkey.pem  ~/tpotce/data/nginx/cert/nginx.key
sudo chown tpot:tpot ~/tpotce/data/nginx/cert/nginx.crt ~/tpotce/data/nginx/cert/nginx.key
sudo chmod 600 ~/tpotce/data/nginx/cert/nginx.key
```

4) (Optional) Switch HTTPS to 443
```
sudo micro ~/tpotce/.env
# Change: TPOT_HTTPS_PORT=64297 → TPOT_HTTPS_PORT=443
```
Update Azure NSG rules accordingly (open 443/tcp; you can remove 64297 if unused).

5) Start T-Pot
```
sudo systemctl start tpot
```

6) Test access
- `https://<your_domain>:64297` (default) or `https://<your_domain>` if you set 443
- Verify certificate issued by Let’s Encrypt and browser padlock appears

## Notes
- Keep port 80 open only during issuance/renewal windows if you prefer tight exposure. Alternatively, use DNS validation with a supported plugin.
- For renewals, either use a brief maintenance window (HTTP-01) or configure DNS-01 per your DNS provider.

## References
- T-Pot GitHub: `https://github.com/dtag-dev-sec/tpotce`
- Certbot: `https://certbot.eff.org/`
