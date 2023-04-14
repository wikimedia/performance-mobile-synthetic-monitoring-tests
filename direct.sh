#!/bin/bash

# Python3 is installed in two locations in the container
# make sure we use the correct one in Visual Metrics
export PYTHON=/usr/local/bin/python3

# Run tests directly against Wikipedia
FILE=$1
BROWSER=$2

TEST=direct
FILENAME=$(basename -- "$FILE")
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"
POTENTIAL_CONFIG_FILE="config/$FILENAME_WITHOUT_EXTENSION.json"
[[ -f "$POTENTIAL_CONFIG_FILE" ]] && CONFIG_FILE="$POTENTIAL_CONFIG_FILE" || CONFIG_FILE="config/direct.json"
[[ -f "$CONFIG_FILE" ]] && echo "Using config file $CONFIG_FILE" for $FILE || (echo "Missing config file $CONFIG_FILE for $FILE" && exit 1)

sitespeed.io $FILE --config $CONFIG_FILE -b $BROWSER
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
adb shell am force-stop "org.mozilla.firefox"
adb shell pm clear "org.mozilla.firefox"
