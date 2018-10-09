# apcupsd_zabbix
Мониторинг UPS
udevadm info --name=/dev/usb/hiddev0 --attribute-walk
udevadm info --name=/dev/usb/hiddev1 --attribute-walk
vim /etc/udev/rules.d/ups.rules
cat /boot/cmdline.txt 
dwc_otg.lpm_enable=0 dwc_otg.speed=1 console=serial0,115200 console=tty1 root=PARTUUID=0b6dce98-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait
