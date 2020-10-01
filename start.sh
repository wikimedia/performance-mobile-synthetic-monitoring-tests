#!/bin/bash

# The first parameter is the phone name, so we can find the right tests to run
if [ -d "config/$1" ]
then
    echo "Missing input/config directory. You need to run with a parameter that gives the path to the configuration for the phone. "
    exit 1
fi

CONTROL_FILE="./locks/$1.run"

# You cannot start multiple instances!
if [ -f "$CONTROL_FILE" ]
then
    echo "$CONTROL_FILE exist, do you have running tests?"
    exit 1;
else
    touch $CONTROL_FILE
fi

LOGFILE=./logs/$1.log
exec > $LOGFILE 2>&1

DEVICE_ID=${1%%-*}

# Help us end on demand
function control() {
    if [ -f "$CONTROL_FILE" ]
    then
        echo "$CONTROL_FILE found. Make another run ..."
    else
        echo "$CONTROL_FILE not found - stopping after cleaning up ..."
        echo "Exit"
        exit 0
    fi
}

while true
do
    ## For each iteration, we pull the latest code from git and run
    git pull
    for fileAndPath in tests/$1/*.txt ; do
        [ -e "$fileAndPath" ] || continue
        FILENAME=$(basename $fileAndPath)
        POTENTIAL_CONFIG="./config/$1.${FILENAME%%.*}.json"
        [[ -f "$POTENTIAL_CONFIG" ]] && CONFIG_FILE="$POTENTIAL_CONFIG" || CONFIG_FILE="./config/$1.json"
        sitespeed.io --config ./$CONFIG_FILE $fileAndPath
        control
        sleep 60
    done
    for scriptAndPath in tests/$1/*.js ; do
        [ -e "$scriptAndPath" ] || continue
        FILENAME=$(basename $scriptAndPath)
        POTENTIAL_CONFIG="./config/$1.${FILENAME%%.*}.json"
        [[ -f "$POTENTIAL_CONFIG" ]] && CONFIG_FILE="$POTENTIAL_CONFIG" || CONFIG_FILE="./config/$1.json"
        sitespeed.io --config ./$CONFIG_FILE $scriptAndPath --multi
        control
        sleep 60
    done
    # At the moment we only run WebPageReplay on one of the phones
    if [ "$DEVICE_ID" = "ZY3222N2CZ" ]; then
        for file in tests/$1/*.wpr ; do
            while IFS= read url
            do
                DEVICE_SERIAL=$DEVICE_ID ./wpr/wprAndroid.sh $url --config ./config/$1.json
                control
                sleep 180
            done <"$file"
            control
            sleep 500
        done
    fi
done