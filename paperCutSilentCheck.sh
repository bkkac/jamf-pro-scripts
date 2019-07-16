#!/bin/sh
# read File a single line from a text file
# In JAMF PRO set 
result=`cat "$1" | sed -n "$2p"`
echo "<result>"
echo $result
echo "</result>"
# echo "<result>"$result"</result>"

# echo 'this is a test'
# echo
# echo $result
# exit 0