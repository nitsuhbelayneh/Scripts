#!/bin/bash

<<comment
# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y

#install qemu guest agent and restart it (so the machine better comunicate with proxmox)
sudo apt install qemu-guest-agent -y
sudo systemctl restart qemu-guest-agent

comment


<<comment

#install openshh-server and configure it so that root can ssh as well
sudo apt install openssh-server -y

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

#Restart the ssh Service
sudo systemctl restart ssh 

comment



<<comment

#for desktop servers to install and enable rdp for root
sudo apt install xserver-xorg-core -y
sudo apt install xorgxrdp -y
sudo apt install xrdp -y

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

# Remove residual packages
sudo apt autoremove -y

#Clear command history 
#history -c

#Remove the bash history
sudo cat /dev/null > ~/.bash_history 
sudo cat /dev/null > ~/.bash_history
sudo echo -n > ~/.bash_history
sudo truncate -s 0 ~/.bash_history

#sudo rm ~/.bash_history
#sudo touch ~/.bash_history

sudo -i  # Switch to root user
history -c  # Clear command history for regular user
exit  # Exit from root user session
history -c  # Clear command history for root user




# Delete the script file
rm "$0"
