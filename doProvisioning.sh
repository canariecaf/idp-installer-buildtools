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


echo "Test installation done"
exit 0

# Fetch mod_auth_openidc
#wget https://github.com/pingidentity/mod_auth_openidc/archive/${MOD_AUTH_OPENIDC_COMMIT}.tar.gz -O mod_auth_openidc.tar.gz
#mkdir mod_auth_openidc && tar zxvf mod_auth_openidc.tar.gz -C mod_auth_openidc --strip-components 1

# Compile and install mod_auth_openidc
#cd mod_auth_openidc/
#./autogen.sh
#./configure --with-apxs2=/usr/bin/apxs2
#make
#sudo make install

