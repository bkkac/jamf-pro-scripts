#!/bin/sh
###################################
# Fire Fox #
###################################
let "count++"
/bin/echo "Installing Firefox"
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing FireFox" -icon "$jh_icon" &

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