#!/bin/bash
#
####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#	configUsed.sh -- Creates a plist com.XX.imaging.plist for imageing date and configuration used. 
#	So we can use the info in the JSS.
#
# SYNOPSIS
#
# 	What configuration was used at image time
#	Examples:
#	Studio
#	Creative
#	I.I.
#
# DESCRIPTION
#	Wright to the plist, /Library/Preferences/com.XX.imaging values ImageBuildDate ( hard coded to the date) & config.
####################################################################################################
#
# HISTORY
#
version="1.3"
#
#	- Created by Will Pierce on 130225
#	- modified from https://jamfnation.jamfsoftware.com/discussion.html?id=4120
#	- Modified  150604
#	- Updated to use -array & -array-add for smart configurations.
#
####################################################################################################
#
# HARDCODED VALUES ARE SET HERE
# What kind of configuration are you using?
# Standard or Smart?
# Examples:
# configType="smart"
# configType="standard"
configType="smart"
#
# What is the name of the config?
# Examples: 
# config="XX_10.10_BASE"
# config="Studio"
#
config="smart_test07"
#	
####################################################################################################
# 
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################
# Get the date and set it to variable the_date
the_date=`date "+%Y-%m-%d"`
# 
# echoes for the pretty logs...
echo -----
echo "Start script configUsed.sh $version"
echo -----
#
# Check to see if config os set correctly
	if [ $configType ==  standard ] || [ $configType == smart ]; then
		echo configType -$configType- found, setting...
	else
		echo configType not set corectly, exiting....
		exit 1
	fi
# Check to see what configType is set to
	if [ $configType ==  standard ]; then
		arrayType="-array"
	else
		arrayType="-array-add"
		# config=/$config
	fi
#
echo "Configuration is: $config"
echo "arrayType is $arrayType"
echo -----
####################################################################################################
#
echo "Writing to: /Library/Preferences/com.XX.imaging Configuration $arrayType"
#
# Wright to: /Library/Preferences/com.XX.imaging Configuration
# use -array for the first config, then -array-add for the configs based on smart configs.
# Creative Studio for example
/usr/bin/defaults write /Library/Preferences/com.XX.imaging Configuration "$arrayType" "$config"
# -array "$( echo 'foo bar' )"
echo $config
echo "Checking on wright to Configuration..."
# Check that the wright....
ConfigurationCheck=`/usr/bin/defaults read /Library/Preferences/com.XX.imaging Configuration`
	if [[ $ConfigurationCheck == *$config* ]];then
		echo "Confirmed, Configuration value is $ConfigurationCheck"
	else
		echo "Something went wrong ImageBuildDate value is $ConfigurationCheck"
	fi
####################################################################################################
echo -----
echo "Writing the date to: /Library/Preferences/com.XX.imaging ImageBuildDate"
# now wright the date to: /Library/Preferences/com.XX.imaging ImageBuildDate
/usr/bin/defaults write /Library/Preferences/com.XX.imaging ImageBuildDate "$the_date" 
#
echo "Checking on wright to ImageBuildDate..."
# Check that the wright....
ImageBuildDateCheck=`/usr/bin/defaults read /Library/Preferences/com.XX.imaging ImageBuildDate`
	if [ $ImageBuildDateCheck == $the_date ];then
		echo "Confirmed, ImageBuildDate value is $ImageBuildDateCheck"
	else
		echo "Something went wrong ImageBuildDate value is $ImageBuildDateCheck"
	fi
#
echo "End script configUsed.sh $version"
echo -----
exit 0