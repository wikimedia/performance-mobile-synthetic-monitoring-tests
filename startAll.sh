#!/bin/bash

phones=(ZY3222N2CZ-Moto-G5-Root-WebPageReplay ZY2242HHQ8-Moto-G4 ZY2242HJDX-Moto-G4)

for phone in  "${phones[@]}"; do
    CONTROL_FILE="./locks/$phone.run"
    
    if [ -f "$CONTROL_FILE" ]
    then
        echo "Not starting $phone since lock file $CONTROL_FILE exist."
    else
        echo "Starting $phone"
        nohup ./start.sh $phone &
    fi
done
