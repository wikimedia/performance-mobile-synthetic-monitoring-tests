#!/bin/bash

# Install sitespeed.io and dependencies
apt-get update -y && sudo apt-get install -y imagemagick ffmpeg iproute2 libnss3-tools python3-dev
pip install --upgrade pip
python -m pip install scikit-build pyssim OpenCV-Python Numpy

# At the moment we use the main branch to get the extra run metrics
git clone https://github.com/sitespeedio/sitespeed.io.git
cd sitespeed.io
npm install
npm install --location=global
cd ..