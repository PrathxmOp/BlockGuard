#!/bin/sh

# BlockGuard CLI Installation Script
# Fetches the latest precompiled release binary directly from GitHub.

set -e -u

log() {
  if [ "${verbose:-0}" -gt 0 ]; then
    echo "$1" 1>&2
  fi
}

error_exit() {
  echo "Error: $1" 1>&2
  exit 1
}

# 1. Detect OS
set_os() {
  os="$(uname -s)"
  case "$os" in
    'Darwin')
      os='macos'
      ;;
    'Linux')
      os='linux'
      ;;
    *)
      error_exit "Unsupported operating system: '$os'"
      ;;
  esac
  log "Operating system detected: $os"
}

# 2. Detect CPU Architecture
set_cpu() {
  # Universal binary for macOS
  if [ "$os" = 'macos' ]; then
    cpu=''
    return 0
  fi

  cpu="$(uname -m)"
  case "$cpu" in
    'x86_64'|'x86-64'|'x64'|'amd64')
      cpu='x86_64'
      ;;
    'armv7l'|'armv8l'|'armv7')
      cpu='armv7'
      ;;
    'aarch64'|'arm64')
      cpu='aarch64'
      ;;
    'mips'|'mipsel')
      cpu='mipsel'
      ;;
    *)
      error_exit "Unsupported CPU architecture: $cpu"
      ;;
  esac
  log "CPU architecture detected: $cpu"
}

# 3. Setup install directory and package url
configure() {
  set_os
  set_cpu

  # Install path defaults to /opt/blockguard
  output_dir="/opt/blockguard"
  pkg_ext="tar.gz"

  # Match targets from Makefile
  if [ "$os" = 'macos' ]; then
    pkg_name="blockguard-macos.${pkg_ext}"
  elif [ "$cpu" = 'armv7' ]; then
    pkg_name="blockguard-router-arm.${pkg_ext}"
  elif [ "$cpu" = 'mipsel' ]; then
    pkg_name="blockguard-router-mips.${pkg_ext}"
  else
    pkg_name="blockguard-${os}-${cpu}.${pkg_ext}"
  fi

  # Dynamic URL pointing to the latest GitHub release
  url="https://github.com/PrathxmOp/BlockGuard/releases/latest/download/${pkg_name}"
}

# 4. Download latest archive
download() {
  echo "Downloading BlockGuard CLI package: $pkg_name..."
  tmp_dir=$(mktemp -d -t blockguard-install-XXXXXX)
  
  if ! curl -fsSL "$url" -o "${tmp_dir}/${pkg_name}"; then
    rm -rf "$tmp_dir"
    error_exit "Failed to download $pkg_name from $url. Please make sure a release exists."
  fi
}

# 5. Extract and Install
install_binary() {
  echo "Installing BlockGuard CLI to $output_dir..."
  
  # Ensure output directory exists (requires root if /opt)
  if [ ! -d "$output_dir" ]; then
    sudo mkdir -p "$output_dir"
  fi

  # Extract tarball
  sudo tar -C "$output_dir" -xzf "${tmp_dir}/${pkg_name}"
  
  # Clean up temp downloads
  rm -rf "$tmp_dir"

  # Link binary to system path (/usr/local/bin)
  echo "Creating system link in /usr/local/bin/blockguard..."
  sudo ln -sf "${output_dir}/blockguard" /usr/local/bin/blockguard
}

report_success() {
  echo
  echo "BlockGuard CLI has been installed successfully!"
  echo "You can check the version by running:"
  echo "    blockguard --version"
  echo "Get started by running:"
  echo "    blockguard --help"
}

# Execution
verbose=0
configure
download
install_binary
report_success
