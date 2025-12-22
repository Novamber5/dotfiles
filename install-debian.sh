
#!/bin/bash

# Dotfiles installer for Debian-based distros (Kali, Ubuntu, Debian, etc.)

set -e

echo "======================================"
echo "  Dotfiles Installer for Debian/Kali"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running on Debian-based system
if [ ! -f /etc/debian_version ]; then
    echo -e "${RED}Error: This script is for Debian-based distributions only!${NC}"
    echo "Use install-arch.sh for Arch Linux."
    exit 1
fi

echo -e "${YELLOW}Updating package lists...${NC}"
sudo apt update

echo ""
echo -e "${YELLOW}Installing required packages...${NC}"
sudo apt install -y \
    hyprland \
    waybar \
    rofi \
    kitty \
    mako-notifier \
    wofi \
    neofetch \
    stow \
    git \
    curl \
    wget \
    grim \
    slurp \
    wl-clipboard \
    thunar

echo ""
echo -e "${GREEN}Packages installed successfully!${NC}"

echo ""
mkdir -p ~/.cache/wal

if [ ! -d ~/Pictures/Pintrest ]; then
    mkdir -p ~/Pictures/Pintrest
    echo -e "${YELLOW}Note: Place your wallpaper at ~/Pictures/Pintrest/wire.jpg for neofetch${NC}"
fi

# Generate colors from default wallpaper or use a solid color
if [ -f ~/Pictures/Pintrest/wire.jpg ]; then
elif [ -f /usr/share/backgrounds/kali-16x9/default ]; then
else
    # Create a simple fallback color scheme
    echo -e "${YELLOW}No wallpaper found, creating default color scheme...${NC}"
    mkdir -p ~/.cache/wal
    cat > ~/.cache/wal/colors.sh << 'EOF'
# Fallback color scheme
wallpaper='None'
background='#1e1e2e'
foreground='#cdd6f4'
cursor='#f5e0dc'
EOF
fi

echo ""
echo -e "${YELLOW}Backing up existing configs...${NC}"
BACKUP_DIR=~/.config-backup-$(date +%Y%m%d-%H%M%S)
mkdir -p "$BACKUP_DIR"

# Backup existing configs
[ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_DIR/"
[ -d ~/.config/hypr ] && cp -r ~/.config/hypr "$BACKUP_DIR/"
[ -d ~/.config/waybar ] && cp -r ~/.config/waybar "$BACKUP_DIR/"
[ -d ~/.config/kitty ] && cp -r ~/.config/kitty "$BACKUP_DIR/"
[ -d ~/.config/rofi ] && cp -r ~/.config/rofi "$BACKUP_DIR/"
[ -d ~/.config/mako ] && cp -r ~/.config/mako "$BACKUP_DIR/"
[ -d ~/.config/wofi ] && cp -r ~/.config/wofi "$BACKUP_DIR/"

echo -e "${GREEN}Backup created at: $BACKUP_DIR${NC}"

echo ""
echo -e "${YELLOW}Installing dotfiles with stow...${NC}"

# Remove conflicting files
rm -f ~/.bashrc
rm -f ~/.config/hypr/hyprland.conf 2>/dev/null || true

# Stow all configs
stow hypr
stow waybar
stow kitty
stow rofi
stow mako
stow wofi
stow neofetch
stow shell

echo ""
echo -e "${GREEN}======================================"
echo -e "  Installation Complete!"
echo -e "======================================${NC}"
echo ""
echo "Next steps:"
echo "1. Logout and select 'Hyprland' at the login screen"
echo "2. Add your wallpaper to ~/Pictures/Pintrest/wire.jpg (optional)"
echo "3. Reload Hyprland config: Super+Shift+R"
echo ""
echo "Your old configs are backed up in: $BACKUP_DIR"
echo ""
