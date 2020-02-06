#!/usr/bin/python
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
# Need to find all installed versions of Indesign so we can update and 
# or install Triple Triangle
# Need to install the Triple Triangle files in /Users/Shared/Studio_Deployment/
# Fintd all of the Indesign folders and place the files in the correct locations
# Indesing should be closed when this happens
#
# fonts folder to Adobe InDesign CSX:Fonts folder
# /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/Fonts/DO_NOT_PUT_IN_SUITECASE_READ_THIS.txt
# /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/Fonts/PUT_IN_INDESIGN_FONTS_FOLDER.txt
# /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/Fonts/TTSlu.otf
# /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/Fonts/TTSluBol.otf
# /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/Fonts/TTSlugFontLicense.txt
#
# TripleTriangle folder Adobe InDesign CSX:Plug-Ins folder
# /Users/Shared/Studio_Deployment/colle_deployment_cc2015_10202016/TripleTriangle
#
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
#Imports
import os
import subprocess
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
#
# Deploy the Triple Triangle zip file and unzip first for this to work.
# This is done with the policy: 
# Triple Triangle colle deployment cc2015 10202016.sit Studio Deplyment
# https://jss.XX.com:8443/policies.html?id=3350&o=r
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
#
# Variables
#
# Amout of time eatch window is shown to the user
messageWindowTimeOut = "5"
# Title of window to user
messageWindowTitle = "Studio CheckBot 5000 beta v0.5"
# Where to look for the instaled versions of Indesing
searchPath = "/Applications"
#
installingFilePath = "/Users/Shared/Studio_Deployment/"
#
# What is the name of the file to install?
installingFile = "c1c35dfdbfb_XX_deployment_cc2015_10202016.zip"
#
folderName = "XX_deployment_cc2015_10202016"
#
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Module for JAMF Helper message with time out
def jamfHelperMessageTimeOut(windowHeading, messageText):
    # path to JAMF Helper
    jh = "/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    iconPath = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns"
    button1Text = "OK"
    os.system("%s -windowType hud -title '%s' -heading '%s' -icon %s -iconSize 128 -timeout '%s' -cancelButton 1 -description '%s'" %
              (jh, messageWindowTitle, windowHeading, iconPath, messageWindowTimeOut, messageText))
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Module for JAMF Helper message with OK button
def jamfHelperMessageOK(windowHeading, messageText):
    # path to JAMF Helper
    jh = "/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
    iconPath = "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/ToolbarCustomizeIcon.icns"
    button1Text = "OK"
    os.system("%s -windowType hud -title '%s' -heading '%s' -icon %s -button1 '%s' -cancelButton 1 -description '%s'" %
              (jh, messageWindowTitle, windowHeading, iconPath, button1Text, messageText))
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
# Module for checking for the installFile
# In this case the .zip
def checkForFile(installingFile):
    print "Checking for %s in %s " % (installingFile, installingFilePath)
    if os.path.isfile(os.path.join(installingFilePath, installingFile)):
        print "%s is found we can continue." % installingFile
        jamfHelperMessageTimeOut("Checking for:", "%s \nIn:\n%s" %
                             (installingFile, installingFilePath))
    else:
        print "File NOT found. %s\nNOT found in:\n%s" % (installingFile, installingFilePath)
        jamfHelperMessageOK("File NOT found.", "%s\nNOT found in:\n%s \nContact HelpDesk." %
                            (installingFile, installingFilePath))
        quit()
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
# Check that the .zip have been un ziped
def checkForFolder():
    print "Checking for %s in %s " % (folderName, installingFilePath)
    if os.path.isdir(os.path.join(installingFilePath, folderName)):
        print "%s is found we can continue." % folderName
        jamfHelperMessageTimeOut("Checking for:", "%s \nIn:\n%s" %
                             (folderName, installingFilePath))
        print
    else:
        print "File NOT found. %s\nNOT found in:\n%s" % (folderName, installingFilePath)
        jamfHelperMessageOK("File NOT found.", "%s\nNOT found in:\n%s \nContact HelpDesk." %
                            (folderName, installingFilePath))
        quit()
#
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
# Module for checking for apps
def checkForApp(appName):
    print "Checking for %s in %s " % (appName, searchPath)
    if os.path.isdir(os.path.join(searchPath, appName)):
	print "%s is found we can continue." % appName
	jamfHelperMessageTimeOut("Checking for:", "%s \nIn:\n%s" %
                             (appName, searchPath))
	print ""
	jamfHelperMessageTimeOut("Installing: XX_deployment_cc2015_10202016/Fonts", "In: Applications/Adobe InDesign CC 2015/Fonts")
	os.system("cp -pR /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/Fonts/ /Applications/Adobe\ InDesign\ CC\ 2015/Fonts")
	jamfHelperMessageTimeOut("Installing: XX_deployment_cc2015_10202016/TripleTriangle", "In: Adobe InDesign CC 2015/Plug-Ins")

	os.system("cp -pR /Users/Shared/Studio_Deployment/XX_deployment_cc2015_10202016/TripleTriangle /Applications/Adobe\ InDesign\ CC\ 2015/Plug-Ins")
    else:
        print "Applaction NOT found. %s\nNOT found in:\n%s \n." % (appName, searchPath)
        jamfHelperMessageOK("File NOT found.", "%s\nNOT found in:\n%s \nContact HelpDesk." %
                            (appName, searchPath))
        quit()
#  ---------- ---------- ---------- ---------- ---------- ---------- ---------- -------
# Function for installing files
def installFile(appVersions, appInstallPath, installingFile):
	    print "Installing:", os.path.join(installingFilePath, installingFile),\
	     "\n\tto:", os.path.join(searchPath, appVersions, appInstallPath)
	    print
	    shutil.copy2(os.path.join(installingFilePath, installingFile),os.path.join(searchPath, appVersions, appInstallPath))
#
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
# Function for installing folders
def installFolder(appVersions, appInstallPath, installingFile):
	    print "Installing:", os.path.join(installingFilePath, installingFile),\
	     "\n\tto:", os.path.join(searchPath, appVersions, appInstallPath)
	    src_folder = os.path.join(installingFilePath, installingFile)
	    dst_folder = os.path.join(searchPath, appVersions, appInstallPath)
	    shutil.copytree (src_folder, dst_folder)
#  ---------- ---------- ---------- ---------- ---------- ---------- -----
#
checkForFile(installingFile)
# unzip the file from Triple Triangle
# print "Un zipping c1c35dfdbfb_XX_deployment_cc2015_10202016.zip"
# os.system("unzip -o /Users/Shared/Studio_Deployment/c1c35dfdbfb_XX_deployment_cc2015_10202016 -d /Users/Shared/Studio_Deployment/")
# print "Checking on the un zip. . ."z

checkForFolder()
#
checkForApp("Adobe InDesign CC 2015")
jamfHelperMessageOK("Triple Triangle updated.", "please launch Adobe InDesign CC 2015 and test.")

