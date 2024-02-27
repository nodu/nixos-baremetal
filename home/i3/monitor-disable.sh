#!/usr/bin/env bash

xrandr --output DP-2 --off
xrandr --output DP-3 --off
xrandr --output eDP-1 --primary
dunstify "Secondary Monitor: Off"
