# System-Wide Routing

To filter ads and trackers, your system's network traffic must route through BlockGuard's local DNS listener (`127.0.0.1:53`).

---

## 🐧 Linux (Automatic Mode)

BlockGuard fully supports Linux platforms running `systemd-resolved` (Fedora, Ubuntu, Debian, Arch, etc.).

When you run `sudo blockguard start`, it automatically performs the following:
1. Parses your routing table (`ip route`) to find the active internet interface (e.g., `wlo1` or `eth0`).
2. Configures `systemd-resolved` to point the DNS servers list for that interface to `127.0.0.1`.
3. Flushes resolver caches.

When you run `sudo blockguard stop`, it:
1. Clears `127.0.0.1` from the interface DNS settings.
2. Reverts the link configurations back to default.
3. Restarts the `systemd-resolved` daemon to instantly pull DHCP configurations from NetworkManager.

---

## 🐧 Linux (Manual Mode)

If your Linux distribution does not run `systemd-resolved` (e.g. Alpine Linux, basic server installations, or custom router builds), the automatic setup might warn that `resolvectl` is missing. In this case, you must manually point your system DNS resolver to localhost.

### Option A: Edit `/etc/resolv.conf` (Direct & Fast)

Open `/etc/resolv.conf` in your editor with root privileges:
```bash
sudo nano /etc/resolv.conf
```

Replace the existing `nameserver` lines with:
```text
nameserver 127.0.0.1
```

::: warning NOTE
On many modern Linux distros, `/etc/resolv.conf` is dynamically managed by NetworkManager or dhcpcd, meaning your edits will be overwritten upon reboot or reconnection. To lock your changes permanently, see Option B.
:::

### Option B: Configure dhcpcd / dhclient
If your system uses a DHCP client to manage `/etc/resolv.conf`, configure it to prepend localhost as the primary resolver:

- **For `dhcpcd`** (Edit `/etc/dhcpcd.conf`):
  ```text
  prepend domain_name_servers 127.0.0.1;
  ```
- **For `dhclient`** (Edit `/etc/dhcp/dhclient.conf`):
  ```text
  prepend domain-name-servers 127.0.0.1;
  ```

---

## 🍏 macOS (Manual Configuration)

On macOS, you must manually point your primary network DNS settings to localhost:

1. Open **System Settings** → **Network**.
2. Select your active Wi-Fi or Ethernet connection, click **Details...** → **DNS**.
3. Click the **+** button under DNS servers, and add: `127.0.0.1`.
4. Remove any other DNS addresses so all queries route through BlockGuard.
5. Click **OK** → **Apply**.

---

## 🏁 Windows (Manual Configuration)

On Windows, you must configure IPv4 assignment properties:

1. Open **Settings** → **Network & internet** → **Wi-Fi** (or **Ethernet**).
2. Click **Hardware properties**.
3. Under **DNS server assignment**, click **Edit**.
4. Choose **Manual**, enable the **IPv4** toggle.
5. Enter `127.0.0.1` in the **Preferred DNS** field.
6. Click **Save**.
