#!/bin/bash

############################################################################################################################################

#add this to the main script (update.sh)

netplan_config="network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens18:
      addresses:
      - 
      routes:
      - to: 0.0.0.0/0
        via: 
      nameservers:
        addresses:
        - 
        - 8.8.8.8
    ens19:
      addresses:
      - 
      routes:
      - to: 
        via: 
      - to: 
        via: 
      - to: 
        via: "
# Define the netplan configuration file path
netplan_file="/etc/netplan/new"
#netplan_file="/etc/netplan/01-network-manager-all.yaml"

# Check if the netplan configuration file already exists
if [[ -f "$netplan_file" ]]; then
  # Check if there is existing configuration written
  #Check for any thing that is written in the configuration file
  if grep -qs '^' "$netplan_file"; then  
  #Check only for the word network in the configuration file
  #if grep -q 'network:' "$netplan_file"; then
    # Comment out the existing configuration
    sed -i 's/^/#/' "$netplan_file"
    # Add the new configuration after commented lines
    echo "$netplan_config" | sudo tee -a "$netplan_file" > /dev/null
  else
    # Write the netplan configuration to the file
    echo "$netplan_config" | sudo tee "$netplan_file" > /dev/null
  fi
else
  # Write the netplan configuration to the file
  echo "The file $netplan_file does not exists"
  #echo "$netplan_config" | sudo tee "$netplan_file" > /dev/null
fi

# Apply the netplan configuration
sudo netplan apply

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