#!/bin/bash

# if browser is't defined kill all

if [ "$1" = "" ]; then
    sudo killall opera
    sudo killall chromium
    sudo killall iceweasel
else
    sudo killall $1
fi
