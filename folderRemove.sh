#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
#	folderRemove.sh -- Remove any folder
#
# SYNOPSIS
# rm -R /FolderYouWant
#
# DESCRIPTION
#	Use the policy variable to set the path of the folder and remove it.
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 151103
#	- 
#
####################################################################################################
# HARDCODED VALUES ARE SET HERE
# Folder path?
# what is the path of the folder to remove?
# Leave blank to set in the script policy
# example: folderPath=" /Applications/Utilities/Casper Suite"
folderPath=""
#
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
#
# Check Parameter Values variables from the JSS
# Parameter 4 = path where the app is.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "folderPath"
if [ "$4" != "" ] && [ "$folderPath" == "" ];then
    folderPath=$4
fi

# Check to see if the folder is there
echo ----
echo "Running script removeFolder.sh"
echo "Folder to be removed is $folderPath"
echo "checking for $folderPath"
if [ -d "$folderPath" ]; then
	# Do this if folder is there
	echo "$folderPath found removing...."
	rm -R "$folderPath"
	echo "checking on that remove..."
		if [ -d "$folderPath" ]; then
			# Do this if folder is STILL there
			echo "$folderPath still present, something went wrong."
		else
			echo "$folderPath has been removed, all is good."
		fi

	else
	# do this if folder is NOT there
	echo "$folderPath not present, nothing to do."
fi

exit 0