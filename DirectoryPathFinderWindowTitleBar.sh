#!/bin/bash

#### Display the full directory path in the Finder window title bar.
#### Will Pierce
#### May 20, 2014
### updated February 9, 2015

## Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

## switch to the current logged in user launch app
sudo -u $user defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES 

sudo -u $user killall Finder

exit 0