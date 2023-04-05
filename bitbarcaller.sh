#!/bin/bash

# This script loops through our tests and call the BitBar API.
# It needs to have BITBAR_API_KEY in the environment and be called
# with one parameter to choose which kind of tests to run (tests 
# run on different phones).

# You need to have exported the BitBar key to be able to run
if [[ -z "${BITBAR_API_KEY}" ]]; then
  echo 'Missing env variable BITBAR_API_KEY'
  exit -1
fi

# These are settings used by BitBar
# You can see these in BitBar GUI
WEBPAGEREPLAY_FRAMEWORK_ID=19
WEBPAGEREPLAY_PROJECT_ID=204
SAMSUNG_DEVICE_GROUP_ID=10
DIRECT_FRAMEWORK_ID=7
DIRECT_PROJECT_ID=257
MOTO_DEVICE_GROUP_ID=7
APK_FILE_ID=15
RUN_TEST_FILE_ID=60274

if [ "$1" = "webpagereplay" ]; then
    FRAMEWORK_ID=$WEBPAGEREPLAY_FRAMEWORK_ID
    DEVICE_GROUP_ID=$SAMSUNG_DEVICE_GROUP_ID
    PROJECT_ID=$WEBPAGEREPLAY_PROJECT_ID
else
    FRAMEWORK_ID=$DIRECT_FRAMEWORK_ID
    DEVICE_GROUP_ID=$MOTO_DEVICE_GROUP_ID
    PROJECT_ID=$DIRECT_PROJECT_ID
fi

# For all the files that we have, pass them on to
# the BitBar API. At the moment we run all tests
# with both Chrome and Firefox
for file in tests/$1/*.*; do
    [ -e "$file" ] || continue
    BROWSERS=(chrome firefox)
    for browser in "${BROWSERS[@]}" ; do
        FILENAME=$(basename -- "$file")
        BITBAR_CONFIG='{
        "osType":"ANDROID",
        "files":[
            {"id":'$APK_FILE_ID'},
            {"id":'$RUN_TEST_FILE_ID'}
        ],
        "frameworkId":'$FRAMEWORK_ID',
        "deviceGroupId":'$DEVICE_GROUP_ID',
        "scheduler":"SINGLE",
        "projectId": '$PROJECT_ID',
        "testRunName": "Test running '$FILENAME' using '$browser'",
        "testRunParameters": [
            {
            "key":"CALABASH_TAGS","value":"'$1';'$browser'"
            },
            {
            "key":"CALABASH_PROFILE","value":"'$file'"
            }
            ]
        }'

    # It's time to send the jobs to BitBar
    curl -H 'Content-Type: application/json'  \
    -u $BITBAR_API_KEY \
    https://wikimedia.bitbar.com/cloud/api/v2/runs \
    -d "$BITBAR_CONFIG"
    done
done