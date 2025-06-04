#!/bin/bash

# Create passcodes.txt with 'bandit0' if it doesn't exist
if [[ ! -f passcodes.txt ]]
then
    echo "bandit0" > passcodes.txt
    start_level=0
else
    # Count the number of passwords to determine the last completed level
    num_passwords=$(wc -l < passcodes.txt)
    start_level=$((num_passwords -1))
fi

max_level=34  # Set maximum level (adjust as needed)

i=$start_level
while [[ $i -le $max_level ]]
do
    clear
    # Read password for current level (i+1 th line)
    password=$(sed -n "$((i+1))p" passcodes.txt)

    if [[ -z "$password" ]]
    then
        echo "❌ No password found for level $i in passcodes.txt. Exiting with code 1."
        exit 1
    fi

    echo "🔐 Connecting to bandit$i..."

    # Attempt SSH connection (interactive session)
    if ! sshpass -p "$password" ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no \
        bandit$i@bandit.labs.overthewire.org -p 2220
    then
        echo "❌ Failed to connect to bandit$i. Exiting with code 1."
        exit 1
    fi

    # Prompt for next level's password after exiting SSH
    read -p "Enter new password for level $((i + 1)): " passcode
    if [[ -z "$passcode" ]]
    then
        echo "❌ No password entered for level $((i + 1)). Exiting with code 1."
        exit 1
    fi

    # Append the new password to passcodes.txt
    echo "$passcode" >> passcodes.txt
    ((i++))
done

clear
echo "--------------Exit Done--------------------"