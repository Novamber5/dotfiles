#!/bin/bash

# Dotfiles Installation Script for Arch Linux
# https://github.com/Novamber5/dotfiles

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

clear
echo "========================================"
echo "  Arch Linux Dotfiles Installer"
echo "========================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root"
    exit 1
fi

# Check if on Arch
if [ ! -f /etc/arch-release ] && [ ! -f /etc/manjaro-release ]; then
    print_error "This script is for Arch Linux only"
    print_info "Use install-debian.sh for Debian-based systems"
    exit 1
fi

# Install yay if not installed
if ! command -v yay &> /dev/null; then
    print_info "Installing yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
    print_success "yay installed"
fi

# Install packages
print_info "Installing packages with pacman..."
echo ""

sudo pacman -Syu --needed --noconfirm \
    hyprland \
    hyprpaper \
    waybar \
    rofi-wayland \
    kitty \
    mako \
    fastfetch \
    neovim \
    starship \
    swww \
    wl-clipboard \
    grim \
    slurp \
    swaylock \
    swayidle \
    networkmanager \
    network-manager-applet \
    pavucontrol \
    blueman \
    bluez \
    bluez-utils \
    brightnessctl \
    polkit-gnome \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    qt5-wayland \
    qt6-wayland \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    thunar \
    firefox \
    kdeconnect \
    btop \
    yazi \
    cowsay \
    cmatrix

print_success "Pacman packages installed"
echo ""

# Install AUR packages
print_info "Installing AUR packages with yay..."
yay -S --needed --noconfirm \
    zen-browser-bin \
    pipes.sh

print_success "AUR packages installed"
echo ""

# Backup existing configs
print_info "Backing up existing configurations..."
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

configs=("hypr" "waybar" "rofi" "kitty" "mako" "fastfetch" "nvim" "gtk-3.0" "gtk-4.0" "fontconfig" "swww")
for config in "${configs[@]}"; do
    if [ -d "$HOME/.config/$config" ] || [ -f "$HOME/.config/$config" ]; then
        cp -r "$HOME/.config/$config" "$BACKUP_DIR/" 2>/dev/null || true
        print_info "Backed up $config"
    fi
done

if [ -f "$HOME/.bashrc" ]; then
    cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc"
    print_info "Backed up .bashrc"
fi

print_success "Backup created at: $BACKUP_DIR"
echo ""

# Install dotfiles
print_info "Installing dotfiles..."

# Create directories
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share"

# Copy .config
if [ -d ".config" ]; then
    cp -r .config/* "$HOME/.config/"
    print_success "Copied .config files"
fi

# Copy .local
if [ -d ".local" ]; then
    cp -r .local/* "$HOME/.local/"
    print_success "Copied .local files"
fi

# Copy .bashrc
if [ -f ".bashrc" ]; then
    cp .bashrc "$HOME/.bashrc"
    print_success "Installed .bashrc"
fi

# Copy wallpapers/images
if [ -d "images" ]; then
    mkdir -p "$HOME/Pictures/wallpapers"
    cp -r images/* "$HOME/Pictures/wallpapers/"
    print_success "Copied wallpapers"
fi

echo ""

# Set permissions
print_info "Setting executable permissions..."
find "$HOME/.config/hypr" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
find "$HOME/.config/waybar" -type f -name "*.sh" -exec chmod +x {} \; 2>/dev/null || true
print_success "Permissions set"
echo ""

# Enable services
print_info "Enabling system services..."
sudo systemctl enable NetworkManager
sudo systemctl enable bluetooth
print_success "Services enabled"
echo ""

# Setup starship
if command -v starship &> /dev/null; then
    if ! grep -q "starship init bash" "$HOME/.bashrc"; then
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
        print_success "Added starship to .bashrc"
    fi
fi

echo "========================================"
print_success "Installation completed!"
echo "========================================"
echo ""
print_info "Next steps:"
echo "  1. Log out and log back in"
echo "  2. Select Hyprland from your login manager"
echo "  3. Run: source ~/.bashrc"
echo ""
print_info "Keybindings:"
print_warning "  Super+Q        - Close window"
print_warning "  Super+Return   - Open terminal"
print_warning "  Super+D        - Open rofi"
echo ""
print_info "Installed apps:"
echo "  • Zen Browser  - Privacy-focused browser"
echo "  • Yazi         - Modern file manager (run: yazi)"
echo "  • Btop         - System monitor (run: btop)"
echo "  • Cowsay       - Fun terminal tool (run: cowsay hello)"
echo "  • Cmatrix      - Matrix effect (run: cmatrix)"
echo "  • Pipes.sh     - Animated pipes (run: pipes.sh)"
echo "  • KDE Connect  - Phone integration"
echo ""
