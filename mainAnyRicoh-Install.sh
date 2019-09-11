#!/bin/sh

# Variables
applicationTitle="Any_Ricoh_MFP" 
customTrigger="provision_anyRicoh" 
appPath="" ## Leave blank if /Applacations
appIcon="/Library/Printers/RICOH/Icons/154E.icns" 
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jh_icon="/System/Library/PreferencePanes/PrintAndScan.prefPane/Contents/Resources/PrintScanPref.icns"
jamfPath="/usr/local/jamf/bin/jamf"
title="Colle McVoy Provisioning Bot 5000"
##########- DONT NOT EDIT BELOW THIS LINE -########## ###############
appPath="${appPath:-Applications}"
dateStamp=$( date "+%a %b %d %H%M%S" )
log=/Users/Shared/Provisiong-log.txt
app_IconPath="$appIcon"
## Verbose
echo "######### ##########"
echo "App Title is:" $applicationTitle
echo "Custom Trigger is:" $customTrigger
echo "App Icon is: $appIcon"
echo "Applacation path is: $appPath"
echo "######### ##########"
echo
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$applicationTitle" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $customTrigger
#
version=$(lpstat -p)
# echo $applicationTitle "versions is: $version" 
if [[ ${version} != *${applicationTitle}* ]]; then
    # does not contain 
	# App is not installed
	/bin/echo "$applicationTitle install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "ERROR:" -description "$applicationTitle install FAILED" -icon "$jh_icon" &
	sleep 5
    killAll jamfHelper
else
	# App is installed
	/bin/echo "$applicationTitle - Installed Successfully" >> $log
    /bin/echo $version >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$applicationTitle" -icon "$app_IconPath" &
	sleep 5
    killAll jamfHelper
fi
/bin/echo >> $log
exit 0
###################################