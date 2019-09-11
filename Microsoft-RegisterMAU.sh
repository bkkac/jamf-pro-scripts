#!/bin/sh
#
# Create MAU trust Launch Agent and the Script using scripting method
#
# Only run Once
# https://www.jamf.com/jamf-nation/discussions/22853/best-practices-for-automating-office-2016-updates
#
# WHP 20170705
#
/bin/cat << 'EOF' > "/Library/LaunchAgents/com.collemcvoy.registermau.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
     <key>Label</key>
     <string>com.collemcvoy.registermau</string>
     <key>ProgramArguments</key>
     <array>
          <string>/usr/local/bin/RegisterMAU.sh</string>
     </array>
     <key>RunAtLoad</key>
     <true/>
</dict>
</plist>
EOF

/bin/cat << 'EOF' > "/usr/local/bin/RegisterMAU.sh"
#!/bin/sh

###############################################################################################################
#
# Register MAU using a Launch Agent (/Library/LaunchAgents/com.collemcvoy.registermau.plist)
#
###############################################################################################################

###########
# Functions
###########

# Check if com.collemcvoy.MAUtrustDone.plist file exists and if yes don't re-register
checkMAUtrustDone() {
     if [ -f $HOME/Library/Preferences/com.collemcvoy.MAUtrustDone.plist ] ; then
        exit 0
    fi
}

# re-register and create a file called com.collemcvoy.MAUtrustDone.plist
trustMAU() {
if [ -e "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app" ]; then
     /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app"
fi

if [ -e "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app" ]; then
     /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app"
fi

# Add office apps to com.microsoft.autoupdate2 plist
# Taken from Office Postinstall script and edited
applications="
Word.app
Excel.app
PowerPoint.app
OneNote.app
Outlook.app"

for application in $applications
do
     domain="com.microsoft.autoupdate2"
     defaults_cmd="/usr/bin/defaults"
     application_info_plist="/Applications/Microsoft $application/Contents/Info.plist"
     lcid="1033"

     if /bin/test -f "$application_info_plist"
     then
          application_bundle_signature=$($defaults_cmd read "$application_info_plist" CFBundleSignature)
          application_bundle_version=$($defaults_cmd read "$application_info_plist" CFBundleVersion)
          application_id=$(printf "%s%02s" "$application_bundle_signature" "${application_bundle_version%%.*}")
          $defaults_cmd write $domain Applications -dict-add "/Applications/Microsoft $application" "{ 'Application ID' = $application_id; LCID = $lcid ; }"
     fi
done

/usr/bin/touch $HOME/Library/Preferences/com.collemcvoy.MAUtrustDone.plist
}

# Execute the Functions
checkMAUtrustDone
trustMAU

exit 0
EOF


# Set the correct permissions on the created files
/usr/sbin/chown -R root:wheel "/Library/LaunchAgents/com.myorg.registermau.plist"
/bin/chmod -R 644 "/Library/LaunchAgents/com.collemcvoy.registermau.plist"

/usr/sbin/chown -R root:wheel "/usr/local/bin/RegisterMAU.sh"
/bin/chmod a+x "/usr/local/bin/RegisterMAU.sh"

# Run Once for current user as LaunchAgent will kick-in for next user onwards and we are running the initial run as root.
CurrentloggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

if [ -e "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app" ]; then
     sudo -u "$CurrentloggedInUser" /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app"
fi

if [ -e "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app" ]; then
     sudo -u "$CurrentloggedInUser" /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -R -f -trusted "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/Microsoft AU Daemon.app"
fi

# Add office apps to com.microsoft.autoupdate2 plist
# Taken from Office Postinstall script and edited
applications="
Word.app
Excel.app
PowerPoint.app
OneNote.app
Outlook.app"

for application in $applications
do
     domain="com.microsoft.autoupdate2"
     defaults_cmd="/usr/bin/sudo -u $CurrentloggedInUser /usr/bin/defaults"
     application_info_plist="/Applications/Microsoft $application/Contents/Info.plist"
     lcid="1033"

     if /bin/test -f "$application_info_plist"
     then
          application_bundle_signature=$($defaults_cmd read "$application_info_plist" CFBundleSignature)
          application_bundle_version=$($defaults_cmd read "$application_info_plist" CFBundleVersion)
          application_id=$(printf "%s%02s" "$application_bundle_signature" "${application_bundle_version%%.*}")
          $defaults_cmd write $domain Applications -dict-add "/Applications/Microsoft $application" "{ 'Application ID' = $application_id; LCID = $lcid ; }"
     fi
done

exit 0