#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# 
# NAME
#	pathfinder-set-preferences.sh -- Set the EULA for PathFinder
#
# Set com.cocoatech.PathFinder NTEULA7Shown to 1
# So users dont see the EULA

###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# Set Var for the path to the prefs
prefsPath="/Users/$user/Library/Preferences"
#
# define what plist you are setting
plist="com.cocoatech.PathFinder"
#
# define what key in the plist you are setting
key="NTEULA7Shown"
#
# Perform Keychain Lock check at launch
sudo -u $user defaults -currentHost write $prefsPath/$plist NTEULA7Shown -bool true
#
# Turn off check for updates
sudo -u $user defaults -currentHost write $prefsPath/$plist checkForUpdates -bool false

exit 0