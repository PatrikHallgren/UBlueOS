#!/usr/bin/env bash
set -euxo pipefail

# -------------------------------------------------------
# 00-base.sh — Core system: MangoWM, Noctalia, desktop tools
# -------------------------------------------------------

# --- Install MangoWM (from Terra, already enabled on Bazzite) ---
dnf5 -y --enable-repo=terra install mangowm

# --- Install Noctalia v5 (native C++/OpenGL ES, NOT Quickshell) ---
dnf5 -y --enable-repo=terra install noctalia-shell
dnf5 -y install libwebp

# --- Noctalia needs xdg-desktop-portal-gnome for screen capture ---
dnf5 -y install xdg-desktop-portal-gnome xdg-desktop-portal-gtk

# --- Desktop tooling — fills gaps Noctalia doesn't cover ---
dnf5 -y install \
  fuzzel               `# app launcher (Super+D fallback)` \
  wl-clipboard         `# clipboard CLI (wl-copy / wl-paste)` \
  swayidle swaylock    `# idle daemon + screen locker` \
  pamixer pavucontrol  `# terminal volume + GUI mixer` \
  imv                  `# lightweight Wayland image viewer` \
  wev                  `# input event debugger` \
  wlsunset             `# night light (Noctalia service)` \
  playerctl            `# media key controls`

# --- Qt/GTK theming bridge ---
dnf5 -y install \
  qt6ct kvantum        `# Qt6 theme selector + engine` \
  adw-gtk3-theme       `# libadwaita → GTK3 theme bridge`

# --- Nerd Fonts (Cascadia Code — icons for starship/fuzzel/neovim) ---
dnf5 -y --enable-repo=terra install cascadiacode-nerd-fonts

# --- Set Qt theme via environment ---
mkdir -p /etc/environment.d
cat > /etc/environment.d/qt6ct.conf << 'EOF'
QT_QPA_PLATFORM=wayland
QT_QPA_PLATFORMTHEME=qt6ct
QT_STYLE_OVERRIDE=kvantum
EOF
