#!/usr/bin/env bash

# i3blocks command for the screensaver block.
# - On signal or startup (no BLOCK_BUTTON): queries and displays current state
# - On click (BLOCK_BUTTON set): toggles DPMS+screensaver, then displays new state

# If clicked in i3blocks, toggle first
if [ -n "$BLOCK_BUTTON" ]; then
	dpms_state=$(xset q | grep -Po 'DPMS is \K(Enabled|Disabled)')
	if [ "$dpms_state" == "Enabled" ]; then
		xset -dpms
		xset s off
		dunstify "Screensaver: Off"
	else
		xset +dpms dpms 0 310 310
		xset s 280 300
		dunstify "Screensaver: On"
	fi
fi

# Output icon based on current state
dpms_state=$(xset q | grep -Po 'DPMS is \K(Enabled|Disabled)')

if [ "$dpms_state" == "Enabled" ]; then
	echo "䷺"
else
	echo "❎"
fi
