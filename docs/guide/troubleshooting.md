# Troubleshooting Guide

Here are solutions to the most common issues users encounter when using BlockGuard CLI.

---

## ❓ Internet stops working after stopping BlockGuard

This happens if the DNS restoration sequence did not complete cleanly (e.g. BlockGuard crashed or the process was forcefully killed via `kill -9` without running the `stop` command).

### Linux Fix:
Force `systemd-resolved` to reload DHCP DNS settings from NetworkManager:
```bash
sudo systemctl restart systemd-resolved
```
If that doesn't work immediately, disconnect and reconnect your Wi-Fi interface, or run:
```bash
# Replace wlo1 with your network interface name
sudo resolvectl revert wlo1
sudo systemctl restart systemd-resolved
```

---

## ❓ BlockGuard shows "0 queries" or does not block ads

This means your system's network DNS is not actually pointing to BlockGuard.

### Verify:
Check if resolved is routing queries to localhost:
```bash
resolvectl status
# Verify that "DNS Servers: 127.0.0.1" is set on your active interface.
```

### Fix:
Restart BlockGuard to force it to re-apply the DNS routing:
```bash
sudo blockguard stop
sudo blockguard start
```

---

## ❓ "permission denied" when starting the server

Ports below `1024` are system-level privileged ports. DNS runs on port `53`, which requires administrator access.

### Fix:
Always start the daemon with `sudo` (Linux/macOS) or run Command Prompt as **Administrator** (Windows):
```bash
sudo blockguard start
```

---

## ❓ "no active subscription found" when using sudo

Your license activation details are saved in the user's home directory (e.g., `~/.blockguard/`). When you run `sudo start`, it looks under the root user's home folder (`/root/.blockguard/`).

### Fix:
Ensure you run the `activate` command with `sudo` as well:
```bash
sudo blockguard activate YOUR-LICENSE-KEY
```

---

## ❓ A website or service is broken / falsely blocked

Some blocklists can be aggressive and block legitimate content or login flows.

### Fix:
Whitelist the domain to bypass all filters:
```bash
sudo blockguard whitelist add example.com
sudo blockguard stop && sudo blockguard start
```
