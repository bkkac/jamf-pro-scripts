#!/bin/sh

# Name: adminDock.sh
# Add all the stuff to the dock that I.T. admins need.
# Set Global Variables
# set the user folder to work on
# Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

sleep 1

# loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
myUserHome=/Users/$user
echo $myUserHome
#
# set the path to dockutil
du='/usr/local/bin/dockutil'
#
# check for dockutil
if [[ ! -e "/usr/local/bin/dockutil" ]]; then
	echo "dockutil NOT found."
	exit 0
fi
#
$du --add '' --type spacer --section apps --no-restart $myUserHome
#
sleep 1
if [[ -d "/Applications/Casper Suite/Recon.app" ]]; then
	$du --add "/Applications/Casper Suite/Recon.app" --no-restart $myUserHome
fi
#
sleep 1
if [[ -d "/Applications/Casper Suite/Composer.app" ]]; then
	$du --add "/Applications/Casper Suite/Composer.app" --no-restart $myUserHome
fi
#
if [[ -d "/Applications/Casper Suite/Casper Remote.app" ]]; then
	$du --add "/Applications/Casper Suite/Casper Remote.app" --no-restart $myUserHome
fi
#
sleep 1
if [[ -d "/Applications/Casper Suite/Casper Imaging.app" ]]; then
	$du --add "/Applications/Casper Suite/Casper Imaging.app" --no-restart $myUserHome
fi
#
sleep 1
if [[ -d "/Applications/Casper Suite/Casper Admin.app" ]]; then
	$du --add "/Applications/Casper Suite/Casper Admin.app" --no-restart $myUserHome
fi
#
sleep 1
if [[ -d "/Applications/Remote Desktop.app" ]]; then
	$du --add "/Applications/Remote Desktop.app" --no-restart $myUserHome
fi
#
sleep 5
if [[ -d "/Applications/Microsoft Remote Desktop.app" ]]; then
	$du --add "/Applications/Microsoft Remote Desktop.app" $myUserHome
fi
sudo -u $user killall Dock
exit 0