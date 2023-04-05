#!/bin/bash

# Run tests using WebPageReplay
# It's replay!
curl -L "https://github.com/sitespeedio/replay/blob/main/replay/linux/wpr?raw=true"  --output wpr
chmod 755 wpr
mv wpr ./webpagereplay/wpr

# Replay run on Samsung A51 (ARM64)
curl -L https://github.com/mozilla-mobile/firefox-android/releases/download/fenix-v111.0/fenix-111.0-arm64-v8a.apk --output firefox.apk
adb install  -r firefox.apk

# Disable the wifi on the device to make sure we are recording/replaying through the server
adb shell svc wifi disable

TEST=webpagereplay
FILE=$TEST/$1
FILENAME=$(basename -- "$file")
FILENAME_WITHOUT_EXTENSION="${FILENAME%.*}"
POTENTIAL_CONFIG_FILE="config/$TEST/$FILENAME_WITHOUT_EXTENSION.json"
[[ -f "$POTENTIAL_CONFIG_FILE" ]] && CONFIG_FILE="$POTENTIAL_CONFIG_FILE" || CONFIG_FILE="config/replay.json"
[[ -f "$CONFIG_FILE" ]] && echo "Using config file $CONFIG_FILE" for $file || (echo "Missing config file $CONFIG_FILE for $file" && exit 1)

BROWSERS=(chrome firefox)
for browser in "${BROWSERS[@]}" ; do
    ANDROID=true ./webpagereplay/replay.sh --config ./$CONFIG_FILE $file -b $browser
    adb shell am force-stop "com.android.chrome"
    adb shell pm clear "com.android.chrome"
    adb shell am force-stop "org.mozilla.firefox"
    adb shell pm clear "org.mozilla.firefox"
done
sleep 120
