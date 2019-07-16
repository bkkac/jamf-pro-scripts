#!/bin/bash
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	GoogleChromeInstall.sh -- Installs the latest Google Chrome version
#
# SYNOPSIS
#	sudo GoogleChromeInstall.sh
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Joe Farage, 17.03.2015
#
####################################################################################################
# Script to download and install Google Earth.
# Only works on Intel systems.
# Edits by Will Pierce April 24, 2015
####################################################################################################
# Var for jamfHelper
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
# Var for the icon
icon="/Applications/Google Chrome.app/Contents/Resources/app.icns"

# Var for the date and time for use in script timing and display
the_date=`date "+%Y-%m-%d"`
the_time=`date "+%r"`

# Check to see if Google Chrome is installed, is is then update if not exit
	if [ -e /Applications/Google\ Chrome.app ]; then

	# Kick off a jamfHelper message stating the GoogleChrome update
	"$jamfHelper" -windowType hud -title "$the_time" -icon "$icon" -heading "Google Chrome" -description "Checking for Chrome..." -timeout 5 >&-


	dmgfile="googlechrome.dmg"
	volname="Google Chrome"
	logfile="/Library/Logs/GoogleChromeInstallScript.log"

	url='https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg'

			# Are we running on Intel?
			if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
					/bin/echo "--" >> ${logfile}
					/bin/echo "`date`: Downloading latest version." >> ${logfile}

					"$jamfHelper" -windowType hud -title "$the_time" -icon "$icon" -heading "Google Chrome" -description "Chrome found, Downloading latest version..." &

					/usr/bin/curl -s -o /tmp/${dmgfile} ${url}
					/bin/echo "`date`: Mounting installer disk image." >> ${logfile}

					/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet
					/bin/echo "`date`: Installing..." >> ${logfile}

						killall jamfHelper
						wait 2>/dev/null

					"$jamfHelper"  -windowType hud -title "$the_time" -icon "$icon" -heading "Google Chrome" -description "Installing latest version..." &

					ditto -rsrc "/Volumes/${volname}/Google Chrome.app" "/Applications/Google Chrome.app"
					/bin/sleep 10
					/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
					/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet
					/bin/sleep 10
					/bin/echo "`date`: Deleting disk image." >> ${logfile}
					/bin/rm /tmp/"${dmgfile}"
			else
				/bin/echo "`date`: ERROR: This script is for Intel Macs only." >> ${logfile}
			fi
	# Kill the jamfHelper after the install
	killall jamfHelper
	wait 2>/dev/null
	# New jamfHelper message that we are done installing Chrome
	"$jamfHelper" -windowType hud -title "$the_time" -icon "$icon" -timeout 5 -heading "Google Chrome" -description "Checking for updates... DONE" -timeout 5
	else
		echo "GoogleChrome not found."
		exit 0
	fi
exit 0