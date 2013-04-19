#!/bin/sh

lb clean
lb config
lb build

cd ./binary/live

cp filesystem.squashfs /srv/tftp/live
cp vmlinuz /srv/tftp/live

cd ../../

cd initrd
find . | cpio --quiet -H newc -o | gzip -9 -n > /srv/tftp/live/initrd.img
cd ..

tar -cf /var/www/live.current.tar /srv/tftp/live
md5sum  /var/www/live.current.tar > /var/www/live.current.md5



