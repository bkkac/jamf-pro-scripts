#!/bin/bash
# Name: adobeAppsToDock.sh
# Purpose:  Add all installed adobe apps to the dock
# Date:  2018 10 29
# Author:  Steve Wood (swood@integer.com)
## 2018 WIll Pierce
## COLLE+McVOY
## https://github.com/stevewood-tx/CasperScripts-Public/blob/master/FixDock/fixDock.sh
#
# Set Global Variables
# set the user folder to work on
# Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
sleep 1
#
# loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
myUserHome=/Users/$user
echo "Adding Adobe apps to the dock for user: " $myUserHome
#
# check for dockutil
if [[ ! -e "/usr/local/bin/dockutil" ]]; then
	echo "dockutil NOT found."
	exit 0
    else echo "dockutil fond, lets do this."
fi
# set the path to dockutil
du='/usr/local/bin/dockutil'
#
sleep 10
#
# add spacer ------------------------------ ------------------------------ / add spacer 
echo "Adding spacer."
$du --add '' --type spacer --section apps --no-restart --allhomes
#
## Adobe Apps ------------------------------ ------------------------------
echo "Adding Adobe apps."
#
if [[ -d "/Applications/Adobe Acrobat DC/Adobe Acrobat.app" ]]; then
	$du --add "/Applications/Adobe Acrobat DC/Adobe Acrobat.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe After Effects CC 2019/Adobe After Effects CC 2019.app" ]]; then
	$du --add "/Applications/Adobe After Effects CC 2019/Adobe After Effects CC 2019.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Dimension CC/Adobe Dimension CC.app" ]]; then
	$du --add "/Applications/Adobe Dimension CC/Adobe Dimension CC.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Illustrator CC 2019/Adobe Illustrator.app" ]]; then
	$du --add "/Applications/Adobe Illustrator CC 2019/Adobe Illustrator.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe InDesign CC 2019/Adobe InDesign CC 2019.app" ]]; then
	$du --add "/Applications/Adobe InDesign CC 2019/Adobe InDesign CC 2019.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Media Encoder CC 2019/Adobe Media Encoder CC 2019.app" ]]; then
	$du --add "/Applications/Adobe Media Encoder CC 2019/Adobe Media Encoder CC 2019.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Photoshop CC 2018/Adobe Photoshop CC 2019.app" ]]; then
	$du --add "/Applications/Adobe Photoshop CC 2018/Adobe Photoshop CC 2019.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Premiere Pro CC 2019/Adobe Premiere Pro CC 2019.app" ]]; then
	$du --add "/Applications/Adobe Premiere Pro CC 2019/Adobe Premiere Pro CC 2019.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Premiere Rush CC/Adobe Premiere Rush CC.app" ]]; then
	$du --add "/Applications/Adobe Premiere Rush CC/Adobe Premiere Rush CC.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe XD CC/Adobe XD CC.app" ]]; then
	$du --add "/Applications/Adobe XD CC/Adobe XD CC.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Bridge CC 2019/Adobe Bridge CC 2019.app" ]]; then
	$du --add "/Applications/Adobe Bridge CC 2019/Adobe Bridge CC 2019.app" --no-restart --allhomes
fi
if [[ -d "/Applications/Adobe Audition CC 2019/Adobe Audition CC 2019.app" ]]; then
	$du --add "/Applications/Adobe Audition CC 2019/Adobe Audition CC 2019.app" --no-restart --allhomes
fi
# add spacer ------------------------------ ------------------------------ / add spacer 
echo "Adding spacer."
$du --add '' --type spacer --section apps --allhomes
#

exit 0