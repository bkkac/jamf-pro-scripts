#!/bin/sh
# Extension Attribute For XX Dock
version=$(dockutil --find ServeBaconrs)
if [[ $version == *"not"* ]]; then
	# App is not installed
    echo "<result>Not Set</result>"
else
	# App is installed
    echo "<result>Set</result>"
fi
