#!/bin/bash

############################################################################################################################################

<<comment



comment

############################################################################################################################################

<<comment



comment

############################################################################################################################################

<<comment



comment

############################################################################################################################################

<<comment



comment

############################################################################################################################################

<<comment



comment

############################################################################################################################################

<<comment



comment

############################################################################################################################################


<<comment

# Remove xfc

sudo apt purge xfdesktop4 -y
sudo apt purge xfce4* 
sudo apt purge xfce4
sudo apt purge xfce4-session
sudo apt purge lightdm-gtk-greeter
sudo apt autoremove


#sudo apt-get purge xfconf xfce4-utils xfwm4 xfce4-session xfdesktop4 exo-utils xfce4-panel xfce4-terminal  thunar
sudo apt autoremove --purge xfce*

comment

############################################################################################################################################
<<comment

# Install winbox

sudo apt update
sudo apt install snapd -y
sudo snap install core
sudo snap install winbox

comment

<<comment

# Modify the bashrc file so that winbox can be opened from the command line

lineToAdd='export PATH="$PATH:/snap/bin"'
#bashrcFile=~/.bashrc
bashrcFile=/home/clean/.bashrc

# Check if the file exists
if [[ -f "$bashrcFile" ]]; then
  # Add the line at the end of the file
  echo "$lineToAdd" >> "$bashrcFile"
  echo "The line has been added to $bashrcFile."
else
  echo "The file $bashrcFile does not exist."
fi

comment

<<comment

# Add the desktop icon 
# Step 1: Create the .desktop file
touch ~/.local/share/applications/winbox.desktop
cat <<EOT > ~/.local/share/applications/winbox.desktop
[Desktop Entry]
Name=Winbox
Exec=/snap/bin/winbox
Icon=winbox
Type=Application
Categories=Network;Utility;
EOT

# Step 2: Make the .desktop file executable
chmod +x ~/.local/share/applications/winbox.desktop

comment

############################################################################################################################################

<<comment

# Install vscode

sudo apt update

sudo apt install software-properties-common apt-transport-https wget gpg -y

wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg 

sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg 

sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

sudo apt update

sudo apt install code -y

comment

<<comment

# Remove VS Code
sudo apt remove code -y

# Remove the VS Code repository configuration
sudo rm /etc/apt/sources.list.d/vscode.list

# Remove the Microsoft GPG key used for repository verification
sudo rm /usr/share/keyrings/packages.microsoft.gpg

# Clean up any unused dependencies
sudo apt autoremove --purge -y

echo "Completly removed vscode"

# Update package lists
sudo apt update

comment

############################################################################################################################################

<<comment

#Remove xrdp

sudo apt-get remove xrdp -y
sudo apt-get remove --auto-remove xrdp -y
sudo apt-get purge xrdp -y
sudo apt-get purge --auto-remove xrdp -y
sudo apt autoremove -y

comment

############################################################################################################################################

# Error Handling (should be at the top )
#set -euo pipefail

# Logging Function ( this also should be at the top )
#log() {
#    echo "$(date +"%Y-%m-%d %T") - $1" >> /var/log/script.log
#}

# Variables ( this also should be at the top )
#TMP_DIR="/tmp"

# Clear logs
#sudo truncate -s 0 /var/log/syslog
#sudo truncate -s 0 /var/log/auth.log

# Clear logs
#sudo truncate -s 0 /var/log/syslog
#sudo truncate -s 0 /var/log/auth.log
#echo "Logs cleared."

# Delete temporary files
#sudo rm -rf /tmp/*

# Delete temporary files
#sudo rm -rf "$TMP_DIR"/*
#echo "Temporary files deleted."