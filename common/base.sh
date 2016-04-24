#!/usr/bin/env bash
set -e 
set -u 

apt-get update
apt-get install -y dbus ntpdate
MYTZ="America/Toronto"
echo "Setting time zome to ${MYTZ}"
echo "${MYTZ}" > /etc/timezone
dpkg-reconfigure --frontend noninteractive tzdata
ntpdate-debian
