[12:04 PM] Andrae, Jason
Text

#!/bin/bash
/usr/bin/env python <<EOF
# -*- coding: utf-8 -*-
'''
%&[]^#~*{}
reqs: renamed-log.txt
rename files safely (in case renamed file already exists)
take dir as arg
python 2.7
spaces at beginning or end of file or directory name
Functions by using a depth first search
'''
import sys
reload(sys)
sys.setdefaultencoding('utf8')
import codecs
import os
import string
from shutil import move
import sys
from re import search, sub, compile
import time
from SystemConfiguration import SCDynamicStoreCopyConsoleUser
from time import strftime
BAD_CHARS = r"[$%&\[\]^#~\*{}\/\\\\+><:]"
class MyLog(object):
    """An object to make and maintain a log."""
    def __init__(self, location):
        log_path = os.path.join(
            location, "renamedLog-" + strftime("%Y-%m-%d_%H-%M") + ".txt")
        # create file log
        self.log_file = codecs.open(log_path, "w", "utf-8")
        print "\n*****    Fixing files starting at:    *****" + "\n%s" % (os.path.splitext(log_path)[0])
        print "Log name : %s" % (log_path)
    def add_log(self, message):
        """Method to add a message to log file."""
        self.log_file.write(message)
    def close_log(self):
        """Method to close current log file."""
        self.log_file.close()
def fixFileName(directoryRoot):
    # walks through directoryRoot and returns directories and files in each root
    for root, dirs, files in os.walk(directoryRoot):
        # iterate through each directory and rename directories safely
        for d in dirs:
            # strip non-ascii characters
            newDirName = sub(r'[^\x00-\x7f]','', d)
            # remove illegal chars and whitespace
            newDirName = sub(BAD_CHARS, '', newDirName).lstrip().rstrip()
            # only do something if name had any issues
            if newDirName != d:
                # make d and newDirName absolute paths
                dAbsolute = os.path.join(root, d)
                newDirNameAbsolute = os.path.join(root, newDirName)
                suffixAttempt = 0
                # check to see if fixed name already exists
                while os.path.exists(newDirNameAbsolute):
                    # it does, so add suffix to temp name
                    tempName = newDirName + "_@_"
                    # increment the attempt
                    suffixAttempt += 1
                    tempName += str(suffixAttempt)
                    log_file.add_log(
                        "Directory already exists! Attempting to use name: %s.\n" % (tempName))
                    # change absolute name to new attempt name
                    newDirNameAbsolute = os.path.join(root, tempName)
                log_file.add_log("@@Renaming Directory '%s' to '%s'\n\n" %
                                 (dAbsolute, newDirNameAbsolute))
                # Recursively call before changing path
                fixFileName(dAbsolute)
                move(dAbsolute, newDirNameAbsolute)
        for f in files:
            # Isolate filename and extension
            fileName, ext = os.path.splitext(os.path.basename(f))
            oldfileName = os.path.splitext(os.path.basename(f))[0]
            # strip non-ascii characters
            fileName = sub(r'[^\x00-\x7f]','', fileName)
            # remove illegal chars and whitespace
            newFileName = sub(BAD_CHARS, '', fileName).lstrip().rstrip()
            # only do something if name without extension had any issues
            if newFileName != oldfileName:
                # make f and newFileName absolute paths
                fAbsolute = os.path.join(root, f)
                # add extension back to fileName before creating full path
                fullFileName = newFileName + ext
                newFileNameAbsolute = os.path.join(root, fullFileName)
                suffixAttempt = 0
                # check to see if fixed name already exists
                while os.path.exists(newFileNameAbsolute):
                    # it does, so add suffix to temp name
                    tempName = newFileName + "_@_"
                    # increment the attempt
                    suffixAttempt += 1
                    tempName += str(suffixAttempt)
                    log_file.add_log(
                        "File already exists! Attempting to use name: %s.\n" % (tempName + ext))
                    # change absolute name to new attempt name
                    fullFileName = tempName + ext
                    newFileNameAbsolute = os.path.join(root, fullFileName)
                message = "@@Renaming File '%s' to '%s'\n\n" % (fAbsolute, newFileNameAbsolute)
                message = message.encode('UTF-8', 'ignore')
                print(message)
                log_file.add_log(message.encode('utf-8'))
                move(fAbsolute, newFileNameAbsolute)
if __name__ == "__main__":
    # If CLI parameter exists, set rename root to that
    if len(sys.argv) > 1:
        ABSOLUTE_PATH = sys.argv[1]
    # Use default OneDrive location
    else:
        username = (SCDynamicStoreCopyConsoleUser(
            None, None, None) or [None])[0]
        username = [username, ""][username in [u"loginwindow", None, u""]]
        # Check for OneDrive path
        ABSOLUTE_PATH = "/Users/" + username + "/OneDrive - Colle McVoy"
        isDir = os.path.isdir(ABSOLUTE_PATH)
        print(isDir)
        if not isDir:
            error = "Error: '%s' is not a valid path. Attempting newer path\n" % (ABSOLUTE_PATH)
            print error
            ABSOLUTE_PATH = "/Users/" + username + "/OneDrive - Colle + McVoy"
    # If entered path is null or not a valid path, bail
    if ABSOLUTE_PATH == '' or not os.path.isdir(ABSOLUTE_PATH):
        error = "Error: '%s' is not a valid path. Exiting...\n" % (ABSOLUTE_PATH)
        print error
        sys.exit(1)
    # Make a new log file
    log_file = MyLog(ABSOLUTE_PATH)
    fixFileName(ABSOLUTE_PATH)
    log_file.close_log()
EOF