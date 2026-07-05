# Router Setup (OpenWrt)

BlockGuard is written in optimized Go, meaning it can be compiled into a single static binary for any CPU architecture (including **ARM** or **MIPS/MIPSEL** commonly used in routers). 

By running BlockGuard directly on your router, you get network-wide ad blocking:
- **Zero device resource usage:** Laptops and mobile phones do not run any local agent, saving battery and CPU.
- **Universal coverage:** All connected devices (Smart TVs, iPads, gaming consoles, guests' phones) are automatically protected.

---

## Step 1: Download the Router Binary

Download the compiled archive matching your router's processor from the [GitHub Releases Page](https://github.com/PrathxmOp/BlockGuard/releases):
- Modern/Premium routers (ARM-based) → `blockguard-VERSION-router-arm.tar.gz`
- Budget/Legacy routers (MIPS-based) → `blockguard-VERSION-router-mips.tar.gz`

Extract the archive locally to get the `blockguard` executable.

---

## Step 2: Upload BlockGuard to the Router

Use SCP (Secure Copy) from your terminal to transfer the binary to the router's `/usr/bin/` folder:

```bash
# Transfer the binary
scp blockguard root@192.168.1.1:/usr/bin/blockguard

# SSH into the router
ssh root@192.168.1.1

# Make the binary executable
chmod +x /usr/bin/blockguard
```
*(Replace `192.168.1.1` with your router's gateway IP address).*

---

## Step 3: Run BlockGuard on a Custom Port

By default, routers run their own DNS resolver (e.g. `dnsmasq` or `unbound`) on port `53`. BlockGuard cannot bind to port 53 directly.

Instead, we configure BlockGuard to run on **port 5353** listening on the local loopback interface:

```bash
# Set configuration options on the router
blockguard config set dns.listen_address 127.0.0.1
blockguard config set dns.listen_port 5353

# Start the BlockGuard daemon
blockguard start
```

---

## Step 4: Configure DNS Forwarding (OpenWrt)

We now configure the router's main DNS resolver to forward all external lookup queries to BlockGuard running on port 5353.

### Method A: Via Web GUI (LuCI)
1. Open the OpenWrt Web Interface, and go to **Network** → **DHCP and DNS**.
2. Locate the **DNS Forwardings** text box.
3. Add the address pointing to BlockGuard:
   ```text
   127.0.0.1#5353
   ```
   *(Note: OpenWrt uses `#` instead of `:` to specify port numbers in DNS configurations).*
4. Click **Save & Apply**.

### Method B: Via CLI Config
Open `/etc/config/dhcp` on the router:
```bash
vi /etc/config/dhcp
```
Find the `config dnsmasq` block and add the server option:
```text
list server '127.0.0.1#5353'
```
Save and exit (`:wq`), then restart the `dnsmasq` service:
```bash
/etc/init.d/dnsmasq restart
```

---

## 🎉 Verification

Connect a device to your Wi-Fi, open any webpage, and then run the status command on the router terminal:

```bash
blockguard status
```

You should see queries counting up and ad/tracker domains being successfully intercepted. Your whole home network is now protected!
