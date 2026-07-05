# 📚 BlockGuard CLI — Full Documentation

> This is the complete technical documentation for BlockGuard CLI.
> For a quick overview and getting started guide, see the [README](README.md).

---

## Table of Contents

- [How DNS-Level Blocking Works](#-how-dns-level-blocking-works)
- [System-Wide Setup (Detailed)](#-system-wide-setup-detailed)
  - [Linux (Fedora, Ubuntu, Debian, Arch)](#-linux-fedora-ubuntu-debian-arch)
  - [macOS](#-macos)
  - [Windows](#-windows)
- [Blocking Methods](#-blocking-methods)
- [Configuration Reference](#-configuration-reference)
- [Filter Management](#-filter-management)
- [Whitelisting Domains](#-whitelisting-domains)
- [License & Activation](#-license--activation)
- [Troubleshooting](#-troubleshooting)
- [Uninstallation](#-uninstallation)

---

## 🧠 How DNS-Level Blocking Works

Every time you open a website, click a link, or use any app that connects to the internet, your device performs a **DNS lookup** — it asks a DNS server to translate a domain name (like `ads.google.com`) into an IP address.

BlockGuard sits between your device and the internet as a **local DNS server**. It intercepts every DNS query and checks it against 230,000+ known ad/tracker/malware domains:

```
┌──────────────┐         ┌──────────────────┐         ┌──────────────┐
│  Your Device │──DNS──▶ │   BlockGuard     │──DNS──▶ │  Internet    │
│  (Browser,   │  Query  │   (127.0.0.1)    │  Query  │  (1.1.1.1)   │
│   Apps,      │         │                  │         │              │
│   Games)     │◀─Reply──│  ✅ Clean domain │◀─Reply──│              │
│              │         │  → Forward       │         │              │
│              │◀─Block──│  ❌ Ad/Tracker   │         │              │
│              │         │  → Return NXDOMAIN│        │              │
└──────────────┘         └──────────────────┘         └──────────────┘
```

**Key advantages over browser extensions:**
- Blocks ads in **ALL** applications (not just browsers)
- Blocks tracking/telemetry from apps, games, and OS services
- Ads are blocked **before download**, saving bandwidth and battery
- Cannot be bypassed by websites that detect ad blockers
- Works across your entire system with a single installation

---

## 🔧 System-Wide Setup (Detailed)

BlockGuard runs on **port 53** (the standard DNS port) and requires **root/administrator** privileges. When you run `sudo blockguard start`, it automatically:

1. Starts the DNS filtering server in the background
2. Detects your active network interface (e.g., `wlo1`, `eth0`, `enp3s0`)
3. Routes your system DNS to `127.0.0.1` (BlockGuard)

When you run `sudo blockguard stop`, it automatically:

1. Stops the DNS filtering server
2. Restores your system DNS to the original DHCP/router settings
3. Restarts `systemd-resolved` to ensure clean DNS state

> **Important:** Always use `sudo blockguard stop` to stop BlockGuard. Do NOT kill the process manually (`kill`, `pkill`, etc.) as this will leave your system DNS pointing to `127.0.0.1` with no server running, breaking your internet.

### 🐧 Linux (Fedora, Ubuntu, Debian, Arch)

**Automatic setup (recommended):**
```bash
# Start (auto-configures system DNS)
sudo blockguard start

# Stop (auto-restores system DNS)
sudo blockguard stop
```

BlockGuard automatically manages your DNS settings via `resolvectl` and `systemd-resolved`. No manual configuration needed.

**If your internet breaks after stopping BlockGuard:**

This can happen if BlockGuard was force-killed or crashed without running the stop sequence. To fix:

```bash
# Option 1: Restart systemd-resolved (recommended)
sudo systemctl restart systemd-resolved

# Option 2: Manually reset your DNS
# Replace wlo1 with your network interface name
sudo resolvectl revert wlo1
sudo systemctl restart systemd-resolved

# Option 3: Disconnect and reconnect Wi-Fi
# This forces NetworkManager to reconfigure DNS from DHCP
```

**Finding your network interface name:**
```bash
ip route show default
# Look for the name after "dev" — e.g., "wlo1", "eth0", "enp3s0"
```

**Making BlockGuard start on boot (optional):**
```bash
# Create a systemd service (run once)
sudo bash -c 'cat > /etc/systemd/system/blockguard.service << EOF
[Unit]
Description=BlockGuard DNS Ad Blocker
After=network-online.target
Wants=network-online.target

[Service]
Type=forking
ExecStart=/opt/blockguard/blockguard start
ExecStop=/opt/blockguard/blockguard stop
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

# Enable and start the service
sudo systemctl enable blockguard
sudo systemctl start blockguard
```

### 🍏 macOS

```bash
# Start
sudo blockguard start
```

After starting, configure your DNS manually:
1. Open **System Settings** → **Network**
2. Select your active connection (Wi-Fi or Ethernet)
3. Click **Details...** → **DNS**
4. Click **+** and add: `127.0.0.1`
5. Remove any other DNS entries
6. Click **OK** → **Apply**

To stop and restore:
```bash
sudo blockguard stop
```
Then remove `127.0.0.1` from your DNS settings and re-enable automatic DNS.

### 🏁 Windows

Run **Command Prompt as Administrator**:
```cmd
blockguard start
```

After starting, configure your DNS:
1. Open **Settings** → **Network & internet** → **Wi-Fi** (or **Ethernet**)
2. Click **Hardware properties**
3. Next to **DNS server assignment**, click **Edit**
4. Select **Manual**, enable **IPv4**
5. Set **Preferred DNS** to: `127.0.0.1`
6. Click **Save**

To stop and restore:
```cmd
blockguard stop
```
Then change your DNS server assignment back to **Automatic (DHCP)**.

---

## 🛡️ Blocking Methods

### Method 1: DNS Blocking (Default & Recommended)

This is the default mode. BlockGuard runs a local DNS server and filters queries in real-time.

| Aspect | Details |
|--------|---------|
| **How it works** | Intercepts DNS queries, blocks known ad/tracker domains |
| **Block rules** | 230,000+ rules from AdGuard DNS Filter + Steven Black Hosts |
| **Response type** | Returns `NXDOMAIN` (domain not found) for blocked domains |
| **Performance** | Near-zero latency with in-memory cache |
| **Scope** | All apps, browsers, games, and background services |

### Method 2: Hosts File Blocking (Optional)

Writes blocked domains directly to `/etc/hosts`. Use this as an **additional layer** alongside DNS blocking, or as a standalone method if you cannot change DNS settings.

```bash
# Enable hosts file management
sudo blockguard config set hosts.manage true

# Start the server
sudo blockguard start
```

| Aspect | Details |
|--------|---------|
| **How it works** | Writes `0.0.0.0 domain.com` entries to `/etc/hosts` |
| **Pros** | Works without DNS configuration changes |
| **Cons** | Slower with large blocklists (200k+ entries) |
| **Scope** | System-wide, but less effective for subdomain matching |

> **Tip:** You can use both methods together for maximum protection.

---

## ⚙️ Configuration Reference

View current settings:
```bash
sudo blockguard config show
```

Change a setting:
```bash
sudo blockguard config set <key> <value>
```

### All Configuration Keys

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `dns.listen_address` | string | `127.0.0.1` | IP address to bind the DNS server |
| `dns.listen_port` | int | `53` | Port for the DNS server |
| `dns.upstreams` | string | `1.1.1.1,8.8.8.8` | Upstream DNS resolvers (comma-separated) |
| `dns.cache.enabled` | bool | `true` | Enable/disable DNS response caching |
| `dns.cache.max_size` | int | `10000` | Maximum number of cached entries |
| `dns.cache.ttl` | int | `300` | Cache entry TTL in seconds |
| `blocking.enabled` | bool | `true` | Enable/disable ad blocking |
| `blocking.response_type` | string | `nxdomain` | Response for blocked domains: `nxdomain`, `zero_ip`, `custom_ip` |
| `blocking.custom_ip` | string | `0.0.0.0` | Custom IP for blocked domains |
| `hosts.manage` | bool | `false` | Enable/disable system hosts file management |
| `api.enabled` | bool | `true` | Enable/disable the local HTTP stats API |
| `api.port` | int | `4321` | Port for the local HTTP stats API |
| `api.address` | string | `127.0.0.1` | Address for the local HTTP stats API |
| `logging.level` | string | `info` | Log level: `debug`, `info`, `warn`, `error` |

### Example Configurations

**Use Cloudflare + Quad9 as upstream DNS:**
```bash
sudo blockguard config set dns.upstreams "1.1.1.1,9.9.9.9"
```

**Block ads with `0.0.0.0` instead of NXDOMAIN:**
```bash
sudo blockguard config set blocking.response_type zero_ip
```

**Enable both DNS blocking and hosts file blocking:**
```bash
sudo blockguard config set hosts.manage true
```

**Enable debug logging for troubleshooting:**
```bash
sudo blockguard config set logging.level debug
```

---

## 📋 Filter Management

BlockGuard ships with two filter lists enabled by default:

| Filter | Rules | Source |
|--------|-------|--------|
| AdGuard DNS Filter | ~155,000 | [adguardteam/AdGuardSDNSFilter](https://github.com/AdguardTeam/AdGuardSDNSFilter) |
| Steven Black Hosts | ~79,000 | [StevenBlack/hosts](https://github.com/StevenBlack/hosts) |

### Managing Filters

```bash
# List all active filter lists
sudo blockguard filters list

# Add a new filter list
sudo blockguard filters add "https://example.com/blocklist.txt"

# Remove a filter list
sudo blockguard filters remove <id>

# Update all filter lists (re-download)
sudo blockguard filters update

# Temporarily disable a filter list
sudo blockguard filters disable <id>

# Re-enable a disabled filter list
sudo blockguard filters enable <id>
```

### Popular Third-Party Filter Lists

| Name | URL | Focus |
|------|-----|-------|
| OISD Big | `https://big.oisd.nl` | Comprehensive (ads, trackers, malware) |
| Hagezi Pro | `https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/domains/pro.txt` | Privacy-focused |
| 1Hosts Lite | `https://o0.pages.dev/Lite/domains.txt` | Lightweight, minimal false positives |

---

## ✅ Whitelisting Domains

If BlockGuard blocks a domain that you need to access (like a legitimate service), you can whitelist it:

```bash
# Allow a specific domain
sudo blockguard whitelist add example.com

# List all whitelisted domains
sudo blockguard whitelist list

# Remove a domain from the whitelist
sudo blockguard whitelist remove example.com
```

---

## 🔑 License & Activation

### Activating Your License

```bash
sudo blockguard activate YOUR-LICENSE-KEY
```

> **Important:** Use `sudo` when activating so the license is stored in the root user's directory (required for system-wide mode).
>
> 🎁 **Free Trial:** If you do not have a license key yet, you can contact us on [Signal](https://signal.me/#eu/5hn89XV1PsUQlPRc0WhEoUEh197WioxzFJj-CTXOGe1Boymy0-FCub3zwWXa_L3a) to get a **free 3-day trial key** to test BlockGuard on your system.

### Checking License Status

```bash
sudo blockguard license
```

Output example:
```
✓ Subscription is Active
License Key:   BG-****-KEY
Plan Type:     Pro Plan
Subscriber:    your@email.com
Expiration:    05 Jul 2027 (365 days remaining)
```

### Deactivating / Resetting

```bash
sudo blockguard reset-license
```

This clears the local activation and frees up a device slot on your key.

### Device Limits

Each license key has a maximum number of devices that can be activated simultaneously. If you reach the limit:
- Deactivate an old device using `sudo blockguard reset-license` on that machine
- Or contact us on Signal to reset your device list or upgrade your plan

### Hardware Fingerprinting

BlockGuard generates a unique hardware fingerprint (HWID) for each device to prevent license sharing. This fingerprint is derived from:

| Platform | Source |
|----------|--------|
| Linux | `/etc/machine-id` |
| macOS | `IOPlatformUUID` from IOKit |
| Windows | `MachineGuid` from Windows Registry |

---

## 🐛 Troubleshooting

<details>
<summary><b>❓ Internet stops working after stopping BlockGuard</b></summary>

This happens if the DNS restoration didn't complete cleanly. Fix it by restarting the system DNS resolver:

```bash
sudo systemctl restart systemd-resolved
```

If that doesn't work, disconnect and reconnect your Wi-Fi, or run:
```bash
# Replace wlo1 with your network interface
sudo resolvectl revert wlo1
sudo systemctl restart systemd-resolved
```
</details>

<details>
<summary><b>❓ BlockGuard shows 0 queries / not blocking ads</b></summary>

Your system DNS is not pointing to BlockGuard. Verify:
```bash
resolvectl status
# Look for "DNS Servers: 127.0.0.1" on your active interface
```

If it's not set, restart BlockGuard:
```bash
sudo blockguard stop
sudo blockguard start
```
</details>

<details>
<summary><b>❓ "permission denied" when starting</b></summary>

Port 53 requires root privileges. Always use `sudo`:
```bash
sudo blockguard start
```
</details>

<details>
<summary><b>❓ "no active subscription found" with sudo</b></summary>

You activated without `sudo` but started with `sudo`. The license is stored per-user. Fix:
```bash
sudo blockguard activate YOUR-LICENSE-KEY
```
</details>

<details>
<summary><b>❓ "device limit reached"</b></summary>

Your key has reached its max devices. Contact us on [Signal](https://signal.me/#eu/5hn89XV1PsUQlPRc0WhEoUEh197WioxzFJj-CTXOGe1Boymy0-FCub3zwWXa_L3a) to reset devices or upgrade your plan.
</details>

<details>
<summary><b>❓ A website is broken / falsely blocked</b></summary>

Whitelist the domain:
```bash
sudo blockguard whitelist add example.com
```

Then restart BlockGuard:
```bash
sudo blockguard stop && sudo blockguard start
```
</details>

<details>
<summary><b>❓ How to check what domains are being blocked</b></summary>

Run BlockGuard in foreground mode to see live logs:
```bash
sudo blockguard start -f
```

Or check the top blocked domains:
```bash
sudo blockguard status
```
</details>

<details>
<summary><b>❓ BlockGuard crashed and internet is broken</b></summary>

If BlockGuard crashes without running the stop sequence:
```bash
# 1. Restart systemd-resolved to restore DNS
sudo systemctl restart systemd-resolved

# 2. Start BlockGuard again (or leave it stopped)
sudo blockguard start
```
</details>

---

## 🗑️ Uninstallation

```bash
# 1. Stop BlockGuard if running
sudo blockguard stop

# 2. Remove the binary
sudo rm -rf /opt/blockguard

# 3. Remove the symlink (if created)
sudo rm -f /usr/local/bin/blockguard

# 4. Remove configuration and license data
rm -rf ~/.blockguard
sudo rm -rf /root/.blockguard

# 5. Remove systemd service (if created)
sudo systemctl disable blockguard 2>/dev/null
sudo rm -f /etc/systemd/system/blockguard.service
sudo systemctl daemon-reload
```

---

<p align="center">
  <b>BlockGuard CLI v1.0.0</b> — Developed by <a href="https://github.com/PrathxmOp">PrathxmOp</a>
  <br/><br/>
  <a href="https://signal.me/#eu/5hn89XV1PsUQlPRc0WhEoUEh197WioxzFJj-CTXOGe1Boymy0-FCub3zwWXa_L3a">
    <img src="https://img.shields.io/badge/Contact-Signal-3a76f0?style=flat-square&logo=signal&logoColor=white" alt="Signal" />
  </a>
  <a href="https://github.com/PrathxmOp/BlockGuard">
    <img src="https://img.shields.io/badge/GitHub-BlockGuard-181717?style=flat-square&logo=github&logoColor=white" alt="GitHub" />
  </a>
</p>
