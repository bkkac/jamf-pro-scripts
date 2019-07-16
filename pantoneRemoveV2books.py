#!/usr/bin/python
# Problem:
# Remove all the old PANTONE books
# Need to find all versions of PhotoShop, Illustrator, and InDesign installed
# Then remove all the old PANTONE books
# Will Pierce
# 2018 05 07
# Imports
import os
import shutil
import subprocess
#
# Variables
#
# Where should we check to see if the books are installed?
searchPath = "/Applications"
#
# Sometimes there are different paths for each application,
# if so what are they?
photoShopInstallPath = "Presets/Color Books/"
illustratorInstallPath = "Presets.localized/en_US/Swatches/Color Books" # recursif search below Swatches?
inDesignInstallPath = "Presets/Swatch Libraries"
#
removeBooks = []
removeBooks.append('PANTONE+ CMYK Coated.acb')
removeBooks.append('PANTONE+ CMYK Uncoated.acb')

removeBooks.append('PANTONE+ Color Bridge Coated.acb')
PANTONE+ Color Bridge Uncoated.acb
PANTONE+ Metallic Coated.acb
PANTONE+ Pastels & Neons Coated.acb
PANTONE+ Pastels & Neons Uncoated.acb
PANTONE+ Premium Metallics Coated.acb
PANTONE+ Solid Coated-V2.acb
PANTONE+ Solid Coated.acb
PANTONE+ Solid Uncoated.acb
Swatches/System (Windows).ai
Swatches/System (Macintosh).ai
TOYO 94 COLOR FINDER.acb
TOYO COLOR FINDER.acb
TRUMATCH.acb
Swatches/Web.ai
ANPA Color 2.acb
DIC Color Guide2.acb
FOCOLTONE 2.acb
HKS E Process 2.acb
HKS E 2.acb
HKS K Process 2.acb
HKS K 2.acb
# PANTONE+ CMYK Coated 2.acb
# PANTONE+ CMYK Uncoated 2.acb
# PANTONE+ Color Bridge Coated 2.acb
# PANTONE+ Color Bridge Uncoated 2.acb
# PANTONE+ Metallic Coated 2.acb
# PANTONE+ Pastels & Neons Coated 2.acb
# PANTONE+ Pastels & Neons Uncoated 2.acb
# PANTONE+ Premium Metallics Coated 2.acb
# PANTONE+ Solid Coated-V2 2.acb
# PANTONE+ Solid Coated 2.acb
# PANTONE+ Solid Uncoated 2.acb
# System (Windows) 2.ai
# System (Macintosh) 2.ai
# TOYO 94 COLOR FINDER 2.acb
# TOYO COLOR FINDER 2.acb
# TRUMATCH 2.acb
# Web 2.ai
Legacy/TOYO Color Finder.acbl

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