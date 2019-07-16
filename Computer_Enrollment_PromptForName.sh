#!/bin/sh

# Get serial number
serialNumber=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`

# Set name to serial number (in case name is not set by user)
scutil --set ComputerName $serialNumber
scutil --set LocalHostName $serialNumber
scutil --set HostName $serialNumber

# Get currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Only proceed if _mbsetupuser is logged in (used by Apple for setup screens)
# if [[ ! $loggedInUser = "_mbsetupuser" ]];then
#   echo "Logged in user is not _mbsetupuser. Exiting..."
#   exit 0
# fi

# Get the logged in UID
loggedInUID=$(id -u $loggedInUser)

# Prompt for Computer Name as the user
/bin/launchctl asuser $loggedInUID sudo -iu $loggedInUser whoami
computerName=$(/bin/launchctl asuser "${loggedInUID}" sudo -iu "${loggedInUser}" /usr/bin/osascript<<EOL
tell application "System Events"
activate
with timeout of 120 seconds
set r to display dialog "Change compuer name?" with title "Colle McVoy Computer Rename 8000" buttons {"No", "Yes"} default button "Yes" giving up after 120 -- seconds
             if r's gave up or r's button returned is not "No" then
set answer to text returned of (display dialog "Set Computer Name" with title "Colle McVoy Computer Rename 8000" default answer "$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}')")
end if
end timeout
end tell
EOL)
wait
echo "Move on with the script eh"
# Check to make sure $computerName is set
if [[ -z $computerName ]];then
  echo "Computer Name not set. useing Serial..."
  exit 0
fi
echo $computerName
# Set name using variable created above
#computerName=`echo $computerName | tr '[:lower:]' '[:upper:]'`
scutil --set ComputerName $computerName
scutil --set LocalHostName $computerName
scutil --set HostName $computerName

echo "Computer Name set to $computerName"

# Confirm Computer Name
/bin/launchctl asuser "${loggedInUID}" sudo -iu "${loggedInUser}" /usr/bin/osascript<<EOL
tell application "System Events"
activate
display dialog "Computer Name set to " & host name of (system info) buttons {"OK"} default button 1 with title "Colle McVoy Computer Rename 8000" giving up after 5
end tell
EOL

exit 0
