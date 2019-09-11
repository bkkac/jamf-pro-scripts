#!/bin/bash

#### Use this in self service so users can check on Apple and 3rd party updates
#### 3rd party updates must be cached via JAMFs JSS
#### Will Pierce
#### 140804
#### Requirements
#### http://mstratman.github.io/cocoadialog/

## Do a policy check just to be sure nothing is waiting
jamf policy

## Var for the last time user restarted and hit yes
UpdatesRunDate=`defaults read /Library/Preferences/com.cm.imaging UpdatesRunDate`
if [[ '$UpdatesRunDate' != "" ]]; then
   echo "Updates Run Date has run"
else
   UpdatesRunDate="N/A"
fi

## Create a variable for Apple update command. 86 the lines we dont need.
appleUpdates=`softwareupdate -l | sed 's/Software Update Tool//g;s/Copyright 2002-2012 Apple Inc.//g;s/Finding available software//g;s/Software Update found the following new or updated software://' | grep '*' | sed 's/*//'`
## If there are no Apple updates then create new variable for noau set to No apple updates
if [ "$appleUpdates" == "" ];then
noau="No Apple Updates"
## If there are Apple updates set variable noau to nothing
else
noau=""
fi
## Check for JAMF waiting room, if so create variable for geting the results of waiting room command
if [ -d /Library/Application\ Support/JAMF/Waiting\ Room ];then
result=`/bin/ls -1 /Library/Application\ Support/JAMF/Waiting\ Room/ 2> /dev/null | /usr/bin/grep -v ".cache.xml"`
fi
## If nothing in the waiting room create variable for no set it to No updates
if [ "$result" == "" ];then
no="No updates"
## if we have something in the waiting room set variable no to nothing
else
no=""
fi
## Create a Cocoa Dialog textbox window
CD_APP="/Applications/Utilities/CocoaDialog.app"
CD="$CD_APP/Contents/MacOS/CocoaDialog"

$CD textbox ‑‑float --title "Updates" --informative-text "Checking for updates"  --button1 acknowledged --text "
Your last restart & update was on $UpdatesRunDate
Checking your computer for new updates waiting to install......

3rd Party updates: $no
$result

Apple Updates: $noau
$appleUpdates

Mac OS can’t install updates while the system is running.
If there are updates to install, simply restart and click "Yes".

Best practice is to restart and click yes once a week.

If you have questions please contact the helpdesk.
EXT 6400 or helpdesk@collemcvoy.com

Thank you.
"
exit 0
