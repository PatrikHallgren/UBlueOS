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

# --- Brave Origin (from official RPM repo) ---
dnf5 config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf5 -y install brave-origin

# --- pCloud CLI — REMOVED from CI build ---
# pCloud's download URLs are unreliable from CI runners.
# Install post-rebase: sudo /usr/share/ublue-os/install-pcloud.sh

# --- LibreWolf (privacy browser) ---
curl -fsSL https://repo.librewolf.net/librewolf.repo \
  -o /etc/yum.repos.d/librewolf.repo
dnf5 -y install librewolf
