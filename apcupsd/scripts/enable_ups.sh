#!/bin/bash

conf_files="/etc/apcupsd/apcupsd-*.conf"

if [ -f $conf_file ]
then
printf "{\"data\":["

for conf_file in $conf_files
do
ups_serial_number=$(printf ${conf_file%.conf}| grep -E -o '[^-]+$')

printf $var"{\"{#UPS}\":\"$ups_serial_number\"}"

var=","
done
printf "]}"

fi
exit 0

