echo "Enter IP adress of NAS server without /"
read theip
echo "Enter share name without /"
read theshare
echo "Enter username"
read theuser
echo "Enter password"
read thepass
echo "sda/sdb/sdc/sdb?"
read device
total="//${theip}/${theshare}	/mnt/data/supervisor/media	cifs	vers=2.0,nofail,username=${theuser},password=${thepass},iocharset=utf8,x-systemd.after=network-online.target	0	0"
sudo mkdir /tmp/${device}3
sudo unsquashfs -f -d /tmp/${device}3 /dev/${device}3
echo "Continue to check mnt if exists? hit enter"
read gonext
mntexist3=$(sudo grep -c "mnt" /tmp/${device}3/etc/fstab)
if [ "$mntexist3" = "0" ]
then
echo "MNT INSERTING 3"
echo $total >> /tmp/${device}3/etc/fstab
echo "MNT INSERTING 3"
else
echo "MNT ALREADY INSERTED FROM PREVIOUS RUN 3"
echo $mntexist3
echo "MNT ALREADY INSERTED FROM PREVIOUS RUN 3"
fi
echo "START---${device}3"
sudo cat /tmp/${device}3/etc/fstab
echo "END---${device}3"
echo "is everything correct? y/n?"
read isok
if [ $isok = 'y' ]
then
echo OK
sudo mksquashfs /tmp/${device}3/ /tmp/squash.rootfs.${device}3
sudo dd if=/tmp/squash.rootfs.${device}3 of=/dev/${device}3
sudo dd if=/tmp/squash.rootfs.${device}3 of=/dev/${device}5
echo "-------"
echo "finished..turn off vm and remove iso image"
echo "-------"
else
echo EXITED
fi
