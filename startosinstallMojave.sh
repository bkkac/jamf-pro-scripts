#!/bin/bash

/Applications/Install\ macOS\ Mojave.app/Contents/Resources/startosinstall --applicationpath "/Applications/Install macOS Mojave.app" --volume $1 --rebootdelay 10 --nointeraction
killall "Self Service"
