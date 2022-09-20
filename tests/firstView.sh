#!/bin/bash

URLS=('https://en.m.wikipedia.org/wiki/Barack_Obama' 'https://en.m.wikipedia.org/wiki/Main_Page' 'https://en.m.wikipedia.org/wiki/Facebook' 'https://en.m.wikipedia.org/wiki/Sweden')

for url in ${URLS[@]}; do
    sitespeed.io $url --config ./config/firstView.json
    adb -shell am force-stop "com.android.chrome"
    adb -shell pm clear "com.android.chrome"
    sleep 10
done