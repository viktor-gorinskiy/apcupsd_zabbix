#!/bin/bash

usb_port="/dev/usb/${1}"
serial_number=$2

UPSNAME=$(grep $serial_number /etc/apcupsd/scripts/serial_to_name.txt|awk -F= '{print $2}'|tr -s ' ' '_')
if [ -z ${UPSNAME// /} ]; then UPSNAME=$serial_number;fi


UPS_DAEMON="/sbin/apcupsd"
conf_file="/etc/apcupsd/apcupsd-${UPSNAME}.conf"
all_conf_file="/etc/apcupsd/apcupsd-*.conf"

# find NISPORT
for file in $all_conf_file
do
	if [ $file == $all_conf_file ]
	then NISPORT=3551
	else
	NISPORT=$[$(grep NISPORT /etc/apcupsd/apcupsd-*| awk '{print $2}'|sort|tail -n1) +1]
	fi
done


if ! [ -f $conf_file ]
then
echo "UPSNAME ${UPSNAME}
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
EVENTSFILE /var/log/apcupsd/${UPSNAME}.events
EVENTSFILEMAX 10
UPSCLASS standalone
UPSMODE disable
STATTIME 60
STATFILE /var/log/apcupsd/${UPSNAME}.status
LOGSTATS off
DATATIME 0" > $conf_file;
/bin/echo  $(date +"%d_%m_%Y") Был добавлен новый UPS $1 ${UPSNAME} >> /tmp/usb.log;
#sleep 5
touch /var/log/apcupsd/${UPSNAME}.events;
touch /var/log/apcupsd/${UPSNAME}.status;
#service apcupsd restart;

/etc/apcupsd/scripts/apcups-start.sh
sleep 5
#[ -n "`pgrep apcupsd`" ] && killall apcupsd ;
#for CONF_FILE in /etc/apcupsd/apcupsd-*conf
#do
#    $UPS_DAEMON -f $CONF_FILE
#done

else
if [ -f $(/bin/cat $conf_file |awk '{print $2}'|grep -nx ${UPSNAME}) ]; then rm -rf $conf_file && /bin/echo  $(date +"%d_%m_%Y") Был удален файл $conf_file >> /tmp/usb.log; fi
fi
exit 0
