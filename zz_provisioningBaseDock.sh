﻿#!/bin/bash
# Name: fixDock.sh
# Purpose:  to set the initial dock configuration for new users
# Date:  28 February 2014
# Updated: 22 Jun 2016
#	- changed how home folder is derived
#   - updated 2019 08 28
#   - Set to just the Base applacations for provisioning in the dock
# Author:  Steve Wood (swood@integer.com)
## 2017 WIll Pierce
## COLLE+McVOY
## https://github.com/stevewood-tx/CasperScripts-Public/blob/master/FixDock/fixDock.sh
## 20170320
### 2018 06 20 WHP
# Set Global Variables
# set the user folder to work on
# Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
sleep 1
#
# loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
myUserHome=/Users/$user
# echo --allhomes
#
shortModel=`system_profiler SPHardwareDataType | grep 'Model Name:' | awk '{ print $3 }'`
echo "Updating dock for:" $shortModel
# check for dockutil
if [[ ! -e "/usr/local/bin/dockutil" ]]; then
	echo "dockutil NOT found."
	exit 0
    else echo "dockutil fond, lets do this."
fi
# set the path to dockutil
du='/usr/local/bin/dockutil'
## Remove the apple stuff we dont want ------------------------------
#$du --remove all --no-restart --allhomes
echo "NUKEING ALL CURRENT DOCKS"
$du --remove all 
#
sleep 10
#
## System Apps ------------------------------ ------------------------------
echo "Adding system apps."
#
$du --add "/Applications/Launchpad.app" --no-restart
$du --add "/Applications/Mission Control.app"  --no-restart
$du --add "/Applications/System Preferences.app" --no-restart
$du --add "/Applications/iTunes.app"  --no-restart
if [[ -d "/Applications/EasyFind.app" ]]; then
    $du --add "/Applications/EasyFind.app" --no-restart
fi
#
# add spacer ------------------------------ ------------------------------ / add spacer 
echo "Adding spacer."
$du --add '' --type spacer --section apps --no-restart
#
echo "Adding Web browsers."
## Web browers ------------------------------ ------------------------------ / Web browsers
if [[ -d "/Applications/Google Chrome.app" ]]; then
	$du --add "/Applications/Google Chrome.app" --no-restart
fi
if [[ -d "/Applications/Firefox.app" ]]; then
	$du --add "/Applications/Firefox.app" --no-restart
fi
$du --add "/Applications/Safari.app" --no-restart
# add spacer ------------------------------ ------------------------------ / add spacer 
echo "Adding spacer."
$du --add '' --type spacer --section apps --no-restart
#
echo "Adding office apps."
## Office Apps ------------------------------ ------------------------------
$du --add "/Applications/Microsoft Excel.app" --no-restart
$du --add "/Applications/Microsoft OneNote.app" --no-restart
$du --add "/Applications/Microsoft Outlook.app" --no-restart
$du --add "/Applications/Microsoft PowerPoint.app" --no-restart
$du --add "/Applications/Microsoft Word.app" --no-restart
# $du --add "/Applications/OneDrive.app" --no-restart --allhomes
$du --add "/Applications/Skype for Business.app" --no-restart
#
if [[ -d "/Applications/Microsoft Teams.app" ]]; then
    $du --add "/Applications/Microsoft Teams.app" --no-restart
fi
$du --add "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app" --no-restart
#
if [[ -d "/Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app" ]]; then
    $du --add "/Applications/Adobe\ Acrobat\ DC/Adobe\ Acrobat.app" --no-restart
fi
#
if [[ $shortModel == "MacBook" ]]; then
    $du --add '' --type spacer --section apps --no-restart --position end
    $du --add "/Applications/Cisco/Cisco AnyConnect Secure Mobility Client.app" --position end --no-restart
fi
# Kill the recent apps in the dock
# defaults write com.apple.dock show-recents -bool FALSE
## Others section
$du --add '~/Downloads' --view list --display folder --no-restart
# $du --add '/Applications' --view grid --display folder --allhomes
$du --add '/Users/Shared/Servers' --view grid --display stack --no-restart
# $du --add '' --type spacer --section others --no-restart --allhomes
#
#Remove macOS apps
# News, Photos, Siri, Maps
$du --remove "News" --no-restart
$du --remove "Maps" --no-restart
$du --remove "Photos" --no-restart
$du --remove "Siri" --no-restart
$du --remove "Mail" --no-restart
$du --remove "Contacts" --no-restart
$du --remove "Calendar" --no-restart
$du --remove "Notes" --no-restart
$du --remove "Reminders" --no-restart
$du --remove "Messages" --no-restart
$du --remove "FaceTime" --no-restart
$du --remove "Pages" --no-restart
$du --remove "Numbers" --no-restart
$du --remove "Keynote" --no-restart
#
# $du --add '' --type spacer --section apps --no-restart --allhomes
# $du --add '' --type spacer --section apps --allhomes --position end
$du --move 'System Preferences' --before 'Google Chrome'--no-restart
$du --add "/Applications/Self Service.app" --position end
defaults write /Users/$user/Library/Preferences/com.XX.provision.plist XX-defaultDockSet -bool True
#
exit 0