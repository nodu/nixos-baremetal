#!/usr/bin/env bash

n_screens=$(xrandr | grep '*' | wc -l)

if [ $n_screens -eq 1 ]
then
  xrandr --output DP-2 --auto --above eDP-1
  xrandr --output DP-3 --auto --above eDP-1
  dunstify "Extended to Secondary Monitor"
else
  xrandr --output DP-2 --off
  xrandr --output DP-3 --off
  dunstify "Secondary Monitor: Off"
fi
