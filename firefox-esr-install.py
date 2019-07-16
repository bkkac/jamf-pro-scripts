#!/usr/bin/python
#####################################################################################################
#
# ABOUT THIS PROGRAM
#
############
# This script installs/updates the latest ESR version of the Firefox web browser.
# Dowloads from https://download.mozilla.org/?product=firefox-esr-latest&os=osx&lang=en-US
############
# Modified and inspiration from-
# 1.0 - Jorge Escala - 2014-12-24
#        * Initial script creation.
# https://www.jamf.com/jamf-nation/discussions/12956/firefox-update-script
############
# This version Will Pierce 20170531
# 
####################################################################################################
# imports
from os.path import basename, isfile
import os, re, glob, datetime
from urlparse import urlsplit
import urllib2
from distutils.dir_util import copy_tree
from plistlib import readPlist
#
# Variables 
DEBUG=True
plistFile='/Applications/Firefox.app/Contents/Info.plist'
now = datetime.datetime.now()
#
if DEBUG:
    # print "Starting Firefox ESR installer script. . ."
    print
    print now.strftime('Starting Firefox ESR installer script %b, %d %Y %I:%M:%S %p')
    print "Downloading latest version. . . "
# Create some modules
def url2name(url):
    return basename(urlsplit(url)[2])
#
def download(url, out_path):
    global localName
    localName = url2name(url)
    req = urllib2.Request(url)
    r = urllib2.urlopen(req)
    if r.info().has_key('Content-Disposition'):
        # If the response has Content-Disposition, we take file name from it
        localName = r.info()['Content-Disposition'].split('filename=')[1]
        if localName[0] == '"' or localName[0] == "'":
            localName = localName[1:-1]
    elif r.url != url: 
        # if we were redirected, the real file name we take from the final URL
        localName = url2name(r.url)
        # Remove the %20 - do we need to? If so uncomment line below 
        localName = urllib2.unquote(localName)
#
    localName = os.path.join(out_path, localName)
    f = open(localName, 'wb')
    f.write(r.read())
    f.close()
# Dowload Firefox ESR
# Call the module 
# This is for the ESR Version
download("https://download.mozilla.org/?product=firefox-esr-latest&os=osx&lang=en-US", '/tmp')
# This is for the normal version
# Might add this in a future version
#
# # Get currently installed version of Firefox
if isfile(plistFile):
    pl = readPlist(plistFile)
    currentFirefoxVersion=pl["CFBundleShortVersionString"]
else:
    currentFirefoxVersion="none"
#
# # Get latest version of Firefox and filename
for latestFirefoxVersion in glob.glob('/tmp/Firefox*'):
    latestFirefoxVersion_dmg = latestFirefoxVersion
    latestFirefoxVersion = latestFirefoxVersion.strip( '/tmp/Firefox esr.dmg .') 
#
if DEBUG:
    print("current: "+currentFirefoxVersion)
    print("latest: "+latestFirefoxVersion)
    print
# remove the . from the version numbers so we can compare them
currentFirefoxVersion = currentFirefoxVersion.replace('.', '')
latestFirefoxVersion = latestFirefoxVersion.replace('.', '')

if int(currentFirefoxVersion) >= int(latestFirefoxVersion):
    print "Current version of Firefox is the same or newer then the downloaded version."
    print "No need to install."
else:
    print "Current version is less then the downloaded version, or not installed."
    print "Lets install the downloaded version. . ."
#
    commandCall='hdiutil attach -nobrowse "%s" ' % localName
    if DEBUG:
        print "Mounting Firefox.dmg"
    os.system(commandCall)
    if DEBUG:
        print "Installing Firefox. . ."
    copy_tree("/Volumes/Firefox/Firefox.app", "/Applications/Firefox.app")
    #
    if DEBUG:
        print "Ejecting %s" % localName

    commandCall='hdiutil detach "/Volumes/Firefox"'
    os.system(commandCall)
#
# Delete the downloaded installer
if DEBUG:
    print "Deleting installer .dmg"
os.remove(latestFirefoxVersion_dmg)
if DEBUG:
    print "Install complete."
