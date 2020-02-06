#!/bin/bash

# get the logged in user - thanks to Ben Toms (@maXXule) - https://macmule.com/2014/11/19/how-to-get-the-currently-logged-in-user-in-a-more-apple-approved-way/
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# do nothing until scep_gui is running - thanks to Richard Purves (@franton) for that - stolen from a dock setup script!
until [[ $(pgrep scep_gui) ]]; do
        wait
done
scep_guiPID=$(pgrep scep_gui)
until [[ $(ps -p $scep_guiPID -oetime= | tr '-' ':' | awk -F: '{ total=0; m=1; } { for (i=0; i < NF; i++) {total += $(NF-i)*m; m *= i >= 2 ? 24 : 60 }} {print total}') -ge 1 ]]; do
    sleep 1
done

# now let's set something
sudo -u "$loggedInUser" "/Applications/System Center Endpoint Protection.app/Contents/MacOS/scep_set" --cfg=/Users/"$loggedInUser"/.scep/gui.cfg --section gui 'update_success_tray_report_enabled=no'
sudo -u "$loggedInUser" killall scep_gui
sleep 1
sudo -u "$loggedInUser" open "/Applications/System Center Endpoint Protection.app"

exit 0