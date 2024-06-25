#!/usr/bin/env bash

n_screens=$(xrandr | grep '*' | wc -l)
connected_monitor=$(xrandr | grep ' connected' | grep -v 'eDP\|LVDS' | awk '{ print $1 }')

# if [ $connected_monitor ]; then
# 	xrandr --output $connected_monitor --auto --above eDP-1
# 	xrandr --output $connected_monitor --primary
# 	dunstify "Extended to Secondary Monitor"
# else
# 	xrandr --output $connected_monitor --off
# 	xrandr --output eDP-1 --primary
# 	dunstify "Secondary Monitor: Off"
# fi

xrandr --output eDP-1 --primary
xrandr --output $connected_monitor --auto --right-of eDP-1
dunstify "Secondary Monitor on Right"
