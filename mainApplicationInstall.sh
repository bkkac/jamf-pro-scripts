#!/bin/sh

# Variables
applicationTitle="$4"

customTrigger="$5"
appPath="$6"
appIcon="$7"
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
## this works when quoteing the the var
jh_icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ApplicationsFolderIcon.icns"
jamfPath="/usr/local/jamf/bin/jamf"
title="Colle McVoy Provisioning Bot 5000"
#
## Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 7 AND, IF NOTSO, ASSIGN TO "Applacations"
appPath="${appPath:-Applacations}"
log=/Users/$user/Desktop/log.txt
app_IconPath="/"$appPath"/"$4".app/Contents/Resources/$7"
## Verbose
echo "######### ##########"
echo "App Title is:" $4
echo "Custom Trigger is:" $5
echo "App Icon is: $7"
echo "Applacation path is: $appPath"
echo "######### ##########"
###################################
# Main Application Install #
###################################
/bin/echo "######### ##########" >> $log
/bin/echo "Installing: $applicationTitle" >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Installing:" -description "$4" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger $5
#
version=$(mdls -name kMDItemVersion /"$appPath"/"$4".app | cut -c 19- | rev | cut -c 2- | rev)
echo $4 "versions is:" $version
if [[ $version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "$4 install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "ERROR:" -description "$4 install FAILED" -icon "$jh_icon" &
	sleep 5
    killAll jamfHelper
else
	# App is installed
	/bin/echo "$4 $version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -title "$title" -heading "Installed" -description "$4 version: $version Installed" -icon "$app_IconPath" &
	sleep 5
    killAll jamfHelper
fi
/bin/echo >> $log
exit 0
###################################