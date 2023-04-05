# Configuration for synthetic tests on mobile phones.

This repository contains configuration files for running Browsertime/sitespeed.io/WebPageReplay on Android phones. You can read more about our setup at [https://wikitech.wikimedia.org/wiki/Performance/Mobile_Device_Lab](https://wikitech.wikimedia.org/wiki/Performance/Mobile_Device_Lab).

## Setup
We run two types of tests: *Direct* against Wikipedia and against the *WebPageReplay* replay proxy.

All tests that runs direct against Wikipedia exists in **tests/direct/**. All tests using WebPageReplay exists in **tests/webpagereplay/**.

All configuration for the tests exists in **config/**. The name of the test file will match the name of the config file. If a test file is named *myTests.js* the corresponing configuration file need to be named *myTests.json*.

## How the tests run
This repo is checkout on one of our servers. The repo is git pulled and every X hour, the *bitbarcaller.sh* script runs with one parameter (direct or webpagereplay).

The script loops through our **tests/direct|webpagereply** directory and call the BitBar API with which test that should run. At BitBar all the tests are queued and executed one by one when there's a free phone.

## How to add a new test
TODO