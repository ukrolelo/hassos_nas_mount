#!/bin/bash
#if debug=1 no mksquash,dd,umounts
debug=0
rm -f /tmp/ascriptstarted
touch /tmp/ascriptstarted
sleep 10
rm -f /tmp/main.log
touch /tmp/main.log
diskfile='/tmp/disks'
rm -f $diskfile
lsblk >> $diskfile
chmod 777 $diskfile
atleastonefstab=0
n=1
while read line
do
if [[ "$line" == *":0"* ]] #firstif
then
echo "Line No. $n : $line" >> /tmp/main.log
#echo "$line"

device=$(echo $line | awk '{print $1}')
#echo "$device"

if [ -b /dev/${device}8 ] #second if
then
echo "$device exists"
wall "$device exists"
echo "$device exists" >> /tmp/main.log
mkdir /tmp/hastorage
umount /tmp/hastorage
mount /dev/${device}8 /tmp/hastorage
echo "mounting /dev/${device}8"
wall "mounting /dev/${device}8"
echo "mounting /dev/${device}8" >> /tmp/main.log
if [ -f /tmp/hastorage/supervisor/homeassistant/custom_components/hanasmount/fstab ] #third if
then
echo "mounted storage is HA and i see fstab"
wall "mounted storage is HA and i see fstab"
echo "mounted storage is HA and i see fstab" >> /tmp/main.log
#searching for fstab file in partitions
mkdir /tmp/s3
mount /dev/${device}3 /tmp/s3
if [ -f /tmp/s3/etc/fstab ] #forth if
then
echo "fstab on ${device}3 exists"
wall "fstab on ${device}3 exists"
echo "fstab on ${device}3 exists" >> /tmp/main.log
#####unmount,unsquash,copy,squash,dd
umount /tmp/s3
unsquashfs -f -d /tmp/s3 /dev/${device}3
cp /tmp/hastorage/supervisor/homeassistant/custom_components/hanasmount/fstab /tmp/s3/etc/
if [ $debug == 0 ] #fifth if
then
echo "mksquashfs ${device}3"
wall "mksquashfs ${device}3"
echo "mksquashfs ${device}3" >> /tmp/main.log
mksquashfs /tmp/s3/ /tmp/squash.rootfs.${device}3
dd if=/tmp/squash.rootfs.${device}3 of=/dev/${device}3
rm -f /tmp/squash.rootfs.${device}3
atleastonefstab=1
echo "end mksquashfs ${device}3"
wall "end mksquashfs ${device}3"
echo "end mksquashfs ${device}3" >> /tmp/main.log
else
echo "debug=1"
wall "debug=1"
echo "debug=1" >> /tmp/main.log
fi #fifth if ending
#####
else
echo "fstab on ${device}3 doesn't exists"
wall "fstab on ${device}3 doesn't exists"
echo "fstab on ${device}3 doesn't exists" >> /tmp/main.log
fi #forth if ending


mkdir /tmp/s5
mount /dev/${device}5 /tmp/s5
if [ -f /tmp/s5/etc/fstab ] #forth if
then
echo "fstab on ${device}5 exists"
wall "fstab on ${device}5 exists"
echo "fstab on ${device}5 exists" >> /tmp/main.log
#####unmount,unsquash,copy,squash,dd
umount /tmp/s5
unsquashfs -f -d /tmp/s5 /dev/${device}5
cp /tmp/hastorage/supervisor/homeassistant/custom_components/hanasmount/fstab /tmp/s5/etc/
if [ $debug == 0 ] #fifth if 
then
echo "mksquashfs ${device}5"
wall "mksquashfs ${device}5"
echo "mksquashfs ${device}5" >> /tmp/main.log
mksquashfs /tmp/s5/ /tmp/squash.rootfs.${device}5
dd if=/tmp/squash.rootfs.${device}5 of=/dev/${device}5
rm -f /tmp/squash.rootfs.${device}5
atleastonefstab=1
echo "end mksquashfs ${device}5"
wall "end mksquashfs ${device}5"
echo "enc mksquashfs ${device}5" >> /tmp/main.log
else
echo "debug=1"
wall "debug=1"
echo "debug=1" >> /tmp/main.log
fi #fifth if ending
####
else
echo "fstab on ${device}5 doesn't exists"
wall "fstab on ${device}5 doesn't exists"
echo "fstab on ${device}5 doesn't exists" >> /tmp/main.log
fi #forth if ending

#unmounting HA storage
echo "copying logs"
wall "copying logs"
echo "copying logs" >> /tmp/main.log
cp /tmp/stdout.log /tmp/hastorage/supervisor/homeassistant/custom_components/hanasmount/
cp /tmp/stderr.log /tmp/hastorage/supervisor/homeassistant/custom_components/hanasmount/
cp /tmp/main.log /tmp/hastorage/supervisor/homeassistant/custom_components/hanasmount/
if [ -f /tmp/stop ] #forth if
then
echo "can't shutdown because stop file exists"
wall "can't shutdown because stop file exists"
echo "can't shutdown because stop file exists" >> /tmp/main.log
else
echo "FINISHED unmounting shutting down the VM"
wall "FINISHED unmounting shutting down the VM"
sleep 5
umount /tmp/hastorage
sudo shutdown now
fi #forth if ending

else
echo "mounted storage is not HA or i dont see fstab"
wall "mounted storage is not HA or i dont see fstab"
echo "mounted storage is not HA or i dont see fstab" >> /tmp/main.log
fi #third if ending

else
echo "$device doesnt exists in dev"
wall "$device doesnt exists in dev"
echo "$device doesnt exists in dev" >> /tmp/main.log
fi #second if ending

fi #first if ending
n=$((n+1))
done < $diskfile
echo "FINISHED"
wall "FINISHED"
echo "FINISHED" >> /tmp/main.log 
