#!/bin/bash
# script to set app to not prompt for updates
# run this like once a week

### Will Pierce 
# 20160908
echo ---------- Starting script updatesAutoOff. . . 
# HARDCODED VALUES ARE SET HERE
############################################################ Make changes below ####################
# $4 applicationName # needed to check to see it is installed
# The application name
#applicationName=VLC.app
## example: VLC.app 
## If app has spaces do NOT use \ for them. Example [ Remote Desktop.app ]
####################################################################################################
# $5 plist
#plist=org.videolan.vlc.plist
## For the do not update command example: org.videolan.vlc.plist
####################################################################################################
# $6 key
#key=SUEnableAutomaticChecks
## example: disableCheckForUpdates
####################################################################################################
# $7 type
#type=bool 
## example: bool for Boolean 
############################################################################################# 8
# $8 value
#value=NO
## example: YES
####################################################################################################
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
###################################################################	Get the currently logged in user
## Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
####################################################################################################
# Check Parameter Values variables from the JSS
####################################################################################################
# Parameter 4 = Name of application
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "applicationName"
if [ "$4" != "" ] && [ "$applicationName" == "" ];then
    applicationName=$4
fi
####################################################################################################
# Parameter 5 = plist
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "plist"
if [ "$5" != "" ] && [ "$plist" == "" ];then
    plist=$5
fi
####################################################################################################
# Parameter 6 = key
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "key"
if [ "$6" != "" ] && [ "$key" == "" ];then
    key=$6
fi
####################################################################################################
# Parameter 7 = type
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 7 AND, IF SO, ASSIGN TO "type"
if [ "$7" != "" ] && [ "$type" == "" ];then
    type=$7
fi
####################################################################################################
# Parameter 8 = value
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 8 AND, IF SO, ASSIGN TO "value"
if [ "$8" != "" ] && [ "$value" == "" ];then
    value=$8
fi
####################################################################################################
echo User is: $user
echo The application we are setting to not auto update is: $applicationName
echo The plist is $plist
echo The key is $key type: $type value: $value

## check to see if the app is installed
if [ -e /Applications/$applicationName ]; then
echo $applicationName is installed # comment out after testing
echo Now set $applicationName to NOT check for updates

# sudo -u ${user} defaults write $plist $key -$type $value # old command
su $user -c "defaults write $plist $key -$type $value"
/usr/bin/killall -u "$user" cfprefsd
# echo defaults set
## Create a var for autoUpdate so we can see if this all works
autoUpdate=`su $user -c "defaults read $plist $key"`
echo $plist $key is set to $autoUpdate
echo "If type is bool YES=1 NO=0"
else
echo Application $applicationName not installed
fi
echo ---------- Exiting script updatesAutoOff. . .
exit 0