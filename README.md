Home Assistant NAS mount (hanasmount)
====================
Mount NAS share directly to HASS OS
It is based on debian live iso image

Recommended setup:
-------------------
- Have Proxmox guest VM with Home Assistant
- Have NAS as LXC or VM on the host
- Create Host only network between HA and NAS (This will prevent loosing network connection, if you reboot router or other situations and speed will be superfast.


Requirements:
-------------------
- Proxmox host with Home Assistant guest
- 2GB of RAM (its for unsquashing images)
- Everytime you update/upgrade Home Assistant check the sensor if the share is mounted, if not then you need to use this repository.

## STEP 1:
- MAKE A BACKUP OF Home Assistant VM !!!

## STEP 2:

- Create or take my template of fstab and upload it to new folder ``custom_components/hanasmount``.
- Create monitoring variable for mounted volume (i am sure my solution is not the best,but it works fine):
- Create file in the network share named ``thisisnas`` and put ``1`` inside and save.
- Setup a switch in Home Assistant to monitor mounted volume
```yaml
        nas_available_sw:
            command_on: "echo -e '1' > /media/thisisnas"
            command_off: "echo -e '1' > /media/thisisnas"
            command_state: "grep -c '1' /media/thisisnas"
            value_template: "{{ value == '1' }}"
```

## STEP 3:
- Download my 1.1GB image
https://drive.google.com/file/d/18PlE-wAlc_snZpq1v-BJUUFiKxyUXlO-/view?usp=share_link
- Mount it to the HA VM, boot VM from image,press enter on grub menu.
- Wait 1-2minutes until it will write FINISHED on the screen and it will shutdown after few seconds.
- There will be a message to press enter to finish shutdown process.
- Remove the ISO from VM and run the Home Assistant VM without the iso

## PS:
If you want the machine not to shutdown after the process is finish for debuging, write this command on boot
```shell
touch /tmp/stop
```
If by any reason there would be a problem, go look for logs located in ``/tmp/`` folder or in home assistant ``custom_components/hanasmount``




Just to be 100% sure any accounts can be hacked and somebody can put malicious code inside my repository
====================
Here is a tutorial how to make your own bootable image for Home Assistant NAS mount. Or just fork the repository so you will keep the md5 checksum 
``hanasmountdebian-live-11.6.0-amd64-standard.md5`` and link for the file.
Reuploaded file's google link can't be the same link if somebody/me change the file in the future.

###### 1.
Boot to any debian host/vm

Read:
https://dev.to/otomato_io/how-to-create-custom-debian-based-iso-4g37
or
https://web.archive.org/web/20220425175043/https://dev.to/otomato_io/how-to-create-custom-debian-based-iso-4g37

###### 2.

run command:
```shell
sudo apt-get update && sudo apt-get install -y xorriso
```

Goto Downloads folder
run command:
```shell
wget "https://cdimage.debian.org/debian-cd/current-live/amd64/iso-hybrid/debian-live-11.6.0-amd64-standard.iso"
```

run commands:
```shell
sudo apt-get install squashfs-tools
sudo apt-get install -y fakeroot
sudo apt-get install isolinux
xorriso -osirrox on -indev "debian-live-11.6.0-amd64-standard.iso" -extract / iso && chmod -R +w iso
```




###### 3.

Create new folder unsquash in Downloads folder
```shell
mkdir unsquash
```
copy iso/live/filesystem.squashfs to new folder with command
```shell
cp iso/live/filesystem.squashfs unsquash/
cd unsquash
```


run commands inside unsquash folder:
```shell
sudo unsquashfs filesystem.squashfs
sudo chroot squashfs-root/
```

###### 4.
Now you will be inside unsquashed root and you will see user changed to root
run commands:
```shell
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
sudo apt-get update
sudo apt-get install squashfs-tools
```
download execute.sh script from my repository to /root/
```shell
wget "https://raw.githubusercontent.com/ukrolelo/hassos_nas_mount/main/execute.sh"
```
((Check it on malicious code))
```shell
chmod 700 /root/execute.sh
chmod +x /root/execute.sh
```

```shell
nano /var/spool/cron/crontabs/root
```
insert below text:
```shell
@reboot root sleep 30 ; /root/execute.sh > /tmp/stdout.txt 2> /tmp/stderr.txt &
```

Then ending the image preparation with commands:
```shell
``echo ' ' > /etc/resolv.conf
apt-get clean
history -c
exit
```

###### 5.

Now we left squashfs environment
To create new squashfs from the folder that we made changes

```shell
sudo mksquashfs squashfs-root/ filesystem.squashfs -comp xz -b 1M -noappend
```
copy new created filesystem.squashfs file to the iso/live location with command

```shell
cp filesystem.squashfs ../iso/live/
```

Go to downloads directory and run this command:
```shell
sudo xorriso -as mkisofs -r -V "Home assistant NAS mount" -o hanasmountdebian-live-11.6.0-amd64-standard.iso -J -l -b isolinux/isolinux.bin \
-c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img \
-no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin iso/boot iso
```

###### 6.
Take new created ISO and mount&boot on Home Assistant VM



My notes for future refference:
```shell
echo $(date -u) "Some message or other"
```


## Deprecated:
Mount NAS share directly to HASS OS
It is based on GPARTED iso image

***Important!!!***
After HAOS 8.5 or 9.0 There are changes to sda3 and sda5.
Temp workaround is script from dev branch
https://raw.githubusercontent.com/ukrolelo/hassos_nas_mount/dev/execute.sh

**Instructions:**
Download image<br>
https://drive.google.com/file/d/1rUSd2u5P51MLITZ1rCESJgEF90mY9O9V/view?usp=sharing
<br>
BOOT GPARTED image<br>
press enter on grub screen<br>
then<br>
hit 3x enter<br>
check what letters are the disks should be sda<br>
open terminal and execute the script with<br>
/home/execute.sh<br>
<br>
This is the image that i made myself:<br>
if you need, network settings on desktop and press dhcp  enter<br>
network should work rightaway<br>
<br>
If you want to do your own image you need to insert this comands and then recompile the image<br>
sudo apt update<br>
sudo apt-get install squashfs-tools<br>
https://gparted.org/add-packages-in-gparted-live.php
<br>

gparted-live.md5<br>
Contains md5 checksum<br>
d8f187a8a8804cf0f71951d4b48cc77e<br>
*gparted-live.iso<br>
