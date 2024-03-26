#!/bin/bash

## Check if "AutomaticLoginEnable=True" exists in /etc/gdm3/custom.conf
#if grep -q "AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
#  # Check if the line is commented
#  if grep -q "^#.*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
#    # Add a new line above the commented line
#    sed -i '/^#.*AutomaticLoginEnable=True/i AutomaticLoginEnable=True' /etc/gdm3/custom.conf
#    echo "Added a new line 'AutomaticLoginEnable=True' above the commented line in custom.conf"
#  else
#    echo "Line 'AutomaticLoginEnable=True' already exists in custom.conf"
#  fi
#else
#  # Add the line at the end of the file
#  echo "AutomaticLoginEnable=True" >> /etc/gdm3/custom.conf
#  echo "Added line 'AutomaticLoginEnable=True' to custom.conf"
#fi




##############################################################################



sudo apt install openssh-server -y


# Check if the line "#PermitRootLogin prohibit-password" exists in /etc/ssh/sshd_config
if grep -q "#PermitRootLogin prohibit-password" /etc/ssh/sshd_config; then
  # Add a new line above the line
  sed -i '/#PermitRootLogin prohibit-password/i \your_new_line_here' /etc/ssh/sshd_config
  echo "Added a new line above the line '#PermitRootLogin prohibit-password' in sshd_config"
else
  echo "Line '#PermitRootLogin prohibit-password' does not exist in sshd_config"
fi








# Check if "AutomaticLoginEnable=True" exists in /etc/gdm3/custom.conf
if grep -q "AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
  # Check if the line is commented
  if grep -q "^#.*AutomaticLoginEnable=True" /etc/gdm3/custom.conf; then
    # Add a new line above the commented line
    sed -i '/^#.*AutomaticLoginEnable=True/i AutomaticLoginEnable=True' /etc/gdm3/custom.conf
    echo "Added a new line 'AutomaticLoginEnable=True' above the commented line in custom.conf"
  else
    echo "Line 'AutomaticLoginEnable=True' already exists in custom.conf"
  fi
else
  # Add the line under [daemon]
  sed -i '/\[daemon\]/a AutomaticLoginEnable=True' /etc/gdm3/custom.conf
  echo "Added line 'AutomaticLoginEnable=True' under [daemon] in custom.conf"
fi

# Check if "AutomaticLogin=root" exists in /etc/gdm3/custom.conf
if grep -q "AutomaticLogin=root" /etc/gdm3/custom.conf; then
  # Check if the line is commented
  if grep -q "^#.*AutomaticLogin=root" /etc/gdm3/custom.conf; then
    # Add a new line above the commented line
    sed -i '/^#.*AutomaticLogin=root/i AutomaticLogin=root' /etc/gdm3/custom.conf
    echo "Added a new line 'AutomaticLogin=root' above the commented line in custom.conf"
  else
    echo "Line 'AutomaticLogin=root' already exists in custom.conf"
  fi
else
  # Add the line under [daemon]
  sed -i '/\[daemon\]/a AutomaticLogin=root' /etc/gdm3/custom.conf
  echo "Added line 'AutomaticLogin=root' under [daemon] in custom.conf"
fi

# Check if "AllowRoot=True" exists below "# TimedLoginDelay = 10" in /etc/gdm3/custom.conf
if grep -q "# TimedLoginDelay = 10" /etc/gdm3/custom.conf | grep -q "AllowRoot=True"; then
  # Check if the line is commented
  if grep -q "^#.*AllowRoot=True" /etc/gdm3/custom.conf; then
    # Add a new line below "# TimedLoginDelay = 10"
    sed -i '/# TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf
    echo "Added a new line 'AllowRoot=True' below '# TimedLoginDelay = 10' in custom.conf"
  else
    echo "Line 'AllowRoot=True' already exists below '# TimedLoginDelay = 10' in custom.conf"
  fi
else
  # Add the line under "# TimedLoginDelay = 10"
  sed -i '/# TimedLoginDelay = 10/a AllowRoot=True' /etc/gdm3/custom.conf
  echo "Added line 'AllowRoot=True' under '# TimedLoginDelay = 10' in custom.conf"
fi

# Check if the line "auth required pam_succeed_if.so user != root quite_success" is already commented in /etc/pam.d/gdm-password
if grep -q "^[^#].*auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet" /etc/pam.d/gdm-password; then
  echo "Line 'auth required pam_succeed_if.so user != root quite_success' is already commented in gdm-password"
else
  # Comment the line
  sed -i 's/^\(.*auth\s\+required\s\+pam_succeed_if\.so\s\+user\s\+!=\s\+root\s\+quiet\)/# \1/' /etc/pam.d/gdm-password
  echo "Commented the line 'auth required pam_succeed_if.so user != root quite_success' in gdm-password"
fi