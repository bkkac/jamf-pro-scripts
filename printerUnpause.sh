#!/bin/bash
#####################################################################################################
#
# ABOUT THIS PROGRAM
# Script to alow users to unpause printers
# security authorizationdb write system.print.operator allow
#
# https://www.jamf.com/jamf-nation/discussions/6770/resuming-a-paused-printer-on-10-8
#
####################################################################################################
#
# HISTORY
#
#	Version: 1.1
#	- Will Pierce 2017 08 14
#
####################################################################################################
#

lpstat -p | grep -B 1 "Paused" | awk '{print $2}' | xargs -n 1 -I{} sudo cupsenable {}

exit 0