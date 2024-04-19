#!/usr/bin/bash

# Author:  Angel Cruz (angelcruz07)

# Colors
green='\e[0;32m\033[1m'
endColor='\033[0m\e[0m'
red='\e[0;31m\033[1m'
yellow='\e[0;33m\033[1m'


successMessage() {
    echo -e "${green}$1${endColor}"
}

warningMessage() {
    echo -e "${yellow}$1${endColor}"
}

errorMessage() {
    echo -e "${red}$1${endColor}"
    exit 1
}


if [ "$(id -u)" != "0" ]; then
    errorMessage "${red}This script must be run as root${endColor}"
fi



warningMessage "¡Warning!"
read -p "This script will install and configure Arch Linux, do you want to continue? (Y/n): " response
response=${response:-"Y"}

if [ "$response" != "Y" ] && [ "$response" != "y" ]; then
    errorMessage "Installation aborted."
fi



function installSystem(){
  successMessage "Starting installation..."
  pacstrap /mnt base linux linux-firmware
 
  #Configuration 
  successMessage "System configuration completed."
  genfstab -U /mnt >> /mnt/etc/fstab
  successMessage "System configuration completed."
  
  # System configuration
  successMessage "Configuring system..."  
  arch-chroot /mnt
  ln -sf /usr/share/zoneinfo/America/Mexico_City /etc/localtime
  hwclock --systohc

  pacman -S nano
  nano /etc/locale.gen  # Buscar en_US.UTF-8 UTF-8 y es_ES.UTF-8 UTF-8
  locale-gen

  nano /etc/hosts
  127.0.0.1     localhost
  ::1           localhost
  127.0.1.1   	myhostname.localhost	myhostname
  # Conexion a internet
  passwd
  pacman -S networkmanager
  systemctl enable NetworkManager
  pacman -S grub efibootmgr
  grub-install --target=x86_64-efi --efi-directory=/boot
  grub-mkconfig -o /boot/grub/grub.cfg

  useradd -m usuario
  passwd usuario
  usermod -aG wheel,audio,video,storage usuario
  pacman -S sudo
  nano /etc/sudoers # descomentar el  %wheel ALL=(ALL) ALL
  exit
 
  umount -R /mnt
  successMessage "Installation completed successfully. You device shutdown now..."
  shutdown now
}

installSystem