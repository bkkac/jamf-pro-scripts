#!/bin/sh
# Configure Adobe Flash to *not* update
#
# Dan K. Snelson, 7-Nov-2014
#
# Inspired by Lance Berrier
# https://jamfnation.jamfsoftware.com/viewProfile.html?userID=12774

directory="/Library/Application Support/Macromedia/"
file="/Library/Application Support/Macromedia/mms.cfg"

if [ -f "$file" ] ; then
	
	# Flash Player is installed, has been launched and mms.cfg exists
	# let's configure it to not update
		
	echo "AutoUpdateDisable=1" > $file
	echo "SilentAutoUpdateEnable=0" >> $file
	
	RESULT="Configured"

else

	# mms.cfg doesn't exsist
	
	mkdir "${directory}"

	echo "AutoUpdateDisable=1" > $file
	echo "SilentAutoUpdateEnable=0" >> $file

	RESULT="Created and configured"

fi

echo "<result>$RESULT</result>"