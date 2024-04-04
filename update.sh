#!/bin/bash

############################################################################################################################################

#<<comment

# Fix repo problem in debian

sources_file_edit="#deb cdrom:[Debian GNU/Linux 12.1.0 _Bookworm_ - Official amd64 DVD Binary-1 with firmware 20230722-10:49]/ bookworm main non-free-firmware

deb http://deb.debian.org/debian/ bookworm main non-free-firmware
deb-src http://deb.debian.org/debian/ bookworm main

deb http://deb.debian.org/debian/ bookworm-updates main
deb-src http://deb.debian.org/debian/ bookworm-updates main

#deb http://security.debian.org/debian-security bookworm/updates main
#deb-src http://security.debian.org/debian-security bookworm/updates main

deb http://security.debian.org/debian-security bookworm-security main
deb-src http://security.debian.org/debian-security bookworm-security main
"

# Define the netplan configuration file path
sources_file="/etc/apt/sources.list"

# Check if the netplan configuration file already exists
if [[ -f "$sources_file" ]]; then
  # Check if there is existing configuration written
  # Check for any thing that is written in the configuration file
  if grep -qs '^' "$sources_file"; then  
    # Comment out the existing configuration
    sed -i 's/^/#/' "$sources_file"
    # Add the new configuration after commented lines
    echo "$sources_file_edit" | sudo tee -a "$sources_file" > /dev/null
    echo "Added the new repo after commenting the existing one"
  else
    # Write the netplan configuration to the file
    echo "$sources_file_edit" | sudo tee "$sources_file" > /dev/null
    echo "Added new repo to the empty file"
  fi
else
  # The file does not exists
  echo "The file $sources_file_edit does not exists"
fi

#comment

############################################################################################################################################

#<<comment

# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y

#comment

############################################################################################################################################

<<comment

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
sudo apt install qemu-guest-agent -y
sudo systemctl restart qemu-guest-agent

comment

############################################################################################################################################

<<comment

#install openshh-server
sudo apt install openssh-server -y

comment

############################################################################################################################################

#Configure ssh so that root can ssh as well

<<comment
# Check if "PermitRootLogin yes" exists and is commented in /etc/ssh/sshd_config
if grep -q "^\s*PermitRootLogin yes" /etc/ssh/sshd_config; then
  echo "The line 'PermitRootLogin yes' already exists in /etc/ssh/sshd_config"
else
  if grep -q "^\s*PermitRootLogin yes" /etc/ssh/sshd_config && grep -q "#\s*PermitRootLogin yes" /etc/ssh/sshd_config; then
    sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
    echo "Line 'PermitRootLogin yes' was commented but now added to /etc/ssh/sshd_config"
  else
    sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
    echo "Added line 'PermitRootLogin yes' above '#PermitRootLogin prohibit-password' in /etc/ssh/sshd_config"
  fi
fi

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

<<comment

#Enable rdp for root

# Check if "AutomaticLoginEnable=True" exists in /etc/gdm3/custom.conf
if grep -q "^\s*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
  # Check if the line is commented
  echo "Line 'AutomaticLoginEnable=True' already exists in custom.conf"
else
  if grep -q "^\s*AutomaticLoginEnable=True" /etc/gdm3/custom.conf && grep -q "^#.*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
    # Add a new line above the commented line
    sed -i '/^#.*AutomaticLoginEnable=True/i AutomaticLoginEnable=True' /etc/gdm3/custom.conf
    echo "Added a new line 'AutomaticLoginEnable=True' above the commented line in custom.conf"
  else
    sed -i '/\[daemon\]/a AutomaticLoginEnable=True' /etc/gdm3/custom.conf
    echo "Added a new line 'AutomaticLoginEnable=True' under [daemon] in custom.conf"
  fi
fi

# Check if "AutomaticLogin=root" exists in /etc/gdm3/custom.conf
if grep -q "^\s*AutomaticLogin=root" /etc/gdm3/custom.conf; then
  # Check if the line is commented
  echo "Line 'AutomaticLogin=root' already exists in custom.conf"
else
  if grep -q "^\s*AutomaticLogin=root" /etc/gdm3/custom.conf && grep -q "^#.*AutomaticLogin=root" /etc/gdm3/custom.conf; then
    # Add a new line above the commented line
    sed -i '/\[daemon\]/a AutomaticLogin=root' /etc/gdm3/custom.conf
    #sed -i '/^#.*AutomaticLogin=root/i AutomaticLogin=root' /etc/gdm3/custom.conf
    echo "Added a new line 'AutomaticLogin=root' above the commented line in custom.conf"
  else
    sed -i '/\[daemon\]/a AutomaticLogin=root' /etc/gdm3/custom.conf
    echo "Added a new line 'AutomaticLogin=root' under [daemon] in custom.conf"
  fi
fi

# Check if "AllowRoot=True" exists and is commented in /etc/gdm3/custom.conf (this works the intended way in differnet cases)
if grep -q "^\s*AllowRoot=True" /etc/gdm3/custom.conf; then
  echo "The line 'AllowRoot=True' already exists in /etc/gdm3/custom.conf"
else
  if grep -q "#\s*AllowRoot=True" /etc/gdm3/custom.conf; then
    sed -i '/#\s*TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf
    echo "Line 'AllowRoot=True' was commented but now added to /etc/gdm3/custom.conf"
  else
    sed -i '/#\s*TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf
    echo "Added line 'AllowRoot=True' in /etc/gdm3/custom.conf"
  fi
fi

# Check if the line "auth required pam_succeed_if.so user != root quite_success" is already commented in /etc/pam.d/gdm-password
if grep -q "^#.*auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet" /etc/pam.d/gdm-password; then
  echo "Line 'auth required pam_succeed_if.so user != root quite_success' is already commented in /etc/pam.d/gdm-password"
else
  # Add a comment above the line
  sed -i '/auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet/s/^/# /' /etc/pam.d/gdm-password
  echo "Added a comment above the line 'auth required pam_succeed_if.so user != root quite_success' in /etc/pam.d/gdm-password"
fi

# Restart the rdp service after changing the configuration files
sudo systemctl restart xrdp

comment

############################################################################################################################################

<<comment

# Define the netplan configuration template

#Insert the IP information below

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
netplan_file="/etc/netplan/01-network-manager-all.yaml"

# Check if the netplan configuration file already exists
if [[ -f "$netplan_file" ]]; then
  # Check if there is existing configuration written
  # Check for any thing that is written in the configuration file
  if grep -qs '^' "$netplan_file"; then  
    # Comment out the existing configuration
    sed -i 's/^/#/' "$netplan_file"
    # Add the new configuration after commented lines
    echo "$netplan_config" | sudo tee -a "$netplan_file" > /dev/null
  else
    # Write the netplan configuration to the file
    echo "$netplan_config" | sudo tee "$netplan_file" > /dev/null
  fi
else
  # The file does not exists
  echo "The file $netplan_file does not exists"
fi

# Apply the netplan configuration
sudo netplan apply

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

# Add a user to the sudoer group in debian
# Add user name in the place of <username> 
sudoers_file="/etc/sudoers"
if [[ -f "$sudoers_file" ]]; then
  sudo sed -i '/^root\s*ALL=(ALL:ALL) ALL$/a <username>  ALL=(ALL:ALL) ALL' /etc/sudoers
  echo "Add the user the sudoers group,"
else
  echo "The file does not exist in /etc/sudoers"
fi

comment

############################################################################################################################################

#<<comment

# Remove residual packages
#sudo apt-get clean -y
#sudo apt autoremove -y

# Remove residual packages
sudo apt-get clean -y
sudo apt autoremove -y
echo "Residual packages cleaned up."


#Clear command history 
history -c

#comment

############################################################################################################################################

# Error Handling (should be at the top )
#set -euo pipefail

# Logging Function ( this also should be at the top )
#log() {
#    echo "$(date +"%Y-%m-%d %T") - $1" >> /var/log/script.log
#}
# Variables ( this also should be at the top )
#TMP_DIR="/tmp"

#Remove the bash history
#sudo truncate -s 0 .bash_history
cat /dev/null > ~/.bash_history
history -w
# Clear command history
#history -c || true
#echo -n > ~/.bash_history || true
#echo "Command history cleared."


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
#log "Temporary files deleted."


# Delete the script file
#rm "$0"

# Delete the script file
rm "$0" || true
echo "Script file deleted."