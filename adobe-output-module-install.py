#!/usr/bin/python
# Adobe Output Module Install 
# From the Studio_Deployment Folder.
# Will Pierce
# Monday, May 8, 2017
# https://helpx.adobe.com/bridge/kb/install-output-module-bridge-cc.html
# 
# Copy the Adobe Output Module folder into the Bridge CC 201X Extensions folder in
# /Library/Application Support/Adobe/Bridge CC 201X Extensions
#
# Copy the AdobeOutputModule.workspace file into the Workspaces folder 
# under the Bridge CC 201X Extensions folder (the same folder referenced above).
# Imports
import os, shutil
from distutils.dir_util import copy_tree
#
# Variables 
# Full path to the files we want to install or Source src
installingFilePath01 = "/Users/Shared/Studio_Deployment/Adobe_Output_Module"
installingFile01 = "AdobeOutputModule.workspace"
#
installingFilePath02 = "/Users/Shared/Studio_Deployment/Adobe_Output_Module"
installingFile02 = "Adobe Output Module"
#
# Path we want to install the files to or destination dst
# This is the prefix
bridgeInstallPathPrefix = "/Library/Application Support/Adobe/"
# We need to add this to the app name to create the full dst path
# We need two destination paths ##
bridgeInstallPath01 = " Extensions/Workspaces"
bridgeInstallPath02 = " Extensions"
#
# JAMF Helper variables
# Amount of time each window is shown to the user
messageWindowTimeOut = "5"
# Title of window to user
messageWindowTitle = "Studio Installer 5000 beta v0.5"
#
# Module for JAMF Helper message with time out
def jamfHelperMessageTimeOut(windowHeading, messageText):
    # path to JAMF Helper
    jh = "/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    # iconPath = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns"
    button1Text = "OK"
    # os.system("%s -windowType hud -title '%s' -heading '%s' -icon %s -iconSize 128 -timeout '%s' -cancelButton 1 -description '%s'" %
    os.system("%s -windowType hud -title '%s' -heading '%s' -timeout '%s' -cancelButton 1 -description '%s'" %
            # (jh, messageWindowTitle, windowHeading, iconPath, messageWindowTimeOut, messageText))
            (jh, messageWindowTitle, windowHeading, messageWindowTimeOut, messageText))
# Example call
# jamfHelperMessageTimeOut("Did not find", "Looks like something went wrong. . .")
#
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Function to test if the installing file is available
def checkForFile(installingFile,installingFilePath):
    print "Checking for %s in %s " % (installingFile, installingFilePath)
    jamfHelperMessageTimeOut("Checking for:", "%s \nIn:\n%s" %
                             (installingFile, installingFilePath))
    if os.path.exists(os.path.join(installingFilePath, installingFile)):
        print "%s is found we can continue." % installingFile
        jamfHelperMessageTimeOut("Found:", "%s\nIn: \n%s.\nWe can continue." % (
            installingFile, installingFilePath))
        print
    else:
        jamfHelperMessageOK("File NOT found.", "%s\nNOT found in:\n%s \nRun - Studio Deployment \nFrom Self Service to fix." %
                            (installingFile, installingFilePath))
        quit()
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
## Function for finding installed versions of a given application
def appsInstalled(appName):
    applicationSearchPath = "/Applications"
    print "Checking for installed versions of %s" % appName
    jamfHelperMessageTimeOut(
        "'%s'"% appName, "Checking for installed versions. . .",)
    appNameVersions = appName + 'Versions'
    appNameVersions = []
    for paths in os.listdir(applicationSearchPath):
        if os.path.isdir(os.path.join(applicationSearchPath, paths)) and appName in paths:
            appNameVersions.append(paths)
    # Now print the installed versions of the app
    appNameVersionsList = '\n'.join(appNameVersions)
    if not appNameVersions:
        appNameVersionsList = "None found."
    print "Installed versions of %s are:" % appName
    print '%s' % appNameVersionsList
    jamfHelperMessageTimeOut(
        "%s" % appName, "Installed versions:\n%s" % appNameVersionsList)
    return appNameVersions
    print "- - -"
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Function for checking previous installs and installing if necessary
# Call after calling function appsInstalled
def previousInstallCheck(appVersions, appInstallPathPrefix, appInstallPath, installingFile, installingFilePath):
    for appVersion in appVersions:
        print "Module previousInstallCheck ----------"
        # In this case we need to remove 'Adobe' from the appVersion
        appVersion = appVersion.strip( 'Adobe ' )
        # Create variables for the full paths of src and dst makes calling them easer latter on
        installingFileFullPathSrc = os.path.join(installingFilePath, installingFile)
        installingFileFullPathDst = os.path.join(appInstallPathPrefix,appVersion+appInstallPath,installingFile)
        #
        print "The full path of the source file is: \n%s" % installingFileFullPathDst
        print "The full path of the detestation file is: \n%s" % installingFileFullPathDst
        #
        print "Checking for previous and or current install of:\n\t%s" % installingFileFullPathDst
        print "In:\n\t %s" % appVersion
        # 
        jamfHelperMessageTimeOut("%s Checking For:         "% appVersion, "%s" % (installingFileFullPathDst))
        #
        if os.path.exists(installingFileFullPathDst):
            print "Found:\n\t", installingFileFullPathDst
            print "\tNo need for any action."
            print
            jamfHelperMessageTimeOut("%s Found:                  "%appVersion, "%s \nNo need for any action." % (installingFileFullPathDst))
        else:
            print
            # Do we need to create this list? Yes we need it for the check
            appVersionsInstall = []
            appVersionsInstall.append(appVersion)
            #
            print "Previous install of:\n\t%s \n \tNOT found.\n \tInstalling now. . . " % installingFileFullPathDst
            jamfHelperMessageTimeOut("Did not find:            ","%s \nIn: %s"% (installingFileFullPathDst, appVersion))
            print
            print "Installing:", installingFileFullPathSrc, "\n\tto:\n\t", installingFileFullPathDst
            jamfHelperMessageTimeOut("Installing          ",  "%s\nTo:\n%s" %(installingFileFullPathSrc,installingFileFullPathDst))
            print
            #  ---------- ---------- ---------- ---------- ---------- ---------- -----
            # What if it is a folder?
            if os.path.isdir(installingFileFullPathSrc) == True:
                print "It is a folder. . . ."
                copy_tree(installingFileFullPathSrc, installingFileFullPathDst)
            else:
                print "it is a file. . . "
                shutil.copy2(installingFileFullPathSrc, installingFileFullPathDst)
            # Check that the installs worked....
            # BUT ONLY FOR THE ONE NOT FOUND  -------------
            for appVersion in appVersionsInstall:
                print "\tChecking the instillation of:\n\t", installingFileFullPathDst
                jamfHelperMessageTimeOut("Checking instillation of:", "%s" % (installingFileFullPathDst))
                if os.path.exists(installingFileFullPathDst):
                    print "\tFound:\n\t", installingFileFullPathDst, "\n\tAnd there was much rejoicing!"
                    jamfHelperMessageTimeOut("Installation successful", "Found:\n%s \n\nAnd there was much rejoicing!" % (installingFileFullPathDst))
                    print
                else:
                    print "\tDid not find", installingFileFullPathDst
                    print "\tLooks like something went wrong. . ."
                    jamfHelperMessageTimeOut("Did not find:", "%s" % installingFileFullPathDst)
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Get the list of versions installed
masterAppsInstalled = appsInstalled('Bridge')
# Check for file01
previousInstallCheck(masterAppsInstalled, bridgeInstallPathPrefix, bridgeInstallPath01, installingFile01, installingFilePath01)
# Check for file02
previousInstallCheck(masterAppsInstalled, bridgeInstallPathPrefix, bridgeInstallPath02, installingFile02, installingFilePath02)
