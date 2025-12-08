#!/bin/bash

# Dotfiles Auto-Installer for Arch Linux with Hyprland
# Usage: curl -sSL https://raw.githubusercontent.com/Novamber5/dotfiles/main/install.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check if running on Arch
if [ ! -f /etc/arch-release ]; then
    print_error "This script is designed for Arch Linux!"
    exit 1
fi

print_info "Starting dotfiles installation..."

# Update system
print_info "Updating system packages..."
sudo pacman -Syu --noconfirm

# Install essential packages
print_info "Installing essential packages..."
PACKAGES=(
    # Window Manager & Wayland
    hyprland
    waybar
    rofi-wayland
    wofi
    mako
    dunst
    
    # Terminal & Shell
    kitty
    zsh
    
    # System utilities
    git
    neofetch
    btop
    
    # File managers
    thunar
    ranger
    
    # Media
    mpv
    
    # Fonts
    ttf-font-awesome
    noto-fonts
    noto-fonts-emoji
    
    # Other essentials
    brightnessctl
    pavucontrol
    networkmanager
    bluez
    bluez-utils
)

for package in "${PACKAGES[@]}"; do
    if ! pacman -Q "$package" &>/dev/null; then
        print_info "Installing $package..."
        sudo pacman -S --noconfirm "$package"
    else
        print_success "$package already installed"
    fi
done

# Install yay (AUR helper) if not present
if ! command -v yay &>/dev/null; then
    print_info "Installing yay AUR helper..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
else
    print_success "yay already installed"
fi

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_info "Backup directory created: $BACKUP_DIR"

# Backup existing configs
backup_config() {
    local source=$1
    if [ -e "$source" ]; then
        print_warning "Backing up existing $source"
        cp -r "$source" "$BACKUP_DIR/"
    fi
}

# Clone dotfiles repo
DOTFILES_REPO="https://github.com/Novamber5/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles-temp"

print_info "Cloning dotfiles repository..."
if [ -d "$DOTFILES_DIR" ]; then
    rm -rf "$DOTFILES_DIR"
fi
git clone "$DOTFILES_REPO" "$DOTFILES_DIR"

# Install configs
print_info "Installing configurations..."

# Backup and install .config folders
CONFIG_DIRS=(hypr kitty rofi waybar mako wofi)
for dir in "${CONFIG_DIRS[@]}"; do
    backup_config "$HOME/.config/$dir"
    if [ -d "$DOTFILES_DIR/config/$dir" ]; then
        print_info "Installing $dir config..."
        mkdir -p "$HOME/.config"
        cp -r "$DOTFILES_DIR/config/$dir" "$HOME/.config/"
        print_success "$dir config installed"
    fi
done

# Backup and install home directory files
HOME_FILES=(.bashrc .zshrc)
for file in "${HOME_FILES[@]}"; do
    backup_config "$HOME/$file"
    if [ -f "$DOTFILES_DIR/home/$file" ]; then
        print_info "Installing $file..."
        cp "$DOTFILES_DIR/home/$file" "$HOME/"
        print_success "$file installed"
    fi
done

# Set zsh as default shell if not already
if [ "$SHELL" != "$(which zsh)" ]; then
    print_info "Setting zsh as default shell..."
    chsh -s $(which zsh)
    print_success "Default shell changed to zsh (logout required)"
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_success "Oh My Zsh already installed"
fi

# Set correct permissions
print_info "Setting correct permissions..."
chmod 644 ~/.bashrc ~/.zshrc 2>/dev/null || true
chmod -R 755 ~/.config/hypr ~/.config/waybar ~/.config/rofi 2>/dev/null || true

# Cleanup
print_info "Cleaning up..."
rm -rf "$DOTFILES_DIR"

# Final message
echo ""
print_success "=========================================="
print_success "  Dotfiles installation completed!"
print_success "=========================================="
echo ""
print_info "Backups are stored in: $BACKUP_DIR"
print_warning "Please logout and login again to apply all changes"
echo ""
print_info "To start Hyprland, run: Hyprland"
echo ""
