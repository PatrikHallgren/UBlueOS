#!/usr/bin/env bash
set -euxo pipefail

# -------------------------------------------------------
# 10-apps.sh — Applications: browser, cloud storage, terminal
# -------------------------------------------------------

# --- Ghostty terminal ---
dnf5 -y --enable-repo=terra install ghostty

# --- ProtonPass (Flatpak) ---
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub me.proton.Pass

# --- pCloud Drive ---
# pCloud distributes as a static binary + mount tool
PCLOUD_URL="https://pcloud.com/download-file?platform=linux&arch=x86_64&type=tar.gz"
PCLOUD_TAR="/tmp/pcloud.tar.gz"
PCLOUD_DIR="/opt/pcloud"
curl -fL "$PCLOUD_URL" -o "$PCLOUD_TAR"
mkdir -p "$PCLOUD_DIR"
tar xzf "$PCLOUD_TAR" -C "$PCLOUD_DIR" --strip-components=1
rm -f "$PCLOUD_TAR"
chmod +x "$PCLOUD_DIR/pcloud" "$PCLOUD_DIR/pcloudcc" 2>/dev/null || true
ln -sf "$PCLOUD_DIR/pcloudcc" /usr/local/bin/pcloudcc

# --- LibreWolf (privacy browser) ---
curl -fsSL https://repo.librewolf.net/librewolf.repo \
  -o /etc/yum.repos.d/librewolf.repo
dnf5 -y install librewolf
