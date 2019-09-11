#!/bin/sh

# Name: serverShortcutsDock.sh
# Set Global Variables
# set the user folder to work on
# Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

sleep 1

# loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
myUserHome=/Users/$user
# echo $myUserHome
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
# $du --add '' --type spacer --section apps --no-restart $myUserHome
#
sleep 1
if [[ -d "/Users/Shared/Servers" ]]; then
	$du --add "/Users/Shared/Servers" --replacing "Servers" --view grid --display folder --no-restart --allhomes
fi
#
sleep 1

sudo -u $user killall Dock
exit 0