#!/bin/bash
## EA
#### Check to see if Adobe Remote Update Manager is installed, if so is the override file installed and correct?
#### If not trigger policy to install them and check again!
#### Will Pierce
#### February 12, 2015
## Version 1.1
## Use this in a policy scoped to only clients with a version of Create Suite installed.

## Location of your RemoteUpdateManager install should be
RUM=/usr/sbin/RemoteUpdateManager

##Location of your AdobeUpdater.Overrides file
updaterConfigFile=/Library/Application\ Support/Adobe/AAMUpdater/1.0/AdobeUpdater.Overrides
# /Library/Application\ Support/Adobe/AAMUpdater/1.0/AdobeUpdater.Overrides

# Path to your preferences 
cmPrefs=/Library/Preferences/com.cm.imaging
echo "RUMconfigInstalled version 1.1"
echo Is RUM installed?
sleep 2
	if [ -e $RUM ]; then
		echo "RUM installed set com.imaging RUM to RUMInstalled & check for AdobeUpdater.Overrides file"
		/usr/bin/defaults write $cmPrefs RUM "RUMInstalled"
		sleep 2
		if [ -f "$updaterConfigFile" ]; then
			sleep 2
			echo "AdobeUpdater.Overrides file found set result as AdobeUpdater.Overrides"
			# clean up the result so it only shows what we want
			result=`/bin/cat "$updaterConfigFile" | grep -m 1 "Domain" | sed -e 's/<[^>]*>//g' | sed 's:http\://::g' | awk '{print $1}'`
			sleep 2
			echo Setting preference of com.cm.imaging AdobeUpdater.Overrides
			/usr/bin/defaults write $cmPrefs AdobeUpdater.Overrides "$result"
			sleep 2
			echo Exit this script RUM and AdobeUpdater.Overrides file are installed and Preferences are set
			exit 0
		else 
			echo "AdobeUpdater.Overrides file NOT found, set result as NO-AdobeUpdater.Overrides file"	
			/usr/bin/defaults write /Library/Preferences/com.cm.imaging AdobeUpdater.Overrides "NO-AdobeUpdater.Overrides"
			sleep 2
			echo Triggering policy to install RUM and AdobeUpdater.Overrides file
			/usr/sbin/jamf policy -trigger InstallRUM
			echo Hold for policy to compleate
			wait
		fi
	else
		echo RUM not installed lets install it....
		/usr/bin/defaults write /Library/Preferences/com.cm.imaging RUM "RUMnotInstalled"
		## Trigger policy to install RUM and AdobeUpdater.Overrides file
		/usr/sbin/jamf policy -trigger InstallRUM
		wait
	fi

echo Run through again as something was missing.....
if [ -e $RUM ]; then
		echo "RUM installed set com.imaging RUM to RUMInstalled & check for AdobeUpdater.Overrides file"
		/usr/bin/defaults write /Library/Preferences/com.cm.imaging RUM "RUMInstalled"
		## is the AdobeUpdater.Overrides file installed?
		if [ -f "$updaterConfigFile" ]; then
			echo "AdobeUpdater.Overrides file found set result as AdobeUpdater.Overrides"
			result=`/bin/cat "$updaterConfigFile" | grep -m 1 "Domain" | sed -e 's/<[^>]*>//g' | sed 's:http\://::g' | awk '{print $1}'`
			## Set a preference to com.cm.imaging
			/usr/bin/defaults write /Library/Preferences/com.cm.imaging AdobeUpdater.Overrides "$result"
			echo Exit this script RUM and AdobeUpdater.Overrides file are installed
			exit 0
		else 
			echo "AdobeUpdater.Overrides file NOT found, set result as NO-AdobeUpdater.Overrides file"	
			/usr/bin/defaults write /Library/Preferences/com.cm.imaging AdobeUpdater.Overrides "NO-AdobeUpdater.Overrides"
			## Trigger policy to install RUM and AdobeUpdater.Overrides file
			/usr/sbin/jamf policy -trigger InstallRUM
			## Check the AdobeUpdater.Overrides again
			result=`/bin/cat "$updaterConfigFile" | grep -m 1 "Domain" | sed -e 's/<[^>]*>//g' | sed 's:http\://::g' | awk '{print $1}'`
			## Set a preference to com.cm.imaging
			/usr/bin/defaults write /Library/Preferences/com.cm.imaging AdobeUpdater.Overrides "$result"
			echo RUM and AdobeUpdater.Overrides file now installed exit script
			exit 0

		fi
	else
		echo RUM not installed lets install it....
	/usr/bin/defaults write /Library/Preferences/com.cm.imaging RUM "RUMnotInstalled"
	## Trigger policy to install RUM and AdobeUpdater.Overrides file
	/usr/sbin/jamf policy -trigger InstallRUM
	wait
	fi

echo All is good now exit.
exit 0