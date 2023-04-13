#!/bin/bash

# This is the main hook that is run on startup on 
# BitBar. 
# We always install NodeJs and the dependencies 
# needed to run sitespeed.io


./install/linux/extras.sh

echo "We got $1 , $2 and $3 as input"
# We use a hack to pass on parameters
# CALABASH_TAGS and CALABASH_PROFILE
# The problem is that BitBar only handles two parameters
# so we use the first one to pass on test typ and browser
# separated by a :

nodejs --version
python3 --version
echo $PYTHON

TYPE_OF_TEST=$1
BROWSER=$2
FILE_TO_RUN=$3

if [ "$TYPE_OF_TEST" = "webpagereplay" ]; then
    echo "Run WebPageReplay tests for $FILE_TO_RUN"
    ./webpagereplay.sh $FILE_TO_RUN $BROWSER
else
    echo "Run direct tests for $FILE_TO_RUN"
    ./direct.sh $FILE_TO_RUN $BROWSER
fi

