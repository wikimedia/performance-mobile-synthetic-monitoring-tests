#!/bin/bash
LOGFILE=./logs/$1.log
exec > $LOGFILE 2>&1
DEVICE_ID=${1%%-*}

function printTemperature() {
    tempFromPhone=$(adb -s $1 shell dumpsys battery | grep temperature | grep -Eo '[0-9]{1,3}')
    tempInCelsius=$(echo "scale=1; $tempFromPhone/10" | bc -l )
    echo "Phone battery temperature $tempInCelsius ($2 sleep)"
}

for fileAndPath in tests/$1/*.txt ; do
    [ -e "$fileAndPath" ] || continue
    bash ./clearApplications.sh $DEVICE_ID
    FILENAME=$(basename $fileAndPath)
    POTENTIAL_CONFIG="./config/$1.${FILENAME%%.*}.json"
    [[ -f "$POTENTIAL_CONFIG" ]] && CONFIG_FILE="$POTENTIAL_CONFIG" || CONFIG_FILE="./config/$1.json"
    sitespeed.io --config ./$CONFIG_FILE $fileAndPath
    control
    printTemperature $DEVICE_ID 'before'
    sleep 120
    printTemperature $DEVICE_ID 'after'
done
for scriptAndPath in tests/$1/*.js ; do
    [ -e "$scriptAndPath" ] || continue
    bash ./clearApplications.sh $DEVICE_ID
    FILENAME=$(basename $scriptAndPath)
    POTENTIAL_CONFIG="./config/$1.${FILENAME%%.*}.json"
    [[ -f "$POTENTIAL_CONFIG" ]] && CONFIG_FILE="$POTENTIAL_CONFIG" || CONFIG_FILE="./config/$1.json"
    sitespeed.io --config ./$CONFIG_FILE $scriptAndPath --multi
    control
    printTemperature $DEVICE_ID 'before'
    sleep 120
    printTemperature $DEVICE_ID 'after'
done
# At the moment we only run WebPageReplay on one of the phones
if [ "$DEVICE_ID" = "ZY3222N2CZ" ]; then
    for file in tests/$1/*.wpr ; do
        while IFS= read url
        do
            bash ./clearApplications.sh $DEVICE_ID
            DEVICE_SERIAL=$DEVICE_ID ./wpr/wprAndroid.sh $url --config ./config/$1.json
            control
            sleep 300
        done <"$file"
        control
        printTemperature $DEVICE_ID 'before'
        sleep 600
        printTemperature $DEVICE_ID 'after'
    done
fi
