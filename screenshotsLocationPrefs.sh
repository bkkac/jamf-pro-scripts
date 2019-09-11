#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
#	screenshotsLocationPrefs.sh -- Set the prefs for screenshots to goto a Screenshots folder on the desktop
#
# SYNOPSIS
# defaults write com.apple.screencapture location ~/Dessktop/Screenshots
#
# DESCRIPTION
#	Users have actually requested this!
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
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
screenshots="/Users/$user/Desktop/ScreenShots"
# check for a folder on the Desktop named Screenshots if NOT found create it.

echo Checking for the screenshots folder
if [ ! -d "$screenshots" ]; then
	echo "$screenshots NOT found, creating..."

	# make the Applications_Hidden folder
	sudo -u $user mkdir "$screenshots"
	echo Checking on the creation of that folder 
	# Test to see that it was created
			if [ -d "$screenshots" ]; then
				echo "Confirmed $screenshots created."
					else
						echo "$screenshots NOT created, something went wrong."
						exit 1
			fi
	else
		echo "$screenshots found not creating."
fi

# Now change the screenshot location run as logged in user
sudo -u $user  defaults write com.apple.screencapture location $screenshots

killall SystemUIServer

# echo back the settings to see if they are correct
screenshotsLocation="sudo -u $user  defaults read com.apple.screencapture location $screenshots"
echo "Screenshots will now be saved in $screenshots"

exit 0