#!/bin/sh

#Get current user
#user=`ls -l /dev/console | cut -d " " -f 4`
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

sudo -u $user defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'
killall Dock