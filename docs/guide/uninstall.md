# Uninstallation Guide

To completely remove BlockGuard CLI from your system, follow the steps below.

---

## 🐧 Linux / 🍏 macOS

### Step 1: Stop the service (Critical)
Always stop the daemon before deleting any files. This ensures your system DNS is cleanly restored to DHCP defaults.
```bash
sudo blockguard stop
```

### Step 2: Remove binary and configs
```bash
# Delete global executable
sudo rm -f /usr/local/bin/blockguard
sudo rm -rf /opt/blockguard

# Delete configurations and license databases
rm -rf ~/.blockguard
sudo rm -rf /root/.blockguard
```

### Step 3: Remove systemd service (if installed)
```bash
sudo systemctl disable blockguard 2>/dev/null
sudo rm -f /etc/systemd/system/blockguard.service
sudo systemctl daemon-reload
```

---

## 🏁 Windows

1. Stop the server in **Administrator Command Prompt**:
   ```cmd
   blockguard stop
   ```
2. Restore your DNS server settings back to **Automatic (DHCP)** under Windows settings.
3. Delete the folder containing `blockguard.exe` (e.g. `C:\Program Files\BlockGuard\`).
4. Remove the folder path from your system environment **PATH** variable.
5. Delete the configurations directory at `%USERPROFILE%\.blockguard\`.
