#!/bin/bash

curl -L "https://github.com/sitespeedio/replay/blob/main/replay/linux/wpr?raw=true"  --output wpr
chmod 755 wpr
mv wpr ./webpagereplay/wpr

# Disable the wifi on the device to make sure we are recording/replaying through the server
adb shell svc wifi disable

URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')


for url in ${URLS[@]}; do
    ANDROID=true ./webpagereplay/replay.sh --config ./config/replay.json $url -b chrome
    adb shell am force-stop "com.android.chrome"
    adb shell pm clear "com.android.chrome"
    sleep 120
done

curl -L https://github.com/mozilla-mobile/fenix/releases/download/v108.1.1/fenix-108.1.1-arm64-v8a.apk --output firefox.apk
adb install  -r firefox.apk

FIREFOX_URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')


for url in ${FIREFOX_URLS[@]}; do
    ANDROID=true ./webpagereplay/replay.sh --config ./config/replay.json $url -b firefox
    adb shell am force-stop "org.mozilla.firefox"
    adb shell pm clear "org.mozilla.firefox"
    sleep 120
done