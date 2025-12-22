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

# Install nala (prettier apt)
if ! command -v nala &> /dev/null; then
    print_info "Installing nala (better apt frontend)..."
    sudo apt install -y nala
    print_success "nala installed"
fi

# Install flatpak
if ! command -v flatpak &> /dev/null; then
    print_info "Installing flatpak..."
    sudo apt install -y flatpak
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    print_success "flatpak installed"
fi

# Install basic packages
print_info "Installing packages with apt..."
echo ""

sudo nala install -y \
    wget \
    curl \
    git \
    build-essential \
    kitty \
    rofi \
    mako-notifier \
    neovim \
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
    firefox-esr \
    kdeconnect \
    btop \
    cowsay \
    cmatrix \
    fonts-font-awesome \
    fonts-noto-color-emoji

print_success "Basic packages installed"
echo ""

# Install starship
if ! command -v starship &> /dev/null; then
    print_info "Installing starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_success "Starship installed"
fi

# Install yazi
if ! command -v yazi &> /dev/null; then
    print_info "Installing yazi..."
    YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep tag_name | cut -d '"' -f 4)
    wget "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip" -O /tmp/yazi.zip
    unzip /tmp/yazi.zip -d /tmp/
    sudo mv /tmp/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
    rm -rf /tmp/yazi*
    print_success "Yazi installed"
fi

# Install fastfetch
if ! command -v fastfetch &> /dev/null; then
    print_info "Installing fastfetch..."
    FASTFETCH_VERSION=$(curl -s https://api.github.com/repos/fastfetch-cli/fastfetch/releases/latest | grep tag_name | cut -d '"' -f 4)
    wget "https://github.com/fastfetch-cli/fastfetch/releases/download/${FASTFETCH_VERSION}/fastfetch-linux-amd64.deb" -O /tmp/fastfetch.deb
    sudo dpkg -i /tmp/fastfetch.deb
    rm /tmp/fastfetch.deb
    print_success "Fastfetch installed"
fi

# Install pipes.sh
if ! command -v pipes.sh &> /dev/null; then
    print_info "Installing pipes.sh..."
    sudo wget -O /usr/local/bin/pipes.sh https://raw.githubusercontent.com/pipeseroni/pipes.sh/master/pipes.sh
    sudo chmod +x /usr/local/bin/pipes.sh
    print_success "Pipes.sh installed"
fi

# Install Zen Browser via flatpak
print_info "Installing Zen Browser via flatpak..."
flatpak install -y flathub io.github.zen_browser.zen

echo ""

# Hyprland installation
print_warning "Hyprland needs to be built from source on Debian"
echo ""
read -p "Do you want to build and install Hyprland? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Installing Hyprland dependencies..."
    sudo nala install -y \
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
    sudo nala install -y \
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

# Install swww
print_info "Installing swww (wallpaper daemon)..."
SWWW_VERSION=$(curl -s https://api.github.com/repos/LGFae/swww/releases/latest | grep tag_name | cut -d '"' -f 4)
wget "https://github.com/LGFae/swww/releases/download/${SWWW_VERSION}/swww-x86_64-unknown-linux-musl" -O /tmp/swww
sudo mv /tmp/swww /usr/local/bin/swww
sudo chmod +x /usr/local/bin/swww
print_success "swww installed"
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
echo "  • Zen Browser  - Privacy-focused browser (run: flatpak run io.github.zen_browser.zen)"
echo "  • Yazi         - Modern file manager (run: yazi)"
echo "  • Btop         - System monitor (run: btop)"
echo "  • Cowsay       - Fun terminal tool (run: cowsay hello)"
echo "  • Cmatrix      - Matrix effect (run: cmatrix)"
echo "  • Pipes.sh     - Animated pipes (run: pipes.sh)"
echo "  • KDE Connect  - Phone integration"
echo ""
