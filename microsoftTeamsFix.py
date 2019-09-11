#!/usr/bin/python
# Script to fix Microsoft Teams.
# Will Pierce
# 20170103
# delete these folders: 
# ~/Library/Caches/com.microsoft.teams 
# ~/Library/Caches/com.microsoft.teams.shipit 
# ~/Library/Application Support/Microsoft/Teams
# need to add logic for if caches not found, dont quit teams.
from SystemConfiguration import SCDynamicStoreCopyConsoleUser
import sys, os.path, shutil, subprocess, os, time, datetime				
# Get current logged username
file_name = os.path.basename(sys.argv[0])
#
username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]
# ----- vars for the folders to delete
# libraryCaches ='/Library/Caches'
teamsCashes = '/Users/%s/Library/Caches/com.microsoft.teams' %(username)
teamsCashesShipit = '/Users/%s/Library/Caches/com.microsoft.teams.shipit' %(username)
teamsAppSupport = '/Users/%s/Library/Application Support/com.microsoft.teams' %(username)
#Library/Application\ Support/com.microsoft.teams
# /Users/pierce/Library/Application\ Support/com.microsoft.teams  
print '%s is the current logged in useer...' %(username)
#
print "starting script "+file_name
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
# Quit Microsoft Teams
print "Quiting Microsoft Teams..."
subprocess.call(['osascript', '-e', 'tell application "Microsoft Teams" to quit'])
if os.path.isdir(teamsCashes):
	print "teamsCashes found, deleteing..."
	shutil.rmtree(teamsCashes)
else:
		print "teamsCashes not found"
#		
if os.path.isdir(teamsCashesShipit):
	print "teamsCashesShipit found, deleting..."
	shutil.rmtree(teamsCashesShipit)
else:
	print "teamsCashesShipit not found."
#
if os.path.isdir(teamsAppSupport):
	print "teamsAppSupport found, deleting..."
	shutil.rmtree(teamsAppSupport)
else:
	print "teamsAppSupport not found."

print "Ending script "+file_name
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
