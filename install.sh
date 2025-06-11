#!/usr/bin/env bash

# This script installs kluctl on MacOS or Linux, for both bash and zsh shells.

set -e

# Determine OS
OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

# Map architecture names
if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
elif [[ "$ARCH" == "arm64" || "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
fi

# Set version (latest release)
KLUCTL_VERSION=$(curl -s https://api.github.com/repos/kluctl/kluctl/releases/latest | grep tag_name | cut -d '"' -f 4)

if [[ -z "$KLUCTL_VERSION" ]]; then
    echo "Could not determine kluctl version. Exiting."
    exit 1
fi

# Download URL
KLUCTL_URL="https://github.com/kluctl/kluctl/releases/download/${KLUCTL_VERSION}/kluctl_${KLUCTL_VERSION#v}_${OS}_${ARCH}.tar.gz"

# Temp dir for extraction
TMP_DIR="$(mktemp -d)"
cleanup() { rm -rf "$TMP_DIR"; }
trap cleanup EXIT

echo "Downloading kluctl from $KLUCTL_URL ..."
curl -L "$KLUCTL_URL" -o "$TMP_DIR/kluctl.tar.gz"

echo "Extracting kluctl..."
tar -xzf "$TMP_DIR/kluctl.tar.gz" -C "$TMP_DIR"

# Find the kluctl binary
KLUCTL_BIN="$(find "$TMP_DIR" -type f -name kluctl | head -n 1)"
if [[ ! -f "$KLUCTL_BIN" ]]; then
    echo "kluctl binary not found in archive."
    exit 1
fi

# Install to /usr/local/bin (may require sudo)
if [[ -w /usr/local/bin ]]; then
    cp "$KLUCTL_BIN" /usr/local/bin/kluctl
else
    echo "Installing kluctl to /usr/local/bin (requires sudo)..."
    sudo cp "$KLUCTL_BIN" /usr/local/bin/kluctl
fi
chmod +x /usr/local/bin/kluctl

echo "kluctl installed successfully!"
echo "Version: $(kluctl version 2>/dev/null || echo 'Installed, but failed to get version')"
