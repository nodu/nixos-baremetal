#!/usr/bin/env bash

n_screens=$(xrandr | grep '*' | wc -l)

if [ $n_screens -eq 1 ]
then
  xrandr --output DP-2 --auto --same-as eDP-1
  xrandr --output DP-3 --auto --same-as eDP-1
  dunstify "Mirrored to Secondary Monitor"
else
  xrandr --output DP-2 --off
  xrandr --output DP-3 --off
  dunstify "Secondary Monitor: Off"
fi
