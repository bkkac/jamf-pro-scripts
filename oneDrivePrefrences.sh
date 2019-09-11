#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# 
# NAME
#	oneDrivePrefrences.sh
#
# Set com.microsoft.OneDrive 
# OpenAtLogin = 1
# True, Open at login
# WHP
# 2017 08 21

###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# Set Var for the path to the prefs
prefsPath="/Users/$user/Library/Preferences"
#
# define what plist you are setting
plist="com.microsoft.OneDrive"
#
# define what key in the plist you are setting
key="OpenAtLogin"
#
# Open At Log in
sudo -u $user defaults -currentHost write $prefsPath/$plist $key -bool True
#
echo "OneDrive OpenAtLogin is now:"
OpenAtLoginResult=`sudo -u $user defaults -currentHost read $prefsPath/$plist $key`

if [ "$OpenAtLoginResult" == "1" ]; then
	OpenAtLoginResult=True
else
	OpenAtLoginResult=False
fi
echo $OpenAtLoginResult
exit 0