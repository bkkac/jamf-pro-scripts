#!/bin/bash
# Set desktop backgrounds
# uses desktoppr
# https://github.com/scriptingosx/desktoppr
# WIll Pierce
# 2019 07 16
# No pont in running if desktoppr in not installed
# Check to see that desktoppr is installed
if [[ ! -e "/usr/local/bin/desktoppr" ]]; then
	echo "desktoppr NOT found."
	exit 0
    else echo "desktoppr found, lets do this."
fi
# set Variables
#
# Full path to the deskttops you want to use for screens 0 1 2 or leave blank to set with JAMF PRO
desktop_0="/Users/pierce/Desktop/elDorklo.jpg" 
desktop_1="/Users/pierce/Desktop/elDorklo.jpg" 
desktop_2="/Users/pierce/Desktop/Screen Shot 2019-06-17 at 10.28.00 AM.png"
#
# Check Parameter Values variables from the JSS
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "desktop_0"
if [ "$4" != "" ] && [ "$desktop_0" == "" ];then
    desktop_0=$4
fi
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "desktop_1"
if [ "$5" != "" ] && [ "$desktop_1" == "" ];then
    desktop_1=$5
fi
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "desktop_2"
if [ "$6" != "" ] && [ "$desktop_2" == "" ];then
    desktop_2=$6
fi
#
# Get cutent loged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
#
# Check if the Desktops exist
echo
echo "Checking for:" $desktop_0 ". . ."
# 
if [[ -f "$desktop_0" ]]
then
    # If exists then do this
    echo "$desktop_0 found setting desktop picture..."
    # Set the actual desktop picture
    su - $user -c "desktoppr 0 '$desktop_0'"
else 
    echo "$desktop_0 not found skipping..."
fi
#
echo "Checking for:" $desktop_1 ". . ."
# 
if [[ -f "$desktop_1" ]]
then
    # If exists then do this
    echo "$desktop_1 found setting desktop picture..."
    # Set the actual desktop picture
    su - $user -c "desktoppr 1 '$desktop_1'"
else 
    echo "$desktop_1 not found skipping..."
fi
#
echo "Checking for:" $desktop_2 ". . ."
# 
if [[ -f "$desktop_2" ]]
then
    # If exists then do this
    echo "$desktop_2 found setting desktop picture..."
    # Set the actual desktop picture
    su - $user -c "desktoppr 2 '$desktop_2'"
else 
    echo "$desktop_2 not found skipping..."
fi