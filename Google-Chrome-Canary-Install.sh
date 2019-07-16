#!/bin/sh
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	Google-Chrome-Canary-Install.sh -- Installs the latest Google Chrome Canary version
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Joe Farage, 17.03.2015
#	
#	Version: 2.0
#	- Will Pierce, 20170606
####################################################################################################
# Script to download and install Google Chrome Canary.
# Only works on Intel systems.

dmgfile="googlechrome.dmg"
volname="Google Chrome Canary"
logfile="/Library/Logs/Google-Chrome-Canary-Install-Script.log"

url='https://dl.google.com/release2/q/canary/googlechrome.dmg'

# Are we running on Intel?
if [ '`/usr/bin/uname -p`'="i386" -o '`/usr/bin/uname -p`'="x86_64" ]; then
		/bin/echo "--" >> ${logfile}
		/bin/echo "`date`: Downloading latest version." >> ${logfile}
		/usr/bin/curl -s -o /tmp/${dmgfile} ${url}
		/bin/echo "`date`: Mounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet
		/bin/echo "`date`: Installing..." >> ${logfile}
		ditto -rsrc "/Volumes/${volname}/Google Chrome Canary.app" "/Applications/Google Chrome Canary.app"
		/bin/sleep 10
		/bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
		/usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep "${volname}" | awk '{print $1}') -quiet
		/bin/sleep 10
		/bin/echo "`date`: Deleting disk image." >> ${logfile}
		/bin/rm /tmp/"${dmgfile}"
else
	/bin/echo "`date`: ERROR: This script is for Intel Macs only." >> ${logfile}
fi

exit 0