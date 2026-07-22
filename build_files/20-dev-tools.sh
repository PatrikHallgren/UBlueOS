#!/usr/bin/env bash
set -euxo pipefail

# -------------------------------------------------------
# 20-dev-tools.sh — Developer tooling
# -------------------------------------------------------

# --- Bash: starship prompt ---
dnf5 -y copr enable atim/starship
dnf5 -y install starship
dnf5 -y copr disable atim/starship

# --- Zsh as alternative shell (default can stay bash) ---
dnf5 -y install zsh zoxide

# --- Git tooling ---
dnf5 -y copr enable dejan/lazygit
dnf5 -y install lazygit
dnf5 -y copr disable dejan/lazygit
dnf5 -y install git-delta

# --- Neovim ---
dnf5 -y install neovim
# Replace vim with neovim
alternatives --install /usr/bin/vim vim /usr/bin/nvim 100

# --- Dotfile manager + env tools ---
dnf5 -y install chezmoi direnv

# --- CLI utilities ---
dnf5 -y install \
  bat          `# cat with wings` \
  ripgrep      `# grep on steroids` \
  fd-find      `# find replacement` \
  eza          `# ls with icons` \
  btop         `# resource monitor TUI` \
  jq yq        `# JSON + YAML query` \
  tldr         `# simplified man pages` \
  trash-cli    `# safe rm` \
  fastfetch    `# neofetch replacement`

# --- Unlock flathub (if not already) ---
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
