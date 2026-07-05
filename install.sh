#!/bin/sh

# BlockGuard CLI Installation & Management Script
# High-performance, secure DNS AdBlocker & Tracker Protection CLI tool.
# Features: cross-platform detection, custom installation paths, signature verification hints,
# uninstallation, and local archive installation.

set -e -u

# Function log is an echo wrapper that writes to stderr if the caller
# requested verbosity level greater than 0. Otherwise, it does nothing.
log() {
  if [ "${verbose:-0}" -gt '0' ]
  then
    echo "$1" 1>&2
  fi
}

# Function error_exit is an echo wrapper that writes to stderr and stops the
# script execution with code 1.
error_exit() {
  echo "Error: $1" 1>&2
  exit 1
}

# Function usage prints the note about how to use the script.
usage() {
  echo 'Usage: install.sh [-o output_dir] [-v] [-h] [-u] [-V version] [-l]' 1>&2
  echo 'Options:' 1>&2
  echo '  -o <path>    Custom installation directory (default: /opt/blockguard)' 1>&2
  echo '  -v           Enable verbose logging' 1>&2
  echo '  -u           Uninstall BlockGuard CLI' 1>&2
  echo '  -V <version> Specify a version to install (default: latest)' 1>&2
  echo '  -l           Local install (uses a local package archive instead of downloading)' 1>&2
  echo '  -h           Show this help message' 1>&2
  exit 1
}

# Function parse_opts parses the options list and validates its combinations.
parse_opts() {
  while getopts 'vho:uV:l' opt "$@"
  do
    case "$opt"
    in
    'v')
      verbose='1'
      ;;
    'h')
      usage
      ;;
    'o')
      output_dir="$OPTARG"
      ;;
    'u')
      uninstall='1'
      ;;
    'V')
      version="$OPTARG"
      ;;
    'l')
      local_install='1'
      ;;
    *)
      log "Bad option -$opt"
      usage
      ;;
    esac
  done
}

# Function is_little_endian checks if the CPU is little-endian.
is_little_endian() {
  # ASCII character "I" has the octal code of 111. In two-byte octal display mode (-o),
  # hexdump prints it either as "000111" (little-endian) or "111000" (big-endian).
  is_little_endian_result="$(
    printf 'I' \
      | hexdump -o \
      | awk '{ print substr($2, 6, 1); exit; }'
  )"
  readonly is_little_endian_result

  [ "$is_little_endian_result" -eq '1' ]
}

# Function set_os sets the os if needed and validates the value.
set_os() {
  if [ "$os" = '' ]
  then
    os="$(uname -s)"
    case "$os"
    in
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
  fi

  case "$os"
  in
  'macos'|'linux')
    # Valid OS
    ;;
  *)
    error_exit "Unsupported operating system: '$os'"
    ;;
  esac

  log "Operating system: $os"
}

# Function set_cpu sets the cpu if needed and validates the value.
set_cpu() {
  # macOS uses a universal binary
  if [ "$os" = 'macos' ]
  then
    return 0
  fi

  if [ "$cpu" = '' ]
  then
    cpu="$(uname -m)"
    case "$cpu"
    in
    'x86_64'|'x86-64'|'x64'|'amd64')
      cpu='x86_64'
      ;;
    'armv7l'|'armv8l'|'armv7')
      cpu='armv7'
      ;;
    'aarch64'|'arm64')
      cpu='aarch64'
      ;;
    'mips')
      if is_little_endian
      then
        cpu="mipsel"
      fi
      ;;
    *)
      error_exit "Unsupported CPU type: $cpu"
      ;;
    esac
  fi

  case "$cpu"
  in
  'x86_64'|'aarch64'|'armv7'|'mipsel')
    # Valid CPU
    ;;
  *)
    error_exit "Unsupported CPU type: $cpu. Supported types: x86_64, aarch64, armv7, mipsel."
    ;;
  esac

  log "CPU type: $cpu"
}

# Function is_dir_owned_by_current_user checks if the output directory is owned by the current user
is_dir_owned_by_current_user() {
  dir="$1"
  current_user="${USER:-$(whoami)}"

  if [ "$os" = "macos" ]; then
    owner_name=$(stat -f '%Su' "$dir")
  elif [ "$os" = "linux" ]; then
    owner_name=$(stat -c '%U' "$dir")
  else
    echo "Unsupported OS: $os"
    return 1
  fi

  if [ "$owner_name" = "$current_user" ]; then
    return 0
  else
    return 1
  fi
}

# Function create_dir creates the output directory if it does not exist.
create_dir() {
  current_user="${USER:-$(whoami)}"
  mkdir -p "$output_dir" 2>/dev/null
  if [ $? -eq 1 ];
  then
    echo "Starting sudo to create directory '$output_dir'"
    if sudo mkdir -p "$output_dir"; then
        sudo chown -R "${SUDO_USER:-$current_user}" "$output_dir"
        log "'$output_dir' has been created and ownership has been set to '${SUDO_USER:-$current_user}'"
    else
        error_exit "Failed to create '$output_dir' with sudo"
    fi
  else
    log "'$output_dir' has been created"
  fi
}

# Check if the directory is owned by the current user and change the ownership if needed
check_owner() {
  current_user="${USER:-$(whoami)}"
  if is_dir_owned_by_current_user "$output_dir";
  then
    log "'$output_dir' exists and is owned by '$current_user'"
  else
    log "'$output_dir' exists but is not owned by '$current_user'"
    printf "Would you like to change the ownership of %s to %s? [y/N] " "$output_dir" "$current_user"
    read -r response < /dev/tty
    case "$response" in
    [yY]|[yY][eE][sS])
      target_user="${SUDO_USER:-$current_user}"
      if sudo chown -R "$target_user" "$output_dir"; then
        log "Ownership of $output_dir has been changed to '${target_user}'"
      else
        error_exit "Failed to change ownership of '$output_dir'"
      fi
      ;;
    *)
      error_exit "Installation cannot proceed without changing ownership of '$output_dir'"
      ;;
    esac
  fi
}

# Function check_out_dir requires the output directory to be set and exist.
check_out_dir() {
  if [ "$output_dir" = '' ]
  then
    output_dir='/opt'
  fi

  if [ "$output_dir" = '.' ] || [ "$output_dir" = '/opt' ]
  then
    output_dir="${output_dir}/${exe_name}"
  fi

  if [ "$uninstall" -eq '1' ]
  then
    echo "BlockGuard CLI will be uninstalled from '$output_dir'"
    return 0
  else
    echo "BlockGuard CLI will be installed to '$output_dir'"
  fi

  set +e
  if [ ! -d "$output_dir" ];
  then
    log "'$output_dir' directory does not exist, attempting to create it..."
    create_dir
  else
    log "'$output_dir' directory exists"
    check_owner
  fi
  set -e
}

# Function verify_hint prints a hint about how to verify the installation.
verify_hint() {
  if [ -f "${output_dir}/${exe_name}.sig" ]
  then
    echo
    echo "To verify the installation, run the following command to check the OpenSSL signature:"
    echo "    curl -fsSL https://raw.githubusercontent.com/PrathxmOp/BlockGuard/master/blockguard_ed25519_pubkey.pem -o blockguard_ed25519_pubkey.pem"
    echo "    openssl pkeyutl -verify -inkey blockguard_ed25519_pubkey.pem -pubin -sigfile ${output_dir}/${exe_name}.sig -in ${output_dir}/${exe_name} -rawin"
  fi
}

# Function unpack unpacks the passed archive.
unpack() {
  log "Unpacking package from '$pkg_name' into '$output_dir'"
  if ! mkdir -p "$output_dir"
  then
    error_exit "Cannot create directory '$output_dir'"
  fi

  if ! tar -C "$output_dir" -f "$pkg_name" -x -z
  then
    $remove_command "$pkg_name"
    error_exit "Cannot unpack '$pkg_name'"
  fi

  # Move files out of inner directory if one was created
  dir_name=$(echo "${pkg_name}" | sed -E -e 's/(.*)(\.tar\.gz|\.zip)/\\1/' | sed -E -e 's/-[0-9]+\.[0-9]+\.[0-9]+//')
  if [ -d "${output_dir}/${dir_name}/" ]; then
    mv -f "${output_dir}/${dir_name}/"* "${output_dir}"
    rmdir "${output_dir}/${dir_name}"
  fi

  if [ "$local_install" -ne '1' ]; then
    $remove_command "$pkg_name"
  fi

  log "Package has been unpacked successfully"

  if [ -L "/usr/local/bin/${exe_name}" ] && \
      [ "$(readlink -f "/usr/local/bin/${exe_name}")" = "$(readlink -f "${output_dir}/${exe_name}")" ]; then
    symlink_exists='1'
  fi

  if [ "${symlink_exists}" -eq 1 ]; then
    log "A symlink exists. No further action taken."
  elif [ -f "${output_dir}/.nosymlink" ]; then
    log "'.nosymlink' file exists in the installation directory. No further action taken."
  else
    printf "Would you like to link the binary to /usr/local/bin? [y/N] "
    read -r response < /dev/tty
    case "$response" in
    [yY]|[yY][eE][sS])
      absolute_path=$(readlink -f "${output_dir}/${exe_name}")
      if ln -sf "${absolute_path}" /usr/local/bin/ 2> /dev/null || sudo ln -sf "${absolute_path}" /usr/local/bin/; then
        symlink_exists='1'
        log "Binary has been linked to '/usr/local/bin'"
      else
        log "Failed to link the binary to '/usr/local/bin'"
      fi
      ;;
    [Nn][Oo]|[Nn])
      touch "${output_dir}/.nosymlink"
      log "'.nosymlink' file has been created in the installation directory"
      ;;
    *)
      log "Invalid response. No further action taken."
      ;;
    esac
  fi
}

# Function check_package checks the downloaded package.
check_package() {
  if [ "$uninstall" -eq '1' ]; then
    return 0
  fi

  log "Checking downloaded package '$pkg_name'"
  case "$pkg_ext"
  in
  'zip')
    if ! unzip "$pkg_name" -t -q
    then
      $remove_command "$pkg_name"
      error_exit "Error checking $pkg_name"
    fi
    ;;
  'tar.gz')
    if ! tar -f "$pkg_name" -z -t > /dev/null
    then
      $remove_command "$pkg_name"
      error_exit "Error checking '$pkg_name'"
    fi
    ;;
  *)
    error_exit "Unexpected package extension: '$pkg_ext'"
    ;;
  esac
}

configure() {
  if [ "$uninstall" -eq '1' ]
  then
    echo 'Uninstalling BlockGuard CLI...'
  else
    echo 'Installing BlockGuard CLI...'
    log "Update channel: $channel"
  fi

  set_os
  set_cpu
  check_out_dir

  pkg_ext='tar.gz'
  if [ "$os" = 'macos' ]
  then
    pkg_name="${exe_name}-macos.${pkg_ext}"
  elif [ "$cpu" = 'armv7' ]
  then
    pkg_name="${exe_name}-router-arm.${pkg_ext}"
  elif [ "$cpu" = 'mipsel' ]
  then
    pkg_name="${exe_name}-router-mips.${pkg_ext}"
  else
    pkg_name="${exe_name}-${os}-${cpu}.${pkg_ext}"
  fi

  # Generate proper URL based on specific or latest version requested
  if [ "$version" = 'latest' ]
  then
    url="https://github.com/PrathxmOp/BlockGuard/releases/latest/download/${pkg_name}"
  else
    # Ensure version starts with 'v'
    case "$version" in
      v*) ;;
      *) version="v${version}" ;;
    esac
    url="https://github.com/PrathxmOp/BlockGuard/releases/download/${version}/${pkg_name}"
  fi

  readonly output_dir url pkg_name

  if [ "$uninstall" -eq '0' ]
  then
    log "Package name: '$pkg_name'"
    log "Download URL: '$url'"
    log "BlockGuard CLI will be installed to '$output_dir'"
  fi
}

# Function handle_uninstall removes the existing package from the output directory.
handle_uninstall() {
  if [ ! -f "${output_dir}/${exe_name}" ]
  then
    error_exit "BlockGuard CLI is not installed in '${output_dir}'. Please specify the correct installation directory."
  fi

  if pgrep -x "${exe_name}" > /dev/null
  then
    log 'BlockGuard CLI is running. Stopping it...'
    # Try to stop via binary
    "${output_dir}/${exe_name}" stop || true
  fi

  remove_existing
  remove_existing_uninstall

  if [ -z "$(ls -A "${output_dir}")" ]
  then
    set +e
    log "Remove empty directory: '${output_dir}'"
    rmdir "${output_dir}" 2>/dev/null
    if [ $? -eq 1 ];
    then
      echo "Starting sudo to remove '${output_dir}'"
      if sudo rmdir "${output_dir}"; then
        log "Empty directory '${output_dir}' has been removed"
      else
        error_exit "Failed to remove empty directory '${output_dir}' with sudo"
      fi
    else
      log "Empty directory '${output_dir}' has been removed"
    fi
    set -e
  fi

  if [ -L "/usr/local/bin/${exe_name}" ]
  then
    set +e
    log "Remove symlink from '/usr/local/bin'"
    rm -f "/usr/local/bin/${exe_name}" 2> /dev/null
    if [ $? -eq 1 ];
    then
      echo "Starting sudo to remove '/usr/local/bin/${exe_name}'"
      if sudo rm -f "/usr/local/bin/${exe_name}"; then
        log "Symlink has been removed from '/usr/local/bin'"
      else
        log "Failed to remove symlink from '/usr/local/bin' with sudo"
      fi
    else
      log "Symlink has been removed from '/usr/local/bin'"
    fi
    set -e
  fi

  echo 'BlockGuard CLI has been uninstalled successfully.'
}

# Function remove_existing removes files before installing a new version.
remove_existing() {
  log 'Removing existing package...'
  rm -f "${output_dir}/${exe_name}"
  log "'${exe_name}' has been removed from '${output_dir}'"
  rm -f "${output_dir}/${exe_name}.sig"
  log "'${exe_name}.sig' has been removed from '${output_dir}'"
}

remove_existing_uninstall() {
  rm -f "${output_dir}/.nosymlink"
  log "'.nosymlink' has been removed from '${output_dir}'"
}

# Function checks if the package is already present.
handle_existing() {
  if [ "$uninstall" -eq '1' ]
  then
    handle_uninstall
    exit 0
  fi

  if [ ! -f "${output_dir}/${exe_name}" ]
  then
    return
  fi

  log "Package ${exe_name} is already present in '${output_dir}'"
  remove_existing
}

# Function download downloads the package.
download() {
  if [ "$uninstall" -eq '1' ]; then
    return 0
  fi

  log "Downloading BlockGuard CLI package from: $url"

  tmp_file="tmp_file_check_$$"

  if ! touch "$tmp_file" > /dev/null 2>&1; then
    printf "Cannot create file in the current directory. Try downloading as root? [y/N] "
    read -r response < /dev/tty
    case "$response" in
    [yY]|[yY][eE][sS])
      remove_command="sudo rm -f"
      if ! sudo curl -fsSL "$url" -o "$pkg_name"; then
        error_exit "Failed to download $pkg_name: $?"
      fi
      ;;
    *)
      error_exit "Cannot proceed without file creation rights."
      ;;
    esac
  else
    rm "$tmp_file"
    if ! curl -fsSL "$url" -o "$pkg_name"; then
      error_exit "Failed to download $pkg_name: $?"
    fi
  fi

  log "BlockGuard CLI package has been downloaded successfully"
}

report_success() {
  echo
  echo "BlockGuard CLI has been installed successfully!"
  echo "You can use it by running command:"
  if [ "$symlink_exists" -eq '1' ]
  then
    echo "    ${exe_name} --help"
  else
    echo "    ${output_dir}/${exe_name} --help"
  fi
}

# Entrypoint
exe_name='blockguard'
output_dir=''
url=''
channel='release'
verbose='0'
cpu=''
os=''
version='latest'
uninstall='0'
remove_command="rm -f"
symlink_exists='0'
local_install='0'

parse_opts "$@"

configure

if [ "$local_install" -eq '0' ]; then
  download
fi

check_package
handle_existing
unpack
verify_hint
report_success
