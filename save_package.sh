#!/bin/bash

# Navigate to the script
dir=$(dirname $0)
echo "Moving the active directory to" $dir
cd "$dir"

pacman -Qqe >./pkglist.txt
pacman -Qqem >./aur-pkglist.txt
