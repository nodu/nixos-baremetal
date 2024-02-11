#!/usr/bin/env bash

dpms_state=$(xset q | grep -Po 'DPMS is \K(Enabled|Disabled)')
if [ "$dpms_state" == "Enabled" ]; then
  xset -dpms
  dunstify "DPMS: Off"
else
  xset +dpms dpms 0 300 300
  dunstify "DPMS: On"
fi

screensaver_state=$(xset q | grep -Po 'timeout:\s+\K(\d+)')
if [ "$screensaver_state" -eq 0 ]; then
  xset s on
  dunstify "Screensaver: Off"
else
  xset s off
  dunstify "Screensaver: On"
fi
