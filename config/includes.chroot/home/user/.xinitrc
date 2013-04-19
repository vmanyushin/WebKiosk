#!/bin/bash

_PARAMETERS=`cat /proc/cmdline`

if [ `expr "${_PARAMETERS}" : '.*development'` != 0 ]; then
    exit
fi

# no black screen
xset s off
xset -dpms

# disable bell
xset b 0 0

# set keyboard 
setxkbmap us,ru -option grp:ctrl_shift_toggle,grp_led:scroll

# white background http://webconverger.org/artwork/
xsetroot -solid "#ffffff"

S=`expr "${_PARAMETERS}" : '.*mode='`
E=`expr "${_PARAMETERS}" : '.*mode=[0-9]*x[0-9]*'`
MODE=${_PARAMETERS:$S:$E-$S}

if [ -z $MODE ]; then
    MODE="1280x1024"
fi

xrandr --output default --mode $MODE
sudo chown user. /home/user -R

# setting up browser and it options

# prefix for browser binaries (all stay into /usr/bin/(opera|chromium|iceweasel))
BROWSER_PREFIX=/usr/bin/
SCRIPT_PREFIX=~/setup-

_CMDLINE=`cat /proc/cmdline`

for _PARAMETER in ${_CMDLINE}
do
	case "${_PARAMETER}" in
		homepage=*)
			HOMEPAGE=`busybox httpd -d ${_PARAMETER#homepage=}`
			;;
		http_proxy=*)
			PROXY=${_PARAMETER#http_proxy=}
			;;
		browser=*)
			BROWSER=${_PARAMETER#browser=}
			;;
		kiosk_id=*)
			KIOSKID=${_PARAMETER#kiosk_id=}
	esac
done

# setting default browser to opera
if [ -z $BROWSER ]; then
    BROWSER=opera
fi

if [ -z $HOMEPAGE ]; then
    HOMEPAGE="http://www.ya.ru"
fi

BROWSER_BINARY=$BROWSER_PREFIX$BROWSER

. $SCRIPT_PREFIX$BROWSER.sh

# running window manager
matchbox-window-manager &

# start VNC server
x11vnc -bg

xautolock -secure -time 10 -locker "/home/user/reset-browser.sh $BROWSER" &

while true
do
    if [ -x $BROWSER_BINARY -a `basename $BROWSER_BINARY` == 'opera' ];
    then
	rm -fr ~/.opera/cache
	$BROWSER_BINARY -kioskmode -kioskbuttons -nomail -nocontextmenu -nodownload -noexit -nochangebuttons -nokeys $HOMEPAGE
    fi
    
    if [ -x $BROWSER_BINARY -a `basename $BROWSER_BINARY` == 'chromium' ];
    then
	$BROWSER_BINARY -kiosk $HOMEPAGE
    fi
done
