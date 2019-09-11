#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# applicationName
# NAME
#	launchApp.sh -- Launch an application as current logged in user.
#
# SYNOPSIS
#
# 	Sudo -u $user open /Applications/$applicationName
#	Example:
#	Sudo -u $user open /Applications/Outlook.app
#	If the $applicationName parameter is specified (parameter 4), this is the application that will be Launched.
#
# If no parameter is specified for parameter 4 the hard coded value in the script will be used.
#
# DESCRIPTION
#	This script checks for the application, then if present launches it.
####################################################################################################
#
# HISTORY
#
#	Version: 1.2
#
#	- Created by Will Pierce on May 13, 2015
#	- Modified May 14, 2015
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# $4
# What application do you want to launch? Use full name with OUT.app, do NOT escape spaces.
# Example: applicationName="OneDrive for Business"
# Leave blank to set in the script policy
# Example: applicationName=""
#
applicationName="/Applications/Utilities/Adobe Creative Cloud/ACC/Creative Cloud.app"
#
echo 
echo ---------- launchApp.sh Start #Pretty up the logs eh!
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
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "applicationName"
# if [ "$4" != "" ] && [ "$applicationName" == "" ];then
#     applicationName=$4
# fi
#
# add .app to the applicationName var
# applicationNameDotApp=$applicationName.app
#
# check that .app was added correctly 
# echo Application is $applicationNameDotApp
# Is this application installed? Check before trying to launch
echo ----------
echo Checking that $applicationName is installed in Applications folder...
	if [ -e "$applicationName" ]; then
			echo "$applicationName found, checking that it is not already running..."
#				
				if pgrep -x "Creative Cloud" > /dev/null
					then
			    	echo "$applicationName is Running no need to launch."
			    	echo ---------- launchApp.sh end
			    	exit 0
				else
			    	echo "$applicationName is NOT running launching..."
				fi
echo ----------
			## switch to the current logged in user launch application
			su - $user -c "open '$applicationName'"
			#Test that application was launched
			echo "Checking that $applicationName was launched..."
				if pgrep -x "$applicationName" > /dev/null 
					then
		    		echo "Confirmed $applicationName is Running"
		    	else 
		    		echo "Something went wrong $applicationName not running."
		    		echo ---------- launchApp.sh end
		    		exit 0
				fi
	else 
		echo "$applicationName not found in Applications folder, can not launch."
		echo ---------- launchApp.sh end
		exit 1
	fi 
echo ----------
echo "$applicationName launched successfully"
echo ---------- launchApp.sh end
#
exit 0
#