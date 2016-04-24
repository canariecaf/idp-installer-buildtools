#!/usr/bin/env bash
echo "Starting the bootstrap process to prep things before VMs are provisioned"
cd sp
./bootstrap.sh
cd ..

cd idp
./bootstrap.sh 
cd ..

