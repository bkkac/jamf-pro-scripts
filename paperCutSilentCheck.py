#!/usr/bin/python
# What is paper cut set to for silent?
# Imports
import linecache
from os.path import basename, isfile
readFile="/Applications/PCClient.app/Contents/Resources/config.properties"
# print(type(readFile))
# print "this is a test %s" % (readFile)
if isfile(readFile): # is the file there?
    result=linecache.getline('%s', 23) % (readFile)
    print "<result>%s</result>" % (result)
    print "is a file eh"
else:
    # print "<result>%s not found</result>" % (readFile)
    print "Not a file eh"



# silent=linecache.getline('/Applications/PCClient.app/Contents/Resources/config.properties',23)
# print "<result>%s</result>" %(silent)
