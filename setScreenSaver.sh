#!/bin/bash

# Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`


# Need to run this as the loged in user
/usr/bin/su $user defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName "colle mcvoy" path "/Library/Screen\ Savers/colle\ mcvoy.saver"
exit 0
