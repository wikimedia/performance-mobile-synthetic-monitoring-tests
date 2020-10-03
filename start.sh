#!/bin/bash

# The first parameter is the phone name, so we can find the right tests to run
if [ -d "config/$1" ]
then
    echo "Missing input/config directory. You need to run with a parameter that gives the path to the configuration for the phone. "
    exit 1
fi

CONTROL_FILE="./locks/$1.run"

# You cannot start multiple instances!
if [ -f "$CONTROL_FILE" ]
then
    echo "$CONTROL_FILE exist, do you have running tests?"
    exit 1;
else
    touch $CONTROL_FILE
fi

# Help us end on demand
function control() {
    if [ -f "$CONTROL_FILE" ]
    then
        echo "$CONTROL_FILE found. Make another run ..."
    else
        echo "$CONTROL_FILE not found - stopping after cleaning up ..."
        echo "Exit"
        exit 1
    fi
}

while true
do
    ## For each iteration, we pull the latest code from git and run
    git pull
    source runTheTests.sh "$@"
    result=$?
    if [ $result -ne 0 ]; then
        echo 'Stop the loop $result'
        exit 0;
    fi
done