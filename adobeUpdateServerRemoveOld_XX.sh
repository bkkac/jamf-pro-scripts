#!/bin/sh
## Script to remove the old Adobe Update Server URL that points to XX 
## Check to see if there a confg file if so remove it.
## If so remove 
# 
#----------
if [ -f /Library/Application\ Support/Adobe/AAMUpdater/1.0/AdobeUpdater.Overrides ];
then
	echo "AdobeUpdater.Overrides exists, removing..."
	rm /Library/Application\ Support/Adobe/AAMUpdater/1.0/AdobeUpdater.Overrides
else
   echo "AdobeUpdater.Overrides does not exist."
fi
#---------------

exit 0
