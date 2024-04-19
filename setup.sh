#!/usr/bin/bash

# Author: Angel Cruz (angelcruz07)

# Colors
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

# Banner de Arch Linux
function archBanner(){
    echo -e "${turquoiseColour}"
    echo -e " █████╗ ██╗  ██╗ ██████╗  ██████╗ ██████╗  █████╗ ███╗   ██╗"
    echo -e "██╔══██╗██║  ██║██╔═══██╗██╔════╝ ██╔══██╗██╔══██╗████╗  ██║"
    echo -e "███████║███████║██║   ██║██║  ███╗██████╔╝███████║██╔██╗ ██║"
    echo -e "██╔══██║██╔══██║██║   ██║██║   ██║██╔═══╝ ██╔══██║██║╚██╗██║"
    echo -e "██║  ██║██║  ██║╚██████╔╝╚██████╔╝██║     ██║  ██║██║ ╚████║"
    echo -e "╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝"
    echo -e "${endColour}\n"
}

# Pregunta inicial
function readyQuestion(){
    echo -e "${yellowColour}Are you ready to configure your Arch Linux environment? (Y/n) ${endColour}"
    read -r response
    response=${response:-"Y"}
    if [[ $response =~ ^[Yy]$ ]]; then
        return 0
    else
        echo -e "\n${redColour}Exiting...${endColour}\n"
        exit 1
    fi
}

function updateSystem(){
    echo -e "\n${yellowColour}Updating system...${endColour}\n"
    sudo pacman -Syu --noconfirm
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}System updated successfully!${endColour}\n"
    else
        echo -e "\n${redColour}Error updating system${endColour}\n"
        exit 1
    fi
}

function installBasicPackages(){
    echo -e "\n${yellowColour}Installing Xorg...${endColour}\n"
    sudo pacman -S --noconfirm xorg
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}Xorg installed successfully!${endColour}\n"
    else 
        echo -e "\n${redColour}Error installing Xorg${endColour}\n"
        exit 1
    fi

    echo -e "\n${yellowColour}Installing basic packages...${endColour}\n"
    sudo pacman -S --noconfirm qtile lighdm  rofi pulseaudio pavucontrol feh arandr scrot firefox alacritty neofetch brightnessctl thunar

    if [ $? -eq 0]; then
        echo -e "\n${greenColour}Basic packages installed successfully!${endColour}\n"
    else
        echo -e "\n${redColour}Error installing basic packages${endColour}\n"
        exit 1
    fi
}

function installFonts(){
    echo -e "\n${yellowColour}Installing fonts...${endColour}\n"
    sudo pacman -S --noconfirm ttf-droid ttf-liberation ttf-ubuntu-font-family noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}Fonts installed successfully!${endColour}\n"
    else
        echo -e "\n${redColour}Error installing fonts${endColour}\n"
        exit 1
    fi

}

function downloadConfigurations(){
    local config_dir="$HOME"
    local github_repo="https://github.com/angelcruz07/arch-dotfiles.git"
    
    echo -e "\n${yellowColour}Downloading configurations from GitHub...${endColour}\n"

    if [ -d "$config_dir" ]; then
        echo -e "${purpleColour}Existing configurations directory found. Removing...${endColour}"
        rm -rf "$config_dir"
    fi

    git clone "$github_repo" "$config_dir"
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}Configurations downloaded successfully!${endColour}\n"
    else
        echo -e "\n${redColour}Error downloading configurations.${endColour}\n"
        exit 1
    fi
}

function copyConfigurations(){
    local config_dir="$HOME/.config"
    local dotfiles_dir="$HOME/arch-dotfiles/"

    echo -e "\n${yellowColour}Copying configurations to their respective locations...${endColour}\n"

    if [ ! -d "$config_dir" ]; then
        echo -e "${redColour}Configurations directory not found.${endColour}"
        exit 1
    fi
    
    if [ ! -d "$dotfiles_dir" ]; then
        echo -e "${redColour}Dotfiles directory not found.${endColour}"
        exit 1
    fi

    cp -r "$dotfiles_dir/.config" "$config_dir/"
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}Configurations copied successfully!${endColour}\n"
    else
        echo -e "\n${redColour} Error copying configurations.${endColour}\n"
        exit 1
    fi
    
    echo -e "\n${yellowColour}Setting up wallpaper...${endColour}"

    cp -r "$dotfiles_dir/.wallpapers" "$HOME/.wallpapers"
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour} Wallpaper successfully!${endColour}\n"
    else
        echo -e "\n${redColour} Error in setup wallpaper.${endColour}\n"
    fi


    cp -r "$HOME/arch-dotfiles/.bashrc" "$HOME/.bashrc"
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}.bashrc copied successfully!${endColour}\n"
    else
        echo -e "\n${redColour}Error copying .bashrc${endColour}\n"
        exit 1
    fi
    
    cp -r "$HOME/arch-dotfiles/.xprofile" "$HOME/"
    if [ $? -eq 0 ]; then
        echo -e "\n${greenColour}.xprofile copied successfully!${endColour}\n"
    else
        echo -e "\n${redColour}Error copying .xprofile${endColour}\n"
        exit 1
    fi

}

archBanner
readyQuestion
updateSystem
installBasicPackages
downloadConfigurations
copyConfigurations
