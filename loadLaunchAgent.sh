#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	loadLaunchAgent.sh -- Launch an application as current logged in user via a launch agent plist.
#
# SYNOPSIS
#	You must first create and deploy a launch agent to launch the app.
# 	launchctl load 
#	Example:
#	launchctl load /Users/pierce/Library/LaunchAgents/com.CM.OneDriveLaunch.plist 
#	If the $launchAgent parameter is specified (parameter 4), this is the launch agent that will be loaded.
#
# If no parameter is specified for parameter 4 the hard coded value in the script will be used.
#
# DESCRIPTION
#	This script checks for the launch agent, then if present loads it.
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on May 13, 2015
#	- Modified  
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# $4
# What is the name of the launch agent?
# Example: launchAgent="/com.CM.OneDriveLaunch.plist"
# Leave blank to set in the script policy
# Example: launchAgent=""
#
launchAgent=""
#
# $5
# What is the name of the process the launch agent is launching?
# Example: process="OneDrive for Business"
# Leave blank to set in the script policy
# Example: process=""
#
process=""
echo #Just a blank space to pretty up the logs
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
# Parameter 4 = Name of app to launch.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "app"
if [ "$4" != "" ] && [ "$launchAgent" == "" ];then
    launchAgent=$4
fi
# 
# Parameter 5 = Name of process to launch.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "app"
if [ "$5" != "" ] && [ "$process" == "" ];then
    process=$4
fi
# 
# Check to see if the launch agent is installed
#
if [ -e /Users/$user/Library/LaunchAgents/$launchAgent ]; then
	# if found
	echo $launchAgent found, loading
	# load launch agent
	launchctl load /Users/$user/Library/LaunchAgents/$launchAgent

else
	# if not found
	echo $launchAgent not found exiting
	exit 1
fi
#
# Now check that app is running.
echo "Checking that $process was launched..."
if pgrep "$process" > /dev/null 
	then
	echo "Confirmed $process is Running"
else 
	echo "Something went wrong $process not running."
	exit 1
fi

exit 0



