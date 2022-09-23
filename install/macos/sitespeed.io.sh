#!/bin/bash

python --version
python3 --version
alias python=python3

pip install --upgrade pip
python3 -m pip install pyssim OpenCV-Python Numpy

brew install imagemagick@6

npm install sitespeed.io --location=global