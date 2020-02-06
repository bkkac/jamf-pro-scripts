#!/bin/sh
########################################################################################################
#
# Copyright (c) 2018, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################
# PURPOSE
# - Ensure computers maintain proper naming conventions, prompts for computer name
# - Provisioning based on policy
# HISTORY
#   Version 1.0
#   - Created by Jonathan Yuresko June 17, 2018
# 
####################################################################################################
jamfHelperPath="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
## this works when quoteing the the var
jh_icon="/Library/User Pictures/XX_Logo_512x512.png"
jamfPath="/usr/local/jamf/bin/jamf"
count="1"
#################################
# Creates Provisioning Log File #
#################################
log=~/Desktop/log.txt
/usr/bin/touch $log

##############################
# Jamf Helper Popup Window 1 #
##############################
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 1 of 3 Running first recon" -icon "$jh_icon" &

####################################
# First Recon to set Computer Name #
####################################
/bin/echo "Running recon"
# /usr/local/jamf/bin/jamf recon

#####################
# Stops Jamf Helper #
#####################
killAll jamfHelper

"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 Now Provisioning. . ." -icon "$jh_icon" &

###################################
# Writes data to provisioning log #
###################################
/bin/echo "
Build 1a" >> $log
dateStamp=$( date "+%a %b %d %H%M%S" )
/bin/echo "
Imaging started at $dateStamp
" >> $log

###################################
# Custom triggered policies begin #
###################################
killAll jamfHelper

###################################
# Google Chrome #
###################################
# /bin/echo "Installing Google Chrome"
# "$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing Google Chrome" -icon "$jh_icon" &

# $jamfPath policy -trigger provision_googlechrome
# chrome_version=$(mdls -name kMDItemVersion /Applications/Google\ Chrome.app | cut -c 19- | rev | cut -c 2- | rev)
# if [[ $chrome_version == *"could not find"* ]]; then
# 	# App is not installed
# 	/bin/echo "Google Chrome install FAILED" >> $log
# 	killAll jamfHelper
# 	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Google Chrome install FAILED" -icon "$jh_icon" &
# 	sleep 3
# else
# 	# App is installed
# 	killAll jamfHelper
# 	/bin/echo "Google Chrome $chrome_version - Installed Successfully" >> $log
# 	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Google Chrome Installed" -icon "$jh_icon" &
# 	sleep 3

# fi
# killAll jamfHelper

###################################
# Fire Fox #
###################################
let "count++"
/bin/echo "Installing Firefox"
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing FireFox" -icon "$jh_icon" &

/usr/local/jamf/bin/jamf policy -trigger provision_firefox 
firefox_version=$(mdls -name kMDItemVersion /Applications/Firefox.app | cut -c 19- | rev | cut -c 2- | rev)
if [[ $firefox_version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "Firefox install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count FireFox install FAILED" -icon "$jh_icon" &
	sleep 3
else
	# App is installed
	/bin/echo "Firefox $firefox_version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count FireFox Installed" -icon "$jh_icon" &
	sleep 3
fi
killAll jamfHelper

###################################
# Cisco AnyConnect Secure Mobility Client #
###################################
let "count++"
/bin/echo "Installing Cisco AnyConnect Secure Mobility Client"
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing Cisco AnyConnect Secure Mobility Client" -icon "$jh_icon" &

$jamfPath policy -trigger provision_anyConnect 
anyConnect_version=$(mdls -name kMDItemVersion /Applications/Cisco/Cisco\ AnyConnect\ Secure\ Mobility\ Client.app | cut -c 19- | rev | cut -c 2- | rev)
if [[ $anyConnect_version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "Cisco AnyConnect Secure Mobility Client install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Cisco AnyConnect Secure Mobility Client install FAILED" -icon "$jh_icon" &
	sleep 3
else
	# App is installed
	/bin/echo "Cisco AnyConnect Secure Mobility Client $anyConnect_version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Cisco AnyConnect Secure Mobility Client Installed" -icon "$jh_icon" &
	sleep 3
fi
###################################
# dockutil #
###################################
let "count++"
/bin/echo "Installing dockutil"
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing dockutil" -icon "$jh_icon" &

$jamfPath policy -trigger provision_dockutil 
dockutil_version=$(/usr/local/bin/dockutil --version)
if [[ $dockutil_version == *"could not find"* ]]; then
	# App is not installed
	/bin/echo "dockutil install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count dockutil install FAILED" -icon "$jh_icon" &
	sleep 3
else
	# App is installed
	/bin/echo "dockutil $dockutil_version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count dockutil Installed" -icon "$jh_icon" &
	sleep 3
fi
###################################
# Any Ricoh #
###################################
let "count++"
/bin/echo "Installing Any Ricoh"
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing Any Ricoh" -icon "$jh_icon" &

/usr/local/jamf/bin/jamf policy -trigger provision_anyRicoh 
anyRicoh_version=$(lpstat -d)

if [[ "$anyRicoh_version" == "system default destination: Any_Ricoh_MFP" ]]; then
	# App is installed
	/bin/echo "$anyRicoh_version - Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count $anyRicoh_version Is the default printer" -icon "$jh_icon" &
	sleep 3
else
	# App is not installed
	/bin/echo "Any Ricoh install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count Any Ricoh install FAILED" -icon "$jh_icon" &
	sleep 3
fi
killAll jamfHelper
###################################
# Campton Fonts #  camptonFonts
###################################
let "count++"
# /bin/echo "Installing  Campton Fonts" >> $log
"$jamfHelperPath" -startlaunchd -windowType hud -description "Step 2 of 3 - $count Installing  Campton Fonts" -icon "$jh_icon" &
/usr/local/jamf/bin/jamf policy -trigger provision_camptonFonts
camptonFonts_version=$(ls /Library/Fonts/ | grep "Campton")
if [[ -z "$camptonFonts_version" ]]; then
	# App is not installed
	/bin/echo "Campton Fonts install FAILED" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count Campton Fonts install FAILED" -icon "$jh_icon" &
	sleep 3
else
	# App is installed
	/bin/echo "Campton Fonts:" >> $log
	/bin/echo "$camptonFonts_version" >> $log
	/bin/echo "- Installed Successfully" >> $log
	killAll jamfHelper
	"$jamfHelperPath"  -startlaunchd -windowType hud -description "Step 2 of 3 - $count Campton Fonts Installed" -icon "$jh_icon" &
	sleep 3
fi
killAll jamfHelper

# /bin/echo "Installing BlueCoat"
# /usr/local/jamf/bin/jamf policy -trigger bluecoat 
# bluecoat_version=$(sudo launchctl list | grep -i com.bluecoat.ua)
# /bin/echo $bluecoat_version
# if [[ $bluecoat_version == "" ]]; then
# 	# App is not installed
# 	/bin/echo "BlueCoat install FAILED" >> $log
# else
# 	# App is installed
# 	/bin/echo "BlueCoat - Installed Successfully" >> $log
# fi

##############################
# Completes Provisioning log file #
##############################
log=/Users/Shared/Provisiong-log.txt
dateStamp=$( date "+%a %b %d %H%M%S" )
/bin/echo "
Provisioning completed at $dateStamp
" >> $log
bin/echo "
Provisioning completed at $dateStamp
"
#####################
# Stops Jamf Helper #
#####################
killAll jamfHelper

########################################
# Provisioning Complete, Jamf Helper Prompt #
########################################
userChoice=$("$jamfHelperPath" -windowType hud -description "Step 3 of 3  `Provisioning` Complete" -button2 "Restart" -icon "$jh_icon" &)
if [ "$userChoice" == "2" ]; then
    open ~/Desktop/log.txt
    killall Terminal
    exit
else
    exit 0
fi

