#!/bin/bash

# Dotfiles Installation Script for Debian/Ubuntu
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
echo "  Debian/Ubuntu Dotfiles Installer"
echo "========================================"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root"
    exit 1
fi

# Check if on Debian-based system
if [ ! -f /etc/debian_version ]; then
    print_error "This script is for Debian-based systems only"
    print_info "Use install-arch.sh for Arch Linux"
    exit 1
fi

# Update package list
print_info "Updating package list..."
sudo apt update
echo ""

# Install basic packages
print_info "Installing packages with apt..."
echo ""

sudo apt install -y \
    wget \
    curl \
    git \
    build-essential \
    kitty \
    rofi \
    mako-notifier \
    wl-clipboard \
    grim \
    slurp \
    swaylock \
    swayidle \
    network-manager \
    network-manager-gnome \
    pavucontrol \
    pulseaudio \
    blueman \
    bluez \
    brightnessctl \
    policykit-1-gnome \
    thunar \
    firefox-esr

print_success "Basic packages installed"
echo ""

# Install fastfetch
print_info "Installing fastfetch..."
if ! command -v fastfetch &> /dev/null; then
    FASTFETCH_VERSION=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep tag_name | cut -d '"' -f 4)
    wget "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb" -O /tmp/fastfetch.deb
    sudo dpkg -i /tmp/fastfetch.deb
    rm /tmp/fastfetch.deb
    print_success "Fastfetch installed"
else
    print_info "Fastfetch already installed"
fi
echo ""

# Hyprland installation
print_warning "Hyprland needs to be built from source on Debian"
echo ""
read -p "Do you want to build and install Hyprland? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installing Hyprland dependencies..."
    sudo apt install -y \
        meson \
        cmake \
        ninja-build \
        gettext \
        libpango1.0-dev \
        libcairo2-dev \
        libpixman-1-dev \
        libwayland-dev \
        wayland-protocols \
        libinput-dev \
        libxkbcommon-dev \
        libtomlplusplus-dev \
        libzip-dev \
        librsvg2-dev \
        libdisplay-info-dev \
        libliftoff-dev \
        libgbm-dev \
        libdrm-dev \
        libgl-dev \
        libegl-dev \
        libgles-dev \
        glslang-tools \
        hwdata \
        xwayland \
        libseat-dev
    
    print_info "Cloning Hyprland..."
    cd /tmp
    git clone --recursive https://github.com/hyprwm/Hyprland
    cd Hyprland
    make all
    sudo make install
    cd ~
    print_success "Hyprland installed"
else
    print_warning "Skipping Hyprland installation"
    print_info "You can install it later from: https://hyprland.org"
fi
echo ""

# Waybar installation
print_warning "Waybar needs to be built from source on Debian"
echo ""
read -p "Do you want to build and install Waybar? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installing Waybar dependencies..."
    sudo apt install -y \
        libgtkmm-3.0-dev \
        libsigc++-2.0-dev \
        libjsoncpp-dev \
        libspdlog-dev \
        libfmt-dev \
        libnl-3-dev \
        libnl-genl-3-dev \
        libpulse-dev \
        libupower-glib-dev \
        libmpdclient-dev \
        libsndio-dev \
        libgtk-layer-shell-dev
    
    print_info "Cloning Waybar..."
    cd /tmp
    git clone https://github.com/Alexays/Waybar.git
    cd Waybar
    meson build
    ninja -C build
    sudo ninja -C build install
    cd ~
    print_success "Waybar installed"
else
    print_warning "Skipping Waybar installation"
fi
echo ""

# Backup existing configs
print_info "Backing up existing configurations..."
BACKUP_DIR="$HOME/.config_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

configs=("hypr" "waybar" "rofi" "kitty" "mako" "fastfetch")
for config in "${configs[@]}"; do
    if [ -d "$HOME/.config/$config" ]; then
        cp -r "$HOME/.config/$config" "$BACKUP_DIR/"
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

echo "========================================"
print_success "Installation completed!"
echo "========================================"
echo ""
print_info "Next steps:"
echo "  1. Log out and log back in"
echo "  2. Select Hyprland from your login manager"
echo "  3. Run: source ~/.bashrc"
echo ""
print_warning "Press Super+Q to close windows"
print_warning "Press Super+Return to open terminal"
print_warning "Press Super+D to open rofi"
echo ""
