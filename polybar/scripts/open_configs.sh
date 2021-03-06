#!/bin/bash

declare -a options=("alacritty"
"awesome"
"bash"
"broot"
"bspwm"
"doom.d/config.el"
"doom.d/init.el"
"dunst"
"dwm"
"emacs.d/init.el"
"herbstluftwm"
"i3"
"neovim"
"picom"
"polybar"
"qtile"
"quickmarks"
"qutebrowser"
"spectrwm"
"st"
"stumpwm"
"surf"
"sxhkd"
"tabbed"
"termite"
"vifm"
"vim"
"vimb"
"xmobar"
"xmonad"
"xresources"
"zsh"
"quit"
)

# The combination of echo and printf is done to add line breaks to the end of each
# item in the array before it is piped into dmenu.  Otherwise, all the items are listed
# as one long line (one item).

choice=$(echo "$(printf '%s\n' "${options[@]}")" | rofi -show 'Edit config file: ')
case "$choice" in
	quit)
		echo "Program terminated." && exit 1
	;;
	alacritty)
		choice="$HOME/.config/alacritty/alacritty.yml"
	;;
	awesome)
		choice="$HOME/.config/awesome/rc.lua"
	;;
	bash)
		choice="$HOME/.bashrc"
	;;
	broot)
		choice="$HOME/.config/broot/conf.toml"
	;;
	bspwm)
		choice="$HOME/.config/bspwm/bspwmrc"
	;;
    doom.d/config.el)
		choice="$HOME/.doom.d/config.el"
	;;
    doom.d/init.el)
		choice="$HOME/.doom.d/init.el"
	;;
	dunst)
		choice="$HOME/.config/dunst/dunstrc"
	;;
	dwm)
		choice="$HOME/dwm-distrotube/config.h"
	;;
	emacs.d/init.el)
		choice="$HOME/.emacs.d/init.el"
	;;
	herbstluftwm)
		choice="$HOME/.config/herbstluftwm/autostart"
	;;
	i3)
		choice="$HOME/.i3/config"
	;;
	neovim)
		choice="$HOME/.config/nvim/init.vim"
	;;
	picom)
		choice="$HOME/.config/picom/picom.conf"
	;;
	polybar)
		choice="$HOME/.config/polybar/config"
	;;
	qtile)
		choice="$HOME/.config/qtile/config.py"
	;;
	quickmarks)
		choice="$HOME/.config/qutebrowser/quickmarks"
	;;
	qutebrowser)
		choice="$HOME/.config/qutebrowser/autoconfig.yml"
	;;
	spectrwm)
		choice="$HOME/.spectrwm.conf"
	;;
	st)
		choice="$HOME/st-distrotube/config.h"
	;;
	stumpwm)
		choice="$HOME/.config/stumpwm/config"
	;;
	surf)
		choice="$HOME/surf-distrotube/config.h"
	;;
	sxhkd)
		choice="$HOME/.config/sxhkd/sxhkdrc"
	;;
	tabbed)
		choice="$HOME/tabbed-distrotube/config.h"
	;;
	termite)
		choice="$HOME/.config/termite/config"
	;;
	vifm)
		choice="$HOME/.config/vifm/vifmrc"
	;;
	vim)
		choice="$HOME/.vimrc"
	;;
	vimb)
		choice="$HOME/.config/vimb/config"
	;;
	xmobar)
		choice="$HOME/.config/xmobar/xmobarrc2"
	;;
	xmonad)
		choice="$HOME/.xmonad/xmonad.hs"
	;;
	xresources)
		choice="$HOME/.Xresources"
	;;
	zsh)
		choice="$HOME/.zshrc"
	;;
	*)
		exit 1
	;;
esac

# Ultimately, what do want to do with our choice?  Open in our editor!
alacritty -e nvim "$choice"
# emacsclient -c -a emacs "$choice"

