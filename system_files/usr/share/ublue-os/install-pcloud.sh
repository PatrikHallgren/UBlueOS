#!/usr/bin/env bash
# install-pcloud.sh — Download and install pCloud CLI
# Run after rebasing: sudo /usr/share/ublue-os/install-pcloud.sh
set -euo pipefail

echo "Downloading pCloud CLI client..."
# Try the direct download URL first, fall back to GitHub releases
PCLOUD_TAR="/tmp/pcloudcc.tar.gz"

if curl -fsL "https://download.pcloud.com/cli/pcloudcc.tar.gz" -o "$PCLOUD_TAR"; then
  echo "Extracting pcloudcc..."
  tar xzf "$PCLOUD_TAR" -C /usr/local/bin/
  chmod +x /usr/local/bin/pcloudcc
  rm -f "$PCLOUD_TAR"
  echo "pCloud CLI installed at /usr/local/bin/pcloudcc"
  echo "Usage: pcloudcc -u your@email.com -p"
else
  echo "Direct download failed. Trying GitHub releases..."
  LATEST=$(curl -sL https://api.github.com/repos/pCloud/console-client/releases/latest | grep tag_name | cut -d'"' -f4)
  if [ -n "$LATEST" ]; then
    echo "Latest release: $LATEST"
    echo "Download from: https://github.com/pCloud/console-client/releases"
  fi
  echo ""
  echo "Visit https://www.pcloud.com/download-free-online-cloud-storage.html"
  echo "or build from source: https://github.com/pCloud/console-client"
  exit 1
fi
