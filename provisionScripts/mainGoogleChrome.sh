#!/bin/sh
####################################################################################################
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
## this works when quoteing the the var
jh_icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ApplicationsFolderIcon.icns"
jamfPath="/usr/local/jamf/bin/jamf"
log=~/Desktop/log.txt
###################################
# Google Chrome #
###################################
/bin/echo "Installing Google Chrome" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -description "Installing Google Chrome" -icon "$jh_icon" &
#
$jamfPath policy -trigger provision_googlechrome
chrome_version=$(mdls -name kMDItemVersion /Applications/Google\ Chrome.app | cut -c 19- | rev | cut -c 2- | rev)
if [[ $chrome_version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "Google Chrome install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Google Chrome install FAILED" -icon "$jh_icon" &
	sleep 3
else
	# App is installed
	killAll jamfHelper
	/bin/echo "Google Chrome $chrome_version - Installed Successfully" >> $log
	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Google Chrome Installed" -icon "$jh_icon" &
	sleep 3

fi
killAll jamfHelper

###################################