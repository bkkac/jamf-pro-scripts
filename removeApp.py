#!/usr/bin/python
#
##########################################################################
#
# ABOUT THIS PROGRAM
# Script to remove a Application
#
# Will Pierce
# 2019 07 30
#
##########################################################################
# Import modules to help
import os, glob, json, sys
#
# Import variables from JAMP PRO
removeApp = sys.arg[5]
#
# check to see that variables were imported
# try:
#     removeApp
# except NameError:
#     print "App name not imported from JAMF PRO"
# else:
#     print "App name imported from JAMF PRO"


if 'myVar' in locals():
  print "App name imported from JAMF PRO"
  pass
else:
    print "App name not imported from JAMF PRO"
    pass