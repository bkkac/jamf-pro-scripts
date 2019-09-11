#!/bin/bash

#This script is made to change the priority of the populated SSID to 0 (Top of list)
#It has been tested and does not de-auth the user if they are currently on the SSID to be changed (If the SSID password remains in the keychain)
#This has been tested on 10.10 and 10.11

#Sets arguements for script
#Disabled NetworkDevice as NetworkPort will auto-detect WiFi port location
    Priority=$4
    PreferredNetwork=$5
    WirelessSecurity=$6
    RemoveNetworkAlso=$7
#Running RemoveNetworkOnly populated will not run other options
    RemoveNetworkOnly=$8
#Setting argument $9 to anything will trigger this to be run (i.e. asdfasdf) Will run with RemoveNetworkOnly
    ShowPreferred=$9
#Sets arguement to check for port location of wifi, nulls need of NetworkDevice.
    NetworkPort=`/usr/sbin/networksetup -listallhardwareports | grep -A 1 Wi-Fi | grep Device | cut -d' ' -f2`

#As stated above, if the RemoveNetworkOnly field is populated the script will only run the very last command.
if [ -z $RemoveNetworkOnly ]; then
#Checks if all arguements have been entered, will exit out with statement if no settings have been set.
    if [ -z $NetworkPort ]; then
        echo "WiFi Port not detected, please ensure system has WiFi capabilities"
        exit 1
    else
            if [ -z $PreferredNetwork ]; then
                echo "Please set the Preferred Network SSID"
                exit 1
            else
                    if [ -z $WirelessSecurity ]; then
                        echo "Please set the Wireless Security Type" 
                        exit 1
                    else        
                        #Echos all arguements
                        echo "Network Device is $NetworkPort" 
                        echo "Preferred Network SSID is $PreferredNetwork" 
                        echo "Wireless Security Type is $WirelessSecurity" 

                        #Changes Priority of SSID to 0
                        networksetup -removepreferredwirelessnetwork "$NetworkPort" "$PreferredNetwork"
                        networksetup -addpreferredwirelessnetworkatindex "$NetworkPort" "$PreferredNetwork" "$Priority" "$WirelessSecurity"
                        echo "Priority changed"

                            #If RemoveNetworkAlso is populated it will run otherwise the script will close
                            if [ -z $RemoveNetworkAlso ]; then
                                networksetup -removepreferredwirelessnetwork "$NetworkPort" "$RemoveNetworkAlso"
                            else
                                echo "SSID $RemoveNetworkAlso Removed"

                            fi
                    fi
            fi
    fi
else
    if [ -z $NetworkPort ]; then
        echo "WiFi Port not detected, please ensure system has WiFi capabilities"
        exit 1
    else
        if [ -z $RemoveNetworkOnly ]; then
            echo "Unknown error, check to make sure script has not been edited"
            exit 1
        else
            networksetup -removepreferredwirelessnetwork "$NetworkPort" "$RemoveNetworkOnly"
            echo "SSID Removed"
        fi
    fi
fi

#If arguement is populated it will show preferred list *Warning can be a large list*
#Do not rely fully on this as it can have false reporting, having a sleep time has not helped. 
if [ -z $ShowPreferred ]; then
    echo Done
else
    networksetup -listpreferredwirelessnetworks "$NetworkPort"
fi

exit 0