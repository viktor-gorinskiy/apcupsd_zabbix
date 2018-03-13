#!/bin/bash

usb_port="/dev/usb/${1}"
serial_number=$2
UPS_DAEMON="/sbin/apcupsd"

conf_file="/etc/apcupsd/apcupsd-${serial_number}.conf"
activ_UPS="/var/log/apcupsd/activ_UPS.log"

for file in /etc/apcupsd/apcupsd-*
do
	if [ $file == "/etc/apcupsd/apcupsd-*" ]
	then NISPORT=3551
	else
	NISPORT=$[$(grep NISPORT /etc/apcupsd/apcupsd-*| awk '{print $2}'|sort|tail -n1) +1]
	fi
done


if ! [ -f $conf_file ]
then
echo "UPSNAME ${serial_number}
UPSCABLE usb
UPSTYPE usb
DEVICE ${usb_port}
LOCKFILE /var/lock
SCRIPTDIR /etc/apcupsd
PWRFAILDIR /etc/apcupsd
NOLOGINDIR /etc
ONBATTERYDELAY 6
BATTERYLEVEL 5
MINUTES 3
TIMEOUT 0
ANNOY 300
ANNOYDELAY 60
NOLOGON disable
KILLDELAY 0
NETSERVER on
NISIP 127.0.0.1
NISPORT ${NISPORT}
EVENTSFILE /var/log/apcupsd/${serial_number}.events
EVENTSFILEMAX 10
UPSCLASS standalone
UPSMODE disable
STATTIME 60
STATFILE /var/log/apcupsd/${serial_number}.status
LOGSTATS off
DATATIME 0" > $conf_file;
/bin/echo  $(date +"%d_%m_%Y") Был добавлен новый UPS $1 ${serial_number} >> /tmp/usb.log;
#if [ -f $(/bin/cat $activ_UPS|grep -nx ${serial_number}) ]; then  echo ${serial_number} >> $activ_UPS; fi;
#sleep 5
touch /var/log/apcupsd/${serial_number}.events;
touch /var/log/apcupsd/${serial_number}.status;
#service apcupsd restart;

/etc/apcupsd/scripts/apcups-start.sh
sleep 5
#[ -n "`pgrep apcupsd`" ] && killall apcupsd ;
#for CONF_FILE in /etc/apcupsd/apcupsd-*conf
#do
#    $UPS_DAEMON -f $CONF_FILE
#done

else
if [ -f $(/bin/cat $conf_file |awk '{print $2}'|grep -nx ${serial_number}) ]; then rm -rf $conf_file && /bin/echo  $(date +"%d_%m_%Y") Был удален файл $conf_file >> /tmp/usb.log; fi
fi
exit 0
