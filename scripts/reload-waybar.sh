#!/bin/bash
killall -9 waybar
sleep 0.5
hyprctl dispatch exec waybar
