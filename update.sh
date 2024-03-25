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



#for desktop servers to enable rdp un comment the lines below

sudo apt install xserver-xorg-core -y
sudo apt install xorgxrdp -y
sudo apt install xrdp -y

# Check if the lines are already present in the file /etc/gdm3/custom.conf
#if grep -q "AutomaticLoginEnable=True" /etc/gdm3/custom.conf && grep -q "AutomaticLogin=root" /etc/gdm3/custom.conf && grep -q "AllowRoot=True" /etc/gdm3/custom.conf; then
#  echo "Lines already exist in /etc/gdm3/custom.conf"
#else
  # Add the lines under [daemon]
  sed -i '/\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=root' /etc/gdm3/custom.conf

  # Add the line AllowRoot=True below # TimedLoginDelay = 10
  sed -i '/#  TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf

  echo "Lines added to /etc/gdm3/custom.conf"
#fi

# Comment out the line in /etc/pam.d/gdm-password
sed -i 's/^auth required     pam_succeed_if.so user != root quiet/#&/' /etc/pam.d/gdm-password

echo "Line commented in /etc/pam.d/gdm-password"










# Remove and clear
sudo apt autoremove
history -c

# Delete the script file
rm "$0"