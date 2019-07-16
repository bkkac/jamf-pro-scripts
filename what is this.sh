#!/bin/bash
# Commands required by this script
declare -x awk="/usr/bin/awk"
declare -x sysctl="/usr/sbin/sysctl"
declare -x perl="/usr/bin/perl"

declare -xi DAY=86400
declare -xi EPOCH="$($perl -e "print time")"
declare -xi UPTIME="$($sysctl kern.boottime |
                        $awk -F'[= ,]' '/sec/{print $6;exit}')"

declare -xi DIFF="$(($EPOCH - $UPTIME))"

if [ $DIFF -le $DAY ] ; then
        echo "<result>1</result>"
        ## Also set ARD computer info 1 to uptime
        /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set1 -1 "Uptime 1 day"
else
        echo "<result>$(($DIFF / $DAY))</result>"
        ## Also set ARD computer info 1 to uptime
        /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set1 -1 "Uptime $(($DIFF / $DAY)) Days"
fi