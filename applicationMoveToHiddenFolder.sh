#!/bin/bash	
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	applicationMoveToHiddenFolder.sh -- Move an application to a hidden folder to hide it from users and spotlight.
#	This will make it easy to move it back or use as admin if needed.
#	Typically the library of a local admin account.
#
# SYNOPSIS
#
# 	If the $hiddenFolder parameter is specified (parameter 4), this is the folder that will be 
# 	checked for and if not found created.
#	Example:
#	/Users/yourlocaladminaccount/Library/Applications_Hidden/
#
#	If the $app parameter is specified (parameter 5), this is the application that will be 
# 	checked for and moved if to $hiddebFolder if found.
#
# 	f no parameter is specified for parameters 4 and 5, the hardcoded value in the script will be used.
#
# DESCRIPTION
#	This script checks for and creates a folder to move apps to that you don't want your users using
#	Like Photos or the App store, what have you. 
#	Spotlight does not typically search in the Library folder so depending on your environment 
#	you can move the apps to a local admin account if you have one.
####################################################################################################
#
# HISTORY
#
#	Version: 1.3
#
#	- Created by Will Pierce on May 12, 2015
#	- Modified  May 19, 2015
#	- Added remove app from the dock with dockutil
#	- Full patch to dockutil - moved the dock item check to before app check
#	Version 1.4 
#	May 20, 2015
#	- Logic to check for dockutil
#	- Clean up logging 
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# where do you want to move the app? Full path to a folder
# Example: hiddenFolder="/Users/macroot/Library/Applications_Hidden/"
# Leave blank to set in the script policy
# Example: hiddenFolder=""
#
hiddenFolder=""
#
# What app are you wanting to move?
# Examples:
# app="Photos.app"
# app="Photo Booth.app"
#
# Leave blank to set in the script policy
# Example app=""
app=""
#
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
#
# Check Parameter Values variables from the JSS
# Parameter 4 = path to the folder you want the app to move to.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "hiddenFolder"
if [ "$4" != "" ] && [ "$hiddenFolder" == "" ];then
    hiddenFolder=$4
fi

# Parameter 5 = Name of the app you want to move
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "app"
if [ "$5" != "" ] && [ "$app" == "" ];then
    app=$5
fi
echo ""
echo "applicationMoveToHiddenFolder.sh ver 1.4"
echo ----
echo Hidden Folder is: $hiddenFolder
echo App we are moveing is: $app
echo ----
####################################################################################################
# Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
####################################################################################################
# is the app in the dock?
####################################################################################################
# check to see if dockutil is installed in usr/local/bin/ if so then check for the app in the dock
 if [ -e /usr/local/bin/dockutil ]; then

# check to see if the app is in the dock
	dockTest=`/usr/local/bin/dockutil --find "${app%.*}" /Users/$user`
#
	if [[ $dockTest != *not* ]]; then
		# It  - IS - in the dock, remove it
		echo "$app -IS- in the dock, removing..."
		/usr/local/bin/dockutil --remove "${app%.*}" /Users/$user
		echo "Checking that app was removed from the dock..."
		sleep 7 # let the system cache up eh!
		# Run the command again
		dockTest2=`/usr/local/bin/dockutil --find "${app%.*}" /Users/$user`
#
			if [[ $dockTest2 == *not* ]]; then
				echo "$app is -NOT- in the dock all is good"
			else
				echo "$app  -IS- still in the dock something went wrong"
				# exit 1
			fi
#
	else
		# it is NOT in the dock
		echo "$app is -NOT- in the dock"
	fi	
else
	echo "dockutil is -NOT- installed in /usr/local/bin/ skipping the check for $app in the dock"
fi
echo ----
####################################################################################################
# check for the the $hiddenFolder
echo Checking for the hidden folder
if [ ! -d "$hiddenFolder" ]; then
	echo "$hiddenFolder -NOT- found, creating..."
	# make the Applications_Hidden folder
	mkdir "$hiddenFolder"
	echo Checking on the creation of that folder 
	# Test to see that it was created
	if [ -d "$hiddenFolder" ]; then
		echo "Confirmed $hiddenFolder created."
	else
		echo "$hiddenFolder -NOT- created, something went wrong."
		exit 1
	fi
else
		echo "$hiddenFolder -FOUND- not creating."
fi
####################################################################################################
# Check to see if $app is installed 
echo ----
echo Checking for app
if [ -e /Applications/"$app" ]; then
	echo "$app -FOUND- moving to $hiddenFolder"

	# Move the $app to Applications_Hidden
	mv /Applications/"$app" "$hiddenFolder"
	echo Checking on that move...
	# Test that it was moved
	# Make sure $app is gone from Applications folder & # Make sure $app is now in $hiddenFolder
	if [ ! -e /Applications/"$app" ] && [ -e "$hiddenFolder"/"$app" ]; then
		echo "Confirmed, $app moved from Applications folder to $hiddenFolder successfully"
		echo --
		echo "Setting Spotlight to re index"
		# erase the Spotlight index
 		mdutil -E /
#
 		# turn Spotlight indexing off
 		mdutil -i off /
#
 		# turn Spotlight indexing back on
 		mdutil -i on /
	else
		echo "Something went wrong $app -NOT- in Applications and not in $hiddenFolder"
		echo ----
		exit 1
	fi
else
	echo "$app -NOT- found, nothing to move."
	echo ----
fi 
echo "applicationMoveToHiddenFolder.sh done exiting..."
exit 0