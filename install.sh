#!/bin/bash

# Install zram
sudo apt-get update
sudo apt-get install zram-tools -y

# Configure zram
sudo sed -i 's|/dev/zram0|/dev/zram0 none swap defaults 0 0|g' /etc/fstab
sudo sed -i 's|#zram_size=auto|zram_size=$((1024*1024*1024))|g' /usr/share/initramfs-tools/scripts/init-top/compressed_swap

# Update initramfs
sudo update-initramfs -u

# Enable zram
sudo systemctl enable zram-config.service

echo "ZRAM swap configured with 1GB size."
