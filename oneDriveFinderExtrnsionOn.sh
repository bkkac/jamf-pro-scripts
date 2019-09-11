#!/bin/bash
#
# Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
echo "user is $user"
# 150420 moved the -c to before the user switch - whp
# su -l $user -c "pluginkit -e use -i com.microsoft.OneDrive-mac.FinderSync"

sudo -l -c $user "pluginkit -e use -i com.microsoft.OneDrive-mac.FinderSync"
