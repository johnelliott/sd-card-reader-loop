#!/bin/bash

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

echo start
# Set the ACT LED to heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"
echo heartbeat

# Wait for a USB SD reader (ID 8564:4000 Transcend Information, Inc. RDF8)
echo waiting for reader
READER=$(lsusb -d 8564:4000)
while [ -z ${READER} ]
  do
  sleep 1
  READER=$(lsusb -d 8564:4000)
done
echo got reader

# Wait for a USB storage device (e.g., a USB flash drive)
echo waiting for card
CARD_DEV='sda1'
CARD_MOUNT_POINT='/media/card'
STORAGE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
while [ -z ${STORAGE} ]
  do
  sleep 1
  STORAGE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
done
mount /dev/$CARD_DEV $CARD_MOUNT_POINT
echo got card

# Log the output of the lsblk command for troubleshooting
sudo lsblk > lsblk.log

# Set the ACT LED to blink at 1000ms to indicate that the storage device has been mounted
sudo sh -c "echo timer > /sys/class/leds/led0/trigger"
sudo sh -c "echo 1000 > /sys/class/leds/led0/delay_on"
echo blinking

RATED_DIR='/media/rated'
PHOTOS_DIR='/media/card/DCIM'

echo start exiftool rated copy
# Put rated images in a directory
$exiftool -r -o $RATED_DIR/ -ext JPG -Rating -if '$Rating ge 1' $PHOTOS_DIR
echo end exiftool rated copy

# Post rated images from SD card to instagram stories
echo start posting to ig story
DEBUG='ig*' $node $insta "$RATED_DIR/*.JPG"
echo done posting to ig story

# unmount SD card
echo unmounting
umount /dev/$CARD_DEV
# Set the ACT LED to heartbeat
echo heartbeat
sudo sh -c "echo heartbeat > /sys/class/leds/led0/trigger"

# wait for SD card removal
echo waiting for card removal
STORAGE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
while [ -n "${STORAGE}" ]
  do
  sleep 1
  STORAGE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
done
echo card removed

# wait for USB reader removal to restart machine
echo waiting for reader removal
READER=$(lsusb -d 8564:4000)
while [ -n "${READER}" ]
  do
  sleep 1
  READER=$(lsusb -d 8564:4000)
done
echo reader removed
echo rebooting
sudo shutdown -r now