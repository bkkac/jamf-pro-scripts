#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
#	Shiftit-prefs.sh -- Set the prefs for Shiftit
#
# SYNOPSIS
# Library/Preferences/org.shiftitapp.ShiftIt.plist
#
# DESCRIPTION
#	This script sets all the C+M prefrences for Shiftit.
####################################################################################################
#
# HISTORY
#
#	Version: 2.0
#
#	- Created by Will Pierce on 160204
#	- 
#
####################################################################################################
#
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# Set Var for the path to the prefs
prefsPath="/Users/$user/Library/Preferences"
# dont ask to add to login
sudo -u $user defaults -currentHost write $prefsPath/org.shiftitapp.ShiftIt.plist SUHasLaunchedBefore true
# Dont auto update
sudo -u $user defaults -currentHost write $prefsPath/org.shiftitapp.ShiftIt.plist SUEnableAutomaticChecks false
