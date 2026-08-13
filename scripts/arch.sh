#!/bin/bash

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Error handler
trap 'echo -e "${RED}Error: Script failed at line $LINENO${NC}"; exit 1' ERR


# Helper function for echo + cowsay
print_section() {
    echo "$1" | cowsay
}

# Update system
echo -e "${YELLOW}Updating system...${NC}"
sudo pacman -Syu

# Core utilities 
echo -e "${YELLOW}Installing core utilities...${NC}"
sudo pacman -S --noconfirm \
    dosfstools mtools os-prober base-devel autoconf git \
    wget pulseaudio unzip resolvconf pavucontrol \
    yazi gvfs gvfs-afc \
    mtpfs libmtp gvfs-mtp zathura-pdf-mupdf zathura

# Development environment
print_section "Installing Dev environment"
sudo pacman -S --noconfirm \
    tmux neovim fastfetch ly \
    go gcc cmake make pyright gopls

# Setup Packer for Neovim
echo -e "${YELLOW}Setting up Packer.nvim...${NC}"
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim 2>/dev/null || \
    echo -e "${YELLOW}Packer.nvim already exists${NC}"

print_section "Installing yay (AUR helper)"
if ! command -v yay &> /dev/null; then
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://aur.archlinux.org/yay-git.git
    cd yay-git
    makepkg -si --noconfirm
    sudo mv yay /opt/yay || true
    cd /
    rm -rf "$TEMP_DIR"
else
    echo -e "${YELLOW}yay already installed${NC}"
fi

# Utilities
print_section "Installing utilities"
sudo pacman -S --noconfirm \
    ncdu nginx-mainline ufw openvpn btop fzf \
    discord tree flatpak \
    ghostty brave spotify-launcher syncthing \
    hyprland hyprpaper hyprlock hyprsunset \
    python-pip python-pipx

echo -e "${YELLOW}Installing AUR packages...${NC}"
yay -S --noconfirm wireguard-arch wireguard-tools hyprshot tofi apple-fonts material-symbols-font

echo -e "${YELLOW}Installing Flatpak packages...${NC}"
sudo pacman -S --noconfirm flatpak
flatpak install -y flathub one.ablaze.floorp

echo -e "${YELLOW}Enabling ly display manager...${NC}"
sudo systemctl enable --now ly

echo -e "${GREEN}Installation complete!${NC}"
