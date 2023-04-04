#!/bin/bash

# This is the main hook that is run on startup
# We always install NodeJs and the dependencies 
# needed to run sitespeed.io

./install/linux/nodejs.sh
./install/linux/sitespeed.io.sh

# We use a hack to pass on parameters
./tests/$1.sh