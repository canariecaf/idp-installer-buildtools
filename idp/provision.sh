#!/usr/bin/env bash
#
# The provisioning task for the IdP.
set -u 
set -e 


BSWITCHES=""
# uncomment for debugging of deploy_idp.sh"
#BSWITCHES=" -x "

echo "Performing installation and capturing output in /installer/run.txt "
sudo  sudo -- bash -c 'cd /installer;script run.txt;  bash ${BSWITCHES} /installer/deploy_idp.sh;' 


echo "Installation done"
