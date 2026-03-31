#!/usr/bin/env bash
#
# powermenu.sh — Rofi power menu for Hyprland
# Icons require a Nerd Font to be set in powermenu.rasi
#

THEME="$HOME/.config/rofi/powermenu.rasi"

# Choices: icon + label (Nerd Font icons)
# shutdown="󰐥  Shutdown"
# reboot="󰑓  Reboot"
# suspend="󰒲  Suspend"
# lock="󰌾  Lock"
# logout="󰍃  Logout"

shutdown="Shutdown"
reboot="Reboot"
suspend="Suspend"
logout="Logout"

# Configure the Icon here
entry_shutdown="$shutdown\0icon\x1fsystem-shutdown"
entry_reboot="$reboot\0icon\x1fsystem-reboot"
entry_suspend="$suspend\0icon\x1fsystem-hibernate"
entry_logout="$logout\0icon\x1fsystem-log-out"

# Launch rofi dmenu
chosen=$(printf "$entry_shutdown\n$entry_reboot\n$entry_suspend\n$entry_logout" |
  rofi -dmenu \
    -p "  Power" \
    -theme "$THEME" \
    -no-custom)

# Confirmation prompt for destructive actions

entry_yes="Yes\0icon\x1fdialog-apply"
entry_no="No\0icon\x1fdialog-cancel"

confirm() {
  printf "$entry_yes\n$entry_no" | rofi -dmenu -theme "$THEME" -no-custom -theme-str "listview {columns: 2;}" -icon-theme "Papirus-Dark"
}

case "$chosen" in
"$shutdown")
  [[ $(confirm "Shutdown") == "Yes" ]] && systemctl poweroff
  ;;
"$reboot")
  [[ $(confirm "Reboot") == "Yes" ]] && systemctl reboot
  ;;
"$suspend")
  systemctl suspend
  ;;
"$logout")
  [[ $(confirm "Logout") == "Yes" ]] && hyprctl dispatch exit
  ;;
esac
