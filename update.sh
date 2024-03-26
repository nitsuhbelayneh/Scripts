#!/bin/bash

#chane the permission to excute
#chmod +x update.sh

# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
sudo apt install qemu-guest-agent -y
sudo systemctl restart qemu-guest-agent

#install openshh-server and configure it so that root can ssh as well
#sudo apt install openssh-server -y
#sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
#sudo systemctl restart ssh 



#for desktop servers to enable rdp un comment the lines below

sudo apt install xserver-xorg-core -y
sudo apt install xorgxrdp -y
sudo apt install xrdp -y







# Check if the line "AutomaticLoginEnable=True" exists in /etc/gdm3/custom.conf
if ! grep -q "^[^#].*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
  # Add the line under [daemon] if it doesn't already exist
  sed -i '/\[daemon\]/a AutomaticLoginEnable=True' /etc/gdm3/custom.conf
  echo "Line 'AutomaticLoginEnable=True' added to /etc/gdm3/custom.conf"
fi

# Check if the line "AutomaticLogin=root" exists in /etc/gdm3/custom.conf
if ! grep -q "^[^#].*AutomaticLogin=root" /etc/gdm3/custom.conf; then
  # Add the line under [daemon] if it doesn't already exist
  sed -i '/\[daemon\]/a AutomaticLogin=root' /etc/gdm3/custom.conf
  echo "Line 'AutomaticLogin=root' added to /etc/gdm3/custom.conf"
fi

# Check if the line "AllowRoot=True" exists below "# TimedLoginDelay = 10" in /etc/gdm3/custom.conf
if ! grep -q "#  TimedLoginDelay = 10.*AllowRoot=True" /etc/gdm3/custom.conf; then
  # Add the line below "# TimedLoginDelay = 10" if it doesn't already exist
  sed -i '/#  TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf
  echo "Line 'AllowRoot=True' added to /etc/gdm3/custom.conf"
fi

# Check if the line is already commented in /etc/pam.d/gdm-password
if ! grep -q "^[^#].*auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet" /etc/pam.d/gdm-password; then
  # Comment out the line in /etc/pam.d/gdm-password if it's not already commented
  sed -i 's/^auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet/#&/' /etc/pam.d/gdm-password
  echo "Line commented in /etc/pam.d/gdm-password"
fi





####################################################################################################################################

# Check if the lines already exist in /etc/gdm3/custom.conf
#if ! grep -q "AutomaticLoginEnable=True" /etc/gdm3/custom.conf || \
#   ! grep -q "AutomaticLogin=root" /etc/gdm3/custom.conf || \
#   ! grep -q "AllowRoot=True" /etc/gdm3/custom.conf; then

  # Add the lines under [daemon] if they don't already exist
#  sed -i '/\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=root' /etc/gdm3/custom.conf

  # Add the line AllowRoot=True below # TimedLoginDelay = 10 if it doesn't already exist
#  sed -i '/#  TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf

#  echo "Lines added to /etc/gdm3/custom.conf"
#fi

# Check if the line is already commented in /etc/pam.d/gdm-password
#if ! grep -q "^#.*auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet" /etc/pam.d/gdm-password; then
  # Comment out the line in /etc/pam.d/gdm-password if it's not already commented
#  sed -i 's/^auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet/#&/' /etc/pam.d/gdm-password
#  echo "Line commented in /etc/pam.d/gdm-password"
#fi



#############################################################################################################################################



# Check if the lines are already present in the file /etc/gdm3/custom.conf
#if grep -q "AutomaticLoginEnable=True" /etc/gdm3/custom.conf && grep -q "AutomaticLogin=root" /etc/gdm3/custom.conf && grep -q "AllowRoot=True" /etc/gdm3/custom.conf; then
#  echo "Lines already exist in /etc/gdm3/custom.conf"
#else
  # Add the lines under [daemon]
#  sed -i '/\[daemon\]/a AutomaticLoginEnable=True\nAutomaticLogin=root' /etc/gdm3/custom.conf

  # Add the line AllowRoot=True below # TimedLoginDelay = 10
#  sed -i '/#  TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf

  #echo "Lines added to /etc/gdm3/custom.conf"
#fi

# Comment out the line in /etc/pam.d/gdm-password
#sed -i 's/^auth required    pam_succeed_if.so user != root quiet/#&/' /etc/pam.d/gdm-password

#sed -i 's/^\s*auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet/#&/' /etc/pam.d/gdm-password

#cho "Line commented in /etc/pam.d/gdm-password"





# Remove and clear
sudo apt autoremove
history -c

# Delete the script file
rm "$0"


