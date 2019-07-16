#!/bin/bash
# in this script, COMPANY WiFi can be replaced with whatever your particular SSID is named.

SSIDS=$(networksetup -listpreferredwirelessnetworks "en0" | sed '1d')
CURRENTSSID=$(networksetup -getairportnetwork "en0" | sed 's/^Current Wi-Fi Network: //')

while read -r SSID; do
  if [ "$SSID" == "CMTrusted" ]; then
    echo Skipping $SSID
  elif [ "$SSID" == "$CURRENTSSID" ]; then
    echo Skipping your current network $SSID
  else
    echo Deleting $SSID
    networksetup -removepreferredwirelessnetwork "en0" "$SSID"
  fi
done <<< "$SSIDS"

echo Done!