#!/bin/sh
# PowerPoint Templates

# Variables
applicationTitle="PowerPoint Templates" 
customTrigger="provision_powerPointTemplates" # The name of the cuntom Trigger for the Provisiong policy:  provision_firefox
# appPath="Applications/Cisco" ## Leave blank if /Applacations
appIcon="/Applications/Microsoft PowerPoint.app/Contents/Resources/POTX.icns" 
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jh_icon="/Applications/Microsoft PowerPoint.app/Contents/Resources/POTX.icns"
jamfPath="/usr/local/jamf/bin/jamf"
title="XX Provisioning Bot 5000"

##########- DONT NOT EDIT BELOW THIS LINE -########## ###############
dateStamp=$( date "+%a %b %d %H%M%S" )
log="/Users/Shared/Provisiong-log.txt"
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$applicationTitle" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $customTrigger
#
version=$(ls -x1 "/Library/Application Support/Microsoft/Office365/User Content.localized/Templates.localized")
if [[ ${version} != *MasterSlides* ]]; then
    # does not contain 
	# Fonts are not installed 
	/bin/echo "$applicationTitle install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "ERROR:" -description "$applicationTitle install FAILED" -icon "$jh_icon" &
	sleep 5
    killAll jamfHelper
else
	# App is installed
	masterSlidesNumber=$(ls -x1 "/Library/Application Support/Microsoft/Office365/User Content.localized/Templates.localized" | grep -c "MasterSlides")
	/bin/echo "$masterSlidesNumber $applicationTitle - Installed Successfully" >> $log
	/bin/echo >> $log
    /bin/echo $version | tee -a $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$masterSlidesNumber $applicationTitle" -icon "$appIcon" &
	sleep 5
    killAll jamfHelper
fi
/bin/echo >> $log
exit 0
###################################