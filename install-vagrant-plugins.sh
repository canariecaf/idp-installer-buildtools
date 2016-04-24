#!/usr/bin/env bash

set -e 
set -u 

PLAT=`uname`

echo -e "\nOne moment checking for plugins on your OS (${PLAT})"
echo -e "Checking for vagrant-hostmanager to manage /etc/hosts manipulation when hosts come up/down"
vagrant plugin list | grep vagrant-hostmanager 2>&1 >/dev/null
if [ $? -eq 1 ]; then

  vagrant plugin install vagrant-hostmanager


  case `uname` in
    Darwin)
      echo -e "Updating the /etc/sudoers file"
      sudo tee -a /etc/sudoers <<EOF
Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp $HOME/.vagrant.d/tmp/hosts.local /etc/hosts
%admin ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
EOF
      ;;
    Linux)
      if [ -f /etc/debian_version ]; then
        sudo apt-get install -y unzip curl
      fi
      sudo tee -a /etc/sudoers <<EOF
Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp $HOME/.vagrant.d/tmp/hosts.local /etc/hosts
%admin ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
EOF
      ;;
    CYGWIN*)
      sudo apt-get install -y unzip curl
      ;;
  esac
 
fi
  
echo -e "checking for vagrant-vbguest"
vagrant plugin list | grep vagrant-vbguest 2>&1 >/dev/null
if [ $? -eq 1 ]; then
  vagrant plugin install vagrant-vbguest
fi

echo -e ""
echo -e "Installed Plugins:"
vagrant plugin list
echo -e ""