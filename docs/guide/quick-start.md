# Quick Start (5 Minutes)

Once BlockGuard is installed, follow these 3 simple steps to get system-wide ad blocking running.

## Step 1: Activate your license key
Use `sudo` so that the license details are saved for the root user.

```bash
sudo blockguard activate YOUR-LICENSE-KEY
```
*(Replace `YOUR-LICENSE-KEY` with your actual subscription or 3-day trial key).*

Expected output:
```
✓ Activation Successful!
Plan:       Pro Plan
Email:      your@email.com
Expires:    05 Jul 2027
```

---

## Step 2: Start BlockGuard
Start the DNS server daemon in the background:

```bash
sudo blockguard start
```

Expected output:
```
✓ BlockGuard started successfully in background (PID: 155893).
  DNS Server:  127.0.0.1:53
  API Server:  http://127.0.0.1:4321
✓ System DNS routed through BlockGuard (system-wide ad blocking active)
```

::: tip NOTE
On Linux, BlockGuard automatically detects your active network interface and routes system DNS to `127.0.0.1`.
:::

---

## Step 3: Check status and stats
Verify that BlockGuard is active and blocking queries:

```bash
sudo blockguard status
```

Expected output:
```
BlockGuard is running (PID 155893).
Uptime:         1m6s
Total Queries:  941
Blocked:        768 (81.62%)
Allowed:        173 (18.38%)
Cache Hits:     15 (1.59%)

Top Blocked Domains:
┌────────────────────────────────┬────────┐
│             DOMAIN             │ BLOCKS │
├────────────────────────────────┼────────┤
│ segment-data-us-east.zqtk.net  │ 10     │
│ live.rezync.com                │ 10     │
│ segment-data.zqtk.net          │ 10     │
│ config.aps.amazon-adsystem.com │ 10     │
└────────────────────────────────┴────────┘
```

---

## Step 4: Stop the server
To turn off ad blocking and restore default system DNS configurations:

```bash
sudo blockguard stop
```

Expected output:
```
Stopping BlockGuard (PID 158053)...
BlockGuard stopped successfully.
✓ System DNS restored to default settings.
```
