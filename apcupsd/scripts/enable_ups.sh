#!/bin/bash

#conf_files="/etc/apcupsd/apcupsd-*"

printf "{\"data\":["

for conf_file in /etc/apcupsd/apcupsd-*
do

ups_serial_number=$(printf ${conf_file%.conf}| grep -E -o '[^-]+$')

printf $var"{\"{#UPS}\":\"$ups_serial_number\"}"

var=","
done
printf "]}"

