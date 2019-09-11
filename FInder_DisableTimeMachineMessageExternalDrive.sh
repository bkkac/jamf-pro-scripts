#!/bin/sh

# Disable Time Machines pop-up message whenever an external drive is plugged in
defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true