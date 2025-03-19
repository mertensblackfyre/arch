#!/bin/bash
sudo pacman -Syu
sudo pacman -S dosfstools mtools os-prober base-devel autoconf git
sudo pacman -S wget pulseaudio unzip resolvconf pavucontrol
sudo pacman -S nautilus gvfs gvfs-afc
sudo pacman -S mtpfs libmtp gvfs-mtp zathura-pdf-mupdf zathura

echo "Installing Dev enviroment" | cowsay 
sudo pacman -S tmux neovim fastfetch ly

git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

echo "Installing libs" | cowsay 
cd
cd Downloads
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
sudo mv yay-git /opt 
cd

echo "Installing programming languages" | cowsay 
sudo pacman -S go gcc cmake make

echo "Installing utils" | cowsay 
sudo pacman -S ncdu nginx-mainline ufw openvpn btop fzf discord
#yay -S  wireguard-arch wireguard-tools
yay -Sy hyprshot tofi
yay -S librewolf-bin

sudo pacman -S ghostty
sudo pacman -S waybar hyprland hyprpaper hyprlock

sudo systemctl enable --now ly
