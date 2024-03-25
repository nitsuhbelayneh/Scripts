#!/bin/bash

# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
sudo apt install qemu-guest-agent -y
sudo systemctl restart qemu-guest-agent

#install openshh-server and configure it so that root can ssh as well
sudo apt install openssh-server -y
sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
sudo systemctl restart ssh 

# Remove and clear
sudo apt autoremove
history -c

# Delete the script file
rm "$0"

#for desktop servers to enable rdp un comment the lines below

# sudo apt install xserver-xorg-core
# sudo apt install xorgxrdp
# sudo apt install xrdp

