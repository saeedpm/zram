#!/bin/bash

swap_size=1G

# Install necessary packages
sudo apt-get update && sudo apt-get install -y zram-tools

# Enable zramswap
sudo sed -i 's/^#zram$/zram/' /etc/modules
sudo sed -i "s/^#SIZE=$/SIZE=$swap_size/" /etc/default/zramswap
sudo sed -i 's/^#PRIORITY=/PRIORITY=/' /etc/default/zramswap
sudo systemctl enable zramswap.service
sudo systemctl start zramswap.service
