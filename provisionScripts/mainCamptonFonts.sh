#!/bin/sh
# Campton Fonts

# Variables
applicationTitle="Campton Fonts" 
customTrigger="provision_camptonFonts" # The name of the cuntom Trigger for the Provisiong policy:  provision_firefox
# appPath="Applications/Cisco" ## Leave blank if /Applacations
appIcon="/Applications/Font Book.app/Contents/Resources/appicon.icns" 
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jh_icon="/Applications/Font Book.app/Contents/Resources/appicon.icns"
jamfPath="/usr/local/jamf/bin/jamf"
title="Colle McVoy Provisioning Bot 5000"

##########- DONT NOT EDIT BELOW THIS LINE -########## ###############
dateStamp=$( date "+%a %b %d %H%M%S" )
log="/Users/Shared/Provisiong-log.txt"
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$applicationTitle to /Library/Fonts" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $customTrigger
#
version=$(fc-list | grep -Z "Campton")
if [[ ${version} != *Campton* ]]; then
    # does not contain 
	# Fonts are not installed 
	/bin/echo "$applicationTitle install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "ERROR:" -description "$applicationTitle install FAILED" -icon "$jh_icon" &
	sleep 5
    killAll jamfHelper
else
	# App is installed
	fontsNumber=$(fc-list | grep -c "Campton")
	/bin/echo "$fontsNumber $applicationTitle - Installed Successfully" >> $log
	/bin/echo >> $log
    /bin/echo $version | tee -a $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$fontsNumber $applicationTitle Installed" -icon "$appIcon" &
	sleep 5
    killAll jamfHelper
fi
/bin/echo >> $log
exit 0
###################################