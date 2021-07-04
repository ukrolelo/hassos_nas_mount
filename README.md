# hassos_nas_mount
Mount NAS share directly to HASS OS
It is based on GPARTED iso image

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
