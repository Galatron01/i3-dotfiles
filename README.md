# i3-dotfiles

i3 window manager setup for Arch-based systems (Endeavour OS, Manjaro, CachyOS, etc.).

Includes: i3, polybar, picom, rofi, dunst, alacritty.

**Keybinds of note:**
| Key | Action |
|---|---|
| `Mod+B` | Firefox |
| `Mod+Shift+B` | Burp Suite Pro |
| `Mod+O` | Obsidian |
| `Mod+Scroll` | Switch workspaces |
| `Mod+Return` | Terminal (alacritty) |
| `Mod+D` | App launcher (rofi) |
| `Mod+Q / Mod+C` | Close window |
| `Mod+Shift+R` | Restart i3 |

---

## Install

### 1. Clone

**HTTPS:**
```bash
git clone https://github.com/Galatron01/i3-dotfiles.git ~/i3-dotfiles
cd ~/i3-dotfiles
```

**SSH:**
```bash
git clone git@github.com:Galatron01/i3-dotfiles.git ~/i3-dotfiles
cd ~/i3-dotfiles
```

### 2. Run installer
```bash
chmod +x install.sh
./install.sh
```

On Arch-based systems this installs all packages automatically (including AUR via paru) and symlinks every config into place.

### 3. Manual steps after install

**Wallpaper** — point the symlink at any PNG:
```bash
ln -s /path/to/your/wallpaper.png ~/.config/i3/theme/wallpaper
```

**Burp Suite Pro** — download the installer from [portswigger.net](https://portswigger.net/burp/releases) and install to `~/BurpSuitePro`.

Then log out and select **i3** from your display manager.

---

## What gets symlinked

| Repo path | Symlinked to |
|---|---|
| `config/i3/` | `~/.config/i3/` |
| `config/alacritty/` | `~/.config/alacritty/` |
| `config/rofi/config.rasi` | `~/.config/rofi/config.rasi` |
| `config/dunst/dunstrc` | `~/.config/dunst/dunstrc` |
