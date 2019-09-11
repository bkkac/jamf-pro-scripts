#!/bin/bash
####################################################################################################
#
# ABOUT THIS PROGRAM
# NAME
scriptName="outlookFontSet.sh"
#
# SYNOPSIS
# Set Outlook default font
# https://github.com/pbowden-msft/OutlookFontPoke#
# Requirements: 
# 	/Users/Shared/OutlookFontPoke-master/TemplateRegDB.reg
#	/Users/Shared/OutlookFontPoke-master/OutlookFontPoke
# DESCRIPTION
# Microsoft Outlook 2016 for Mac Default Font Changer - 1.2
# Purpose: Sets the default compose and reply/forward fonts in Outlook 2016 for Mac
# Usage: OutlookFontPoke <font-name> <font-size> <font-color>
# Example: OutlookFontPoke 'Helvetica' '11.0pt' 'gray'

####################################################################################################
#
# HISTORY
#
scriptVersion="1.0"
#
#	- Created by Will Pierce on 20170810
#	- 
#
####################################################################################################
#
echo "starting script: $scriptName Ver: $scriptVersion"
###Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
echo "logged in user is:"
echo $user
# Run commands as current logged in user
# sudo -u $user /Users/Shared/OutlookFontPoke-master/OutlookFontPoke 'Arial' '14.0pt' 'black'
sudo -u $user /Users/Shared/OutlookFontPoke-master/OutlookFontPoke 'Arial' '11.0pt' 'black'

#
exit 0