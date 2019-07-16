#!/bin/sh
########################################################################################################
"/Applications/Install macOS High Sierra.app/Contents/Resources/startosinstall" --eraseinstall --agreetolicense --newvolumename "Macintosh HD" --installpackage /Applications/Utilities/QuickAdd-20180803.pkg --nointeraction &


 "/Applications/Install macOS High Sierra.app/Contents/Resources/startosinstall" --eraseinstall --newvolumename "Macintosh HD" --agreetolicense --installpackage /Applications/Utilities/QuickAdd-20180803.pkg --nointeraction &
##### THIS DOES NOT WORK
  "/Applications/Install macOS High Sierra.app/Contents/Resources/startosinstall" --eraseinstall --newvolumename "Macintosh HD" --agreetolicense &
  #### THIS WORKS



/Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/startosinstall --eraseinstall --newvolumename "Macintosh HD" --agreetolicense --installpackage /Users/Shared/QuickAdd-20180803.pkg  --nointeraction &
#### Testing localy . . . . . 


/Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/startosinstall --eraseinstall --newvolumename "Macintosh HD" --agreetolicense --installpackage /Users/Shared/QuickAdd-20180803-ds.pkg &




## Test this
/Applications/Install\ macOS\ High\ Sierra.app/Contents/Resources/startosinstall --applicationpath /Applications/Install\ macOS\ High\ Sierra.app --agreetolicense --installpackage /Users/Shared/QuickAdd-20180803-ds.pkg --nointeraction
#### NOPE

productbuild –package /path/to/component.pkg /path/to/distribution.pkg



/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users macroot,sshroot -privs -all -restart -agent -menu -clientopts -setmenuextra -menuextra no
