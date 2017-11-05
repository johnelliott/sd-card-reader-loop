#!/bin/bash

# this file is will install sd-card-reader-loop on a system


# expect that we are checked out in the right location
[ "`pwd`" == "/opt/sd-card-reader-loop" ] || echo "Source expected in /opt/sd-card-reader-loop" && exit 1

# source our .env file to get all variables
source .envrc

# give the user permission to change LED trigger
echo "$USER cms051=/usr/bin/tee /sys/class/leds/*/trigger" | sudo tee -a /etc/sudoers
# give the user permission to mount the card
sudo echo "$USER cms051=/bin/mount ${CARD_DEV} ${CARD_MOUNT_POINT}" | sudo tee -a /etc/sudoers
sudo mkdir -p ${CARD_MOUNT_POINT}
# give the user permission to set led blink delay
echo "$USER cms051=/usr/bin/tee /sys/class/leds/*/delay_on" | sudo tee -a /etc/sudoers
# give the user permission to unmount
sudo echo "$USER cms051=/bin/umount ${CARD_MOUNT_POINT}" | sudo tee -a /etc/sudoers

mkdir -p ~/.config/systemd/user
ln -s `pwd`*service ~/.config/systemd/user

# warning: this might copy photos, post to instragram, and turn of your computer
# if that happens, remove a media device and this command with disable:
systemctl --user enable complete-loop.service
