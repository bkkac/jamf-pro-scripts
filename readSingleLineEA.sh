#!/bin/sh
# read File a single line from a text file
readFile="/Applications/PCClient.app/Contents/Resources/config.properties"
lineNumber="23"
if [ -e $readFile ]; then
    result=`cat "$readFile" | sed -n "$lineNumber p"`
    # echo $result
    echo "<result>"&& echo $result|tr -d '\n' && echo "</result>"
else
    echo "<result>Config not found/result>"
fi
