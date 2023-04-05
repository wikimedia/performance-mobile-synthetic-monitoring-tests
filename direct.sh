#!/bin/bash

# Run tests directly against Wikipedia
FILE=$1
BROWSER=$2

# arm64 works fine using A51 and armeabi on Moto G5.
if [ "$BROWSER" = "firefox" ]; then
    curl -L https://github.com/mozilla-mobile/firefox-android/releases/download/fenix-v111.0/fenix-111.0-armeabi-v7a.apk --output firefox.apk
    adb install  -r firefox.apk
fi

TEST=direct
FILENAME=$(basename -- "$FILE")
FILE_EXTENSION="${FILENAME##*.}"
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"
POTENTIAL_CONFIG_FILE="config/$TEST/$FILENAME_WITHOUT_EXTENSION.json"
[[ -f "$POTENTIAL_CONFIG_FILE" ]] && CONFIG_FILE="$POTENTIAL_CONFIG_FILE" || CONFIG_FILE="config/direct.json"
[[ -f "$CONFIG_FILE" ]] && echo "Using config file $CONFIG_FILE" for $FILE || (echo "Missing config file $CONFIG_FILE for $FILE" && exit 1)
EXTRAS=$(if [ "$FILE_EXTENSION" = "cjs" ]; then echo "--multi"; else echo ""; fi)

sitespeed.io $FILE --config $CONFIG_FILE -b $BROWSER $EXTRAS
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
adb shell am force-stop "org.mozilla.firefox"
adb shell pm clear "org.mozilla.firefox"
