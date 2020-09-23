#!/bin/bash
set -u

# You need to supply a DEVICE_SERIAL we can reverse the traffic for tht phone
DEVICE_SERIAL=${DEVICE_SERIAL:-'default'}
if [ "$DEVICE_SERIAL" == "default" ]
then
    echo "You need to add \$DEVICE_SERIAL so traffic can be reversed"
    exit 1
fi

BROWSERTIME=sitespeed.io-wpr
SITESPEEDIO=sitespeed.io

WPR_BINARY=../../wpr

# Ports used for mapping the browser to WPR
HTTP_PORT=80
HTTPS_PORT=443

# WebPageReplay setup
WPR_CERT_FILE=./wpr/wpr_cert.pem
WPR_KEY_FILE=./wpr/wpr_key.pem
WPR_SCRIPTS=./wpr/deterministic.js
WPR_HTTP_PORT=8085
WPR_HTTPS_PORT=8086
WPR_ARCHIVE=./logs/$DEVICE_SERIAL-archive.wprgo
WPR_RECORD_LOG=./logs/$DEVICE_SERIAL-wpr-record.log
WPR_REPLAY_LOG=./logs/$DEVICE_SERIAL-wpr-replay.log

# Parameters used to start WebPageReplay
WPR_PARAMS="--http_port $WPR_HTTP_PORT --https_port $WPR_HTTPS_PORT --https_cert_file $WPR_CERT_FILE --https_key_file $WPR_KEY_FILE --inject_scripts $WPR_SCRIPTS $WPR_ARCHIVE"

# Reverse the traffic for the android device back to the computer
adb -s $DEVICE_SERIAL reverse tcp:$WPR_HTTP_PORT tcp:$WPR_HTTP_PORT
adb -s $DEVICE_SERIAL reverse tcp:$WPR_HTTPS_PORT tcp:$WPR_HTTPS_PORT

function shutdown {
    kill -2 $replay_pid
    wait $replay_pid
    kill -s SIGTERM ${PID}
    wait $PID
}

declare -i RESULT=0
echo 'Start WebPageReplay Record'
$WPR_BINARY record $WPR_PARAMS > $WPR_RECORD_LOG 2>&1 &
record_pid=$!
sleep 3
$BROWSERTIME "$@"
RESULT+=$?

kill -2 $record_pid
RESULT+=$?
wait $record_pid
echo 'Stopped WebPageReplay record'

if [ $RESULT -eq 0 ]
then
    echo 'Start WebPageReplay Replay'
    $WPR_BINARY replay $WPR_PARAMS > $WPR_REPLAY_LOG 2>&1 &
    replay_pid=$!
    if [ $? -eq 0 ]
    then
        echo 'Pre warm the Replay server'
        sleep 10
        $BROWSERTIME "$@"
        sleep 10
        throttle --localhost --rtt 100
        echo 'Run the test'
        $SITESPEEDIO "$@" &
        PID=$!
        
        trap shutdown SIGTERM SIGINT
        wait $PID
        kill -s SIGTERM $replay_pid
        adb -s $DEVICE_SERIAL reverse --remove-all
        throttle --localhost stop
    else
        echo "Replay server didn't start correctly" >&2
        exit 1
    fi
else
    echo "Recording or accessing the URL failed, will not replay" >&2
    exit 1
fi
