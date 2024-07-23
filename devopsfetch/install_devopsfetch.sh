#!/bin/bash

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Install dependencies
apt-get update
apt-get install -y net-tools docker.io nginx

# Create devopsfetch directory
mkdir -p /opt/devopsfetch
cp devopsfetch.sh /opt/devopsfetch/
chmod +x /opt/devopsfetch/devopsfetch.sh

# Create systemd service
cat <<EOF > /etc/systemd/system/devopsfetch.service
[Unit]
Description=Devopsfetch Service
After=network.target

[Service]
ExecStart=/opt/devopsfetch/devopsfetch.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd and start service
systemctl daemon-reload
systemctl enable devopsfetch.service
systemctl start devopsfetch.service

echo "Devopsfetch installed and service started."
