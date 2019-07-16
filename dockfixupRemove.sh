#!/bin/bash
#
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	dockfixupRemove.sh -- remove the extra junk that apple adds to the dock
#
# SYNOPSIS
#
# 	rm /Library/Preferences/com.apple.dockfixup.plist
#	https://jamfnation.jamfsoftware.com/discussion.html?id=6081
#
# DESCRIPTION
#	remove the plist, /Library/Preferences/com.apple.dockfixup.plist
#	Run this as a policy at login so it will remove the plist after an OS update
####################################################################################################
#
# HISTORY
#
version="1.0"
#
#	- Created by Will Pierce on 150618
#	- 
#
####################################################################################################
#
# Check to see if the plist is there if so remove it. If not exit.
if [ -e /Library/Preferences/com.apple.dockfixup.plist ]; then
	rm /Library/Preferences/com.apple.dockfixup.plist
else
	echo "/Library/Preferences/com.apple.dockfixup.plist not found exiting..."
fi
exit 0