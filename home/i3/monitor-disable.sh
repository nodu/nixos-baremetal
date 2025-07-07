#!/usr/bin/env bash

connected_monitor=$(xrandr | grep ' connected' | grep -v 'eDP\|LVDS' | awk '{ print $1 }')

xrandr --output $connected_monitor --off
xrandr --output eDP-1 --primary
dunstify "Secondary Monitor: Off"
