#!/bin/bash

loggedInUser=$(stat -f%Su /dev/console)
loggedInUID=$(id -u $loggedInUser)

# if [[ "$loggedInUser" != "root" ]] && [[ "$loggedInUser" != "_mbsetup" ]]; then
#     ## Create local script
    cat << EOD > /private/tmp/computerrenamescript.sh

# initial=\$(/usr/bin/osascript -e 'tell application "System Events" to set initial to text returned of (display dialog "Please Input The Users first initial - " default answer "" with icon 2)')

# lastName=\$(/usr/bin/osascript -e 'tell application "System Events" to set lastName to text returned of (display dialog "Please Input The Users last name - " default answer "" with icon 2)')

# MODEL=\$(/usr/bin/osascript -e 'tell application "System Events" to set MODEL to text returned of (display dialog "Please Input Model - " default answer "13mbp" with icon 2)')
# Get serial number

# serialNumber="system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'"
echo $serialNumber
TAG=$serialNumber
TAG=\$ /usr/bin/osascript -e 'tell application "System Events" to set TAG to text returned of (display dialog "Please Input The Asset Tag - " default answer "$serialNumber" with icon 2)'


echo "\${TAG}" > /private/tmp/computerrenametext.txt

EOD

    ## Make script executable
    /bin/chmod +x /private/tmp/computerrenamescript.sh

    ## Run the script as logged in user
    /bin/launchctl asuser "$loggedInUID" sudo -iu "$loggedInUser" "/private/tmp/computerrenamescript.sh"

    ## Get the new name from the local file
    newcomputername=$(cat /tmp/computerrenametext.txt)

    if [ ! -z "$newcomputername" ]; then
        echo "$newcomputername"
        ## Rename the computer to the new name
        /usr/local/bin/jamf setComputerName -name "$newcomputername"
        scutil --set LocalHostName $newcomputername
        scutil --set HostName $newcomputername
        dscacheutil -flushcache

        ## Remove local script
        rm -f /private/tmp/computerrenamescript.sh

        exit 0
    else
        echo "No name was found to rename to"

        ## Remove local script
        rm -f /private/tmp/computerrenamescript.sh

        exit 1
    fi
else
    echo "No-one logged in. Exiting"
    exit 0
fi