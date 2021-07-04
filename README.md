# hassos_nas_mount
Mount NAS share directly to HASS OS
It is based on GPARTED iso image

**Instructions:**
BOOT GPARTED image

press enter on grub screen<br>
then<br>
hit 3xenter<br>
check that it shows sda's<br>
open terminal and execute the script with<br>
This is the image that i made myself:<br>
if you need, network settings on desktop and press dhcp  enter<br>
network showould work rightaway<br>

If you want to do your own image you need to insert this comands and then recompile the image<br>
sudo apt update<br>
sudo apt-get install squashfs-tools<br>
https://gparted.org/add-packages-in-gparted-live.php
