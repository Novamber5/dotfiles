# 🎨 My Hyprland Dotfiles

Personal dotfiles for Hyprland on Arch Linux and Debian-based distributions (Kali, Ubuntu, etc.).

![Screenshot](images/wire.jpg)

> ⚠️ **Note**: These dotfiles were created with significant assistance from AI. While they work for my setup, please review and test carefully before using them on your system. Use at your own risk and always backup your existing configurations first.

## 📦 What's Included

### Window Manager & Desktop
- **Hyprland** - Dynamic tiling Wayland compositor
- **Waybar** - Highly customizable status bar
- **Rofi** - Application launcher
- **Mako** - Notification daemon

### Applications & Tools
- **Kitty** - GPU-accelerated terminal emulator
- **Fastfetch** - Fast system information display
- **Starship** - Cross-shell prompt
- **Thunar** - File manager

### Theming & Appearance
- **GTK 3.0 & 4.0** - GTK theme configurations
- **Fontconfig** - Font rendering settings
- **pywal** - Color scheme generator from wallpapers

### Utilities
- **grim** - Screenshot utility
- **slurp** - Screen area selection
- **wl-clipboard** - Wayland clipboard utilities

## 🚀 Installation

### Arch Linux

```bash
git clone https://github.com/Novamber5/dotfiles.git
cd dotfiles
chmod +x install-arch.sh
./install-arch.sh
```

### Debian/Kali/Ubuntu

```bash
git clone https://github.com/Novamber5/dotfiles.git
cd dotfiles
chmod +x install-debian.sh
./install-debian.sh
```

### Manual Installation

If you prefer to install manually:

```bash
# Clone the repository
git clone https://github.com/Novamber5/dotfiles.git
cd dotfiles

# Backup your existing configs
mkdir -p ~/.config-backup
cp -r ~/.config/hypr ~/.config-backup/ 2>/dev/null || true
cp -r ~/.config/waybar ~/.config-backup/ 2>/dev/null || true
cp -r ~/.config/kitty ~/.config-backup/ 2>/dev/null || true
cp ~/.bashrc ~/.config-backup/ 2>/dev/null || true

# Copy configs
cp -r .config/* ~/.config/
cp -r .local/* ~/.local/ 2>/dev/null || true
cp .bashrc ~/

# Make scripts executable
chmod +x ~/.config/waybar/scripts/*.sh 2>/dev/null || true
chmod +x ~/.config/kitty/startup.sh 2>/dev/null || true

# Setup pywal (optional)
mkdir -p ~/Pictures/Pintrest
cp images/wire.jpg ~/Pictures/Pintrest/
wal -i ~/Pictures/Pintrest/wire.jpg
```

## 📁 Directory Structure

```
dotfiles/
├── .config/
│   ├── hypr/          # Hyprland configuration
│   ├── waybar/        # Status bar config & scripts
│   ├── kitty/         # Terminal emulator config
│   ├── rofi/          # Application launcher
│   ├── mako/          # Notification daemon
│   ├── fastfetch/     # System info display
│   ├── gtk-3.0/       # GTK3 theme settings
│   ├── gtk-4.0/       # GTK4 theme settings
│   ├── fontconfig/    # Font configuration
│   ├── starship.toml  # Shell prompt config
│   ├── mimeapps.list  # Default applications
│   └── user-dirs.dirs # XDG user directories
├── .local/            # Local scripts and data
├── images/            # Wallpapers and screenshots
├── .bashrc            # Bash configuration
├── install-arch.sh    # Arch Linux installer
└── install-debian.sh  # Debian-based installer
```

## ⚙️ Configuration Highlights

### Hyprland Keybindings

Check `.config/hypr/hyprland.conf` for full list. Common ones:

- `Super + Return` - Open terminal (Kitty)
- `Super + D` - Application launcher (Rofi)
- `Super + Q` - Close focused window
- `Super + Shift + E` - Exit Hyprland
- `Super + [1-9]` - Switch workspace
- `Super + Shift + [1-9]` - Move window to workspace

### Waybar

Custom status bar with:
- Workspace indicators
- System tray
- Battery status
- Audio controls
- Network status
- Clock/date

Scripts located in `.config/waybar/scripts/`

### Shell Setup

- **Bash** as default shell (not zsh)
- **Starship** prompt for enhanced terminal experience
- **Pywal** integration for dynamic colors

### Fastfetch

Custom system info display configured to show your wallpaper at `~/Pictures/Pintrest/wire.jpg`

## 🔧 Post-Installation

1. **Logout and select Hyprland** at your login screen
2. **Verify services are running:**
   ```bash
   # Check if waybar is running
   pgrep waybar || waybar &
   
   # Check if mako is running
   pgrep mako || mako &
   ```
3. **Reload Hyprland config:**
   ```bash
   hyprctl reload
   ```
4. **Customize your wallpaper:**
   ```bash
   # Place your wallpaper
   cp /path/to/your/wallpaper.jpg ~/Pictures/Pintrest/wire.jpg
   
   # Generate new color scheme
   wal -i ~/Pictures/Pintrest/wire.jpg
   ```

## 🎨 Customization

### Changing Colors

Edit `.config/hypr/colors.conf` or regenerate with pywal:
```bash
wal -i /path/to/your/wallpaper.jpg
```

### Modifying Keybindings

Edit `.config/hypr/hyprland.conf` and reload:
```bash
hyprctl reload
```

### Waybar Styling

Customize `.config/waybar/style.css` and restart waybar:
```bash
killall waybar
waybar &
```

### GTK Theme

GTK theme settings are in `.config/gtk-3.0/settings.ini` and `.config/gtk-4.0/settings.ini`

### Shell Prompt

Starship prompt can be customized in `.config/starship.toml`

## 🐛 Troubleshooting

### Waybar not showing
```bash
killall waybar
waybar &
```

### Pywal colors not loading
```bash
# Check if colors.sh exists
ls ~/.cache/wal/colors.sh

# Regenerate colors
wal -i ~/Pictures/Pintrest/wire.jpg
source ~/.bashrc
```

### Hyprland won't start
Check logs:
```bash
cat /tmp/hypr/$(ls -t /tmp/hypr/ | head -n 1)/hyprland.log
```

### Missing dependencies
Make sure all required packages are installed. Check the install script for your distribution for the complete list.

## 📝 Notes

- These dotfiles use **bash** as the default shell (not zsh)
- Backups of your existing configs are created automatically during installation
- The installation scripts require sudo privileges for package installation
- Make sure your display manager supports Wayland sessions
- **These configs were heavily AI-assisted** - review before use!

## 🛡️ Disclaimer

These dotfiles are provided as-is. While they work on my setup, they may require adjustments for your system. Always backup your existing configurations before installing. The author is not responsible for any issues that may arise from using these dotfiles.

## 📜 License

Feel free to use and modify these dotfiles as you wish.

## 🙏 Credits

- Hyprland community
- Various dotfile repos for inspiration
- Catppuccin color scheme influence
- AI assistance in configuration and scripting (double-check for mistakes)

---

**Enjoy your Hyprland setup! 🚀**
