#!/bin/bash

FOLDER_PATH="/Users/Shared/ScreenSaverPhotos" ## Customize this path to the folder with images
FOLDER_NAME="${FOLDER_PATH##*/}"

LOGGED_IN_USER=$(stat -f%Su /dev/console)
LOGGED_IN_UID=$(id -u "$LOGGED_IN_USER")

UUID=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F\" '/IOPlatformUUID/{print $4}')

/bin/launchctl asuser "$LOGGED_IN_UID" sudo -iu "$LOGGED_IN_USER" /bin/rm ~/Library/Preferences/ByHost/com.apple.ScreenSaverPhotoChooser.${UUID}.plist
/bin/launchctl asuser "$LOGGED_IN_UID" sudo -iu "$LOGGED_IN_USER" defaults -currentHost write com.apple.ScreenSaver.iLifeSlideShows styleKey Classic
/bin/launchctl asuser "$LOGGED_IN_UID" sudo -iu "$LOGGED_IN_USER" defaults -currentHost write com.apple.ScreenSaverPhotoChooser CustomFolderDict -dict identifier "$FOLDER_PATH" name "$FOLDER_NAME"
/bin/launchctl asuser "$LOGGED_IN_UID" sudo -iu "$LOGGED_IN_USER" defaults -currentHost write com.apple.ScreenSaverPhotoChooser SelectedFolderPath "$FOLDER_PATH"
/bin/launchctl asuser "$LOGGED_IN_UID" sudo -iu "$LOGGED_IN_USER" defaults -currentHost write com.apple.ScreenSaver moduleDict -dict moduleName iLifeSlideshows path "/System/Library/Frameworks/ScreenSaver.framework/Resources/iLifeSlideshows.saver" type 0 