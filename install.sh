#!/bin/bash

# Navigate to the script
dir=$(dirname $0)
echo "Moving the active directory to" $dir
cd "$dir"

ls
# Install Packages
sudo pacman -S - <pkglist.txt
yay -S - <aur-pkglist.txt

# Stow the config files
stow */
