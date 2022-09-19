#!/bin/bash

python --version
python3 --version
alias python=python3

pip install --upgrade pip
python3 -m pip install pyssim OpenCV-Python Numpy

brew install imagemagick@6


# At the moment we use the main branch to get the extra run metrics
git clone https://github.com/sitespeedio/sitespeed.io.git
cd sitespeed.io
npm install
npm install --location=global
cd ..