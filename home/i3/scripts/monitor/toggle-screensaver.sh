#!/usr/bin/env bash

# Toggle both DPMS and X screensaver together as a unified pair.
# Determines current state from DPMS (the authoritative source), then
# flips both to the opposite state. Signals i3blocks to refresh.

dpms_state=$(xset q | grep -Po 'DPMS is \K(Enabled|Disabled)')

if [ "$dpms_state" == "Enabled" ]; then
	# Turn everything off
	xset -dpms
	xset s off
	dunstify "Screensaver: Off"
else
	# Turn everything on (restore defaults from i3.config)
	xset +dpms dpms 0 310 310
	xset s 280 300
	dunstify "Screensaver: On"
fi

# Signal i3blocks to refresh the screensaver block (signal=11)
pkill -RTMIN+11 i3blocks || true
