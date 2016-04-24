#!/usr/bin/env bash

set -e 
set -u 



echo "Are you SURE that you want to destroy all your VMs? Sleeping 5 seconds to allow you to abort"
sleep 1;echo "5..";sleep 1;echo "4..";sleep 1;echo "3..";sleep 1;echo "2..";sleep 1;echo "1..";

vagrant destroy ldap -f
vagrant destroy sp -f
vagrant destroy idp -f
