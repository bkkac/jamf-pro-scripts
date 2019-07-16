#!/bin/bash	

# Move the Photos.app to the Users/macroot/Library/Applications_Hidden folder
# This will prevent users finding Photos in the Applications folder, it will also not show in a spotlight search.
# Will Pierce
# May 11, 2015
# Set variables
hiddenFolder="/Users/macroot/Library/Applications_Hidden/"

# check for the the Applications_Hidden folder
if [ ! -d "$hiddenFolder" ]; then
	echo "$hiddenFolder NOT found, creating..."

	# make the Applications_Hidden folder
	mkdir $hiddenFolder

	# Test to see that it was created
			if [ -d "$hiddenFolder" ]; then
				echo "$hiddenFolder created."
					else
						echo "Users/macroot/Library/Applications_Hidden/ NOT created something went wrong."
			fi
	else
		echo "$hiddenFolder folder found."
fi

# Check to see if Photos.app is installed 
if [ -e /Applications/Photos.app ]; then
	echo "Photos.app found moving to /Users/macroot/Library/Applications_Hidden"

	# Move the Photos app to Applications_Hidden
	mv /Applications/Photos.app $hiddenFolder

	# Test that it was moved
	# Make sure Photos.app is gone			Make sure Photos.app is now in /Users/macroot/Library/Applications_Hidden
	if [ ! -e /Applications/Photos.app ] && [ -e $hiddenFolder/Photos.app ]; then
		echo "Photos.app moved from Applications folder to macroot/Library/Applications_Hidden successfully"
		echo "Setting Spotlight to re index"
			# erase the Spotlight index
 			mdutil -E /

 			# turn Spotlight indexing off
 			mdutil -i off /

 			# turn Spotlight indexing back on
 			mdutil -i on /
		else
			echo "something went wrong Photos.app not in Applications and not in /Users/macroot/Library/Applications_Hidden"
	fi
else
	echo "Photos.app NOT found, nothing to move."
fi 

exit 0