#!/bin/bash

#<<comment

# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y

#comment

############################################################################################################################################

#<<comment

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
sudo apt install qemu-guest-agent -y
sudo systemctl restart qemu-guest-agent

#comment

############################################################################################################################################

<<comment

#install openshh-server
sudo apt install openssh-server -y

comment

############################################################################################################################################

<<comment

#Restart the ssh Service
sudo systemctl restart ssh 

comment

############################################################################################################################################

<<comment

# Install xrdp for desktop servers

sudo apt install xserver-xorg-core -y
sudo apt install xorgxrdp -y
sudo apt install xrdp -y



# Restart the rdp service after changing the configuration files
sudo systemctl restart xrdp

comment

############################################################################################################################################

#<<comment

# Remove residual packages
sudo apt-get clean -y
sudo apt autoremove -y
echo "Residual packages cleaned up."

#Clear command history 
history -c
history -w

#Remove the bash history
#sudo truncate -s 0 .bash_history
#cat /dev/null > ~/.bash_history
#echo -n > ~/.bash_history
#sed -i '$ d' ~/.bash_history

#history -c
echo "Command history cleared."

#comment

############################################################################################################################################

# Delete the script file
rm "$0"
echo "Script file deleted."



