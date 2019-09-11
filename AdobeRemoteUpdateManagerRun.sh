#!/bin/bash
#####################################################################################################
# e1a9231f674760a8a7b6483d1e910ed369d37446
# ABOUT THIS PROGRAM
#
# AdobeRemoteUpdateManagerRun.sh
# COLLE+McVOY Script to check if RUM is installed and if so trigger Adobe software updates
####################################################################################################
#
# HISTORY
#	Version 1.0
#	201311
#	Version: 1.2
#	- Will Pierce 150630
#	Versions 1.3
#	20171116
# 	Removed the JAMF helper we wnat to run with out user notifacations
# 	With Creative Clould 2017 this only seems to update Acrbat
####################################################################################################
#
# Set the date & time as a variable 
## the_date=`date "+%Y-%m-%d %H:%M:%S"
the_date=`date "+%Y-%m-%d"`
the_time=`date "+%r"`

#Grab the start time
start=`date +%s`
#
# Check to see if RemoteUpdateManager exists
echo "Checking for Adobe RemoteUpdateManager in /usr/local/bin"
if [ -f /usr/local/bin/RemoteUpdateManager ]; then 
	echo "Found Adobe RemoteUpdateManager, checking for updates..."
	# get adobe updates
	sudo /usr/local/bin/RemoteUpdateManager &
	# Wait for adobe updates to complete
	wait 2>/dev/null
else 
	echo Adobe Remote Update Manager not fond skipping.
fi
#
echo "Done"
#
# grab the end time
end=`date +%s`
# echo $start $end
#get the time of the script
runtime=$((end-start))
echo Adobe update run time was $runtime seconds 
#
exit 0