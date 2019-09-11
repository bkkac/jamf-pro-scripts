#!/bin/sh
########################################################################################################

##############################
# Completes Provisioning log file #
##############################
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
jh_icon="/Library/User Pictures/CM_Logo_512x512.png"
log=/Users/Shared/Provisiong-log.txt
title="Colle McVoy Provisioning Bot 5000"
dateStamp=$( date +'%F'_'%I:%M %p' )
/bin/echo "
Provisioning completed on $dateStamp
" >> $log
/bin/echo Provisioning completed on $dateStamp
#####################
# Stops Jamf Helper #
#####################
killAll jamfHelper

########################################
# Provisioning Complete, Jamf Helper Prompt #
########################################
userChoice=$("$jamfHelperPath" -windowType hud -title $title -heading "Provisioning Complete" -description "And there was much rejoicing!" -button2 "Open Log" -icon "$jh_icon" &)
if [ "$userChoice" == "2" ]; then
    open -a "TextEdit" $log
   # killall Terminal
    exit
else
    exit 0
fi
