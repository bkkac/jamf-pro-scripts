#!/bin/bash
# COLLE+McVOY Script to remove packages cached by the JSS if they get stuck
# Will Pierce, created 130819
# Last modified 130819

if [ -e /Library/Application\ Support/JAMF/Waiting\ Room/ ]
then
echo "Removing cached packages"
rm -rf /Library/Application\ Support/JAMF/Waiting\ Room/
else
echo "Files Already Removed"
fi