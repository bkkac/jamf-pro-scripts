#!/bin/sh
# Set the time and time zone on new computer provisions 

# systemsetup -settimezone America/Chicago
# set the time zone automatically using current location
defaults write /Library/Preferences/com.apple.timezone.auto.plist Active -bool false
systemsetup -setnetworktimeserver time.apple.com.