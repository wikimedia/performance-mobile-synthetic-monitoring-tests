#!/bin/bash

URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')

for url in ${URLS[@]}; do
    sitespeed.io $url --config ./config/firstView.json
    adb shell am force-stop "com.android.chrome"
    adb shell pm clear "com.android.chrome"
    sleep 10
done

# Install Firefox
# arm64 works fine using A51 and armeabi on Moto G5.
#curl -L https://github.com/mozilla-mobile/fenix/releases/download/v105.1.0/fenix-105.1.0-armeabi-v7a.apk --output firefox.apk
#adb install  -r firefox.apk

#sitespeed.io https://en.m.wikipedia.org/wiki/Barack_Obama --config ./config/firstView.json -b firefox --browsertime.cpu false --browsertime.cacheClearRaw false