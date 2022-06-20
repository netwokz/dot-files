#!/bin/bash

# which packages to install from AUR, in this order!
aurpkgs="yay"

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

#wget -q --tries=10 --timeout=20 --spider http://google.com
#if [[ $? -eq 0 ]]; then
#        echo "Online"
#        sleep 5
#else
#        echo "Offline"
#fi

pacman_packages=("thunar" "micro" "kitty")
aur_packages=("visual-studio-code-bin" "google-chrome")

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
    echo "Insalling packages..."
    for pkg in ${pacman_packages[@]};do
        if [[ $(command -v $pkg) ]]; then
            echo "$pkg is installed"
            #echo "Removing $pkg"
            #pacman -R $pkg --noconfirm

        else
            echo "$pkg is not installed"
            sudo pacman -S $pkg --noconfirm --noprogressbar
        fi
    done
}

function aur_install_pkg(){
    echo "Insalling packages..."
    for pkg in ${aur_packages[@]};do
        if [[ $(command -v $pkg) ]]; then
            echo "$pkg is installed"
            #echo "Removing $pkg"
            #pacman -R $pkg --noconfirm

        else
            echo "$pkg is not installed"
            sudo yay -S $pkg --answerclean None --answerdiff None
        fi
    done
}

#pac_remove_pkg

pac_install_pkg
aur_install_pkg

function make_install(){
    cd /home/netwokz/
    sudo -u netwokz mkdir -p temp_dir
    cd /home/netwokz/temp_dir/
    sudo -u netwokz git clone https://aur.archlinux.org/google-chrome.git
    cd /home/netwokz/temp_dir/google-chrome/
    sudo -u netwokz makepkg -si
    rm -rf /home/netwokz/temp_dir/
}

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
