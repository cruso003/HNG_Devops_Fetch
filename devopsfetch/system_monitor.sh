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
