#!/bin/sh

# Variables
applicationTitle="dockutil" 
customTrigger="provision_dockutil" # The name of the cuntom Trigger for the Provisiong policy:  provision_firefox
appPath="/usr/local/bin" ## Leave blank if /Applacations
appIcon="/Applications/Self Service.app/Contents/Resources/AppIcon.icns" ## Find the icon name in: "/"$appPath"/"$applicationTitle".app/Contents/Resources/
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jh_icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ApplicationsFolderIcon.icns"
jamfPath="/usr/local/jamf/bin/jamf"
title="Colle McVoy Provisioning Bot 5000"
##########- DONT NOT EDIT BELOW THIS LINE -########## ###############
appPath="${appPath:-Applications}"
dateStamp=$( date "+%a %b %d %H%M%S" )
log="/Users/Shared/Provisiong-log.txt"
app_IconPath="/"$appPath"/"$applicationTitle".app/Contents/Resources/$appIcon"
#
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$applicationTitle" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $customTrigger
#
version=$(/usr/local/bin/dockutil --version)
echo $applicationTitle "versions is:" $version
if [[ $version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "$applicationTitle install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "ERROR:" -description "$applicationTitle install FAILED" -icon "$jh_icon" &
	sleep 5
    killAll jamfHelper
else
	# App is installed
	/bin/echo "$applicationTitle $version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$applicationTitle version: $version" -icon "$jh_icon" &
	sleep 5
    killAll jamfHelper
fi
/bin/echo >> $log
exit 0
###################################