#!/bin/sh
# Extension Attribute For CM Dock
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
version=$(defaults read /Users/$user/Library/Preferences/com.cm.provision.plist CM-defaultDockSet)
if [[ $version == *"1"* ]]; then
	# Dock is set
    echo "<result>Yes</result>"
else
	# Dock has not been set
    echo "<result>No</result>"
fi


