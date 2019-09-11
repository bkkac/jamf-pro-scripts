#!/bin/bash
## https://gist.github.com/neilmartin83/5d0a3845dd4abbfdff244ac21dae6900#file-eset_endpoint_antivirus_install-sh
## Will Pierce 2019 02 12
# Variables - edit to suit your environment
# Path to the ESET Endpoint Antivirus installer package file
pkgpath="/private/tmp/eea_osx_en_0.pkg"
# Path to exported settings file you wish to import
settingsfile="/private/tmp/cmSettingsV-02"
# Set the variable below to "replace" if you are going to apply your own user settings to the ESET GUI (e.g. notifications/alerts) 
replaceguicfg="yes"
# Path to the directory containing your custom ESET user GUI configuration
guicfgpath="/Library/Application Support/com.collemcvoy/ESET"

# Do not edit these variables
loggedInUser=$( scutil <<< "show State:/Users/ConsoleUser" | awk -F': ' '/[[:space:]]+Name[[:space:]]:/ { if ( $2 != "loginwindow" ) { print $2 }}     ' )
esetapp="/Applications/ESET Endpoint Antivirus.app/Contents/MacOS"

# Prevent ESET GUI launching after install until we set it up)
if [[ "$replaceguicfg" == "yes" ]]; then
	if [[ ! -e "/Library/Application Support/ESET/esets/cache" ]]; then
		/bin/mkdir -p "/Library/Application Support/ESET/esets/cache"
	fi
	/usr/bin/touch "/Library/Application Support/ESET/esets/cache/do_not_launch_esets_gui_after_installation"
fi

# Install ESET from package filename specified in Jamf Policy $4 parameter
/usr/sbin/installer -pkg "$pkgpath" -tgt /

# Import configuration
/bin/launchctl unload "/Library/LaunchDaemons/com.eset.esets_daemon.plist"
"$esetapp"/esets_daemon --import-settings "$settingsfile"
/bin/launchctl load "/Library/LaunchDaemons/com.eset.esets_daemon.plist"

# Generate new user settings LaunchAgent and script
if [[ "$replaceguicfg" == "yes" ]]; then
	if [[ ! -e "$guicfgpath" ]]; then
		/bin/mkdir -p "$guicfgpath"
	fi
	# Generate the gui.cfg file - edit the values below the following line as necessary for your environment
	/bin/cat << EOF > "$guicfgpath/gui.cfg"

[gui]

std_menu_enabled=no
splash_screen_enabled=no
dock_icon_enabled=no
tray_icon_enabled=no
tooltips_enabled=no
alert_display_enabled=yes
scheduler_show_all_tasks=no
filter_log_event=31
filter_log_threat=31
filter_log_nod=31
filter_log_parental=31
filter_log_devctl=31
filter_log_webctl=31
show_hidden_files=no
desktop_notify_enabled=yes
desktop_notify_timeout=5
context_menu_enabled=no
context_menu_type=0
silent_mode_enabled=no
scan_last_profile=""
scan_last_incl=""
scan_last_excl=""
scan_last_time=0
scan_last_infected="(null)"
scan_last_vdb=""
hidden_windows="system_update,enabled:no;media_newdevice,enabled:no;"
prot_stat_display=81

[scan_smart]

av_scan_read_only=no
shutdown_after_scan=no
ctl_incl=""
ctl_excl=""

[scan_deep]

av_scan_read_only=no
shutdown_after_scan=no
ctl_incl=""
ctl_excl=""

[scan_menu]

av_scan_read_only=no
shutdown_after_scan=no
ctl_incl=""
ctl_excl=""

EOF
	# Generate the script to apply user specific GUI settings
	/bin/cat << EOF > "$guicfgpath/gui.sh"
#!/bin/bash

# Check if we've already applied our configuration and exit if so
if [[ -e ~/.esets/configapplied ]]; then
	/usr/bin/open "/Applications/ESET Endpoint Antivirus.app"
	exit 0
fi
/bin/mkdir -p ~/.esets
/bin/cp -f "$guicfgpath/gui.cfg" ~/.esets/
/usr/bin/touch ~/.esets/configapplied
/usr/bin/open "/Applications/ESET Endpoint Antivirus.app"
exit 0

EOF
	/bin/chmod +x "$guicfgpath/gui.sh"
	# Replace ESET's GUI LaunchAgent with our own that will run the above script
	/bin/cat << EOF > "/Library/LaunchAgents/com.eset.esets_gui.plist"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.eset.esets_gui</string>
	<key>ProgramArguments</key>
	<array>
		<string>$guicfgpath/gui.sh</string>
	</array>
	<key>KeepAlive</key>
	<false/>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>

EOF

	# Set up the GUI now if a user is logged in
	if [[ "$loggedInUser" != "" ]]; then
		/bin/mkdir -p /Users/"$loggedInUser"/.esets
		/bin/cp -f "$guicfgpath/gui.cfg" /Users/"$loggedInUser"/.esets
		/usr/bin/touch /Users/"$loggedInUser"/.esets/configapplied
		/usr/sbin/chown -R "$loggedInUser":staff /Users/"$loggedInUser"/.esets
		sudo -u "$loggedInUser" /usr/bin/open "/Applications/ESET Endpoint Antivirus.app"
	fi
fi

exit 0