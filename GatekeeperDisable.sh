#!/bin/sh

####################################################################################################
#
# Copyright  2015, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
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
#
# HISTORY
#
# Version 1.0 by Brock Walters July 14 2015
# Version 1.1 by Brock Walters January 22 2016
#
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   gatekeeper.sh -- Configure the OS X Gatekeeper settings
#
# SYNOPSIS
#   sudo gatekeeper.sh
#   sudo gatekeeper.sh <mountPoint> <computerName> <currentUsername> <gatekeeper>
#
# DESCRIPTION
#   
# The OS X Gatekeeper settings are located on the General tab of the Security & Privacy System
# Preferences Preference Pane. Use this script to set the radio buttons as desired.
#
# The script creates a copy of the System Policy database named "/private/var/db/SystemPolicy.bak"
# OS X default System Policy settings can be restored by deleting "/private/var/db/SystemPolicy"
# then copying "/private/var/db/.SystemPolicy-default" to "/private/var/db/SystemPolicy" Computers
# should be restarted after restoring older versions of the System Policy database.
#
####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
# 1 of the 3 exact text strings below associated with the Gatekeeper features must be used as
# the variable input value:
#
#     Mac App Store
#     Mac App Store and identified developers
#     Anywhere
# 
# Input the value by:
#
# - copying it into the parameter 4 field when using the script as the payload in a JSS policy
# - passing it as argument 4 of the command to run the script (see SYNOPSIS above for syntax)
# - hard-coding the value into the script below
#
# If hard-coding the "gatekeeper" variable copy & paste the string between the double quotes
# following the = sign, e.g., gatekeeper="Mac App Store"
#
####################################################################################################

gatekeeper=""

####################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

# determine if the script is being run by the root user

if [ $EUID -ne 0 ]
then
    echo
    >&2 /bin/echo "error: this script must be run as the root user!"
    echo
    exit
fi

# close System Preferences if running

process=$(ps -ax | grep "System Preferences" | awk '{print $1}')
for i in $process
do
    kill -9 $i &> /dev/null
done

# backup SystemPolicy db

if [ ! -f /private/var/db/SystemPolicy.bak ]
then
    cp /private/var/db/SystemPolicy{,.bak}
fi

# populate parameter 4 & set gatekeeper

if [ "$4" != "" ] && [ "$gatekeeper" == "" ]
then
    gatekeeper="$4"
fi
if [ "$gatekeeper" != "" ]
then
while true
    do
    case "$gatekeeper" in
        "Mac App Store" )
        if /usr/sbin/spctl --status | grep -q "assessments disabled"
        then
            /usr/sbin/spctl --master-enable
        fi
        /usr/sbin/spctl --disable --rule {7,6}
        >&2 echo "setting Gatekeeper to Mac App Store"
        break
        ;;
        "Mac App Store and identified developers" )
        if /usr/sbin/spctl --status | grep -q "assessments disabled"
        then
            /usr/sbin/spctl --master-enable
        fi
        /usr/sbin/spctl --enable --rule {8,7,6,5,4}
        >&2 echo "setting Gatekeeper to Mac App Store and identified developers"
        break
        ;;
        "Anywhere" )
        if /usr/sbin/spctl --status | grep "assessments disabled"
        then
            break
        else
            /usr/sbin/spctl --master-disable
        fi
        >&2 echo "disabling Gatekeeper"
        ;;
        * )
        >&2 /bin/echo "error: the gatekeeper variable is not populated correctly."
        exit
        ;;
    esac
    done
else
    >&2 /bin/echo "error: the gatekeeper variable is not populated."
fi