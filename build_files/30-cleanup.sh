#!/usr/bin/env bash
set -euxo pipefail

# -------------------------------------------------------
# 30-cleanup.sh — Remove cruft, disable conflicts, finalise
# -------------------------------------------------------

# --- xwaylandvideobridge is deprecated and opens blank windows ---
dnf5 -y remove xwaylandvideobridge || true

# --- fw-fanctrl is Framework-specific; remove to avoid noise ---
dnf5 -y remove fw-fanctrl || true

# --- Enable Podman socket for Docker-compatible workflows ---
systemctl enable podman.socket 2>/dev/null || true

# --- Ensure SDDM has a MangoWM session entry ---
# (mangowm package should provide this, but just in case)
if [ ! -f /usr/share/wayland-sessions/mango.desktop ]; then
  mkdir -p /usr/share/wayland-sessions
  cat > /usr/share/wayland-sessions/mango.desktop << 'EOF'
[Desktop Entry]
Name=MangoWM
Comment=Mango Wayland Compositor
Exec=mango
Type=Application
EOF
fi

# --- Enable user services for PipeWire (just ensure they're linked) ---
systemctl --global enable pipewire wireplumber 2>/dev/null || true

# --- Clean package cache ---
dnf5 clean all
