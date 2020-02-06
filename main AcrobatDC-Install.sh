#!/bin/sh

# Variables
applicationTitle="Adobe Acrobat" # Firefox no .app
#
customTrigger="provision_acrobatDC" # The name of the cuntom Trigger for the Provisiong policy:  provision_firefox
#
appPath="/Applications/Adobe Acrobat DC" ## Leave blank if /Applacations
#
appIcon="ACP_App.icns" ## Find the icon name in: "/"$appPath"/"$applicationTitle".app/Contents/Resources/
#
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
jh_icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ApplicationsFolderIcon.icns"
#
jamfPath="/usr/local/jamf/bin/jamf"
#
title="XX Provisioning Bot 5000"
##########- DONT NOT EDIT BELOW THIS LINE -########## ###############
dateStamp=$( date "+%a %b %d %H%M%S" )
#
log=/Users/Shared/Provisiong-log.txt
#
appPath="${appPath:-Applications}"
#
log=/Users/Shared/Provisiong-log.txt
#
app_IconPath="/"$appPath"/"$applicationTitle".app/Contents/Resources/$appIcon"
## Verbose
echo "######### ##########"
echo "App Title is:" $applicationTitle
echo "Custom Trigger is:" $customTrigger
echo "App Icon is: $appIcon"
echo "Applacation path is: $appPath"
echo "######### ##########"
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$applicationTitle" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $customTrigger
#
version=$(mdls -name kMDItemVersion /"$appPath"/"$applicationTitle".app | cut -c 19- | rev | cut -c 2- | rev)
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
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$applicationTitle version: $version" -icon "$app_IconPath" &
	sleep 5
    killAll jamfHelper
fi
/bin/echo >> $log
exit 0
###################################