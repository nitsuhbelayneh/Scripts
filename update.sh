#!/bin/bash

# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
sudo apt install qemu-guest-agent -y
sudo systemctl restart qemu-guest-agent

#install openshh-server and configure it so that root can ssh as well
sudo apt install openssh-server
sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
sudo systemctl restart ssh 

# Delete the script file
rm "$0"
