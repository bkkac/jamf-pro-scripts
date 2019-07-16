#!/usr/bin/osascript
-- script to change computer name so it is NOT macroot's macbook pro
-- Ask for new computer name
set COMPUTERNAME to text returned of (display dialog "Please enter new Computer Name:" default answer "unameXXmbpXX" with icon 2)
display dialog "New Computer name will be: " & COMPUTERNAME
--
# Set Hostname, LoacalHostName, and ComputerName using variable created above
do shell script "scutil --set HostName " & COMPUTERNAME
do shell script "scutil --set LocalHostName " & COMPUTERNAME
do shell script "scutil --set ComputerName " & COMPUTERNAME
--
--get new names and set as new variable 
--
set newHostName to do shell script "scutil --get HostName"
set newLocalHostName to do shell script "scutil --get LocalHostName"
set newComputerName to do shell script "scutil --get ComputerName"
--
-- Display dialog to confirm computer names were changed.
display dialog "The computer Host Name has been changed to: " & newHostName & "

The computer Local Host Name has been changed to: " & newLocalHostName & "

The computer Name has been changed to: " & newComputerName buttons {"Roger That"} default button "Roger That" with icon 2


