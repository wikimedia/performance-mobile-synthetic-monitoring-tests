#!/bin/bash

URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')

for url in ${URLS[@]}; do
    sitespeed.io $url --config ./config/firstView.json
    adb shell am force-stop "com.android.chrome"
    adb shell pm clear "com.android.chrome"
    sleep 120
done

# Install Firefox
# arm64 works fine using A51 and armeabi on Moto G5.
curl -L https://github.com/mozilla-mobile/fenix/releases/download/v105.2.0/fenix-105.2.0-armeabi-v7a.apk --output firefox.apk
adb install  -r firefox.apk

FIREFOX_URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page')

for url in ${FIREFOX_URLS[@]}; do
    sitespeed.io $url --config ./config/firstViewFirefox.json -b firefox
    adb shell am force-stop "org.mozilla.firefox"
    adb shell pm clear "org.mozilla.firefox"
    sleep 120
done
