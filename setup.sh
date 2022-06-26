#!/bin/bash

# save current working directory
workdir=$PWD

# packages to install
pacman_packages=("thunar" "thunar-volman" "micro" "kitty" "xmonad" "xmonad-contrib" "xmobar" "rofi" "nitrogen" "picom" "lsd" "feh" "bottom" "neofetch" "gvfs" "gvfs-smb" "zsh" "starship")

# aur packages to install
aur_packages=("visual-studio-code-bin" "google-chrome" "snapd")

# exit on errors
set -e

info() { echo -e "\e[1m--> $@\e[0m"; }
mkcd() { mkdir -p "$1" && cd "$1"; }

# check if not running as root
test "$UID" -gt 0 || { info "don't run this as root!"; exit; }

# ask for user password once, set timestamp. see sudo(8)
info "setting / verifying sudo timestamp"
sudo -v

# make sure we can even build packages
info "we need packages from 'base-devel'"
sudo pacman -S --noconfirm base-devel

function install_yay(){
    # which packages to install from AUR, in this order!
    aurpkgs="yay"
    
    # make and enter build environment
    buildroot="$(mktemp -d /tmp/install-pacaur-XXXXXX)"
    info "switching to temporary directory '$buildroot'"
    mkcd "$buildroot"

    # set link to plaintext PKGBUILDs
    pkgbuild="https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h"
    info "using '$pkgbuild=<package>' for plaintext PKGBUILDs"

    # loop over required packages
    info "looping over all packages in \$aurpkgs: '$aurpkgs'"
    for pkg in $aurpkgs; do

        info "create subdirectory for $pkg"
        mkcd "$buildroot/$pkg"

        info "fetch PKGBUILD for $pkg"
        curl -o PKGBUILD "$pkgbuild=$pkg"

        info "fetch required pgp keys from PKGBUILD"
        gpg --recv-keys $(sed -n "s:^validpgpkeys=('\([0-9A-Fa-fx]\+\)').*$:\1:p" PKGBUILD)

        info "make and install ..."
        makepkg -si --noconfirm

    done

    info "finished. cleaning up .."
    cd "$buildroot/.."
    rm -rf "$buildroot"
}

function pac_remove_pkg(){
    echo "Removing packages..."
    for pkg in ${pacman_packages[@]};do
        if [[ $(command -v $pkg) ]]; then
            echo "$pkg is installed"
            echo "Removing $pkg"
            pacman -R $pkg --noconfirm --noprogressbar
            sleep 2

        else
            echo "$pkg is not installed"
            #pacman -S $pkg --answerclean None --answerdiff None
        fi
    done    
}

function pac_install_pkg(){
    for pkg in ${pacman_packages[@]};do
        if [[ $(command -v $pkg) ]]; then
            echo "$pkg is already installed"

        else
            echo "Installing $pkg"
            sudo pacman -S $pkg --noconfirm --noprogressbar
        fi
    done
}

function aur_install_pkg(){
    if [[ $(command -v "yay") ]]; then
        echo "Insalling packages..."
        for pkg in ${aur_packages[@]};do
            if [[ $(command -v $pkg) ]]; then
                echo "$pkg is already installed"
            else
                echo "Installing $pkg"
                yay -S $pkg --noconfirm --answerclean None --answerdiff None
            fi            
        done
    else
        echo "yay is not installed!"
        sleep 5
    fi
}

function copy_custom_files(){
    mkdir -p ~/Downloads
    sudo mkdir -p /usr/local/share/fonts/ttf
    sudo cp -a $workdir/JetBrains.ttf /usr/local/share/fonts/ttf/
    cp -a $workdir/xmobar/. ~/.config/xmobar/
    cp -a $workdir/xmonad/. ~/.xmonad/
    cp -a $workdir/rofi/. ~/.config/rofi/
    cp -a $workdir/powermenu/powermenu-theme.rasi ~/.config/rofi/
    sudo cp -a $workdir/powermenu/powermenu /usr/bin/
    cp -a $workdir/system76.png ~/Downloads/
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>r' -s powermenu
    xfconf-query -c xfce4-keyboard-shortcuts -n -t 'string' -p '/commands/custom/<Super>t' -s kitty
    xfconf-query --create --channel xfce4-keyboard-shortcuts --property '/commands/custom/<Super>p' --type string --set  'rofi -show drun'
    #xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorHDMI-0/workspace/last-image -s $workdir/system76.png
    xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual-1/workspace0/last-image -s ~/Downloads/system76.png
    #feh --bg-scale ~/Downloads/system76.png
    sudo systemctl enable --now snapd.socket
    sudo ln -s /var/lib/snapd/snap /snap
}

function setup_shell(){
    touch ~/.histfile
    cp -a $workdir/starship/starship.toml ~/.config/starship.toml
    chsh -s $(which zsh)
    echo "alias ls='lsd -la --group-directories-first'" >> ~/.bashrc
    echo "alias ls='lsd -la --group-directories-first'" >> ~/.zshrc
    echo "eval '$(starship init bash)'" >> ~/.bashrc
    echo "eval '$(starship init zsh)'" >> ~/.zshrc

}

#pac_remove_pkg
install_yay
sudo -v
pac_install_pkg
sudo -v
aur_install_pkg
sudo -v
copy_custom_files
setup_shell

reboot

function make_install(){
    cd /home/netwokz/
    sudo -u netwokz mkdir -p temp_dir
    cd /home/netwokz/temp_dir/
    sudo -u netwokz git clone https://aur.archlinux.org/google-chrome.git
    cd /home/netwokz/temp_dir/google-chrome/
    sudo -u netwokz makepkg -si
    rm -rf /home/netwokz/temp_dir/
}

#wget -q --tries=10 --timeout=20 --spider http://google.com
#if [[ $? -eq 0 ]]; then
#        echo "Online"
#        sleep 5
#else
#        echo "Offline"
#fi

#make_install
#for pkg in ${aur_packages[@]};do
#    if [[ $(command -v $pkg) ]]; then
#        echo "$pkg is installed"
#
#    else
#        echo "$pkg is not installed"
#        yay -S $pkg --answerclean None --answerdiff None
#    fi
#done

#echo "Checking and installing packages..."

#for str in ${packages[@]};do
#    if [[ $(command -v $str) ]]; then
#        echo "$str is installed"
#    else
#        echo "$str is not installed"
#        yay -S $str --answerclean None --answerdiff None
#    fi
#done

#function remove_pkg(){
#        yay -R "$1"
#}

#remove_pkg "visual-studio-code-bin"


#function is_installed() {
#     if [ -n "$(dpkg -l | awk "/^ii  $1/")" ]; then
#        return 1;
#    fi
#    return 0;
#}

#if is_installed "micro"; then
#    echo "micro installed";
#else
#    echo "micro not installed";
#fi

# Check if package is installed
#if [[ $(command -v ${packages[3]}) ]]; then
#    echo "${packages[3]} is installed"
#else
#    echo "${packages[3]} is not installed"
#    echo "Installing ${packages[3]}..."
#    yay -S visual-studio-code-bin --answerclean None --answerdiff None
#fi
