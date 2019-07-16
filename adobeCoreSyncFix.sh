#!/bin/bash

# Get the currently logged in user, in a more Apple approved way
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
folder="/Users/$user/Library/Application Support/Adobe/CoreSync"
echo "Folder is:"
echo $folder
echo "Currently logged in user is:" $user

if [ -d "$folder" ]; then
    chown -R $user "$folder"
    chmod -R 744 "$folder"
else
    echo "$folder" "Not found, creating. . ."
    # Creating the folder
    mkdir -p $folder
    chown -R $user "$folder"
    chmod -R 744 "$folder"
fi

echo "Permisions for $folder are:" 
ls -ld "$folder"

exit 0
