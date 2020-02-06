#!/bin/bash
# use Jamf helpper to ask user if they want to install a cached update.
# User selects no, nothing happens
# User selects yes, a policy is triggerd by a event ID.
## Will Pierce
## 20161109 TRUMP can go jump in a LAKE

# Set the date & time as a variable 
the_date=`date "+%Y-%m-%d"`
the_time=`date "+%r"`
# Vars for Title, Heading, Discription, Icon. Useing the JAMF Var $4 $5 $6 $7 $8.
appUpdating=""
jamfHelperTitle="Update Available!"
jamfHelperHeading="$appUpdating"
jamfHelperDiscription=""
jamfHelperIcon="/Applications/Sublime Text.app/Contents/Resources/Sublime Text.icns"
jamfHelperTimeOut="120"
jamfPolicyID=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "appUpdating"

if [[ "$4" != "" ]] && [[ "$appUpdating" == "" ]]
then
    appUpdating=$4
fi
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "jamfHelperTitle"
if [[ "$5" != "" ]] && [[ "$jamfHelperTitle" == "" ]]
then
    jamfHelperTitle=$5
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "jamfHelperHeading"
if [[ "$6" != "" ]] && [[ "$jamfHelperHeading" == "" ]]
then
    jamfHelperHeading=$6
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 7 AND, IF SO, ASSIGN TO "jamfHelperDiscription"
if [[ "$7" != "" ]] && [[ "$jamfHelperDiscription" == "" ]]
then
    jamfHelperDiscription=$7
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 8 AND, IF SO, ASSIGN TO "jamfHelperIcon"
if [[ "$8" != "" ]] && [[ "$jamfHelperIcon" == "" ]]
then
    jamfHelperIcon=$8
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 9 AND, IF SO, ASSIGN TO "jamfHelperTimeOut"
if [[ "$9" != "" ]] && [[ "$jamfHelperTimeOut" == "" ]]
then
    jamfHelperTimeOut=$9
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 10 AND, IF SO, ASSIGN TO "jamfPolicyID"
if [[ "$10" != "" ]] && [[ "$jamfPolicyID" == "" ]]
then
    jamfPolicyID=$10
fi
#Show user pop up window 
update=`sudo -u $(ls -l /dev/console | awk '{print $3}') /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -windowPosition c -title "$jamfHelperTitle" -heading "$jamfHelperHeading" -description "An update for $appUpdating has been downloaded and is ready to install. Please save any unsaved work in $appUpdating before clicking Update.
\

Click Update to quit $appUpdating and update. 
Click Cancle to try again tomorrow.

\

" -icon "$jamfHelperIcon" -button1 Update -button2 cancel -defaultButton 2 -cancelButton 2 -timeout $jamfHelperTimeOut -countdown`

echo "jamf helper result was $update"

if [ "$update" == "0" ]; then

echo "User hit yes."
# Add the date updates were run to com.XX.imaging plist so we can report on this
# echo "updateing com.XX.imaging"
# /usr/bin/defaults write /Library/Preferences/com.XX.imaging UpdatesRunDate "$the_date" 
usr/local/bin/jamf policy -id $jamfPolicyID

exit 0
else
echo "user chose No";
# Add the date updates were canceld to com.XX.imaging plist so we can report on this
# sudo /usr/bin/defaults write /Library/Preferences/com.XX.imaging UpdatesCancelDate "$the_date" 
exit 0
fi

exit 0