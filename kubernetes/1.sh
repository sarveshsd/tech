#!/bin/bash

# Function to kill processes using a specified port
kill_process_by_port() {
    local port=$1
    echo "Killing processes using port ${port}..."
    # Find the process ID(s) using the specified port and kill them
    for pid in $(lsof -t -i :$port); do
        echo "Killing process with PID ${pid}..."
        kill -9 "$pid"
    done
}

# Call the function for each port
kill_process_by_port 5432
kill_process_by_port 3000
kill_process_by_port 8080

echo "Processes killed for ports 5432, 3000, and 8080."