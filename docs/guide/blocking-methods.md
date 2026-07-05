# Blocking Methods

BlockGuard CLI offers two methods of blocking ads. You can use either method individually or combine them for maximum redundancy.

---

## Method 1: DNS Proxy (Recommended)

This is the default mode of operation. BlockGuard binds to port 53 and acts as a local DNS proxy.

### How it works:
- All system DNS queries go to BlockGuard.
- If a domain matches block rules, BlockGuard returns `NXDOMAIN` (non-existent domain) or `0.0.0.0` (as configured).
- If it is clean, it is resolved via upstream servers (Cloudflare/Google) and cached in-memory for speed.

```bash
# Enable DNS blocking (default: true)
sudo blockguard config set blocking.enabled true
```

---

## Method 2: System Hosts File Management

This method writes rules directly to your system `/etc/hosts` (Linux/macOS) or `C:\Windows\System32\drivers\etc\hosts` (Windows) file.

### How it works:
- When you start BlockGuard, it writes blocklists directly into the hosts file.
- The operating system resolves these domains to `0.0.0.0` locally without making external network queries.
- When you stop BlockGuard, it cleans up and restores your original hosts file.

### How to enable:
```bash
# Enable hosts file management
sudo blockguard config set hosts.manage true
```

::: warning PERFORMANCE CONSIDERATION
Writing 200,000+ domains directly to the system hosts file can slow down DNS resolution on some older systems. The DNS Proxy method is highly recommended for general use.
:::
