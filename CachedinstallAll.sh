#!/bin/bash
# COLLE+McVOY Script install Third party updates
# Will Pierce, June 5, 2014
# Last modified 150205
# Last modified 160107
# Added var for jamf helper and icon
#
# Var for jamfHelper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
# Var for the icon
icon="/System/Library/CoreServices/Software Update.app/Contents/Resources/SoftwareUpdate.icns"
#
# Set the date & time as a variable 
the_date=`date "+%Y-%m-%d"`
the_time=`date "+%r"`
#
#Grab the start time
start=`date +%s`
#
sudo -u $(ls -l /dev/console | awk '{print $3}') "$jamfHelper" -windowType hud -title "$the_time" -heading "Third party software." -description "Installing any available updates..." -icon "$icon" >&- &
sleep 3
jamf installAllCached &
wait %2
# killall jamfHelper
ps axco pid,command | grep jamfHelper | awk '{ print $1; }' | xargs kill -9
wait 2>/dev/null
#
sudo -u $(ls -l /dev/console | awk '{print $3}') "$jamfHelper" -windowType hud -title "$the_time" -heading "Third party software." -description "Installing any available updates...
Done" -icon "$icon" -timeout 3 >&- &
wait
exit 0