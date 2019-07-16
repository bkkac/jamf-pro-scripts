#!/bin/bash

outputVersion="Not Installed"

if [ -d /Applications/Microsoft\ Teams.app ]; then
    outputVersion=$(defaults read /Applications/Microsoft\ Teams.app/Contents/Info.plist CFBundleShortVersionString)
fi

echo "<result>$outputVersion</result>"
