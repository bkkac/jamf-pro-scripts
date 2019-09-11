#!/bin/bash
# https://www.jamf.com/blog/streamlining-your-macos-upgrade-process/
# Will Peirce
# 2019 05 16
#
##Heading to be used for jamfHelper

heading="Please wait as we prepare your computer for macOS Mojave…"

##Title to be used for jamfHelper

description="

This process will take approximately 5-10 minutes.

Once completed your computer will reboot and begin the upgrade."

##Icon to be used for jamfHelper

icon=Applications/Install\ macOS\ Mojave.app/Contents/Resources/InstallAssistant.icns

##Launch jamfHelper

/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs -title "" -icon "$icon" -heading "$heading" -description "$description" &

jamfHelperPID=$(echo $!)

##Start macOS Mojave Upgrade

/Applications/Install\ macOS\ Mojave.app/Contents/Resources/startosinstall --volume / --applicationpath /Applications/Install\ macOS\ Mojave.app --nointeraction --pidtosignal $jamfHelperPID &

exit 0