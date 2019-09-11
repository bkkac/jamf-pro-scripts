#!/bin/bash
echo "System Center Endpoint Protection Version 4.5.32.0 Uninstall Script"
echo "This script will uninstall System Center Endpoint Protection 4.5.32.0."

if [ $EUID -ne 0 ]; then
	echo " "
	echo "Warning: Uninstallation of System Center Endpoint Protection 4.5.32.0 could be made only by user with root privileges!"
	echo " "
	exit 2
fi
echo " "

dr="$( cd -P "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
lg=/tmp/scep_uninstall.log
s="Starting uninstallation procedure using '$0'";
echo $s > $lg; echo $s

if [ -d "$dr" ]; then 
	for i in 1 2 3 4 5 6 7
	do
		s="Executing uninstaller tool $i..."
		echo "" >> $lg; echo $s >> $lg; echo $s
		"$dr/../Helpers/ut$i" 2> /dev/null 1>&2
		rc=$?
		pd=$!
		if [ "$rc" -ne 0 ]; then
			s="ERROR: uninstallation step $i failed! Cannot execute tool '$dr/../Helpers/ut$i'"
			echo $s >> $lg; echo $s
			exit $rc;
		fi
	done
	s="Uninstallation finished successfully!"
else
	s="Product is not installed or installation is corrupted !"
fi
echo "" >> $lg; echo ""
echo $s >> $lg; echo $s

