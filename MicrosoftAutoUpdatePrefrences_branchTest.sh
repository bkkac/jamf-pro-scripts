#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# Script to Set Microsoft AutoUpdate 3.8 prefrences	for the Test Branch
# 
# NAME
scriptName=MicrosoftAutoUpdatePrefrences_branchTest.sh 
#
# SYNOPSIS
# http://macadmins.software/docs/MAU_38.pdf
#
# Requirements: 
# 	MAU 3.8 Office 2016
#
# DESCRIPTION
# Set prefrences for MAU TEST.
# 
####################################################################################################
#
# HISTORY
#
scriptVersion="1.1"
#
#	- Created by Will Pierce on 20161101
#	- Updates on 20161107
#
##################################################################################### User
#
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# ser a var for running commands as the logged in user
asUser="su -l $user -c"
##################################################################################### Logs
# For all the pretty logs. . . 
#
echo "--------- -------- ---------- ---------- ---------- ----------"
echo "Starting $scriptName $scriptVersion. . . "
echo "Writing com.microsoft.autoupdate2 (MAU) defaults for user $user. . ."
echo
###################################################################################### ChannelName
#
echo "Writing ChannelName. . ."
$asUser "defaults -currentHost write com.microsoft.autoupdate2 ChannelName -string 'External'"
#
channelName=`$asUser "defaults -currentHost read com.microsoft.autoupdate2 ChannelName"`
echo "com.microsoft.autoupdate2 ChannelName is now:" $channelName
echo
###################################################################################### DisableInsiderCheckbox
#
echo "writing DisableInsiderCheckbox. . ."
$asUser "defaults -currentHost write com.microsoft.autoupdate2 DisableInsiderCheckbox -bool FALSE"
#
disableInsiderCheckbox=`$asUser "defaults -currentHost read com.microsoft.autoupdate2 DisableInsiderCheckbox"`
# echo $disableInsiderCheckbox
if [ disableInsiderCheckbox == 0 ]; then
	disableInsiderCheckboxBool="Disabled"
else
	disableInsiderCheckboxBool="Not disabled"
fi
echo "com.microsoft.autoupdate2 DisableInsiderCheckbox is:" $disableInsiderCheckboxBool
echo

##################################################################################### ExtendedLogging
echo "Writing ExtendedLogging. . ."
$asUser "defaults -currentHost write com.microsoft.autoupdate2 ExtendedLogging -bool TRUE"
#
extendedLogging=`$asUser "defaults -currentHost read com.microsoft.autoupdate2 ExtendedLogging"`
# echo $extendedLogging
if [ extendedLogging == 0 ]; then
	extendedLogging="Off"
else
	extendedLogging="On"
fi
echo "com.microsoft.autoupdate2 ExtendedLogging is now:" $extendedLogging
echo
###################################################################################### HowToCheck
echo "Writing HowToCheck. . ."
$asUser "defaults -currentHost write com.microsoft.autoupdate2 HowToCheck -string 'AutomaticDownload'"
#
howToCheck=`$asUser "defaults -currentHost read com.microsoft.autoupdate2 HowToCheck"`
echo "com.microsoft.autoupdate2 HowToCheck is now:" $howToCheck
# 
####################################################################################################
# For down the road
# defaults write com.microsoft.autoupdate2 ManifestServer -string URL
#
# defaults write com.microsoft.autoupdate2 UpdateCache -string URL
####################################################################################################
#
echo
echo "Ending $scriptName $scriptVersion. . . "
echo "--------- -------- ---------- ---------- ---------- ----------"
exit 0