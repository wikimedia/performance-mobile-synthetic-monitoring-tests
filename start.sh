#!/bin/bash

PHONES=(ZY3222N2CZ-Moto-G5-Root-WebPageReplay ZY2242HHQ8-Moto-G4 ZY2242HJDX-Moto-G4)

if [ -z "$1" ]
then
    for phone in  "${PHONES[@]}"; do
        CONTROL_FILE="./locks/$phone.run"
        
        if [ -f "$CONTROL_FILE" ]
        then
            echo "Not starting $phone since lock file $CONTROL_FILE exist."
        else
            echo "Starting $phone"
            nohup ./loop.sh $phone &
        fi
    done
else
    CONTROL_FILE="./locks/$1.run"
    
    if [ -f "$CONTROL_FILE" ]
    then
        echo "Not starting $1 since lock file $CONTROL_FILE exist."
    else
        echo "Starting $1"
        nohup ./loop.sh $1 &
    fi
fi
