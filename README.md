# UBlueOS

**Bazzite-DX + MangoWM + Noctalia v5** — a custom Universal Blue image for daily driving.

Built for a laptop with NVIDIA (now) and a Framework laptop with AMD (future), with a matrix build producing both variants from one repo.

## Variants

| Image | Base | Target |
|---|---|---|
| `ghcr.io/patrikhallgren/ublueos:stable` | bazzite-dx | AMD/Intel GPUs |
| `ghcr.io/patrikhallgren/ublueos:stable-nvidia` | bazzite-dx-nvidia | NVIDIA (RTX 2000+) |

## What's Included

### Compositor & Shell
- **MangoWM** — scrollable-tiling Wayland compositor (dwl-based, lightweight)
- **Noctalia v5** — native C++/OpenGL ES shell (bar, notifications, launcher, lock screen)
- **Noctalia IPC keybinds** for volume, brightness, launcher
- Gruvbox default theme

### Desktop Tools
- **Ghostty** terminal emulator (Cascadia Code Nerd Font, Gruvbox)
- **fuzzel** app launcher (Super+D fallback)
- **wl-clipboard**, **swaylock**, **swayidle**
- **LibreWolf** browser
- Qt/GTK theming via qt6ct, kvantum, adw-gtk3

### Apps (baked in)
- **ProtonPass** (Flatpak)
- **pCloud Drive** (CLI mount tool at `/opt/pcloud`, run `pcloudcc` to set up)
- **LibreWolf** browser

### Post-rebase setup (run once on your machine)
```bash
# Private Internet Access VPN
sudo /usr/share/ublue-os/install-pia.sh
```

### Developer Tooling
- Neovim (+ normie-nvim config on first login via git clone)
- lazygit, git-delta
- starship prompt (gruvbox preset)
- chezmoi (dotfiles), direnv, zoxide
- bat, ripgrep, fd-find, eza, btop, jq, yq, tldr, trash-cli
- **Podman, Docker CE, distrobox, QEMU/KVM/libvirt** (from Bazzite-DX base)

## Quick Start — Rebase an Existing Bazzite Install

```bash
# NVIDIA laptop:
sudo bootc switch ghcr.io/patrikhallgren/ublueos:stable-nvidia

# AMD desktop:
sudo bootc switch ghcr.io/patrikhallgren/ublueos:stable

# Reboot to apply
systemctl reboot
```

## Building Yourself

### Prerequisites
- GitHub account
- A machine running a bootc image (Bazzite, Bluefin, etc.)
- [cosign CLI](https://edu.chainguard.dev/open-source/sigstore/cosign/how-to-install-cosign/#installing-cosign-with-the-cosign-binary)

### 1. Generate a signing key
```bash
COSIGN_PASSWORD="" cosign generate-key-pair
```

### 2. Add the secret to GitHub
```bash
gh secret set SIGNING_SECRET < cosign.key
```

### 3. Push the repo
```bash
git remote add origin git@github.com:PatrikHallgren/UBlueOS.git
git push -u origin main
```

GitHub Actions will build both variants and publish them to `ghcr.io/patrikhallgren/ublueos:*`.

### 4. Rebase
```bash
sudo bootc switch ghcr.io/patrikhallgren/ublueos:stable
# or for NVIDIA:
sudo bootc switch ghcr.io/patrikhallgren/ublueos:stable-nvidia
```

## Local Builds

```bash
# AMD variant
sudo just build

# NVIDIA variant
sudo just build-nvidia

# Switch to the locally built image
sudo bootc switch --transport containers-storage localhost/ublueos:latest
```

## First Login

On first login, a systemd user service runs automatically to:
- Copy MangoWM defaults from `/usr/share/mango/` to `~/.config/mango/`
- Copy Noctalia defaults to `~/.config/noctalia/`
- Clone [normie-nvim](https://gitlab.com/theblackdon/normie-nvim) for a ready-to-go Neovim setup
- Set up starship with Gruvbox preset

The service runs only once — it creates `~/.config/.ublueos-first-login` as a marker.

## Default Keybinds

| Key | Action |
|---|---|
| `Super+Return` | Terminal (Ghostty) |
| `Super+Space` | App launcher (fuzzel) |
| `Super+Q` | Kill window |
| `Super+W` | Toggle floating |
| `Super+←/→/↑/↓` | Focus direction |
| `Super+Shift+←/→/↑/↓` | Move window |
| `Super+1-9` | Switch tag |
| `Super+Shift+1-9` | Move window to tag |
| `Alt+F` | Fullscreen |
| `Ctrl+Space` | Cycle layouts |
| `Super+Shift+S` | Screenshot (area) |
| `Ctrl+Alt+L` | Noctalia launcher |

Full bindings at `~/.config/mango/bind.conf`.

## Updates

- **OS + baked packages**: rebuilt daily by GitHub Actions at 10:05 UTC. Your machines auto-pull via `uupd` daemon and apply on reboot.
- **Flatpak**: automatic daily.
- **Distrobox**: `ujust update` or `distrobox upgrade --all`.
- **Homebrew** (if installed): `brew update && brew upgrade` (not included by default).

## License

Apache-2.0 (matching Universal Blue convention).
