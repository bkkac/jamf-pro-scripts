#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
#	oneDriveSettings.sh -- Set the prefs for OneDrive=
#
# SYNOPSIS
# defaults write com.microsoft.OneDrive-mac "options"
#
# DESCRIPTION
#	https://support.office.com/en-us/article/Deploying-the-OneDrive-Next-Generation-Sync-Client-on-OS-X-and-configuring-work-or-school-accounts-eadddc4e-edc0-4982-9f50-2aef5038c307?ui=en-US&rs=en-US&ad=US
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 160105
#	- 
#
####################################################################################################
#
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
echo "Running oneDriveSettings.sh version 1.0"
echo "Setting OneDrive Prefrences..."
#
# Set Pref location
location=/Users/$user/Library/Containers/com.microsoft.OneDrive-mac/Data/Library/Preferences
# OneDrive wizard directs to sign in with their Office 365 work or school account
sudo -u $user defaults write $location/com.microsoft.OneDrive-mac DefaultToBusinessFRE -bool True
#
# Enabling users to add additional work or school accounts
# sudo -u $user defaults write com.microsoft.OneDrive-mac EnableAddAccounts -bool True
#
# Add Tenants ID
sudo -u $user /usr/libexec/PlistBuddy -c "Add :Tenants:3a1b575c-fde6-4f8e-b2e5-c71c482a590d" $location/com.microsoft.OneDrive-mac.plist
#
# Set OneDrive location
sudo -u $user /usr/libexec/PlistBuddy -c "Add :Tenants:3a1b575c-fde6-4f8e-b2e5-c71c482a590d:DefaultFolder string '/Users/$user'" $location/com.microsoft.OneDrive-mac.plist
killall SystemUIServer

# echo back the settings to see if they are correct
OneDrivePrefs=`sudo -u $user defaults read com.microsoft.OneDrive-mac`
echo "OneDrive prefs are now:"
echo $OneDrivePrefs
exit 0