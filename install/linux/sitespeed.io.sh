#!/bin/bash

# Install sitespeed.io and dependencies
apt-get update -y && sudo apt-get install -y imagemagick ffmpeg iproute2 libnss3-tools python3-dev
pip install --upgrade pip
python -m pip install scikit-build pyssim OpenCV-Python Numpy

npm install sitespeed.io@27.0.0-beta.2 --location=global