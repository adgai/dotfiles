#! /bin/bash

pgrep -x picom > /dev/null || picom &
feh --no-fehbg --bg-fill $HOME/.config/awesome/themes/wall.png &
pgrep -x cycle_wall > /dev/null || cycle_wall 30m &
pgrep -x polkit-gnome-au > /dev/null || /usr/libexec/polkit-gnome-authentication-agent-1 &
