#!/bin/bash

# setting up homepage for browser

if [ -n $HOMEPAGE ];
then
    cat  ~/.opera/operaprefs.ini | sed -e "s#^Home URL=.*#Home URL=${HOMEPAGE}#" > ~/.pref.tmp
    cat ~/.pref.tmp > ~/.opera/operaprefs.ini
fi

if [ -n $KIOSKID ];
then
    cat  ~/.opera/operaprefs.ini | sed -e "s#^HTTP Accept=.*#HTTP Accept=\"*/*;wcook=${KIOSKID}\"#" > ~/.pref.tmp
    cat ~/.pref.tmp > ~/.opera/operaprefs.ini
fi


if [ -n $PROXY ];
then
cat >> ~/.opera/operaprefs.ini << EOF
[Proxy]
HTTP server=$PROXY
HTTPS server=$PROXY
FTP server=$PROXY
SOCKS server
Use Automatic Proxy Configuration=0
Use HTTP=1
Use HTTPS=1
Use FTP=1
Use SOCKS=0
EOF
fi

rm -f ~/.pref.tmp
