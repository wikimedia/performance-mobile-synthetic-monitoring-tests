#!/bin/bash

curl -L "https://github.com/sitespeedio/replay/blob/main/replay/linux/wpr?raw=true"  --output wpr
chmod 755 wpr
mv wpr ./webpagereplay/wpr

# Disable the wifi on the device to make sure we are recording/replaying through the server
adb shell svc wifi disable

URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama')


for url in ${URLS[@]}; do
    ANDROID=true ./webpagereplay/replay.sh --config ./config/replay.json $url -b chrome
    adb shell am force-stop "com.android.chrome"
    adb shell pm clear "com.android.chrome"
done