# Filter Lists

BlockGuard matches DNS requests against public blocklists. It ships with pre-configured filters and allows you to subscribe to additional community-maintained lists.

---

## Pre-Configured Filters

BlockGuard includes the following lists enabled out-of-the-box:

| Filter | Rules Count | Purpose | Source |
|--------|-------------|---------|--------|
| **AdGuard DNS Filter** | ~155,000 | Blocks web/app ads and tracking domains | [AdGuard Team](https://github.com/AdguardTeam/AdGuardSDNSFilter) |
| **Steven Black Hosts** | ~79,000 | Blocks ads, tracking, and malware sites | [Steven Black](https://github.com/StevenBlack/hosts) |

---

## Filter Management Commands

Use the `filters` command suite to control subscriptions:

```bash
# List all active blocklists and rule counts
sudo blockguard filters list

# Add a new blocklist URL
sudo blockguard filters add "https://some-blocklist.com/list.txt"

# Remove a blocklist subscription by ID
sudo blockguard filters remove <filter_id>

# Re-download and reload all filter lists
sudo blockguard filters update

# Temporarily disable a blocklist
sudo blockguard filters disable <filter_id>

# Enable a disabled blocklist
sudo blockguard filters enable <filter_id>
```

---

## Recommended Third-Party Filters

If you wish to expand your blocking coverage, here are some highly-regarded lists:

### 1. General & Performance Focused
- **OISD Lite / Big** (Adware/Malware/Scam blocking):
  `https://big.oisd.nl`
- **Hagezi Multi PRO** (Privacy-focused tracking blocking):
  `https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/pro.txt`

### 2. Specialized Blocklists
- **NoTracking** (Blocks telemetry and tracker scripts):
  `https://raw.githubusercontent.com/notracking/hosts-blocklists/master/hostnames.txt`
