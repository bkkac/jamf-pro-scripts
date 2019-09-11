#!/bin/sh
# OLD 
# /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users macroot,sshroot -privs -all -restart -agent -menu -clientopts -setmenuextra -menuextra no
#
# https://www.jamf.com/jamf-nation/discussions/5178/enable-remote-management-with-managed-preference
# adminUser = Admin User Name for Remote Acces

adminUser="macroot,sshroot"

##################################
# Do Not Modify Below This Line  #
##################################

if [ "$4" != "" ] && [ "$adminUser" == "" ];then
    adminUser=$4
fi

# DEFINE CONTROL SETTINGS

privs="-DeleteFiles -ControlObserve -TextMessages -OpenQuitApps -GenerateReports -RestartShutDown -SendFiles -ChangeSettings"

# Do Not Modify Below This Line

if [ "$adminUser" != "" ]; then
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -allowAccessFor -specifiedUsers
    /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -access -on -privs $privs -users $adminUser
fi