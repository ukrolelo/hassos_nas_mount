# hassos_nas_mount
Mount NAS share directly to HASS OS
It is based o GPARTED iso image

**Instructions:**
BOOT GPARTED image
press enter on grub screen
then
hit 3xenter
check that it shows sda's
open terminal and execute the script with
This is the image that i made myself:
if you need, network settings on desktop and press dhcp  enter
network showould work rightaway

If you want to do your own image you need to insert this comands and then recompile the image
sudo apt update
sudo apt-get install squashfs-tools
https://gparted.org/add-packages-in-gparted-live.php
