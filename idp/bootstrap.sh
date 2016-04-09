#!/usr/bin/env bash

set -e 
set -u 

r=$PWD

echo "Bootstrapping IdP into idp/work directory"
mkdir -p work
cd work

GITBRANCH="cpdev-develop-Shibv3Support"
GITROOT="https://github.com/canariecaf/idp-installer-CAF"

echo "Cloning IdP tools from Git from Branch ${GITBRANCH}"
git clone ${GITROOT} -b ${GITBRANCH}

echo "Applying default config template to idp-installer"
cp ${r}/config.template ${r}/work/idp-installer-CAF/config
