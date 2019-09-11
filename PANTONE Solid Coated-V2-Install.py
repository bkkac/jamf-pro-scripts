#!/usr/bin/python
# Problem:
# Need to find all versions of PhotoShop, Illustrator, and InDesign installed
# Then instill a plug in or other thing like PANTONE swatches
# Will Pierce
# 20170330
# Updated 
# 2018 02 05
# TO DO:
# Move file to module so we can call more then one file
# Imports
import os
import shutil
import subprocess
#
# Variables
#
# Where should we check to see if the file is already installed?
searchPath = "/Applications"
#
# If the file is not installed where is the cached file?
# Typically part of a JAMF policy to place the file in /private/tmp
# installingFilePath = "/private/tmp/"
installingFilePath = "/Users/Shared/Studio_Deployment/"
#
# What is the name of the file to install?
installingFile = "PANTONE+ Solid Coated-V2.acb"
#
# Sometimes there are different paths for each application,
# if so what are they?
photoShopInstallPath = "Presets/Color Books/"
illustratorInstallPath = "Presets.localized/en_US/Swatches/Color Books"
inDesignInstallPath = "Presets/Swatch Libraries"
# Amout of time eatch window is shown to the user
messageWindowTimeOut = "5"
# Title of window to user
messageWindowTitle = "File CheckBot 5000 v1.0"
print
print "---------- Begin install check of %s ----------" % installingFile
#
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Module for JAMF Helper message with time out
def jamfHelperMessageTimeOut(windowHeading, messageText):
    # path to JAMF Helper
    jh = "/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    iconPath = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns"
    button1Text = "OK"
    os.system("%s -windowType hud -title '%s' -heading '%s' -icon %s -iconSize 128 -timeout '%s' -cancelButton 1 -description '%s'" %
              (jh, messageWindowTitle, windowHeading.replace('Adobe',''), iconPath, messageWindowTimeOut, messageText))
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Module for JAMF Helper message with OK button
def jamfHelperMessageOK(windowHeading, messageText):
    # path to JAMF Helper
    jh = "/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    iconPath = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns"
    button1Text = "OK"
    os.system("%s -windowType hud -title '%s' -heading '%s' -icon %s -button1 '%s' -cancelButton 1 -description '%s'" %
              (jh, messageWindowTitle, windowHeading, iconPath, button1Text, messageText))
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Module for checking for the installFile
def checkForFile():
    print "Checking for %s in %s " % (installingFile, installingFilePath)
    jamfHelperMessageTimeOut("Checking for:", "%s \nIn:\n%s" %
                             (installingFile, installingFilePath))
    if os.path.isfile(os.path.join(installingFilePath, installingFile)):
        print "%s is found we can continue." % installingFile
        jamfHelperMessageTimeOut("Found:", "%s\nIn: \n%s.\nWe can continue." % (
            installingFile, installingFilePath))
        print
    else:
        jamfHelperMessageOK("File NOT found.", "%s\nNOT found in:\n%s \nRun - Studio Deployment \nFrom Self Service to fix." %
                            (installingFile, installingFilePath))
        quit()
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Function for finding installed versions of apps
def appsInstalled(appName):
    print "Checking for installed versions of %s" % appName
    jamfHelperMessageTimeOut(
        "'%s'"% appName, "Checking for installed versions. . .",)
    appNameVersions = appName + 'Versions'
    appNameVersions = []
    for paths in os.listdir(searchPath):
        if os.path.isdir(os.path.join(searchPath, paths)) and appName in paths:
            appNameVersions.append(paths)
    # Now print the installed versions of the app
    appNameVersionsList = '\n'.join(appNameVersions)
    if not appNameVersions:
        appNameVersionsList = "None found."
    print "Installed versions of %s are:" % appName
    print '\t %s' % appNameVersionsList
    jamfHelperMessageTimeOut(
        "%s" % appName, "Installed versions:\n%s" % appNameVersionsList)
    return appNameVersions
    print "- - -"
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Function for checking previous installs and installing if necessary
# Run after finding all installed app versions
def previousInstallCheck(appVersions, appInstallPath):
    for f in appVersions:
        print
        print "Checking for previous and or current install of:\n\t%s" % installingFile
        print "In:\n\t %s" % f
        jamfHelperMessageTimeOut("%s" % f, "Checking For:\n%s\nIn:\n%s" % (
            installingFile, appInstallPath))
        #
        if os.path.isfile(os.path.join(searchPath, f, appInstallPath, installingFile)):
            print "Found:\n\t", os.path.join(searchPath, f, appInstallPath, installingFile)
            print "\tNo need for any action."
            foundFile = os.path.join(
                searchPath, f, appInstallPath, installingFile)
            print
            jamfHelperMessageTimeOut(
                "Found:", "%s \nIn:\n%s/%s \nNo need for any action." % (installingFile,f,appInstallPath))
        else:
            print
            appVersionsInstall = []
            appVersionsInstall.append(f)

            print "Previous install of:\n\t%s \n \tNOT found.\n \tInstalling now. . . " % installingFile
            jamfHelperMessageTimeOut("Did not find:","%s/%s/%s"% (f,appInstallPath,installingFile))
            print
            print "Installing:", os.path.join(installingFilePath, installingFile), "\n\tto:\n\t", os.path.join(searchPath, f, appInstallPath)
            jamfHelperMessageTimeOut("Installing",  "%s\nTo:\n%s/%s" %(installingFile,f,appInstallPath))
            print
            try:
                shutil.copy2(os.path.join(installingFilePath, installingFile),
                         os.path.join(searchPath, f, appInstallPath))
                pass
            except IOError:
                print "\tERROR - No such file or directory\n", os.path.join(searchPath, f, appInstallPath)
                pass
            # Check that the installs worked....
            # BUT ONLY FOR THE ONE NOT FOUND  -------------
            for f in appVersionsInstall:
                print "\tChecking the instillation of:\n\t", os.path.join(searchPath, f, appInstallPath, installingFile)
                jamfHelperMessageTimeOut("Checking instillation of:", "%s\nTo:\n%s/%s" % (installingFile,f,appInstallPath))
                if os.path.isfile(os.path.join(searchPath, f, appInstallPath, installingFile)):
                    print "\tFound:\n\t", os.path.join(searchPath, f, appInstallPath, installingFile), "\n\tAnd there was much rejoicing!"
                    jamfHelperMessageTimeOut("Installation successful", "%s\nIn:\n%s/%s\nAnd there was much rejoicing!" % (installingFile,f,appInstallPath))
                    print
                else:
                    print "\tDid not find", os.path.join(searchPath, f, appInstallPath, installingFile)
                    print "\tLooks like something went wrong. . ."
                    jamfHelperMessageTimeOut("ERROR. . .", "Did not find %s In: %s %s" % (installingFile,f,appInstallPath))  
#
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Call the previousInstallCheck module to see of the file is already there.
# Call the appsInstalled module for all of the apps
# - Done with one call
#
checkForFile()
previousInstallCheck(appsInstalled('Illustrator'), illustratorInstallPath)
previousInstallCheck(appsInstalled('InDesign'), inDesignInstallPath)
previousInstallCheck(appsInstalled('Photoshop C'), photoShopInstallPath)
#