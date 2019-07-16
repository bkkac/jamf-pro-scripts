#!/bin/bash

#### Description
#### Will Pierce
#### February 26, 2015

if \[ -d /Volumes/JSS9_Distribution \]; then
umount /Volumes/JSS9_Distribution
fi

if \[ -d /Volumes/JSS9_Distribution\ 1 \]; then
umount /Volumes/JSS9_Distribution\ 1
fi

#
#if grep -qs '/mnt/foo' /proc/mounts; then
#    echo "It's mounted."
#else
#    echo "It's not mounted."
#fi


diskutil unmount /Volumes/JSS9_Distribution


diskutil unmount /Volumes/JSS9_Distribution\ 1/

exit 0