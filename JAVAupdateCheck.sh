#!/bin/bash
# current git hash
#### Script placed in the restart & update actual policy that simply checks for the policy set to run the script
#### Will Pierce
#### March 3, 2015

## Get the start time so we can find the time it takes for this all to run.
begin=$(date +"%s")

## Create a log file for trouble shooting 
LOGFILE="/Library/Logs/RestartUpdateActual.log"

echo "------------------------------------------------------------" >>$LOGFILE
echo "" >> $LOGFILE # Add space to LOGFILE

#Get the date and tine set it to variable
the_date=`date "+%Y-%m-%d %r"`
the_time=`date "+%r"`

# enter the date to the log file
echo "$the_date" >> $LOGFILE

# enter JAVA check to the log file
echo "----- JAVA Check:" >>$LOGFILE

# Set the path to the JAMF helper
jhPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

# Set the path to the JAVA icon
JAVAicon="/System/Library/CoreServices/Java Web Start.app/Contents/Resources/WebStart.icns"

echo "Showing JAMF helper window to let user know we are checking for JAVA updates " >> $LOGFILE 

# Create a JAMF helper window to let user know we are checking for JAVA updates.
"$jhPath" -windowType hud -title "$the_time" -icon "$JAVAicon" -heading "JAVA" -description "Checking for updates..." -timeout 5

# Check if computer is member of a smart group
JAVAupdate=`jamf policy -trigger JAVA-8-Update-Script`
echo "$JAVAupdate">>$LOGFILE 

if  [[ $JAVAupdate ==  *"No "* ]]; then
	echo "Create a JAMF helper window to let user know result of checking for JAVA updates.">>$LOGFILE
	"$jhPath" -windowType hud -title "$the_time" -icon "$JAVAicon" -heading "JAVA" -description "No JAVA update found"  -timeout 3
	# Script run time
	termin=$(date +"%s")
	difftimelps=$(($termin-$begin))
	echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for Script Execution." >> $LOGFILE
	echo "" >> $LOGFILE 
	echo "------------------------------------------------------------" >>$LOGFILE
	exit 0
else
	echo "Create a JAMF helper window to let user know result of checking for JAVA updates was update found.">>$LOGFILE
	"$jhPath" -windowType hud -title "$the_time" -icon "$JAVAicon" -heading "JAVA" -description "JAVA update found, installing. . . "
	wait
fi
	
killall jamfHelper
wait 2>/dev/null

# Script run time
termin=$(date +"%s")
difftimelps=$(($termin-$begin))
echo "$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for Script Execution." >> $LOGFILE

# Create a JAMF helper window to let user know we are done installing JAVA updates.
	"$jhPath" -windowType hud -title "$the_time" -icon "$JAVAicon" -heading "JAVA" -description "JAVA updated." -timeout 2

echo "" >> $LOGFILE 
echo "------------------------------------------------------------" >>$LOGFILE
exit 0