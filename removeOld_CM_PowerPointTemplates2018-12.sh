#!/bin/sh
## Script to remove the old CM Power Point templates 
## Get the currently logged in user
user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
## Check to see if there are old CM or Exponent templates 
## If so remove them
# full path for reference
# /Users/userName/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/
#----------
#
# ---- files to remove:
# CM_Exp Blended Template 16x9 WIDE 
## /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_EXP\ Blended\ Template\ 16x9\ WIDE.potx
#
# EXP_PowerPoint Template 4x3 FULL
## /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template\ 4x3\ FULL.potx
#
# EXP_PowerPoint Template_16x9_WIDE
## /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template_16x9_WIDE.potx
#
# Global install path
allUsersPath="/Library/Application\ Support/Microsoft/Office365/User\ Content.localized/Templates.localized"
#--------------- --------------- --------------- ---------------
if [ -f /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_EXP\ Blended\ Template\ 16x9\ WIDE.potx ];
then
	echo "CM_Exp Blended Template 16x9 WIDE exists, removing..."
	rm /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_EXP\ Blended\ Template\ 16x9\ WIDE.potx
    #Check the remove
    if [ ! -e /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_EXP\ Blended\ Template\ 16x9\ WIDE.potx ]; 
    then
        echo "Confirmed, CM_Exp Blended Template 16x9 WIDE removed successfully"
    else 
        echo "Something went wrong CM_Exp Blended Template 16x9 WIDE not removed"
    fi
else
   echo "CM_Exp Blended Template 16x9 WIDE does not exist."
fi
#--------------- --------------- --------------- ---------------
if [ -f /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template\ 4x3\ FULL.potx ];
then
	echo "EXP_PowerPoint Template 4x3 FULL exists, removing..."
	rm /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template\ 4x3\ FULL.potx
    #Check the remove
    if [ ! -e /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template\ 4x3\ FULL.potx ]; 
    then
        echo "Confirmed, EXP_PowerPoint Template 4x3 FULL removed successfully"
    else 
        echo "Something went wrong EXP_PowerPoint Template 4x3 FULL not removed"
    fi
else
   echo "EXP_PowerPoint Template 4x3 FULL does not exist."
fi
#--------------- --------------- --------------- ---------------
if [ -f /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template_16x9_WIDE.potx ];
then
	echo "EXP_PowerPoint Template_16x9_WIDE exists, removing..."
    rm /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template_16x9_WIDE.potx
    #Check the remove
    if [ ! -e /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/EXP_PowerPoint\ Template_16x9_WIDE.potx ]; 
    then
        echo "Confirmed, EXP_PowerPoint Template_16x9_WIDE removed successfully"
    else 
        echo "Something went wrong EXP_PowerPoint Template_16x9_WIDE not removed"
    fi
else
   echo "EXP_PowerPoint Template_16x9_WIDE does not exist."
fi
#--------------- --------------- --------------- ---------------
if [ -f /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_MasterSlides_Template.potx ];
then
	echo "CM_MasterSlides_Template.potx exists, removing..."
	rm /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_MasterSlides_Template.potx
    #Check the remove
    if [ ! -e /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/User\ Content.localized/Templates.localized/CM_MasterSlides_Template.potx ]; 
    then
        echo "Confirmed, CM_MasterSlides_Template.potx removed successfully"
    else 
        echo "Something went wrong CM_MasterSlides_Template.potx not removed"
    fi
else
   echo "CM_MasterSlides_Template.potx does not exist."
fi
#--------------- --------------- --------------- ---------------
# REMOVE 2018 Templates
#--------------- --------------- --------------- ---------------
# EXP_MasterSlides_Template_Arial_2018.potx
file2018a="EXP_MasterSlides_Template_Arial_2018.potx"
echo "TEST"
echo "path is" $allUsersPath
echo $file2018a
if [[ -f $allUsersPath/$file2018a ]];
then
	echo $file2018a" exists, removing..."
	rm $allUsersPath/$file2018a
    #Check the remove
    if [ ! -e /Library/Application\ Support/Microsoft/Office365/User\ Content.localized/Templates.localized/$file2018a ]; 
    then
        echo "Confirmed, $file2018a removed successfully"
    else 
        echo "Something went wrong $file2018a not removed"
    fi
else
   echo "$file2018a does not exist."
fi
#--------------- --------------- --------------- ---------------
# EXP_MasterSlides_Template_Campton_2018.potx
file2018b=EXP_MasterSlides_Template_Campton_2018.potx
if [ -f $allUsersPath/$file2018b ];
then
	echo $file2018b" exists, removing..."
	rm $allUsersPath/$file2018b
    #Check the remove
    if [ ! -e $allUsersPath/$file2018b ]; 
    then
        echo "Confirmed, $file2018b removed successfully"
    else 
        echo "Something went wrong $file2018b not removed"
    fi
else
   echo "$file2018b does not exist."
fi
#--------------- --------------- --------------- ---------------
exit 0