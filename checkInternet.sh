#!/bin/bash

for DEVICE in `adb devices | grep -v "List" | awk '{print $1}'`
do
    if adb -s $DEVICE shell ping -c 1 8.8.8.8 | grep -q rtt; then
        echo $DEVICE has a connection to the internet $state
    else
        echo $DEVICE has no connection to the internet $state
    fi
done