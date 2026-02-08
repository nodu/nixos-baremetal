#!/usr/bin/env bash

screen_saver_on=true
dpms_state=$(xset q | grep -Po 'DPMS is \K(Enabled|Disabled)')
if [ "$dpms_state" == "Enabled" ]; then
  xset -dpms
  dunstify "DPMS: Off"
  screen_saver_on=false
else
  xset +dpms #dpms 0 300 300
  dunstify "DPMS: On"
  screen_saver_on=true
fi

screensaver_state=$(xset q | grep -Po 'timeout:\s+\K(\d+)')
if [ "$screensaver_state" -eq 0 ]; then
  xset s 280 300 #on
  dunstify "Screensaver: On"
  screen_saver_on=true
else
  xset s off
  dunstify "Screensaver: Off"
  screen_saver_on=false
fi

if [ $screen_saver_on == true ]; then
  rtn=䷺
else
  rtn=❎
fi

echo "$rtn"
