#!/bin/bash

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Update package list and install dependencies
apt-get update
apt-get install -y jq docker.io nginx net-tools logrotate

# Enable and start Docker
systemctl enable docker
systemctl start docker

# Enable and start Nginx
systemctl enable nginx
systemctl start nginx

# Make devopsfetch a command
DEVOPS_FETCH_PATH="/home/truthserum/HNG_Devops_Fetch/devopsfetch/devopsfetch.sh"
cp "$DEVOPS_FETCH_PATH" /usr/local/bin/devopsfetch.sh
chmod +x /usr/local/bin/devopsfetch.sh

# Create symbolic link
if [ -L /usr/local/bin/devopsfetch ]; then
    rm /usr/local/bin/devopsfetch
fi

ln -s /usr/local/bin/devopsfetch.sh /usr/local/bin/devopsfetch

# Create the monitoring script
MONITOR_SCRIPT_PATH="/home/truthserum/HNG_Devops_Fetch/devopsfetch/system_monitor.sh"
cat << EOF > "$MONITOR_SCRIPT_PATH"
#!/bin/bash

while true; do
    {
        devopsfetch -p
        echo -e "\n"
        devopsfetch -d
        echo -e "\n"
        devopsfetch -n
        echo -e "\n"
        devopsfetch -u
        echo -e "\n"
        devopsfetch -t "00:00:00 to 23:59:59"
        echo -e "\n"
    } | tee -a /var/log/system_monitor.log

    sleep 43200  # 12 hours
done
EOF

chmod +x "$MONITOR_SCRIPT_PATH"

# Create systemd service for the monitoring script
cat << EOF > /etc/systemd/system/system-monitor.service
[Unit]
Description=System Monitoring Service
After=network.target

[Service]
ExecStart=$MONITOR_SCRIPT_PATH
Restart=always
User=root

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable system-monitor.service
systemctl start system-monitor.service

# Set up log rotation for the monitoring log
cat << EOF > /etc/logrotate.d/system-monitor
/var/log/system_monitor.log {
    daily
    rotate 7
    compress
    delaycompress
    missingok
    notifempty
    create 644 root root
}
EOF

# Create systemd service for devopsfetch (if needed for standalone execution)
cat << EOF > /etc/systemd/system/devopsfetch.service
[Unit]
Description=DevOps Fetch Service
After=network.target

[Service]
ExecStart=$DEVOPS_FETCH_PATH -t "00:00:00 to 23:59:59"
Restart=always
User=root
RestartSec=10
StartLimitInterval=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable devopsfetch.service
systemctl start devopsfetch.service

# Set up log rotation for devopsfetch log
LOGROTATE_CONF="/etc/logrotate.d/devopsfetch"
cat << EOL > $LOGROTATE_CONF
/var/log/devopsfetch.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 0644 root root
    su root root
}
EOL

logrotate -f $LOGROTATE_CONF

echo "Installation complete. The devopsfetch and system-monitor services have been started."
