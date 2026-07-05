# Configuration Reference

BlockGuard is configured using a `config.yaml` file stored under your user configuration directory (e.g. `~/.blockguard/config.yaml`).

You can inspect and update configurations directly using the CLI commands.

---

## Configuration Commands

```bash
# View all current configurations
sudo blockguard config show

# Update a configuration value
sudo blockguard config set <key> <value>

# Reset all settings to default values
sudo blockguard config reset
```

---

## Configuration Key Reference

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| `dns.listen_address` | string | `127.0.0.1` | The local IP address the DNS server binds to. |
| `dns.listen_port` | int | `53` | The port the DNS server listens on. |
| `dns.upstreams` | string | `1.1.1.1,8.8.8.8` | Upstream resolvers used to resolve clean domains (comma-separated list). |
| `dns.cache.enabled` | bool | `true` | Caches successful lookups locally to reduce latency. |
| `dns.cache.max_size` | int | `10000` | Maximum number of cached query responses. |
| `dns.cache.ttl` | int | `300` | Time-to-Live (TTL) in seconds for cached responses. |
| `blocking.enabled` | bool | `true` | Toggles ad blocking engine on or off. |
| `blocking.response_type` | string | `nxdomain` | Response type returned for blocked queries: `nxdomain`, `zero_ip`, or `custom_ip`. |
| `blocking.custom_ip` | string | `0.0.0.0` | IP address returned when `response_type` is set to `custom_ip`. |
| `hosts.manage` | bool | `false` | Writes blocks directly to the system hosts file on start and cleans them on stop. |
| `api.enabled` | bool | `true` | Enables the local HTTP server for stats tracking. |
| `api.port` | int | `4321` | Port of the local HTTP stats API. |
| `api.address` | string | `127.0.0.1` | Bind address for the local HTTP stats API. |
| `logging.level` | string | `info` | Log level Verbosity: `debug`, `info`, `warn`, `error`. |
