#!/bin/bash
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# AppleSoftwareUpdate.sh
# COLLE+McVOY Script install Apple software updates
#
#####################################################################################################
#
# HISTORY
#	- Will Pierce, June 5, 2014
# 	- Last modified June 5, 2014
#	Version 1.2
#	- Added header and vars for jamf helper and icon
#	Version 1.3
#	- Fox error at line 22
#####################################################################################################
#
# Show window to start ASU
# /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -timeout 2 -heading "Mac OS X Software Update Tool" -description "Checking for updates." -icon /System/Library/CoreServices/Software\ Update.app/Contents/Resources/SoftwareUpdate.icns 
#Grab the start time
start=`date +%s`
#
# Set the date & time as a variable 
the_date=`date "+%Y-%m-%d"`
the_time=`date "+%r"`
#
# Var for jamf helper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Var for the icon
icon="/System/Library/CoreServices/Software Update.app/Contents/Resources/SoftwareUpdate.icns"
sudo -u $(ls -l /dev/console | awk '{print $3}') "$jamfHelper" -windowType hud -heading "Checking for updates..." -description "Mac OS X Software Updates are downloading and installing..." -title "Start time $the_time" -icon "$icon" >&- &
#
## Run ASU
softwareUpdate -i -a &
#
wait %2
sleep 3
killall jamfHelper
wait 2>/dev/null
#
## Kill the start ASU window
##killall jamfHelper
## /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -kill
## Show new Done window
sudo -u $(ls -l /dev/console | awk '{print $3}') "$jamfHelper"  -title "Start time $the_time" -windowType hud -lockHUD -timeout 3 -heading "Checking for updates..." -description "Mac OS X Software Updates 
Done" -icon "$icon" >&-
#
# grab the end time
end=`date +%s`
#
runtime=$((end-start))
echo Apple update run time was $runtime seconds 
exit 0