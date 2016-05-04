#!/usr/bin/env bash

set -e 
set -u 

PLAT=`uname`
echo -e "\nOne moment checking for plugins on your OS (${PLAT})"


PREVRUNTEST=0

function detectPreviousRun ()
{
  echo -e "Next we need to read the /etc/sudoers file as root to check if we have applied our updates"
  echo -e "If we have, we will skip updates, if not we will apply sudo settings to update /etc/hosts"
  PREVRUNTEST=`sudo cat /etc/sudoers |grep VAGRANT_HOSTMANAGER_UPDATE|wc -l`
}

echo -e "Forcing plugin installation for vagrant-hostmanager and vagrant-vbguest"
vagrant plugin install vagrant-hostmanager
vagrant plugin install vagrant-vbguest

echo -e ""
echo -e "Installed Plugins:"
vagrant plugin list
echo -e ""
  

  case `uname` in
    Darwin)

  detectPreviousRun
  if [ ${PREVRUNTEST} -gt 0 ]; then
    echo "We detected a previous update, skipping editting the /etc/sudoers file"
  else
     echo -e "Updating the /etc/sudoers file"
      sudo tee -a /etc/sudoers <<EOF
Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp $HOME/.vagrant.d/tmp/hosts.local /etc/hosts
%admin ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
EOF

fi
      ;;
    Linux)

  detectPreviousRun
  if [ ${PREVRUNTEST} -gt 0 ]; then
    echo "We detected a previous update, skipping editting the /etc/sudoers file"
  else
     echo -e "Updating the /etc/sudoers file"

      sudo tee -a /etc/sudoers <<EOF
Cmnd_Alias VAGRANT_HOSTMANAGER_UPDATE = /bin/cp $HOME/.vagrant.d/tmp/hosts.local /etc/hosts
%admin ALL=(root) NOPASSWD: VAGRANT_HOSTMANAGER_UPDATE
EOF
fi  
      ;;
    CYGWIN*)

echo "Windows using cygwin - No edits performed. Ensure you have git, curl, and unzip installed via setup"
      ;;
      MING*)

echo "Windows using GIT bash - No edits performed."
      ;;
  esac
 
fi
echo -e "install-vagrant-plugins.sh run complete"
  
