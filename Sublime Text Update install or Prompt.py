#!/usr/bin/python
# Script to see if a user is in an app you Do not wnat to disturb them if they are useing.
# If not then check to see if they have an app open you want to update.
# If so prompt them to update.
#
# Will Pierce
# 20061109 Turmp can go jump in a lake.
#
import time, datetime, os, subprocess, AppKit, sys
from AppKit import NSWorkspace
# ---------- ---------- ---------- ---------- ----------
# Set the variables here eh
# The name of the script
scriptName = "applicationUpdatePrompt.py"
jamfHelper = "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
#
# The name of the application that if is the current active app dont do anything or the
# Do not disturb application 
doNotDisturbApplication  = "Microsoft PowerPoint"
#
# Then name of the application you want to see if is runnig so you can update it
process_name= "Sublime Text" # change this to the name of your process
# ---------- ---------- ---------- ---------- ----------
# Time delay for testing
# time.sleep(5)
#
# Get the active app name
active_app_name = NSWorkspace.sharedWorkspace().frontmostApplication().localizedName()
# 
print "---------- ---------- ---------- ---------- ----------"
print "Runnig script %s " % scriptName
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
# Test to see if Do not disturb application is active
print ""
print "Checking to see if %s is the current active app." % doNotDisturbApplication 
#
# If it IS
if active_app_name == doNotDisturbApplication :
	print ""
	print "%s is active don't do anything." % doNotDisturbApplication
	print "End script %s " % scriptName
	print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
	print "---------- ---------- ---------- ---------- ----------"
	sys.exit()
#
# If is NOT
else:
	print "The actave app is %s." % active_app_name
	print ""
	print "%s is NOT active. OK to prompt user." % doNotDisturbApplication 
	# Do stuff now
	# subprocess.call(["say", "%s", "is not running. Do some stuff."]) % doNotDisturbApplication 
	# subprocess.call(["sudo", "jamf", "policy", "-id" "2583"])
	# jamf policy -id 2583
print
# Check for process_name runnings
tmp = os.popen("ps -Af").read()
# If process_name is NOT running
if process_name not in tmp[:]:
    print "%s is not running. OK to install cached updater." % process_name
    # Kick off JAMF Policy to install cached update
	# print "End script %s " % scriptName
	# print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
	# print "---------- ---------- ---------- ---------- ----------"
	# sys.exit()
# If it is running
else:
    print "%s is running. Lets prompt user to save and quit." % process_name
    print ""
    # Kick off JAMF policy to prompt user with JAMF Helper
    # subprocess.call(["sudo", "jamf", "policy", "-id" "2583"])
print "End script %s " % scriptName
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
print "---------- ---------- ---------- ---------- ----------"
