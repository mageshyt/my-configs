#!/bin/bash


# ensure fzf is installed
if ! command -v fzf &> /dev/null; then
    echo -e "\033[31mError: fzf not found. Please install it and try again.\033[0m"
    exit 1
fi

# list all running processes and allow user to select
selected_process=$(ps aux | fzf)

# extract pid from the selection
selected_process=$(ps aux --sort=-%mem | grep -v "fzf" | fzf --header="Select a Process to Kill" --preview="echo {}" --exit-0)

# Check if a process was selected
if [ -z "$selected_pid" ]; then
    echo -e "\033[33mNo process selected. Exiting.\033[0m"
    exit 1
fi

# confirm the kill action with color
echo -e "\033[34mYou selected process with PID \033[32m$selected_pid\033[34m.\033[0m"

echo -e "\033[33mAre you sure you want to kill this process? (y/n)\033[0m"
read -r response

if [[ "$response" =~ ^[Yy]$ ]]; then
    kill -9 "$selected_pid"
    if [ $? -eq 0 ]; then
      echo -e "\033[32mprocess with pid $selected_pid successfully killed.\033[0m"

    else
      echo -e "\033[31mFailed to kill the process with PID $selected_pid.\033[0m"
    fi

  else
    echo -e "\033[33mOperation canceled.\033[0m"

fi


  
