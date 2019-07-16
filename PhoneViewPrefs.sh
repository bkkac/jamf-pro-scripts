#!/bin/bash

#### Set Phone View preferences for first launch
#### Will Pierce
#### March 18, 2015

###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

pref=com.ecamm.PhoneView.plist

# sudo -u ${user} defaults write $pref $key -$type $value

# Set first launch to true
sudo -u ${user} defaults write $pref FIRST_LAUNCH_DONE -bool YES

# Set has launched before to true
sudo -u ${user} defaults write $pref SUHasLaunchedBefore3 -bool YES

# Set auto updates to false
sudo -u ${user} defaults write $pref SUEnableAutomaticChecks -bool NO

# Read in the prefs
sudo -u ${user} defaults read $pref

# Launch the app
sudo -u $user open /Applications/PhoneView.app

exit 0