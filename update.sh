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

#<<comment

#install openshh-server
sudo apt install openssh-server -y



#Restart the ssh Service
sudo systemctl restart ssh 

#comment

############################################################################################################################################

#<<comment

# Install xrdp for desktop servers

sudo apt install xserver-xorg-core -y
sudo apt install xorgxrdp -y
sudo apt install xrdp -y



# Define the target directory and file path
target_dir="/etc/polkit-1/localauthority/50-local.d"
target_file="${target_dir}/45-allow-colord.pkla"

# Define the content to be added
color_profile="[Allow Colord all Users]
Identity=unix-user:*
Action=org.freedesktop.color-manager.create-device;org.freedesktop.color-manager.create-profile;org.freedesktop.color-manager.delete-device;org.freedesktop.color-manager.delete-profile;org.freedesktop.color-manager.modify-device;org.freedesktop.color-manager.modify-profile
ResultAny=no
ResultInactive=no
ResultActive=yes"

# Create the directory if it doesn't exist
if [ ! -d "$target_dir" ]; then
  sudo mkdir -p "$target_dir"
  if [ $? -ne 0 ]; then
    echo "Failed to create directory: $target_dir"
    exit 1
  fi
fi

# Create the file and write the content to it
if [ ! -f "$target_file" ]; then
  echo "$color_profile" | sudo tee "$target_file" > /dev/null
  if [ $? -ne 0 ]; then
    echo "Failed to write to file: $target_file"
    exit 1
  else
    echo "Successfully wrote to file: $target_file"
  fi
else
  echo "File already exists: $target_file"
fi



# Restart the rdp service after changing the configuration files
sudo systemctl restart xrdp

#comment

############################################################################################################################################

#<<comment

# Remove residual packages
sudo apt-get clean -y
sudo apt autoremove -y
echo "Residual packages cleaned up."

#Remove the bash history
sudo truncate -s 0 .bash_history
cat /dev/null > ~/.bash_history
echo -n > ~/.bash_history
sed -i '$ d' ~/.bash_history

#Clear command history 
history -c
history -w

#history -c
echo "Command history cleared."

#comment

############################################################################################################################################

# Delete the script file
rm "$0"
echo "Script file deleted."

# Completely clear the command history
history -c && history -w
