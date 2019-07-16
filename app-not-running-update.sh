#!/bin/bash

#### Check to see if app is running so we can update apps in the back ground when not running.
#### Will Pierce
#### February 11, 2015
# update 20160902
# update 20170612
####################################################################################################
# HARDCODED VALUES ARE SET HERE
# $4
# The name of the app
process=""
# $5
policyID=""
# $6
policyName=""
#
echo 
echo ---------- appRunning.sh Start #Pretty up the logs eh!
####################################################################################################
# Check Parameter Values variables from the JSS
# Parameter 4 = Name of application to launch.
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "process"
if [ "$4" != "" ] && [ "$process" == "" ];then
    process=$4
fi
#
if [ "$5" != "" ] && [ "$policyID" == "" ];then
    policyID=$5
fi
if [ "$6" != "" ] && [ "$policyName" == "" ];then
    policyName=$6
fi
####################################################################################################
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
#
processrunning=$(pgrep -i "$process")
if [[ $processrunning != "" ]] 
then
     echo $process "is running. Dont do anything."
     # jamf policy -id #####
else
     echo $process " is NOT running. Run policy $policyName without notification."
     wait
     jamf policy -id $policyID
     wait
fi
exit 0

