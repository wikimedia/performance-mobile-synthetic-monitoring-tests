#!/bin/bash

FILE=$1
BROWSER=$2

# Disable the wifi on the device to make sure we are recording/replaying through the server
adb shell svc wifi disable

TEST=webpagereplay
FILENAME=$(basename -- "$FILE")
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"
POTENTIAL_CONFIG_FILE="config/$FILENAME_WITHOUT_EXTENSION.json"
[[ -f "$POTENTIAL_CONFIG_FILE" ]] && CONFIG_FILE="$POTENTIAL_CONFIG_FILE" || CONFIG_FILE="config/replay.json"
[[ -f "$CONFIG_FILE" ]] && echo "Using config file $CONFIG_FILE" for $FILE || (echo "Missing config file $CONFIG_FILE for $FILE" && exit 1)

ANDROID=true ./webpagereplay/replay.sh --config ./$CONFIG_FILE $FILE -b $BROWSER
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
adb shell am force-stop "org.mozilla.firefox"
adb shell pm clear "org.mozilla.firefox"
