#!/bin/bash

i=0
touch bandit0.txt
echo "bandit0" > bandit0.txt
while true
do
    clear
    ssh bandit$i@bandit.labs.overthewire.org -p 2220
    
    echo "Type 'nextl' to go to the next level, or anything else to exit:"
    read input
    
    if [[ "$input" == "nextl" ]]
    then
        ((i++))
        read -p "Enter New password for $i level : " passcode
        echo $passcode >> bandit0.txt

    else
        echo "Exiting..."
        break
    
    fi

done

clear
echo "--------------Exit Done--------------------"
