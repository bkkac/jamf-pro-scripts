#!/bin/bash
####################################################################################################
#
# ABOUT THIS Extension Attribute
# NAME
#	user-picture-report.sh
#
# DESCRIPTION
# dscl read of the current loged in user picture
#	
# Data Type: String
# Inventory Display: Extension Attributes
####################################################################################################
#
# HISTORY
#
#	Version: 1.0
#
#	- Created by Will Pierce on 150622
#	- Version 1.0
#	-	20170511
#
####################################################################################################
#
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# This will read what the users picture is currently set to
result=`dscl . -read /Users/$user Picture | tail -1 | sed 's/^[ \t]*//'`
# If not set by dscl result will be "No such key: Picture"
#
echo "<result>$result</result>"
#
exit 0
