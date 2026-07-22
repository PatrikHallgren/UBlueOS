#!/usr/bin/env bash
# first-login.sh — runs once per user on first login to populate defaults
# Installed as a systemd user service in /usr/lib/systemd/user/

set -e

CONFIG_DIRS=(
  "$HOME/.config/mango"
  "$HOME/.config/noctalia"
  "$HOME/.config/ghostty"
  "$HOME/.config/nvim"
)

SHARE_DIRS=(
  "/usr/share/mango"
  "/usr/share/noctalia"
  "/usr/share/ghostty"
)

# --- Helper: copy a share dir to config if config dir is empty ---
populate_if_empty() {
  local src="$1" dst="$2"
  if [ -d "$src" ] && [ ! -f "$dst/config.conf" ] && [ ! -f "$dst/noctalia.toml" ] && [ ! -f "$dst/config" ]; then
    mkdir -p "$dst"
    cp -rn "$src"/* "$dst"/ 2>/dev/null || true
  fi
}

populate_if_empty "/usr/share/mango" "$HOME/.config/mango"
populate_if_empty "/usr/share/noctalia" "$HOME/.config/noctalia"
populate_if_empty "/usr/share/ghostty" "$HOME/.config/ghostty"

# --- Clone normie-nvim if nvim config is empty ---
if [ ! -f "$HOME/.config/nvim/init.lua" ] && [ ! -f "$HOME/.config/nvim/init.vim" ]; then
  git clone --depth=1 https://gitlab.com/theblackdon/normie-nvim.git "$HOME/.config/nvim" 2>/dev/null || true
fi

# --- Init starship if not present ---
if [ ! -f "$HOME/.config/starship.toml" ]; then
  mkdir -p "$HOME/.config"
  starship preset gruvbox-rainbow -o "$HOME/.config/starship.toml" 2>/dev/null || true
fi

# --- Mark as done ---
touch "$HOME/.config/.ublueos-first-login"
