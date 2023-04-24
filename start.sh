#!/bin/bash

# This is the main hook that is run on startup on 
# BitBar. 

# All dependencies is installed in the Docker container
# But if we need to override something we can do it with
# extras.sh
./install/linux/extras.sh

echo "We got $1 , $2 and $3 as input"
# We use a hack to pass on parameters
# PARAM1, PARAM2 and PARAM3 in the BitBar API
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