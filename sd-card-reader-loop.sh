#!/bin/bash
#sd-card-reader-loop.sh

CARD_DEV='sda1'
CARD_MOUNT_POINT='/media/card'

# READER=$(lsusb -d 8564:4000)
# STORAGE=$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)
# echo "$READER"
# echo "$STORAGE"


echo start

while [ -z "$(lsusb -d 8564:4000)" ]
do
  echo wait reader
  sleep 1
done

while [ -n "$(lsusb -d 8564:4000)" ]
do
  if [ -n "$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)" ]
  then
    echo found card
    mount /dev/$CARD_DEV $CARD_MOUNT_POINT
    echo mounted card
    echo running tasks...
    ls "$CARD_MOUNT_POINT"
    umount /dev/$CARD_DEV
    echo unmounted card

    # wait for SD card removal
    while [ -n "$(ls /dev/* | grep $CARD_DEV | cut -d"/" -f3)" ]
    do
      echo waiting for card removal
      sleep 1
    done
    echo card removed
  fi
  echo wait card
  sleep 1
done

echo reboot
