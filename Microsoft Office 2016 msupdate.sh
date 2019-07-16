#!/bin/sh
## postinstall

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3

####################################################################################################
#
# ABOUT
#
#   Microsoft Office 2016 msupdate Post-install
#   Inspired by: https://github.com/pbowden-msft/msupdatehelper
#
#   Microsoft AutoUpdate (MAU) version 3.18 and later includes the "msupdate" binary which can be
#   used to start the Office for Mac update process.
#   See: https://docs.microsoft.com/en-us/DeployOffice/mac/update-office-for-mac-using-msupdate
#
#   Jamf Pro 10 Patch Management Software Titles currently require a .PKG to apply updates
#   (as opposed to a scripted solution.)
#
#   This script is intended to be used as a post-install script for a payload-free package.
#
#   Required naming convention: "Microsoft Excel 2016 msupdate 16.12.18041000.pkg"
#   • The word after "Microsoft" in the pathToPackage is the application name to be updated (i.e., "Excel").
#   • The word after "msupdate" in the pathToPackage is the target version number (i.e., "16.12.18041000").
#
####################################################################################################
#
# HISTORY
#
#     Version 1.0.0, 26-Apr-2018, Dan K. Snelson
#     Version 1.0.1, 21-Jun-2018, Dan K. Snelson
#         Updated PerformUpdate function; thanks qharouff
#         Recorded the version of msupdate installed
#
####################################################################################################

echo " "
echo "###"
echo "# Microsoft Office 2016 msupdate Post-install"
echo "###"
echo " "



###
# Variables
###


# IT Admin constants for application path
PATH_WORD="/Applications/Microsoft Word.app"
PATH_EXCEL="/Applications/Microsoft Excel.app"
PATH_POWERPOINT="/Applications/Microsoft PowerPoint.app"
PATH_OUTLOOK="/Applications/Microsoft Outlook.app"
PATH_ONENOTE="/Applications/Microsoft OneNote.app"
PATH_SKYPEFORBUSINESS="/Applications/Skype for Business.app"

# Path to package
echo "• pathToPackage: ${1}"

# Target app (i.e., the word after "Microsoft" in the pathToPackage)
targetApp=$( /bin/echo ${1} | /usr/bin/awk '{for (i=1; i<=NF; i++) if ($i~/Microsoft/) print $(i+1)}' )

# Target version (i.e., the word after "msupdate" in the pathToPackage)
targetVersion=$( /bin/echo ${1} | /usr/bin/awk '{for (i=1; i<=NF; i++) if ($i~/msupdate/) print $(i+1)}' | /usr/bin/sed 's/.pkg//' )

echo " "





###
# Define functions
###


# Function to check whether MAU 3.18 or later command-line updates are available
function CheckMAUInstall() {
    if [ ! -e "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate" ]; then
        echo "*** Error: MAU 3.18 or later is required! ***"
        exit 1
  else
    mauVersion=$( /usr/bin/defaults read "/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/Info.plist" CFBundleVersion )
    echo "• MAU ${mauVersion} installed; proceeding ..."
  fi
}



# Function to check whether Office apps are installed
function CheckAppInstall() {
    if [ ! -e "/Applications/Microsoft ${1}.app" ]; then
        echo "*** Error: Microsoft ${1} is not installed; exiting ***"
        exit 1
    else
            echo "• Microsoft ${1} installed; proceeding ..."
    fi
}



# Function to determine the logged-in state of the Mac
function DetermineLoginState() {
    CONSOLE=$( stat -f%Su /dev/console )
    if [[ "${CONSOLE}" == "root" ]] ; then
    echo "• No user logged in"
        CMD_PREFIX=""
    else
    echo "• User ${CONSOLE} is logged in"
    CMD_PREFIX="sudo -u ${CONSOLE} "
    fi
}



# Function to register an application with MAU
function RegisterApp() {
    echo "• Register App: Params - $1 $2"
    $(${CMD_PREFIX}defaults write com.microsoft.autoupdate2 Applications -dict-add "$1" "{ 'Application ID' = '$2'; LCID = 1033 ; }")
}



# Function to call 'msupdate' and update the target application
function PerformUpdate() {
    echo "• Perform Update: ${CMD_PREFIX}./msupdate --install --apps $1 --version $2 --wait 600 2>/dev/null"
    result=$( ${CMD_PREFIX}/Library/Application\ Support/Microsoft/MAU2.0/Microsoft\ AutoUpdate.app/Contents/MacOS/msupdate --install --apps $1 $2 --wait 600 2>/dev/null )
    echo "• ${result}"
}



###
# Command
###

CheckMAUInstall
CheckAppInstall ${targetApp}
DetermineLoginState

echo " "
echo "• Updating Microsoft ${targetApp} to version ${targetVersion} ..."

case "${targetApp}" in

 "Word" )

         RegisterApp "${PATH_WORD}" "MSWD15"
         PerformUpdate "MSWD15" "${targetVersion}"
         ;;

 "Excel" )

         RegisterApp "${PATH_EXCEL}" "XCEL15"
         PerformUpdate "XCEL15" "${targetVersion}"
         ;;


  "PowerPoint" )

         RegisterApp "${PATH_POWERPOINT}" "PPT315"
         PerformUpdate "PPT315" "${targetVersion}"
         ;;

  "Outlook" )

         RegisterApp "${PATH_OUTLOOK}" "OPIM15"
         PerformUpdate "OPIM15" "${targetVersion}"
         ;;

   "OneNote" )

         RegisterApp "${PATH_ONENOTE}" "ONMC15"
         PerformUpdate "ONMC15" "${targetVersion}"
         ;;

   "Skype for Business" )

         RegisterApp "${PATH_ONENOTE}" "msfb16"
         PerformUpdate "msfb16" "${targetVersion}"
         ;;
 *)

         echo "*** Error: Did not recognize the target appliction of ${targetApp}; exiting. ***"
         exit 1

         ;;

esac

echo "• Update inventory ..."
/usr/local/bin/jamf recon

echo " "
echo "Microsoft Office 2016 msupdate Post-install Completed"
echo "#####################################################"
echo " "



exit 0      ## Success
exit 1      ## Failure