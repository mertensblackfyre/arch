
#!/bin/bash

# Update system
sudo dnf upgrade --refresh -y

# Enable RPM Fusion (needed for many desktop & multimedia packages)
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Base system utilities
sudo dnf install -y \
  dosfstools mtools os-prober \
  @development-tools autoconf git

# Networking, audio, utilities
sudo dnf install -y \
  wget pulseaudio-utils unzip resolvconf pavucontrol

# File manager + GVFS
sudo dnf install -y \
  nautilus gvfs gvfs-afc gvfs-mtp libmtp

# PDF viewer
sudo dnf install -y \
  zathura zathura-pdf-mupdf

echo "Installing Dev environment" | cowsay
sudo dnf install -y \
  tmux neovim fastfetch

# Display manager (ly requires COPR)
sudo dnf copr enable -y mkasberg/ly
sudo dnf install -y ly

# Neovim packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
  ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "Installing programming languages" | cowsay
sudo dnf install -y \
  golang gcc gcc-c++ cmake make \
  pyright gopls

echo "Installing utils" | cowsay
sudo dnf install -y \
  ncdu nginx ufw openvpn btop fzf discord

# WireGuard
sudo dnf install -y \
  wireguard-tools

# Screenshot + launcher (Hyprland ecosystem)
sudo dnf copr enable -y solopasha/hyprland
sudo dnf install -y \
  hyprshot tofi

# Flatpak
sudo dnf install -y flatpak

# Wayland terminal (Ghostty – COPR)
sudo dnf copr enable -y pgdev/ghostty
sudo dnf install -y ghostty

# Hyprland stack
sudo dnf install -y \
  waybar hyprland hyprpaper hyprlock

# Enable ly display manager
sudo systemctl enable --now ly

