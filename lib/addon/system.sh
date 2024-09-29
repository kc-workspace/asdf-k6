#!/usr/bin/env bash

## Get current OS name
## usage: `kc_asdf_get_os`
## variable:
##   - ASDF_OVERRIDE_OS for override arch
kc_asdf_get_os() {
  local ns="os.addon"
  local os="${ASDF_OVERRIDE_OS:-}"
  if [ -n "$os" ]; then
    kc_asdf_warn "$ns" "user overriding OS to '%s'" "$os"
    printf "%s" "$os"
    return 0
  fi

  os="$(uname | tr '[:upper:]' '[:lower:]')"
  case "$os" in
  darwin)
    os="macos"
    ;;
  linux)
    os="linux"
    ;;
  esac

  if command -v _kc_asdf_custom_os >/dev/null; then
    local tmp="$os"
    os="$(_kc_asdf_custom_os "$tmp")"
    kc_asdf_debug "$ns" "developer has custom OS name from %s to %s" "$tmp" "$os"
  fi

  printf "%s" "$os"
}

## Is current OS is macOS
## usage: `kc_asdf_is_darwin`
kc_asdf_is_darwin() {
  local ns="os.addon"
  local os custom="macos"
  os="$(kc_asdf_get_os)"
  local darwin="${custom:-darwin}"
  kc_asdf_debug "$ns" "checking current os (%s) should be %s" "$os" "$darwin"
  [[ "$os" == "$darwin" ]]
}

## Is current OS is LinuxOS
## usage: `kc_asdf_is_linux`
kc_asdf_is_linux() {
  local ns="os.addon"
  local os custom="linux"
  os="$(kc_asdf_get_os)"
  local linux="${custom:-linux}"
  kc_asdf_debug "$ns" "checking current os (%s) should be %s" "$os" "$linux"
  [[ "$os" == "$linux" ]]
}

## Get current Arch name
## usage: `kc_asdf_get_arch`
## variable:
##   - ASDF_OVERRIDE_ARCH for override arch
kc_asdf_get_arch() {
  local ns="arch.addon"
  local arch="${ASDF_OVERRIDE_ARCH:-}"
  if [ -n "$arch" ]; then
    kc_asdf_warn "$ns" "user overriding arch to '%s'" "$arch"
  else
    arch="$(uname -m)"
  fi
  case "$arch" in
  aarch64*)
    arch="arm64"
    ;;
  armv5*)
    arch="arm64"
    ;;
  armv6*)
    arch="arm64"
    ;;
  armv7*)
    arch="arm64"
    ;;
  i386)
    arch="amd64"
    ;;
  i686)
    arch="amd64"
    ;;
  powerpc64le)
    arch="amd64"
    ;;
  ppc64le)
    arch="amd64"
    ;;
  x86)
    arch="amd64"
    ;;
  x86_64)
    arch="amd64"
    ;;
  esac

  if command -v _kc_asdf_custom_arch >/dev/null; then
    local tmp="$arch"
    arch="$(_kc_asdf_custom_arch "$tmp")"
    kc_asdf_debug "$ns" "developer has custom ARCH name from %s to %s" "$tmp" "$arch"
  fi

  printf "%s" "$arch"
}

kc_asdf_get_ext() {
  local ns="arch.addon"
  local ext="${ASDF_OVERRIDE_EXT:-}"
  if [ -n "$ext" ]; then
    kc_asdf_warn "$ns" "user overriding download extension to '%s'" "$ext"
    printf "%s" "$ext"
    return 0
  fi

  local os arch
  os="$(kc_asdf_get_os)"
  arch="$(kc_asdf_get_arch)"

  local key="$os-$arch"
  ext="tar.gz"
  case "$key" in
  macos-*)
    ext="zip"
    ;;
  esac

  if command -v _kc_asdf_custom_ext >/dev/null; then
    local tmp="$ext"
    ext="$(_kc_asdf_custom_ext "$tmp")"
    kc_asdf_debug "$ns" "developer has custom DOWNLOAD_EXT from %s to %s" "$tmp" "$ext"
  fi

  printf "%s" "$ext"
}

## System information
KC_ASDF_OS="$(kc_asdf_get_os)"
KC_ASDF_ARCH="$(kc_asdf_get_arch)"
export KC_ASDF_OS KC_ASDF_ARCH
KC_ASDF_EXT="$(kc_asdf_get_ext)"
export KC_ASDF_EXT
