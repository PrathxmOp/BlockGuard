# Installation Guide

BlockGuard CLI works natively on Linux, macOS, and Windows. Follow the instructions below to install it on your system.

## 🚀 One-Line Installer (Linux & macOS)

The easiest way to install BlockGuard CLI on Linux and macOS is using our automated installation script:

```bash
curl -fsSL https://raw.githubusercontent.com/PrathxmOp/my-apis/main/install.sh | sh
```

This will automatically:
1. Detect your OS and system architecture.
2. Download the latest release binary.
3. Move the executable to `/usr/local/bin/blockguard` so it's globally available.

---

## 🛠️ Manual Installation

If you prefer to install BlockGuard CLI manually, download the latest archives directly from the [GitHub Releases Page](https://github.com/PrathxmOp/BlockGuard/releases).

### 🐧 Linux Setup
1. Download the archive for your architecture:
   - Intel/AMD (x86_64) → `blockguard-linux-x86_64.tar.gz`
   - ARM / Raspberry Pi (aarch64) → `blockguard-linux-aarch64.tar.gz`
2. Extract and install:
   ```bash
   tar -xzf blockguard-linux-*.tar.gz
   chmod +x blockguard
   sudo mv blockguard /usr/local/bin/
   ```

### 🍏 macOS Setup
1. Download `blockguard-macos.tar.gz`.
2. Extract and install:
   ```bash
   tar -xzf blockguard-macos.tar.gz
   chmod +x blockguard
   sudo mv blockguard /usr/local/bin/
   ```

### 🏁 Windows Setup
1. Download `blockguard-windows-x86_64.zip`.
2. Extract the zip file contents.
3. Move `blockguard.exe` to a folder of your choice (e.g. `C:\Program Files\BlockGuard\`).
4. Add that directory path to your system **PATH** environment variable.
5. Open **Command Prompt** or **PowerShell** as **Administrator** to use the CLI.
