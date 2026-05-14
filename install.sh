#!/usr/bin/env bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.i3-dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

step() { echo -e "\n${BOLD}${CYAN}==> $*${RESET}"; }
ok()   { echo -e "  ${GREEN}✓${RESET}  $*"; }
warn() { echo -e "  ${YELLOW}!${RESET}  $*"; }
die()  { echo -e "  ${RED}✗  $*${RESET}"; exit 1; }

[[ $EUID -ne 0 ]] || die "Do not run as root — sudo will be used where needed"

# ── Detect distro ──────────────────────────────────────────────────────────────
step "Detecting OS"
if [[ -f /etc/arch-release ]]; then
    DISTRO="arch"
else
    warn "Non-Arch distro detected — package install skipped, symlinks only"
    DISTRO="other"
fi
ok "Detected: $DISTRO"

# ── Install packages (Arch only) ───────────────────────────────────────────────
if [[ "$DISTRO" == "arch" ]]; then
    step "Installing packages"
    sudo pacman -S --needed --noconfirm \
        i3-wm i3status i3lock \
        polybar picom \
        rofi dunst \
        alacritty \
        hsetroot xsettingsd \
        xfce-polkit xfce4-power-manager \
        mpd mpc playerctl \
        brightnessctl \
        flameshot thunar \
        firefox \
        network-manager-applet \
        ttf-font-awesome noto-fonts noto-fonts-emoji \
        ttf-jetbrains-mono ttf-meslo-nerd
    ok "Core packages installed"

    # AUR helper
    AUR_CMD=""
    if command -v paru &>/dev/null; then
        AUR_CMD="paru"
    elif command -v yay &>/dev/null; then
        AUR_CMD="yay"
    else
        warn "No AUR helper found — installing paru"
        sudo pacman -S --needed --noconfirm git base-devel
        tmpdir=$(mktemp -d)
        git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
        (cd "$tmpdir/paru" && makepkg -si --noconfirm)
        rm -rf "$tmpdir"
        AUR_CMD="paru"
    fi

    step "Installing AUR packages"
    $AUR_CMD -S --needed --noconfirm ksuperkey obsidian \
        || warn "AUR packages failed — install ksuperkey and obsidian manually"
    ok "AUR packages done"
fi

# ── Symlink helper ─────────────────────────────────────────────────────────────
link() {
    local src="$1" dst="$2"
    if [[ -e "$dst" && ! -L "$dst" ]]; then
        mkdir -p "$(dirname "$BACKUP/$dst")"
        cp -r "$dst" "$BACKUP/$dst" 2>/dev/null || true
        warn "Backed up $(basename "$dst") → $BACKUP"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "Linked $dst"
}

# ── Symlink configs ────────────────────────────────────────────────────────────
step "Linking configs"
link "$DOTFILES/config/i3"               "$HOME/.config/i3"
link "$DOTFILES/config/alacritty"        "$HOME/.config/alacritty"
link "$DOTFILES/config/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
link "$DOTFILES/config/dunst/dunstrc"    "$HOME/.config/dunst/dunstrc"

chmod +x "$HOME/.config/i3/scripts/"*
ok "All configs linked"

# ── Done ───────────────────────────────────────────────────────────────────────
echo -e "\n${BOLD}${GREEN}══════════════════════════════════════════${RESET}"
echo -e "${BOLD}${GREEN}  i3 dotfiles installed!${RESET}"
echo -e "${BOLD}${GREEN}══════════════════════════════════════════${RESET}"
echo ""
echo -e "  ${CYAN}Manual steps:${RESET}"
echo -e "  1. Wallpaper:      ${YELLOW}ln -s /path/to/image.png ~/.config/i3/theme/wallpaper${RESET}"
echo -e "  2. Burp Suite Pro: ${YELLOW}download from portswigger.net → install to ~/BurpSuitePro${RESET}"
echo -e "  3. Log out and select i3 from your display manager"
echo ""
