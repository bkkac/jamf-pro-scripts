#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
#	launchAgentRemove.sh -- Remove any Launch Agent
#
# SYNOPSIS
# sudo launchctl remove com.annoying.service
#
# DESCRIPTION
#	Use the policy variable to set the name of the app and remove it.
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 2018 04 06
#	- 
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
launchAgent=""
# What is the name of the launchAgent?
# Example: launchctl remove com.annoying.service
# Leave blank to set in the script policy
#
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
#
# Check Parameter Values variables from the JSS
# Parameter 4 = path where the app is.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "launchAgent"
if [ "$4" != "" ] && [ "$launchAgent" == "" ];then
    launchAgent=$4
fi
echo "We are removeing: $launchAgent"
# Remove the $launchAgent 
launchctl remove $launchAgent
echo "Checking on that remove..."
# Test that it was removed
# Make sure $launchAgent is gone 
if [ ! -e /"Library/LaunchAgents"/"$launchAgent" ]; then
	echo "Confirmed, $launchAgent removed successfully"
	echo ----
	else
		echo "Something went wrong $launchAgent not  removed"
		echo ----
		exit 1
	fi

echo "All done here exiting..."
exit 0