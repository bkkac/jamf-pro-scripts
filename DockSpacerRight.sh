#!/bin/sh

#Get current user
user=`ls -l /dev/console | cut -d " " -f 4`

sudo -u $user defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'
killall Dock