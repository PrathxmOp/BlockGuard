# What is BlockGuard?

Every time you open a website, click a link, or use any app that connects to the internet, your device performs a **DNS lookup** — it asks a DNS server to translate a domain name (like `ads.google.com`) into an IP address.

BlockGuard sits between your device and the internet as a **local DNS server**. It intercepts every DNS query and checks it against 312,000+ known ad, tracker, and malware domains:

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

## Key Advantages over Browser Extensions

- **Blocks ads in ALL applications** — Not just browsers, but games, Spotify, Discord, and desktop apps.
- **Blocks tracking & telemetry** — Stops background system analytics from spying on your usage.
- **Saves bandwidth & battery** — Ads are blocked *before* they are downloaded, saving data and reducing page rendering CPU workload.
- **Un-bypassable** — Websites that detect and block traditional browser extensions often cannot detect DNS-level blocking.
- **System-wide coverage** — Protects your entire computer with a single running command.
