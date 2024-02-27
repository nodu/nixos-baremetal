#!/usr/bin/env bash

n_screens=$(xrandr | grep '*' | wc -l)
connected_monitor=$(xrandr | grep ' connected' | grep -v 'eDP\|LVDS' | awk '{ print $1 }')

# if [ $connected_monitor ]; then
# 	xrandr --output $connected_monitor --auto --same-as eDP-1
# 	xrandr --output $connected_monitor --primary
# 	dunstify "Mirrored to Secondary Monitor"
# else
# 	xrandr --output $connected_monitor --off
# 	xrandr --output eDP-1 --primary
# 	dunstify "Secondary Monitor: Off"
# fi

xrandr --output $connected_monitor --auto --same-as eDP-1
xrandr --output $connected_monitor --primary
dunstify "Mirrored to Secondary Monitor"
