#!/bin/bash

# Run tests directly against Wikipedia

# arm64 works fine using A51 and armeabi on Moto G5.
#curl -L https://github.com/mozilla-mobile/firefox-android/releases/download/fenix-v111.0/fenix-111.0-armeabi-v7a.apk --output firefox.apk
#adb install  -r firefox.apk

TEST=direct
FILE=$1
FILENAME=$(basename -- "$file")
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"
POTENTIAL_CONFIG_FILE="config/$TEST/$FILENAME_WITHOUT_EXTENSION.json"
[[ -f "$POTENTIAL_CONFIG_FILE" ]] && CONFIG_FILE="$POTENTIAL_CONFIG_FILE" || CONFIG_FILE="config/$TEST/$TEST.json"
[[ -f "$CONFIG_FILE" ]] && echo "Using config file $CONFIG_FILE" for $file || (echo "Missing config file $CONFIG_FILE for $file" && exit 1)

sitespeed.io $file --config $CONFIG_FILE -b chrome
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
sleep 120
