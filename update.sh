#!/bin/bash

# Update the package lists
sudo apt update

# Upgrade installed packages
sudo apt-get dist-upgrade -y



# Delete the script file
rm "$0"
