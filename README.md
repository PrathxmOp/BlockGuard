# 🛡️ BlockGuard CLI

**BlockGuard CLI** is a lightweight, high-performance command-line utility developed by **PrathxmOp** to protect your system and network from ads, trackers, and malicious domains. It operates as a local DNS sinkhole (DNS proxy) that filters requests based on public blocklists, in-memory cache, and local whitelists.

---

## 🚀 Features

- **DNS-level Ad Blocking** — Intercepts DNS queries and blocks ads/trackers by returning `NXDOMAIN` or `0.0.0.0`.
- **312,000+ Block Rules** — Ships with AdGuard DNS Filter and Steven Black Hosts enabled by default.
- **Subdomain/Wildcard Matching** — Rules like `||example.com^` block the domain and all its subdomains recursively.
- **In-Memory DNS Cache** — Caches clean queries locally for near-zero latency on repeat lookups.
- **Upstream Failover** — Resolves queries through Cloudflare (`1.1.1.1`) and Google (`8.8.8.8`) by default.
- **Live Statistics & API** — View query counts, blocked %, cache hit rate, and top blocked domains in real time.
- **Background Daemon Mode** — Run as a system background service with `start -d`.
- **System Hosts File Protection** — Optional secondary layer via `/etc/hosts` manipulation.
- **Custom Whitelisting** — Allow specific domains to bypass all filter rules.
- **Subscription-Based Licensing** — Device-limited, auto-expiring license keys with hardware fingerprint enforcement.
- **Self-Updating** — Check for and apply updates directly from the CLI.
- **Cross-Platform** — Works on Linux, macOS, and Windows.

---

## 🛠️ Installation

### One-Line Install (Linux & macOS)
```bash
curl -fsSL https://raw.githubusercontent.com/PrathxmOp/my-apis/main/install.sh | sh
```

### Manual Install

#### 1. Download Binary
Download the precompiled binary for your system architecture from the [GitHub Releases](https://github.com/PrathxmOp/BlackHole/releases) page.

| Platform | File |
|----------|------|
| Linux x86_64 | `blockguard-linux-x86_64.tar.gz` |
| Linux ARM64 | `blockguard-linux-aarch64.tar.gz` |
| macOS (Universal) | `blockguard-macos.tar.gz` |
| Windows x86_64 | `blockguard-windows-x86_64.zip` |

#### 2. 🐧 Linux & 🍏 macOS Setup
```bash
# Extract the archive
tar -xzf blockguard-*.tar.gz

# Make it executable
chmod +x blockguard

# Install globally
sudo mv blockguard /usr/local/bin/
```

#### 3. 🏁 Windows Setup
1. Download and extract `blockguard-windows-x86_64.zip`.
2. Move `blockguard.exe` to a folder of your choice (e.g. `C:\Program Files\BlockGuard`).
3. Add that directory to your system **PATH** environment variable.
4. Run Command Prompt or PowerShell as **Administrator** to use commands requiring privileged ports.

---

## ⚡ Quick Start

```bash
# 1. Activate your subscription
blockguard activate BG-PRO-YOURKEYHERE

# 2. Start the DNS server (requires sudo for port 53)
sudo blockguard start

# 3. Check status and live stats
blockguard status

# 4. Test ad blocking (should return NXDOMAIN)
dig @127.0.0.1 adservice.google.com

# 5. Stop the server
blockguard stop
```

---

## 🔑 Subscription & Activation

BlockGuard is a subscription-based utility. You must activate it with a valid license key before starting the filtering server.

### Activate
```bash
blockguard activate BG-PRO-YOURKEYHERE
```
> Activation enforces a per-plan **device limit** and **auto-expiration**. Each device is identified by a unique hardware fingerprint. Once the device limit is reached, no new machines can be activated with the same key.

### Check License Status
```bash
blockguard license
```
Displays: plan type, subscriber email, expiration date, and days remaining.

### Deactivate / Reset
```bash
blockguard reset-license
```
Clears registration details and removes the local machine's activation.

---

## 📖 Command Reference

Run `blockguard [command]` to manage the tool. Use `blockguard [command] --help` for detailed usage.

### Server Control
| Command | Description |
|---------|-------------|
| `start` | Start the DNS filtering server. Use `-d` or `--daemon` for background mode |
| `stop` | Stop the running background daemon |
| `status` | Show running state, uptime, query stats, and top blocked domains |
| `configure` | Run interactive setup wizard to configure upstreams and settings |

### Configuration (`config`)
| Command | Description |
|---------|-------------|
| `config show` | Display all current settings |
| `config set [key] [value]` | Update a single configuration value |
| `config reset` | Reset all settings to factory defaults |

**Configurable Keys:**

| Key | Type | Example | Description |
|-----|------|---------|-------------|
| `dns.listen_address` | string | `127.0.0.1` | IP address to bind the DNS server |
| `dns.listen_port` | int | `53` | Port for the DNS server |
| `blocking.enabled` | bool | `true` | Enable/disable ad blocking |
| `blocking.response_type` | string | `nxdomain` | How to respond to blocked queries (`nxdomain`, `zero_ip`, `custom_ip`) |
| `blocking.custom_ip` | string | `0.0.0.0` | Custom IP for blocked domains (when `custom_ip` response type is set) |
| `hosts.manage` | bool | `false` | Enable/disable system hosts file management |
| `logging.level` | string | `info` | Log level (`debug`, `info`, `warn`, `error`) |
| `api.port` | int | `4321` | Port for the local HTTP stats API |
| `api.enabled` | bool | `true` | Enable/disable the local HTTP API |
| `license.github_token` | string | — | GitHub PAT for license validation |
| `license.repo` | string | — | Private GitHub repo holding license database |

### Filter Subscriptions (`filters`)
| Command | Description |
|---------|-------------|
| `filters list` | List all subscribed filter lists with rule counts |
| `filters add [url]` | Subscribe to a new blocklist URL |
| `filters remove [id]` | Remove a filter subscription |
| `filters enable [id]` | Enable a disabled filter list |
| `filters disable [id]` | Temporarily disable a filter list |
| `filters update` | Re-download and reload all enabled filter lists |

### Whitelisting (`whitelist`)
| Command | Description |
|---------|-------------|
| `whitelist list` | List all custom allowed domains |
| `whitelist add [domain]` | Allow a domain to bypass all blocklists |
| `whitelist remove [domain]` | Remove a domain from the whitelist |

### Backup & Restore
| Command | Description |
|---------|-------------|
| `export-settings` | Export configuration to a ZIP file |
| `import-settings` | Restore settings from an exported ZIP backup |
| `export-logs` | Export log files to a ZIP file |

### Software Updates
| Command | Description |
|---------|-------------|
| `check-update` | Check if a newer version is available on GitHub |
| `update` | Download and apply the latest release binary in-place |

### Other
| Command | Description |
|---------|-------------|
| `completion` | Generate shell autocompletion scripts (bash, zsh, fish, powershell) |
| `--version` | Print version and developer information |

---

## 🔒 Privileged Permissions & System-Wide Setup

Binding to the default DNS port `53` requires **root/administrator** privileges. Start the service with `sudo`:

```bash
sudo blockguard start
```

### Routing your System DNS through BlockGuard
Once the server is running, you must point your system's network DNS settings to `127.0.0.1` so BlockGuard can filter your traffic:

#### 🐧 Linux (Fedora/Ubuntu/Debian)
Run this command in your terminal (replace `wlo1` or `eth0` with your active interface name):
```bash
# Temporarily set DNS for wlo1 interface
sudo resolvectl dns wlo1 127.0.0.1
sudo resolvectl flush-caches
```

#### 🍏 macOS
1. Open **System Settings** -> **Network**.
2. Select your active Wi-Fi or Ethernet connection, click **Details...** -> **DNS**.
3. Add `127.0.0.1` as the primary DNS server.

#### 🏁 Windows
1. Open **Settings** -> **Network & internet** -> **Wi-Fi** (or **Ethernet**).
2. Click **Hardware properties**, select **DNS server assignment** -> **Edit**.
3. Choose **Manual**, enable **IPv4**, and enter `127.0.0.1` as the **Preferred DNS**.

---

## 📂 File Locations

| File | Location | Purpose |
|------|----------|---------|
| Configuration | `~/.blockguard/config.yaml` | All settings (DNS, blocking, filters, license) |
| License | `~/.blockguard/license.json` | Local activation state and machine fingerprint |
| PID File | `~/.blockguard/blockguard.pid` | Daemon process ID for `stop` command |

---

## 🐛 Troubleshooting

| Problem | Solution |
|---------|----------|
| `permission denied` on start | Run with `sudo` or change `dns.listen_port` to a non-privileged port (>1024) |
| `device limit reached` on activate | Your key has reached max device activations. Contact your admin or use `reset-license` on an old device |
| `subscription expired` | Your license key has expired. Contact your admin for a renewal |
| Server not blocking ads | Ensure your system DNS is pointing to `127.0.0.1` on the correct port |
| `check-update` fails | Ensure you have an internet connection and can reach `api.github.com` |

---

<p align="center">
  <b>BlockGuard CLI v1.0.0</b> — Developed by <a href="https://github.com/PrathxmOp">PrathxmOp</a>
</p>
