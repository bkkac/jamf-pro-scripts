#!/bin/sh

# Variables
dateStamp=$( date "+%a %b %d %H%M%S" )
#
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
jh_icon="/Applications/Self Service.app/Contents/Resources/AppIcon.icns"
#
jamfPath="/usr/local/jamf/bin/jamf"
#
title="Colle McVoy Provisioning Bot 5000"
#
log=/Users/Shared/Provisiong-log-$dateStamp.txt
#
/usr/bin/touch $log
/bin/echo "######### ##########" >> $log
/bin/echo "Imaging started at $dateStamp" >> $log
/bin/echo "Runing Recon after computer name chage. . ." >> $log
#
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "Computer PreCheck" -description "Running recon. . ." -icon "$jh_icon" &
/usr/local/jamf/bin/jamf recon
killAll jamfHelper
"$jamfHelperPath" -startlaunchd -windowType hud -title "$title" -heading "PreCheck complete." -description "Proceeding with Provisioning" -icon "$jh_icon" &
sleep 5
killAll jamfHelper
