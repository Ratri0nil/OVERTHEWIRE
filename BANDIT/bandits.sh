#!/bin/bash

if [[ ! -f passcodes.txt ]] 
then
    echo "bandit0" > passcodes.txt
fi

i=0
while [[ $i -le 34 ]]
do
    clear
    password=$(sed -n "$((i+1))p" passcodes.txt)

    echo "🔐 Connecting to bandit$i..."
    
    sshpass -p "$password" ssh bandit$i@bandit.labs.overthewire.org -p 2220

    read -p "Enter New password for level $((i + 1)) : " passcode
    if [[ -z "$passcode" ]]
    then
        echo "❌ No password entered. Exiting with code 1."
        exit 1
    else
        echo "$passcode" >> passcodes.txt
        ((i++))
    fi
done

clear
echo "--------------Exit Done--------------------"
