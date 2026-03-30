#!/bin/bash
killall rofi
sleep 0.5
rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n '{result}' | wl-copy"
