#!/bin/sh
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
## this works when quoteing the the var
jh_icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ApplicationsFolderIcon.icns"
jamfPath="/usr/local/jamf/bin/jamf"
log=~/Desktop/log.txt
###################################
# Fire Fox #
###################################
let "count++"
/bin/echo "Installing Firefox"
test="/usr/local/jamf/bin/jamf policy -trigger provision_firefox "
"$jamfHelperPath" -startlaunchd -windowType hud -description "Installing FireFox" -icon "$jh_icon" $test &

/usr/local/jamf/bin/jamf policy -trigger provision_firefox 
firefox_version=$(mdls -name kMDItemVersion /Applications/Firefox.app | cut -c 19- | rev | cut -c 2- | rev)
if [[ $firefox_version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "Firefox install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count FireFox install FAILED" -icon "$jh_icon" &
	sleep 3
else
	# App is installed
	/bin/echo "Firefox $firefox_version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count FireFox Installed" -icon "$jh_icon" &
	sleep 3
fi
killAll jamfHelper

###################################