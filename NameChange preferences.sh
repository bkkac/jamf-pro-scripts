#!/bin/bash

#### Set NameChange preferences for first launch
#### Will Pierce
#### 20160523

###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

pref=com.mrrsoftware.NameChanger

# sudo -u ${user} defaults write $pref $key -$type $value

# Set first launch to true
sudo -u ${user} defaults write $pref SUHasLaunchedBefore -bool YES

# Set to NOT check for updates at start up
sudo -u ${user} defaults write $pref SUCheckAtStartup -bool NO

# Set to NOT check for updates automaticly 
sudo -u ${user} defaults write $pref SUEnableAutomaticChecks -bool NO

# Set to accept EULA
sudo -u ${user} defaults write $pref hasEULABeenAccepted -bool YES

# Read in the prefs
sudo -u ${user} defaults read $pref

exit 0