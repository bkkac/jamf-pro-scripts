#!/bin/sh

# Variables
dateStamp=$( date +'%F'_'%I:%M %p' )
#
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
jh_icon="/Applications/Self Service.app/Contents/Resources/AppIcon.icns"
#
jamfPath="/usr/local/jamf/bin/jamf"
#
title="Colle McVoy Provisioning Bot 5000"
#
log=/Users/Shared/Provisiong-log.txt
#
/usr/bin/touch $log
/bin/echo "######### ########## - ######### ##########" >> $log
/bin/echo "Provisiong started at $dateStamp" >> $log
/bin/echo "Running Recon after computer name change. . ." >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Computer PreCheck" -description "Running recon. . ." -icon "$jh_icon" &
/usr/local/jamf/bin/jamf recon
Sleep 5
killAll jamfHelper
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "PreCheck complete." -description "Proceeding with Provisioning" -icon "$jh_icon" &
sleep 5
killAll jamfHelper
