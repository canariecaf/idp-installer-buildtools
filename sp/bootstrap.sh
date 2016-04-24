#!/usr/bin/env bash
r=$PWD
. ./common
echo "Working on SP boostrap steps"
mkdir -p _dl
cd _dl
echo "Downloading embedded-discovery-service ${EDS_F}"
curl -JOLs http://shibboleth.net/downloads/embedded-discovery-service/latest/${EDS_F}
cd ..
mkdir -p _work
cd _work
tar -xzf ../_dl/${EDS_F}
