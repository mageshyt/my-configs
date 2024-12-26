#!/usr/bin/env bash

# Ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo -e "\033[31mError: fzf not found. Please install it and try again.\033[0m"
    exit 1
fi

# Function to kill a process by PID
kill_process_by_pid() {
    local pid=$1
    echo -e "\033[34mKilling process with PID \033[32m$pid\033[34m...\033[0m"
    kill -9 "$pid"
    if [ $? -eq 0 ]; then
        echo -e "\033[32mProcess with PID $pid successfully killed.\033[0m"
    else
        echo -e "\033[31mFailed to kill the process with PID $pid.\033[0m"
    fi
}

# Function to kill a process by port
kill_process_by_port() {
    local port=$1
    # Find the PID using the given port
    pid=$(lsof -t -i :$port) 
    pname=$(ps -p $pid -o comm=)


    if [ -n "$pid" ]; then
        echo -e "\033[34mFound process with PID \033[32m$pid and $pname \033[34m listening on port \033[32m$port\033[0m."
        echo -e "\033[33mAre you sure you want to kill this process? (y/n) \033[0m"
        read -r response
        if [[ "$response" =~ ^[Yy]$ ]]; then
            kill_process_by_pid "$pid"
        else
            echo -e "\033[33mOperation canceled.\033[0m"
        fi
    else
        echo -e "\033[31mNo process found listening on port $port.\033[0m"
    fi
}
# List all running ports and allow user to select using fzf
selected_process=$(lsof -i -P -n | grep LISTEN | awk '{print "PID: "$2, "Command: "$1, "Address: "$9}' | fzf)

# Extract PID from the selection
selected_pid=$(echo "$selected_process" | awk '{print $2}')

# If no process is selected, prompt for a port number
if [ -z "$selected_pid" ]; then
    echo -e "\033[33mNo process selected from fzf.\033[0m"
    echo -e "\033[33mPlease enter the port number to kill the process: \033[0m"
    read -r port

    if [[ -z "$port" ]]; then
        echo -e "\033[31mPort number cannot be empty. Exiting.\033[0m"
        exit 1
    fi

    kill_process_by_port "$port"
else
    # If a process is selected, show the details and confirm kill action
    echo -e "\033[34mYou selected the process with PID \033[32m$selected_pid\033[34m.\033[0m"
    echo -e "\033[33mAre you sure you want to kill this process? (y/n) \033[0m"
    read -r response

    if [[ "$response" =~ ^[Yy]$ ]]; then
        kill_process_by_pid "$selected_pid"
    else
        echo -e "\033[33mOperation canceled.\033[0m"
    fi
fi

