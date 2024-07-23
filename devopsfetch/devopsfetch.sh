#!/bin/bash

print_help() {
    echo "Usage: $0 [OPTION]...
Collect and display system information.

Options:
  -p, --port [PORT_NUMBER]     Display active ports and services. Optionally provide a specific port number.
  -d, --docker [CONTAINER_NAME] List Docker images and containers. Optionally provide a specific container name.
  -n, --nginx [DOMAIN]         Display Nginx domains and their ports. Optionally provide a specific domain.
  -u, --users [USERNAME]       List users and their last login times. Optionally provide a specific username.
  -t, --time [TIME_RANGE]      Display activities within a specified time range.
  -h, --help                   Display this help message and exit."
}

list_ports() {
    if [[ -n $1 ]]; then
        netstat -tuln | grep ":$1"
    else
        netstat -tuln
    fi | column -t
}

list_docker() {
    if [[ -n $1 ]]; then
        docker inspect $1
    else
        echo "Images:"
        docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.CreatedAt}}"
        echo "Containers:"
        docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
    fi
}

list_nginx() {
    if [[ -n $1 ]]; then
        nginx -T 2>/dev/null | awk "/server_name $1/,/}/"
    else
        nginx -T 2>/dev/null | grep -E "server_name|listen"
    fi
}

list_users() {
    if [[ -n $1 ]]; then
        lastlog -u $1
    else
        lastlog
    fi | column -t
}

while [[ "$1" != "" ]]; do
    case $1 in
        -p | --port )           shift
                                list_ports $1
                                exit
                                ;;
        -d | --docker )         shift
                                list_docker $1
                                exit
                                ;;
        -n | --nginx )          shift
                                list_nginx $1
                                exit
                                ;;
        -u | --users )          shift
                                list_users $1
                                exit
                                ;;
        -t | --time )           shift
                                echo "Time range functionality not yet implemented."
                                exit
                                ;;
        -h | --help )           print_help
                                exit
                                ;;
        * )                     print_help
                                exit 1
    esac
    shift
done

print_help
