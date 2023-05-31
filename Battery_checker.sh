#!/bin/bash

# Author: Michael Williams
# Company: None
# Purpose: Check the battery status on a Intel and Apple silicon device
# Created 31/05/2023

################################################################################
################################################################################

# Store current users username and real name
currentUser="$(ls -la /dev/console | cut -d " " -f 4)"
realName=$(id -P $(stat -f%Su /dev/console) | awk -F '[:]' '{print $8}')
policyDate=$(date)
scriptName=$(basename "$0")
LogLocation="/var/log/jamf.log"

# Logging Function for reporting actions
ScriptLogging(){
	
	logHeader="$(date +%a" "%b" "%d" "%T) $(hostname) $(echo jamf-S[$$]):"
	LOG="$LogLocation"
	
	echo "$logHeader" " $1" >> $LOG
}

################################################################################
################################################################################


ScriptLogging "======== Starting $scriptName Script ========"

# Check and create the Yoti folder if needed
test -d /Library/Yoti/ && chmod 755 /Library/Yoti/
test ! -d /Library/Yoti/ && mkdir /Library/Yoti/ && chmod 755 /Library/Yoti/


arch=$(/usr/bin/arch)

if [ "$arch" == "arm64" ]; then
	capacity=$(system_profiler SPPowerDataType | grep "Maximum Capacity:" | sed 's/.*Maximum Capacity: //')
	echo "<result>$(system_profiler SPPowerDataType | grep "Condition:" | sed 's/.*Condition: //') with $capacity capacity</result>"
elif [ "$arch" == "i386" ]; then
	echo "<result>$(system_profiler SPPowerDataType | grep "Condition:" | sed 's/.*Condition: //')</result>"
else
	echo "<result>Unknown Battery Status</result>"
fi



ScriptLogging "======== Ending $scriptName Script ========"

exit 0