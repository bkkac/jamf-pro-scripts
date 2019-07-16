#!/bin/sh
#  get the value for hard drive free space in GB

hardDriveFreeSpace=`df -g / | awk '/dev/ {print $4}'`
# Set it to ARD info # 2
/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set2 -1 "HD Free Space $hardDriveFreeSpace GB"

