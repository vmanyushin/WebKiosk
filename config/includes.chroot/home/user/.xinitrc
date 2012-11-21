#!/bin/bash

# no black screen
xset s off
xset -dpms

# disable bell
xset b 0 0

# set keyboard 
setxkbmap us,ru -option grp:ctrl_shift_toggle,grp_led:scroll

# white background http://webconverger.org/artwork/
xsetroot -solid "#ffffff"

xrandr --output default --mode 1280x1024
sudo chown user. /home/webc -R

# fix Opera prefs
~/settings.sh

# running window manager
matchbox-window-manager &

# start VNC server
x11vnc -bg

xautolock -secure -time 10 -locker /home/user/reset_opera.sh &

while true
do

	if test -x /usr/bin/opera
	then
		rm -fr ~/.opera/cache
		opera -kioskmode -kioskbuttons -nomail -nocontextmenu -nodownload -noexit -nochangebuttons -nokeys
	fi
done
