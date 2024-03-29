#!/bin/bash



  
#<<comment

############################################################################################################################################

#add this to the main script (update.sh)

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

############################################################################################################################################

# Define the netplan configuration template
netplan_config="network:
  version: 2
  renderer: NetworkManager
  ethernets:
    ens18:
      addresses:
      - 196.189.155.143/27 #Change This
      routes:
      - to: 0.0.0.0/0
        via: 196.189.155.129 #Change This
      nameservers:
        addresses:
        - 10.3.1.5 
        - 8.8.8.8
    ens19:
      addresses:
      - 172.16.143.50/29
      routes:
      - to: 10.190.10.16/32
        via: 172.16.143.49 #Change This
      - to: 10.204.182.92/32
        via: 172.16.143.49 #Change This
      - to: 10.175.206.40/29
        via: 172.16.143.49" #Change This

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