#!/usr/bin/env bash
# install-pia.sh — Download and install Private Internet Access VPN
# Run after rebasing: sudo /usr/share/ublue-os/install-pia.sh
set -euo pipefail

echo "Downloading PIA Linux client..."
PIA_TMP=$(mktemp -d)
cd "$PIA_TMP"

# Download the .run installer
curl -fL "https://installers.privateinternetaccess.com/download/pia-linux-x86_64-latest.run" \
  -o pia-installer.run

echo "Running PIA installer..."
sh pia-installer.run

cd /
rm -rf "$PIA_TMP"

echo "PIA installed. Launch from your app menu or run 'piactl'."
echo "Note: You'll need to sign in with your PIA credentials on first launch."
