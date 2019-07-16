#!/bin/bash
# temp scrip for testing
app="Casper Admin.app"
## Get the currently logged in user
		user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
		# check to see if the app is in the dock
#
		dockTest=`dockutil --find "${app%.*}" /Users/$user`
#
			if [[ $dockTest != *not* ]]; then
				# It  - IS - in the dock, remove it
				echo "$app - IS - in the dock"
				dockutil --remove "${app%.*}" /Users/$user
				echo "Checking the app was removed from the dock..."
					sleep 7 # let the system cache up eh!
					# Run the command again
					dockTest2=`dockutil --find "${app%.*}" /Users/$user`
#
					if [[ $dockTest2 == *not* ]]; then
						echo "$app is - not - in the dock all is good"
						else
						echo "$app  - is - still in the dock something went wrong"
						exit 1
					fi


			else
				# it is NOT in the dock
				echo "$app is - NOT - in the dock"
			fi

	exit 0