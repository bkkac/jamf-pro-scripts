#!/usr/bin/python
# Script to fix users Keychains .
# Will Pierce
# 2018 04 18
# delete this folder: 
# /Users/$USER/Library/Keychains/*
# 
from SystemConfiguration import SCDynamicStoreCopyConsoleUser
import sys, os.path, shutil, subprocess, os, time, datetime				
# Get current logged username
file_name = os.path.basename(sys.argv[0])
#
username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]
# ----- vars for the folders to delete
#
Keychains = '/Users/%s/Library/Keychains' %(username)
#
print '%s is the current logged in useer...' %(username)
#
print "starting script "+file_name
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
#
if os.path.isdir(Keychains):
	print "Keychains found, deleteing..."
	shutil.rmtree(Keychains)
else:
		print "Keychains not found"
#
print "Ending script "+file_name
print('Timestamp: {:%Y-%m-%d %H:%M:%S}'.format(datetime.datetime.now()))
