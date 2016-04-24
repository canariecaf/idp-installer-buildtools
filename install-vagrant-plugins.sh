#!/usr/bin/env bash

set -e 
set -u 

PLAT=`uname`

echo -e "\nOne moment checking for plugins on your OS (${PLAT})"
echo -e "Forcing plugin installation for vagrant-hostmanager and vagrant-vbguest"
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest



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

echo "on Windows - ensure you have git, curl, and unzip installed"
      ;;
  esac
 

  

echo -e ""
echo -e "Installed Plugins:"
vagrant plugin list
echo -e ""