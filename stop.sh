#!/bin/bash

PHONES=(ZY3222N2CZ-Moto-G5-Root-WebPageReplay ZY2242HHQ8-Moto-G4 ZY2242HJDX-Moto-G4)
PHONES_TO_STOP=()

function printTemperature() {
    tempFromPhone=$(adb -s $1 shell dumpsys battery | grep temperature | grep -Eo '[0-9]{1,3}')
    tempInCelsius=$(echo "scale=1; $tempFromPhone/10" | bc -l )
    echo "Phone $1 battery temperature $tempInCelsius"
}

if [ -z "$1" ]
then
    echo 'Stop tests on all phones'
    for phone in "${PHONES[@]}"; do
        CONTROL_FILE="./locks/$phone.run"
        if [ -f "$CONTROL_FILE" ]
        then
            rm "$CONTROL_FILE"
            echo "Removed lock file for $phone"
            DEVICE_ID=${phone%%-*}
            printTemperature $DEVICE_ID
            PHONES_TO_STOP+=($phone)
        else
            echo "No lock file for $phone"
        fi
    done
else
    echo "Stop tests running on $1"
    CONTROL_FILE="./locks/$1.run"
    if [ -f "$CONTROL_FILE" ]
    then
        rm "$CONTROL_FILE"
        echo "Removed lock file for $1"
        DEVICE_ID=${1%%-*}
        printTemperature $DEVICE_ID
        PHONES_TO_STOP+=($1)
    else
        echo "No lock file for $1"
    fi
fi

for phone in "${PHONES_TO_STOP[@]}"; do
    echo "Wait on test on $phone to stop"
    while ps axg | grep -vw grep | grep -w "/bin/bash ./start.sh $phone" > /dev/null; do sleep 10; done
    echo "$phone stopped"
done