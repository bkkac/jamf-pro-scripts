#!/bin/bash

#### Set Screen Saver
#### Will Pierce
#### September 3, 2014
## https://jamfnation.jamfsoftware.com/discussion.html?id=11647
## Run this at first login. Run this if the current screensaver is one of the defaults like "Flury".

# grab current user
curUser=`ls -l /dev/console | cut -d " " -f 4`

# grab the system's uuid
if [[ `ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-50` != "00000000-0000-1000-8000-" ]]; then
macUUID=`ioreg -rd1 -c IOPlatformExpertDevice | grep -i "UUID" | cut -c27-62`
fi

# defaults write /Users/$curUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist CleanExit "YES"
defaults write /Users/$curUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist PrefsVersion -int 100
## Set time out to 15 min or 900 seconds
defaults write /Users/$curUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist idleTime -int 900
defaults write /Users/$curUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist moduleDict -dict moduleName "colle mcvoy" path "/Library/Screen Savers/colle mcvoy.saver" type -int 0

chown $curUser /Users/$curUser/Library/Preferences/ByHost/com.apple.screensaver.$macUUID.plist

## kill CoreFoundationPreferencesDaemon, or cfprefsd as it shows up in the process list
killall cfprefsd
exit 0