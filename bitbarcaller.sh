#!/bin/bash

# You need to have exported the BitBar key to be able to run
if [[ -z "${BITBAR_API_KEY}" ]]; then
  echo 'Missing env variable BITBAR_API_KEY'
  exit -1
fi

# These are settings used by BitBar
# You can see these in BitBars GUI
WEBPAGEREPLAY_FRAMEWORK_ID=7
WEBPAGEREPLAY_PROJECT_ID=204
SAMSUNG_DEVICE_GROUP_ID=10
DIRECT_FRAMEWORK_ID=7
DIRECT_PROJECT_ID=257
MOTO_DEVICE_GROUP_ID=7
APK_FILE_ID=15
RUN_TEST_FILE_ID=31952

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
# the BitBar API
for file in tests/$1/*.*; do
    [ -e "$file" ] || continue
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
    "testRunParameters": [
        {
        "key":"CALABASH_TAGS","value":"'$1'"
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