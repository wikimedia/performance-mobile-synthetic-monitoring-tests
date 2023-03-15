#!/bin/bash

curl -L "https://github.com/sitespeedio/replay/blob/main/replay/linux/wpr?raw=true"  --output wpr
chmod 755 wpr
mv wpr ./webpagereplay/wpr

curl -L https://github.com/mozilla-mobile/firefox-android/releases/download/fenix-v111.0/fenix-111.0-arm64-v8a.apk --output firefox.apk
adb install  -r firefox.apk

# Disable the wifi on the device to make sure we are recording/replaying through the server
adb shell svc wifi disable

FIREFOX_URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')

for url in ${FIREFOX_URLS[@]}; do
    ANDROID=true ./webpagereplay/replay.sh --config ./config/replay.json $url -b firefox --browsertime.iterations 5
    adb shell am force-stop "org.mozilla.firefox"
    adb shell pm clear "org.mozilla.firefox"
    sleep 120
done