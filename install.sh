#!/bin/bash

# Install zram
sudo apt-get update
sudo apt-get install zram-tools -y

# Configure zram
sudo sed -i 's|/dev/zram0|/dev/zram0 none swap defaults 0 0|g' /etc/fstab
sudo sed -i 's|zram_size=$((1024*1024*1024))|zram_size=$((1024*1024*1024))|g' /usr/share/initramfs-tools/scripts/init-top/compressed_swap

# Update initramfs
sudo update-initramfs -u

# Create zram-config service
sudo tee /etc/systemd/system/zram-config.service << EOF
[Unit]
Description=ZRAM Configuration
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/usr/bin/zramctl --find --size 1024M
ExecStartPost=/sbin/mkswap /dev/zram0
ExecStartPost=/sbin/swapon --priority 100 /dev/zram0
ExecStop=/sbin/swapoff /dev/zram0
ExecStop=/usr/bin/zramctl --reset /dev/zram0
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and enable zram-config service
sudo systemctl daemon-reload
sudo systemctl enable zram-config.service

echo "ZRAM swap configured with 1GB size."
