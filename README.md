<p align="center">
  <img src="https://img.shields.io/badge/BlockGuard-v1.0.0-blue?style=for-the-badge" alt="BlockGuard v1.0.0" />
  <img src="https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-green?style=for-the-badge" alt="Platforms" />
  <img src="https://img.shields.io/badge/License-Subscription-orange?style=for-the-badge" alt="License" />
</p>

<h1 align="center">🛡️ BlockGuard CLI</h1>

<h3 align="center">System-wide Ad Blocker, Tracker Protection & DNS Firewall</h3>

<p align="center">
  Block ads, trackers, and malicious domains across your <b>entire system</b> — browsers, apps, games, and background services.
  <br/>No browser extension needed. Works at the network level.
</p>

<p align="center">
  <a href="#-quick-start-5-minutes">Quick Start</a> •
  <a href="#-installation">Installation</a> •
  <a href="#-how-to-use">How to Use</a> •
  <a href="#-get-a-license-key">Get a Key</a> •
  <a href="DOCS.md"><b>Full Docs 📚</b></a>
</p>

---

<!-- 
  📹 DEMO GIF PLACEHOLDER
  Replace the URL below with your actual GIF link after recording.
  Example: ![BlockGuard Demo](https://raw.githubusercontent.com/PrathxmOp/BlockGuard/main/demo.gif)
-->
<p align="center">
  <img src="https://raw.githubusercontent.com/PrathxmOp/BlockGuard/main/demo.gif" width="700" alt="BlockGuard CLI Demo" />
</p>

---

## 🤔 What is BlockGuard?

BlockGuard is a **system-wide ad blocker** that works at the DNS level. Instead of installing extensions in every browser, BlockGuard sits between your device and the internet and **blocks ad/tracker domains before they even load**.

### How it works (simplified):

```
You open a website
        ↓
Browser asks: "Where is ads.google.com?"
        ↓
BlockGuard intercepts → "That's an ad domain. BLOCKED! ❌"
        ↓
Ad never loads. Page loads faster. ✅
```

### Why use BlockGuard?

| Feature | Browser Extension (uBlock) | BlockGuard |
|---------|---------------------------|------------|
| Blocks ads in browser | ✅ | ✅ |
| Blocks ads in all apps | ❌ | ✅ |
| Blocks ads in games | ❌ | ✅ |
| Blocks background trackers | ❌ | ✅ |
| Saves bandwidth/data | Partial | ✅ Full |
| Works system-wide | ❌ | ✅ |

---

## 🔑 Get a License Key & Pricing

BlockGuard is a premium, highly affordable service costing **just $2 USD per month** (billed flexibly). 

🎁 **Try before you buy:** Message us on Signal to get a **free 3-day trial key** with absolutely no commitment!

<p align="center">
  <a href="https://signal.me/#eu/5hn89XV1PsUQlPRc0WhEoUEh197WioxzFJj-CTXOGe1Boymy0-FCub3zwWXa_L3a">
    <img src="https://img.shields.io/badge/Signal-Message%20Us%20For%20Key-3a76f0?style=for-the-badge&logo=signal&logoColor=white" alt="Contact on Signal" />
  </a>
</p>

> **DM us on Signal** to get your license key or request your free 3-day trial key. We support multiple payment options.

### 💎 Why pay for BlockGuard over free tools?

1. **System-wide Auto-Recovery (Worth it alone!)**  
   Free terminal DNS tricks and scripts often leave your system DNS broken when they stop or crash, meaning your internet stops working entirely. BlockGuard CLI has a built-in safety net: when stopped, it **automatically restores your default DHCP settings** and safely restarts the resolver service, so your internet never breaks.
2. **Ultimate App & Game Blocking**  
   Free browser extensions like uBlock only protect that specific browser. BlockGuard filters all network traffic, stopping telemetry, trackers, and video/display ads inside native apps, desktop clients, games, and OS background tasks.
3. **No Overhead or Bloat**  
   Unlike heavy GUI-based local blockers, BlockGuard is written in optimized Go. It runs as a lightweight, low-footprint daemon with near-zero CPU usage and high-performance in-memory DNS caching.
4. **Active Filter Management**  
   Easily add, disable, enable, and self-update lists via simple CLI commands. Your subscription keeps the default rules (312,000+) updated daily.

---

## 📦 Installation

### One-Line Install (Linux & macOS)

Open your terminal and paste this command:

```bash
curl -fsSL https://raw.githubusercontent.com/PrathxmOp/my-apis/main/install.sh | sh
```

That's it! BlockGuard is now installed on your system.

### Manual Install

<details>
<summary><b>🐧 Linux</b> (click to expand)</summary>

1. Download the correct file for your system from the [Releases page](https://github.com/PrathxmOp/BlockGuard/releases):
   - **Intel/AMD** → `blockguard-linux-x86_64.tar.gz`
   - **ARM (Raspberry Pi, etc.)** → `blockguard-linux-aarch64.tar.gz`

2. Open your terminal and run:
   ```bash
   # Extract
   tar -xzf blockguard-linux-*.tar.gz

   # Install
   sudo mv blockguard-linux-*/blockguard /usr/local/bin/

   # Verify installation
   blockguard --version
   ```

</details>

<details>
<summary><b>🍏 macOS</b> (click to expand)</summary>

1. Download `blockguard-macos.tar.gz` from the [Releases page](https://github.com/PrathxmOp/BlockGuard/releases).

2. Open Terminal and run:
   ```bash
   # Extract
   tar -xzf blockguard-macos.tar.gz

   # Install
   sudo mv blockguard-macos/blockguard /usr/local/bin/

   # Verify installation
   blockguard --version
   ```

</details>

<details>
<summary><b>🏁 Windows</b> (click to expand)</summary>

1. Download `blockguard-windows-x86_64.zip` from the [Releases page](https://github.com/PrathxmOp/BlockGuard/releases).
2. Extract the ZIP file.
3. Move `blockguard.exe` to `C:\Program Files\BlockGuard\`.
4. Add `C:\Program Files\BlockGuard\` to your system **PATH**.
5. Open **Command Prompt as Administrator** to use BlockGuard.

</details>

---

## ⚡ Quick Start (5 Minutes)

Follow these 3 steps and you'll have system-wide ad blocking running:

### Step 1: Activate your license key

```bash
sudo blockguard activate YOUR-LICENSE-KEY
```

> Replace `YOUR-LICENSE-KEY` with the key you received after purchase.
>
> **Important:** Use `sudo` so the activation is saved for the root user (needed for system-wide mode).

You should see:
```
✓ Activation Successful!
Plan:       Pro Plan
Email:      your@email.com
Expires:    05 Jul 2027
```

### Step 2: Start BlockGuard

```bash
sudo blockguard start
```

You should see:
```
✓ BlockGuard started successfully in background (PID: 12345).
  DNS Server:  127.0.0.1:53
  API Server:  http://127.0.0.1:4321
```

### Step 3: Route your system DNS through BlockGuard

This is the most important step! Without this, your system will continue using your ISP's DNS and ads won't be blocked.

<details>
<summary><b>🐧 Linux (Fedora / Ubuntu / Debian)</b> — click to expand</summary>

First, find your active network interface name:
```bash
ip route show default
# Look for the name after "dev", e.g. "wlo1" or "eth0" or "enp3s0"
```

Then route your DNS through BlockGuard (replace `wlo1` with your interface name):
```bash
sudo resolvectl dns wlo1 127.0.0.1
sudo resolvectl flush-caches
```

**To verify it's working:**
```bash
resolvectl status wlo1
# You should see: DNS Servers: 127.0.0.1
```

> **Note:** This setting resets when you restart your computer or reconnect to Wi-Fi. To make it permanent, see the [Permanent DNS Setup](#-making-dns-permanent-linux) section below.

</details>

<details>
<summary><b>🍏 macOS</b> — click to expand</summary>

1. Open **System Settings** → **Network**
2. Select your active connection (Wi-Fi or Ethernet)
3. Click **Details...** → **DNS**
4. Click **+** and add: `127.0.0.1`
5. Remove any other DNS entries
6. Click **OK** → **Apply**

</details>

<details>
<summary><b>🏁 Windows</b> — click to expand</summary>

1. Open **Settings** → **Network & internet** → **Wi-Fi** (or **Ethernet**)
2. Click **Hardware properties**
3. Next to **DNS server assignment**, click **Edit**
4. Select **Manual**
5. Enable **IPv4**
6. Set **Preferred DNS** to: `127.0.0.1`
7. Click **Save**

</details>

### ✅ Done! Verify it's working

Open your browser and visit some websites. Then check your stats:

```bash
sudo blockguard status
```

You should see something like:
```
BlockGuard is running (PID 12345).
Uptime:         2m30s
Total Queries:  930
Blocked:        797 (85.70%)
Allowed:        133 (14.30%)
Cache Hits:     22 (2.37%)

Top Blocked Domains:
┌────────────────────────────────┬────────┐
│             DOMAIN             │ BLOCKS │
├────────────────────────────────┼────────┤
│ securepubads.g.doubleclick.net │ 25     │
│ pixel.adsafeprotected.com      │ 40     │
│ config.aps.amazon-adsystem.com │ 10     │
│ pixel.quantserve.com           │ 20     │
└────────────────────────────────┴────────┘
```

> **85%+ of ad/tracker requests blocked!** 🎉

---

## 📖 How to Use

### Method 1: DNS Blocking (Recommended) 🌐

This is the **default and recommended** method. BlockGuard runs a local DNS server that filters all network traffic on your device.

**Pros:** Fast, lightweight, blocks ads in ALL apps and browsers.

```bash
# Start (runs in background automatically)
sudo blockguard start

# Check stats
sudo blockguard status

# Stop
sudo blockguard stop
```

> **Remember:** You must also configure your system DNS to `127.0.0.1` (see [Step 3](#step-3-route-your-system-dns-through-blockguard) above).

### Method 2: Hosts File Blocking 📝

This method writes blocked domains directly into your system's `/etc/hosts` file. It works without changing DNS settings, but is **slower** with large blocklists.

**Pros:** No DNS configuration needed. Works immediately.
**Cons:** Slower with 200k+ rules. Cannot block subdomains as effectively.

```bash
# Enable hosts file management
sudo blockguard config set hosts.manage true

# Start the server
sudo blockguard start

# BlockGuard will now write blocked domains to /etc/hosts automatically.
# To stop and restore your original hosts file:
sudo blockguard stop
```

> **Tip:** You can use both methods together for maximum protection!

---

## 🔧 Configuration

### View current settings
```bash
sudo blockguard config show
```

### Common settings you might want to change

```bash
# Change DNS upstream servers (default: Cloudflare + Google)
sudo blockguard config set dns.upstreams "1.1.1.1,9.9.9.9"

# Enable hosts file blocking alongside DNS blocking
sudo blockguard config set hosts.manage true

# Change log level for debugging
sudo blockguard config set logging.level debug

# Change how blocked domains are handled
# Options: "nxdomain" (default), "zero_ip", "custom_ip"
sudo blockguard config set blocking.response_type zero_ip
```

---

## 📋 Command Reference

### Everyday Commands

| Command | What it does |
|---------|-------------|
| `sudo blockguard start` | Start the ad blocker (runs in background) |
| `sudo blockguard stop` | Stop the ad blocker |
| `sudo blockguard status` | Show stats: queries, blocked %, top blocked domains |
| `sudo blockguard start -f` | Start in foreground (shows live logs in terminal) |

### License & Activation

| Command | What it does |
|---------|-------------|
| `sudo blockguard activate KEY` | Activate your license key |
| `sudo blockguard license` | Show license status (plan, expiry, days remaining) |
| `sudo blockguard reset-license` | Remove activation from this device |

### Configuration

| Command | What it does |
|---------|-------------|
| `sudo blockguard config show` | Show all current settings |
| `sudo blockguard config set KEY VALUE` | Change a setting |
| `sudo blockguard config reset` | Reset all settings to defaults |
| `sudo blockguard configure` | Run interactive setup wizard |

### Filter Lists

| Command | What it does |
|---------|-------------|
| `sudo blockguard filters list` | Show all active blocklists with rule counts |
| `sudo blockguard filters add URL` | Add a new blocklist |
| `sudo blockguard filters remove ID` | Remove a blocklist |
| `sudo blockguard filters update` | Re-download and reload all blocklists |

### Whitelist (Allow specific domains)

| Command | What it does |
|---------|-------------|
| `sudo blockguard whitelist list` | Show allowed domains |
| `sudo blockguard whitelist add DOMAIN` | Allow a domain (bypass blocking) |
| `sudo blockguard whitelist remove DOMAIN` | Remove a domain from whitelist |

### Updates

| Command | What it does |
|---------|-------------|
| `blockguard check-update` | Check if a newer version is available |
| `sudo blockguard update` | Download and install the latest version |

---

## 🔄 Making DNS Permanent (Linux)

The `resolvectl dns` command resets after reboot. To make it permanent:

### Option A: NetworkManager (Fedora/Ubuntu with GUI)
1. Open **Settings** → **Wi-Fi** → click the ⚙️ gear icon on your connection
2. Go to **IPv4** tab
3. Set **DNS** to `127.0.0.1`
4. Toggle **Automatic DNS** to **OFF**
5. Click **Apply**

### Option B: Command Line (headless servers)
```bash
# Create a systemd-resolved override
sudo mkdir -p /etc/systemd/resolved.conf.d/
echo -e "[Resolve]\nDNS=127.0.0.1" | sudo tee /etc/systemd/resolved.conf.d/blockguard.conf
sudo systemctl restart systemd-resolved
```

---

## 📂 File Locations

| File | Location | Purpose |
|------|----------|---------|
| Configuration | `~/.blockguard/config.yaml` | All settings |
| License | `~/.blockguard/license.json` | Activation state |
| PID File | `~/.blockguard/blockguard.pid` | Background process tracking |

> **Note:** When running with `sudo`, files are stored in `/root/.blockguard/` instead.

---

## 🐛 Troubleshooting

<details>
<summary><b>❓ BlockGuard says 0 queries / not blocking ads</b></summary>

Your system DNS is not pointing to BlockGuard yet. Follow [Step 3](#step-3-route-your-system-dns-through-blockguard) to route your DNS to `127.0.0.1`.

To verify your DNS is correctly configured:
```bash
# This should return NXDOMAIN (blocked)
dig @127.0.0.1 adservice.google.com
```
</details>

<details>
<summary><b>❓ "permission denied" when starting</b></summary>

You need to run with `sudo`:
```bash
sudo blockguard start
```
Port 53 (DNS) is a system-level port and requires root access on all operating systems.
</details>

<details>
<summary><b>❓ "no active subscription found" with sudo</b></summary>

You activated the key as a normal user but started with `sudo`. The license file is stored per-user. Fix it by activating with `sudo` too:
```bash
sudo blockguard activate YOUR-LICENSE-KEY
```
</details>

<details>
<summary><b>❓ "device limit reached"</b></summary>

Your license key has reached its maximum number of devices. Contact the admin on Signal to reset your devices or upgrade your plan.
</details>

<details>
<summary><b>❓ "subscription expired"</b></summary>

Your license key has expired. Contact us on Signal to renew.
</details>

<details>
<summary><b>❓ Internet stops working after starting BlockGuard</b></summary>

If BlockGuard crashes or is stopped while your DNS is pointed to `127.0.0.1`, your internet will stop resolving. To fix:
```bash
# Restore your DNS to automatic (replace wlo1 with your interface)
sudo resolvectl revert wlo1
```
</details>

---

## 🚀 Features

- **312,000+ Block Rules** — Ships with AdGuard DNS Filter and Steven Black Hosts
- **System-Wide Protection** — Blocks ads in browsers, apps, games, and background services
- **In-Memory DNS Cache** — Near-zero latency on repeat lookups
- **Wildcard/Subdomain Blocking** — Rules like `||example.com^` block all subdomains
- **Upstream Failover** — Uses Cloudflare (`1.1.1.1`) and Google (`8.8.8.8`) by default
- **Live Statistics** — Real-time query counts, block rates, and top blocked domains
- **Background Daemon** — Runs silently in the background
- **Hosts File Mode** — Optional `/etc/hosts` manipulation for an extra layer
- **Custom Whitelisting** — Allow specific domains to bypass filters
- **Cross-Platform** — Linux, macOS, and Windows
- **Auto-Updates** — Check and apply updates from the CLI

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
