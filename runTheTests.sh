#!/bin/bash
LOGFILE=./logs/$1.log
exec > $LOGFILE 2>&1
DEVICE_ID=${1%%-*}

for fileAndPath in tests/$1/*.txt ; do
    [ -e "$fileAndPath" ] || continue
    FILENAME=$(basename $fileAndPath)
    POTENTIAL_CONFIG="./config/$1.${FILENAME%%.*}.json"
    [[ -f "$POTENTIAL_CONFIG" ]] && CONFIG_FILE="$POTENTIAL_CONFIG" || CONFIG_FILE="./config/$1.json"
    sitespeed.io --config ./$CONFIG_FILE $fileAndPath
    control
    sleep 120
done
for scriptAndPath in tests/$1/*.js ; do
    [ -e "$scriptAndPath" ] || continue
    FILENAME=$(basename $scriptAndPath)
    POTENTIAL_CONFIG="./config/$1.${FILENAME%%.*}.json"
    [[ -f "$POTENTIAL_CONFIG" ]] && CONFIG_FILE="$POTENTIAL_CONFIG" || CONFIG_FILE="./config/$1.json"
    sitespeed.io --config ./$CONFIG_FILE $scriptAndPath --multi
    control
    sleep 120
done
# At the moment we only run WebPageReplay on one of the phones
if [ "$DEVICE_ID" = "ZY3222N2CZ" ]; then
    for file in tests/$1/*.wpr ; do
        while IFS= read url
        do
            DEVICE_SERIAL=$DEVICE_ID ./wpr/wprAndroid.sh $url --config ./config/$1.json
            control
            sleep 300
        done <"$file"
        control
        sleep 600
    done
fi
