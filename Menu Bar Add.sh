#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# 
# NAME
#	menuBarAdd.sh -- Add items to the menu bar
#
# SYNOPSIS
#
# 	open "/System/Library/CoreServices/Menu Extras/thing.menu"
#	Example:
#	open "/System/Library/CoreServices/Menu Extras/vpn.menu"
#	If the $menuName parameter is specified (parameter 4), this is the application that will be Launched.
#
# If no parameter is specified for parameter 4 the hard coded value in the script will be used.
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 20160928
#	- Modified May XXXXxxXX
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# $4
# What menu item do you want to launch? Use full name with .menu, do NOT escape spaces.
# Example: menuItem="Displays.menu"
# Leave blank to set in the script policy
# Example: menuItem=""
#
menuItem=""
#
echo 
echo ---------- menuBarAdd.sh Start #Pretty up the logs eh!
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
#
## Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# Check Parameter Values variables from the JSS
# Parameter 4 = Name of application to launch.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "menuItem"
if [ "$4" != "" ] && [ "$menuItem" == "" ];then
menuItem=$4
fi
#
# check that .app was added correctly 
echo Menu item is $menuItem
# Is this application installed? Check before trying to launch
echo Checking that $menuItem is installed in /System/Library/CoreServices/Menu Extras...
	if [ -e /System/Library/CoreServices/Menu\ Extras/"$menuItem" ]; then
			## switch to the current logged in user launch application
			su - $user -c "open '/System/Library/CoreServices/Menu Extras/$menuItem'"
#
	else 
		echo "$menuItem not found in /System/Library/CoreServices/Menu Extras folder, can not launch."
		echo ---------- launchApp.sh end
		exit 1
	fi 
echo ----------
echo ---------- menuBarAdd.sh end
#
exit 0
#