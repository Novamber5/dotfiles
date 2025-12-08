# My Arch Linux Dotfiles

Dotfiles for Arch Linux with Hyprland window manager.

## Included Configs
- Hyprland (window manager)
- Waybar (status bar)
- Rofi (application launcher)
- Kitty (terminal)
- Mako (notifications)
- Wofi (launcher alternative)
- Bash & Zsh configs

## Quick Install
```bash
curl -sSL https://raw.githubusercontent.com/Novamber5/dotfiles/main/install.sh | bash
```

## Manual Install
```bash
git clone https://github.com/Novamber5/dotfiles.git
cd dotfiles
chmod +x install.sh
./install.sh
```

## Structure
```
.
├── config/          # .config directory contents
├── home/            # Home directory dotfiles
├── scripts/         # Utility scripts
└── install.sh       # Auto-installer
```
