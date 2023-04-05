#!/bin/bash

# This is the main hook that is run on startup on 
# BitBar. 
# We always install NodeJs and the dependencies 
# needed to run sitespeed.io

./install/linux/nodejs.sh
./install/linux/sitespeed.io.sh

# We use a hack to pass on parameters
# CALABASH_TAGS and CALABASH_PROFILE
TYPE_OF_TEST=$1
FILE_TO_RUN=$2

if [ "$TYPE_OF_TEST" = "webpagereplay" ]; then
    echo "Run WebPageReplay tests for $FILE_TO_RUN"
    ./webpagereplay.sh $FILE_TO_RUN 
else
    echo "Run direct tests for $FILE_TO_RUN"
    ./direct.sh $FILE_TO_RUN
fi

