#!/bin/sh

# Startup, confirm we have the program installed
exiftool='/usr/bin/exiftool'
command -v $exiftool >/dev/null 2>&1 || { echo >&2 "I require $exiftool but it's not installed.  Aborting."; exit 1; }
#echo $exiftool
node='/home/pi/.nvm/versions/node/v8.9.0/bin/node'
command -v $node >/dev/null 2>&1 || { echo >&2 "I require $node but it's not nodelled.  Aborting."; exit 1; }
#echo $node
insta='/home/pi/insta/multi-story.js'
command -v $insta >/dev/null 2>&1 || { echo >&2 "I require $insta but it's not installed.  Aborting."; exit 1; }
#echo $insta
echo install check
