#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# URL
# NAME
#	launchURL.sh -- Launch an URL as current logged in user.
#
# SYNOPSIS
#
# 	Sudo -c $user open 'http://www.apple.com'
#	Example:
#	Sudo  -c "open 'http://qa.collemcvoy.com/w/docs/tips_and_tricks/self_service_installs/node/'"
#	If the $URL parameter is specified (parameter 4), this is the application that will be Launched.
#
# If no parameter is specified for parameter 4 the hard coded value in the script will be used.
#
# DESCRIPTION
#	This script checks for the application, then if present launches it.
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 160211
#	- Modified 
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# $4
# What URL do you want to launch? Use full URL do NOT escape spaces.
# Example: URL="OneDrive for Business"
# Leave blank to set in the script policy
# Example: URL=""
#
URL=""
#
echo 
echo ---------- launchURL.sh Start #Pretty up the logs eh!
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
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "URL"
if [ "$4" != "" ] && [ "$URL" == "" ];then
    URL=$4
fi
## switch to the current logged in user launch application
su $user -c "open '$URL'"
echo ---------- launchApp.sh end
#
exit 0
#