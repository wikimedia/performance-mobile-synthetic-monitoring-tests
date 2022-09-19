#!/bin/bash
set -eu

# This is the main hook that is run on startup
# We always install NodeJs and the dependencies 
# needed to run sitespeed.io

if -n $ANDROID_SERIAL
then
    ./install/linux/nodejs.sh
    ./install/linux/sitespeed.io.sh
else
    ./install/macos/nodejs.sh
    ./install/macos/sitespeed.io.sh
fi

# We use a hack to pass on parameters
TEST=$CALABASH_PROFILE

sitespeed.io --config ./config/$TEST.json ./tests/$test