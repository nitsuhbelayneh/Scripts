#!/bin/bash

# Define the netplan configuration template
netplan_config="network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens18:
      addresses:
      - 196.189.155.143/27
      routes:
      - to: 0.0.0.0/0
        via: 196.189.155.129
      nameservers:
        addresses:
        - 10.3.1.5 
        - 8.8.8.8
    ens19:
      addresses:
      - 172.16.143.50/29
      routes:
      - to: 10.190.10.16/32
        via: 172.16.143.49
      - to: 10.204.182.92/32
        via: 172.16.143.49
      - to: 10.175.206.40/29
        via: 172.16.143.49"

# Define the netplan configuration file path
netplan_file="/etc/netplan/new/01-network-manager-all.yaml"

# Write the netplan configuration to the file
echo "$netplan_config" | sudo tee "$netplan_file" > /dev/null

# Apply the netplan configuration
sudo netplan apply