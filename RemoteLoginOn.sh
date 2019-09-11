#!/bin/bash

##### HEADER BEGINS #####
# scr_sys_turnOnSshLimitToAdmin.bash
#
# Created 20090320 by Miles A. Leacy IV
# miles.leacy@themacadmin.com
# Modified 20090320 by Miles A. Leacy IV
# Copyright 2009 Miles A. Leacy IV
#
# This script may be copied and distributed freely
# as long as this header remains intact.
#
# This script is provided "as is".  The author offers no warranty
# or guarantee of any kind.
# Use of this script is at your own risk.  The author takes no
# responsibility for loss of use, loss of data, loss of job,
# loss of socks, the onset of armageddon, or any other negative effects.
#
# Test thoroughly in a lab environment before use on production systems.
# When you think it's ok, test again.  When you're certain it's ok,
# test twice more.
#
# This script turns on remote login (ssh) and activates a SACL to
# limit access to members of the admin group.  It is intended to be used
# on a fresh image where ssh has not been enabled or limited previously.
#
# Run as an "at reboot" script when imaging with Casper.
#
##### HEADER ENDS #####

# Turn on remote login
systemsetup -setremotelogin on

# Create the com.apple.access_ssh group
dseditgroup -o create -q com.apple.access_ssh

# Add the admin group to com.apple.access_ssh
dseditgroup -o edit -a admin -t group com.apple.access_ssh