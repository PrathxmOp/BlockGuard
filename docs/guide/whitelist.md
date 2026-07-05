# Whitelisting Domains

Sometimes, a blocklist may cause a legitimate website or service you use (such as a marketing email referral link or a gaming service connection) to stop loading. 

BlockGuard allows you to whitelist specific domains to ensure they are never filtered.

---

## Whitelist Commands

Manage your custom whitelist using the following commands:

```bash
# Add a domain to the whitelist
sudo blockguard whitelist add example.com

# List all currently whitelisted domains
sudo blockguard whitelist list

# Remove a domain from the whitelist
sudo blockguard whitelist remove example.com
```

---

## Subdomain Matching Rules

When you whitelist a domain, it applies recursively to all its subdomains.

- Whitelisting `example.com` will automatically allow:
  - `example.com`
  - `www.example.com`
  - `api.staging.example.com`

---

## Applying Changes
After modifying your whitelist, you must restart or reload BlockGuard to apply the changes to the engine:

```bash
sudo blockguard stop
sudo blockguard start
```
*Alternatively, send SIGHUP to reload configs in-memory:*
```bash
sudo kill -HUP $(cat ~/.blockguard/blockguard.pid)
```
