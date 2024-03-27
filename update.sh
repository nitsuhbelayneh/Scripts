#!/bin/bash

# Update the package lists
#sudo apt update

# Upgrade installed packages
#sudo apt-get dist-upgrade -y

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
#sudo apt install qemu-guest-agent -y
#sudo systemctl restart qemu-guest-agent


#install openshh-server and configure it so that root can ssh as well
#sudo apt install openssh-server -y

##############################################################################################################################





## Check if "PermitRootLogin yes" exists and is commented in /etc/ssh/sshd_config
#if grep -q "^\s*PermitRootLogin\s+yes" /etc/ssh/sshd_config; then
#  echo "The line 'PermitRootLogin yes' already exists in /etc/ssh/sshd_config"
#else
#  if grep -q "#\s*PermitRootLogin\s+yes" /etc/ssh/sshd_config; then
#    sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
#    echo "Line 'PermitRootLogin yes' was commented but now added to /etc/ssh/sshd_config"
#  else
#    sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
#    echo "Added line 'PermitRootLogin yes' above '#PermitRootLogin prohibit-password' in /etc/ssh/sshd_config"
#  fi
#fi


# Check if "PermitRootLogin yes" exists and is uncommented in /etc/ssh/sshd_config
if grep -q "^\s*PermitRootLogin\s+yes" /etc/ssh/sshd_config; then
  echo "The line 'PermitRootLogin yes' already exists and is uncommented in /etc/ssh/sshd_config"
else
  if grep -q "^\s*PermitRootLogin\s+yes" /etc/ssh/sshd_config && grep -q "^\s*#\s*PermitRootLogin\s+yes" /etc/ssh/sshd_config; then
    #sed -i '/^#PermitRootLogin\s+prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
    #sed -i '/#PermitRootLogin prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
    #sed -i '/^\s*#\s*PermitRootLogin\s+yes/s/^#\s*//' /etc/ssh/sshd_config
    sed -i '/#\s*#PermitRootLogin\s+prohibit-password/i PermitRootLogin yes' /etc/gdm3/custom.conf
    echo "Line 'PermitRootLogin yes' was commented but is now uncommented in /etc/ssh/sshd_config"
  else
    sed -i '/#\s*#PermitRootLogin\s+prohibit-password/i PermitRootLogin yes' /etc/gdm3/custom.conf
    #sed -i '/^\s*#\s*PermitRootLogin\s+yes/s/^#\s*//' /etc/ssh/sshd_config
    #sed -i '/^#PermitRootLogin\s+prohibit-password/i PermitRootLogin yes' /etc/ssh/sshd_config
    echo "Added line 'PermitRootLogin yes' above '#PermitRootLogin prohibit-password' in /etc/ssh/sshd_config"
  fi
fi






######################################################################################################################################

#sudo systemctl restart ssh 


#for desktop servers to enable rdp un comment the lines below

#sudo apt install xserver-xorg-core -y
#sudo apt install xorgxrdp -y
#sudo apt install xrdp -y





## Check if "AutomaticLoginEnable=True" exists in /etc/gdm3/custom.conf
#if grep -qE "^\s*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
#  # Check if the line is commented
#  if ! grep -qE "^#.*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
#    # Add a new line above the commented line
#    echo "Line 'AutomaticLoginEnable=True' already exists in custom.conf"
#    #sed -i '/^#.*AutomaticLoginEnable=True/i AutomaticLoginEnable=True' /etc/gdm3/custom.conf
#    
#  else
#    sed -i '/\[daemon\]/a AutomaticLoginEnable=True' /etc/gdm3/custom.conf
#    echo "Added a new line 'AutomaticLoginEnable=True' above the commented line in custom.conf"
#  fi
#else
#  # Add the line under [daemon]
#  sed -i '/\[daemon\]/a AutomaticLoginEnable=True' /etc/gdm3/custom.conf
#  echo "Added line 'AutomaticLoginEnable=True' under [daemon] in custom.conf"
#fi
#
## Check if "AutomaticLogin=root" exists in /etc/gdm3/custom.conf
#if grep -q "AutomaticLogin=root" /etc/gdm3/custom.conf; then
#  # Check if the line is commented
#  if grep -q "^#.*AutomaticLogin=root" /etc/gdm3/custom.conf; then
#    # Add a new line above the commented line
#    sed -i '/\[daemon\]/a AutomaticLogin=root' /etc/gdm3/custom.conf
#    #sed -i '/^#.*AutomaticLogin=root/i AutomaticLogin=root' /etc/gdm3/custom.conf
#    echo "Added a new line 'AutomaticLogin=root' above the commented line in custom.conf"
#  else
#    echo "Line 'AutomaticLogin=root' already exists in custom.conf"
#  fi
#else
#  # Add the line under [daemon]
#  sed -i '/\[daemon\]/a AutomaticLogin=root' /etc/gdm3/custom.conf
#  echo "Added line 'AutomaticLogin=root' under [daemon] in custom.conf"
#fi


#the below script works fine

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
  echo "Line 'auth required pam_succeed_if.so user != root quite_success' is already commented in gdm-password"
else
  # Add a comment above the line
  sed -i '/auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet/s/^/# /' /etc/pam.d/gdm-password
  echo "Added a comment above the line 'auth required pam_succeed_if.so user != root quite_success' in gdm-password"
fi




# Restart the rdp service after changing the configuration files
sudo systemctl restart xrdp


# Remove and clear
sudo apt autoremove
history -c


# Delete the script file
rm "$0"



#the order shod be 
#if 
#  chek is the wanted line is in the wanted postion?
#  print the line alrady exists
#else 
#  insert the line in the expected postion
#  print the line has been insterted


# next write the netplan configuration script