#!/usr/bin/env bash

# Unified screensaver/DPMS toggle and query script.
#
# Invocation contexts:
#   No args, no BLOCK_BUTTON (i3blocks startup/signal) -> query only, output icon
#   BLOCK_BUTTON set (i3blocks click)                   -> toggle, output icon
#   --toggle argument (Rofi menu)                       -> toggle, signal i3blocks

do_toggle() {
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
}

output_icon() {
	dpms_state=$(xset q | grep -Po 'DPMS is \K(Enabled|Disabled)')
	if [ "$dpms_state" == "Enabled" ]; then
		echo "䷺"
	else
		echo "❎"
	fi
}

if [ "$1" == "--toggle" ]; then
	# Called from Rofi -- toggle and signal i3blocks to refresh
	do_toggle
	pkill -RTMIN+11 i3blocks || true
elif [ -n "$BLOCK_BUTTON" ]; then
	# Clicked in i3blocks -- toggle and output updated icon
	do_toggle
	output_icon
else
	# i3blocks startup or signal refresh -- just output current state
	output_icon
fi
