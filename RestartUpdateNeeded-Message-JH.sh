#!/bin/bash
#### Version 1.4
#### Message users to let them know they have updates waiting to install. Scope to smart group XX.
#### Will Pierce
#### January 14, 2015
#### Updated March 2, 2015
#### Requirements
#### jamfHelper
# commit 489a3bf03ba5f821e0c7e8c824255212324a2782
## Get the start time so we can find the time it takes for this all to run.
begin=$(date +"%s")
#
## Create a log file for trouble shooting 
#
# removing writing to the log file as it will not show in the JSS
# LOGFILE="/Library/Logs/restartUpdateNeeded-Message.log"
# echo "------------------------------------------------------------" >> $LOGFILE
#
#Get the date and set it to variable the_date
the_date=`date "+%Y-%m-%d %r"`
now=`date +%s`
#
# enter the date to the log file
# echo "$the_date" >> $LOGFILE
#
## Var for the last time user restarted and hit yes
UpdatesRunDate=`defaults read /Library/Preferences/com.cm.imaging UpdatesRunDate`
#
then=$(date -j -f "%Y-%m-%d" "$UpdatesRunDate" +%s)
#
# echo "$(($now/86400-$then/86400))"
#
if [[ '$UpdatesRunDate' != "" ]]; then
   echo "Last restart & update was on $UpdatesRunDate this is "$(($now/86400-$then/86400))" days ago."
else
   UpdatesRunDate="N/A"
   echo "Last restart & update was not found"
fi
#
##-------------------- Get current flash version
flash_major_version=`/usr/bin/curl --silent http://fpdownload2.macromedia.com/get/flashplayer/update/current/xml/version_en_mac_pl.xml | awk '/update version/ { print $2 }' | sed 's/.*"\(.*\)".*/\1/' | sed 's/,/./g'`
#
# get current installed flash version
FlashPluginInstalledVersion=`/usr/bin/defaults read /Library/Internet\ Plug-Ins/Flash\ Player.plugin/Contents/Info CFBundleVersion`
#
echo ""  # Add space to LOG
echo "----- Flash version:"
echo Current flash version $flash_major_version
echo Installed flash version $FlashPluginInstalledVersion
#
# Compare current flash to installed version of flash
if [ "$flash_major_version" = "$FlashPluginInstalledVersion" ]; then
	flashUpdate=""
	else
		flashUpdate="Flash $flash_major_version"
	fi
########## Apple Updates
#
echo ""
echo "----- Apple Updates:"
#
## Create a variable for Apple update command. 86 the lines we dont need.
appleUpdates=`softwareupdate -l | tail -n+6 |  sed -e 's/^[ \t]*//' | sed '/^*/ d' | sed 's/[[:space:]]//g' | awk 1 ORS=' | '`
#
## If there are no Apple updates then set variable to No apple updates
if [ "$appleUpdates" == "" ];then
appleUpdates="No Apple Updates" 
echo "No Apple Updates"
## If there are Apple updates set variable noau to nothing
else
noau=""
echo "$appleUpdates"
fi
echo ""
#
########## 3rd Party updates?
#
## Check for JAMF waiting room, if so create variable for getting the results of waiting room command
#
if [ -d /Library/Application\ Support/JAMF/Waiting\ Room ];then
JAMF_WaitingRoom=`/bin/ls -1 /Library/Application\ Support/JAMF/Waiting\ Room/ 2> /dev/null | /usr/bin/grep -v ".cache.xml" | awk 1 ORS=' | '`
echo "----- Waiting Room: 
$JAMF_WaitingRoom"
fi
## If nothing in the waiting room create variable for no set it to No updates
if [ "$JAMF_WaitingRoom" == "" ];then
JAMF_WaitingRoom="No 3rd party updates"
echo "Nothing in the waiting room. No 3rd party updates."
#
## if we have something in the waiting room set variable no to nothing
else
no=""
fi
#
echo ""
#
################################################
# Create a JAMF Helper window
jhPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
icon_folder="/Library/User Pictures"
logo_K="CM_Square.png"
#
## PREP MESSAGE
title="Important Action Required. Restart and click yes to finish installing important updates."
#
#heading="Important Action Required"
#
###### description
descrip="Available updates:
$JAMF_WaitingRoom
$appleUpdates
$flashUpdate

Mac OS can’t install updates while the system is running. Today at your convenience, please save your work, quit all applications, click the Apple icon in the top left of your screen & choose Restart, click yes when prompted. 

Your last restart & update was over "$(($now/86400-$then/86400))" days ago. Best practice is to restart and click yes once a week. You will get this message once a day until you do. If you have questions please contact the helpdesk. EXT 6400 or helpdesk@collemcvoy.com
Thank you.
"
button_value="OK"

termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for Script Execution."

###### end description
## Create the pop up
response=`"$jhPath" -startlaunchd -windowType hud -title "$title" -description "$descrip" -button1 "I Understand" -lockHUD -icon "$icon_folder/$logo_K"`
if [ "$response" == 0 ];then
echo "User clicked \"I Understand\""
else
echo "User closed window."
fi

#Script spacer - adds a line of ------ to the end of the log session
echo "------------------------------------------------------------" 
echo ""

exit 0