#!/bin/bash
[ -n "`pgrep apcupsd`" ] && killall apcupsd ;

sleep 5 ;

UPS_DAEMON="/sbin/apcupsd"

for CONF_FILE in /etc/apcupsd/apcupsd-*conf
do
    $UPS_DAEMON -f $CONF_FILE
#    echo $UPS_DAEMON -f $CONF_FILE
done
