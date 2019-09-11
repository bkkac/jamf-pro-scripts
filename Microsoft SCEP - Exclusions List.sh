#!/bin/bash

/Applications/System\ Center\ Endpoint\ Protection.app/Contents/MacOS/scep_set --section=global 'av_exclude = "/Volumes/Images/*.*::/Volumes/Production/*.*::/Volumes/Creative/*.*::/Volumes/Transfer/*.*::/Volumes/Logos/*.*::"'
sleep 1
launchctl unload /Library/LaunchDaemons/com.microsoft.scep_daemon.plist
sleep 1
launchctl load /Library/LaunchDaemons/com.microsoft.scep_daemon.plist

exit 0