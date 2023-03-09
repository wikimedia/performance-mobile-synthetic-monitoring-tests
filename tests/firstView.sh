#!/bin/bash

URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')

for url in ${URLS[@]}; do
    sitespeed.io $url --config ./config/firstView.json
    adb shell am force-stop "com.android.chrome"
    adb shell pm clear "com.android.chrome"
    sleep 120
done

# No JS experience
sitespeed.io --block "https://en.m.wikipedia.org/w/load.php?lang=en&modules=startup&only=scripts&raw=1&skin=minerva&target=mobile" https://en.m.wikipedia.org/wiki/Barack_Obama --urlAlias obamaNoJS --config ./config/firstView.json
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
sleep 120

# Test out "Make languages available to index crawlers in mobile version of article pages"
sitespeed.io  https://en.m.wikipedia.org/speed-tests/United_States.enwiki.1143629697/after-body/ --urlAlias afterBody --config ./config/firstView.json
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
sleep 120
sitespeed.io  https://en.m.wikipedia.org/speed-tests/United_States.enwiki.1143629697/after-head/ --urlAlias afterHead --config ./config/firstView.json
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
sleep 120
sitespeed.io  https://en.m.wikipedia.org/speed-tests/United_States.enwiki.1143629697/before/ --urlAlias before --config ./config/firstView.json
adb shell am force-stop "com.android.chrome"
adb shell pm clear "com.android.chrome"
sleep 120


# Install Firefox
# arm64 works fine using A51 and armeabi on Moto G5.
curl -L https://github.com/mozilla-mobile/fenix/releases/download/v105.2.0/fenix-105.2.0-armeabi-v7a.apk --output firefox.apk
adb install  -r firefox.apk

FIREFOX_URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')

for url in ${FIREFOX_URLS[@]}; do
    sitespeed.io $url --config ./config/firstViewFirefox.json -b firefox
    adb shell am force-stop "org.mozilla.firefox"
    adb shell pm clear "org.mozilla.firefox"
    sleep 120
done
