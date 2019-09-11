#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
#	AppRemove.sh -- Remove any app
#
# SYNOPSIS
# rm -R /Applications/AppYouWant.app
#
# DESCRIPTION
#	Use the policy variable to set the name of the app and remove it.
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 151028
#	- 
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# App location?
appLocation=""
#
# What app? I
# Example: app="OmniGraffle.app"
# Example: app="Photo Booth.app"
# Leave blank to set in the script policy
# Example: app=""
#
app=""
# What is the name of the app process? It is not allays the same as the app!
# Example: appProcess="OmniGraffle 6"
# Leave blank to set in the script policy
appProcess=""
#
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
#
# Check Parameter Values variables from the JSS
# Parameter 4 = path where the app is.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "appLocation"
if [ "$4" != "" ] && [ "$appLocation" == "" ];then
    appLocation=$4
fi

# Parameter 5 = Name of the app.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "app"
if [ "$5" != "" ] && [ "$app" == "" ];then
    app=$5
fi
# Parameter 6 = process name of the app.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "app"
if [ "$5" != "" ] && [ "$appProcess" == "" ];then
    appProcess=$6
fi
#
#Check that the app is NOT running!
if pgrep $appProcess; then
    echo "$app is Running exiting..";
    exit 0
fi

# Check to see if $app is installed 
echo ----
echo Checking for app
if [ -e /"$appLocation"/"$app" ]; then
	echo "$app found removing..."

	# Remove the $app 
	rm -rf /"$appLocation"/"$app"
	echo Checking on that remove...
	# Test that it was removed
	# Make sure $app is gone from $appLocation folder 
	if [ ! -e /"$appLocation"/"$app" ]; then
		echo "Confirmed, $app removed from $appLocation folder successfully"
		echo ----
		# uncomment it needed 
		# echo "Setting Spotlight to re index"
			# erase the Spotlight index
 			#mdutil -E /

 			# turn Spotlight indexing off
 			#mdutil -i off /

 			# turn Spotlight indexing back on
 			#mdutil -i on /
		else
			echo "Something went wrong $app not  removed"
			echo ----
			exit 1
	fi
else
	echo "$app NOT found, nothing to remove."
	echo ----
fi 
echo "All done here exiting..."
exit 0