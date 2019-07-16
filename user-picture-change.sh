#!/bin/sh
#### Change the logged in users picture.
#### Run at login.
#### https://jamfnation.jamfsoftware.com/discussion.html?id=4332&postid=47631
# Goes good with a smart group based on this Extension Attribute
# https://github.com/quedayone/jamf-pro-scripts/blob/master/user-picture-report.sh
#### Will Pierce
#### August 11, 2014
#### Updated May 11, 2017
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# Full path to the icon / Picture you want to use
userPicture="/Library/User Pictures/changeME.png"
#
# Check if the Picture exists 
echo
echo "Checking for:" $userPicture ". . ."
# 
if [ -f "$userPicture" ]
# If exists then do this
then
	echo
	echo "found:" $userPicture 
	echo
	echo "Changeing user icon to: " $userPicture
	sudo -u $user dscl . delete /Users/$user jpegphoto
	sudo -u $user dscl . delete /Users/$user Picture
	dscl . create /Users/$user Picture "$userPicture"
else
# If does NOT exist then this this
	echo
	echo "Did NOT find:" $userPicture 
fi
# print out the current use picture
echo
echo "$user" "Current user picture is:" 
dscl . -read /Users/$user Picture | tail -1 | sed 's/^[ \t]*//'
echo
exit 0
