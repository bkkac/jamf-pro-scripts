#!/bin/bash
# Will Pierce
# 2019 07 18
# https://www.jamf.com/jamf-nation/discussions/31201/setting-custom-screensaver
# Set screensaver to SaveHollywood with setings to use videos in:
# /Users/Shared/ScreenSaverVideos

# Get user logged into console and put into variable "user" 
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
# If you plan on deploying to mac os other than 14 (Mojave) then check the mac os
# osMajor=$(sw_vers -productVersion | awk -F"." '{print $2}')
# osMinor=$(sw_vers -productVersion | awk -F"." '{print $3}')

sudo -u $user defaults -currentHost write com.apple.screensaver CleanExit -string "YES"
sudo -u $user defaults -currentHost write com.apple.screensaver PrefsVersion -int 100
sudo -u $user defaults -currentHost write com.apple.screensaver showClock -string "NO"
sudo -u $user defaults -currentHost write com.apple.screensaver idleTime -int 600

# Again if older then Mojave
# if [[ $osMajor -eq 14 ]] && [[ $osMinor -ge 2 ]]; then
# sudo -u $user defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "iLifeSlideshows" path -string "/System/Library/Frameworks/ScreenSaver.framework/PlugIns/iLifeSlideshows.appex" type -int 0
# else
# sudo -u $user defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "iLifeSlideshows" path -string "/System/Library/Frameworks/ScreenSaver.framework/Resources/iLifeSlideshows.saver" type -int 0
# fi

sudo -u $user defaults -currentHost write com.apple.screensaver tokenRemovalAction -int 0
sudo -u $user defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "SaveHollywood" path -string "/Library/Screen Savers/SaveHollywood.saver" type 0
sudo -u $user defaults -currentHost write fr.whitebox.SaveHollywood assets.library -array "/Users/Shared/XX-ScreenSaverVideos"
sudo -u $user defaults -currentHost write fr.whitebox.SaveHollywood movie.volume.mode 1
sudo killall -hup cfprefsd
exit 0
