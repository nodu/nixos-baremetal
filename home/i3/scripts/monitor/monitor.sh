#!/usr/bin/env bash

connected_monitor=$(xrandr | grep ' connected' | grep -v 'eDP\|LVDS' | awk '{ print $1 }')

xrandr --output "$connected_monitor" --primary

xrandr --output "$connected_monitor" --auto "--$1" eDP-1

dunstify "Extended to Secondary Monitor - $1"
