#!/bin/bash
sudo jamf removeMdmProfile
sudo jamf mdm
sudo softwareupdate --clear-catalog
