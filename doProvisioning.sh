#!/usr/bin/env bash

# install unzip
#sudo yum -y install unzip

sudo bash
echo "adding idp.caf-dev.ca as localhost to my machine"
echo "127.0.0.1 idp.caf-dev.ca" >> /etc/hosts
echo "Hosts file looks like this:"
cat /etc/hosts

echo "Performing installation and capturing output in /installer/run.txt "
sudo  sudo -- bash -c 'cd /installer;script run.txt;  bash -x /installer/deploy_idp.sh;' 


echo "Installation done"
