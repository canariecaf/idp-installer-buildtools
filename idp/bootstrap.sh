#!/usr/bin/env bash
set -e 
set -u 

r=$PWD

echo "Bootstrapping IdP into idp/work directory"
mkdir -p work
cd work
GITOWNER="canariecaf"
GITREPO="idp-installer-CAF"
GITBRANCH="3.1.0-CAF-RC2"
GITROOT="https://github.com/${GITOWNER}/${GITREPO}"

CFGTEMPLATE="${r}/config.template"
CFGTGT="${r}/work/idp-installer-CAF/config"

TGT="${r}/work/${GITREPO}"

# detect if we checked out the REPO yet. If yes, keep it, if no, check it out
if [ "$(ls -A ${TGT})" ]; then
	echo "IdP-Installer already checked out, using it"
	echo "Note: we are preserving and using this config file when provisioning is triggered: ${CFGTGT}"

else
	echo "Cloning IdP tools from Git from Branch ${GITBRANCH}"
	git clone ${GITROOT} -b ${GITBRANCH}
fi

# check for config file fresh from IdP-Installer
	if [[ -s "${CFGTGT}" ]]; then

	if ! cmp  ${CFGTEMPLATE} ${CFGTGT}>/dev/null 2>&1
		echo -e "Your IdP-Installer config is identical to our example.com reference..continuing on."
		then
		echo -e "NOTE: \n\nYour IdP-Installer config file in ${CFGTGT} \nis different than the example.com one. Just an FYI -- still continuing on"
	fi

else
	echo "Your IdP-Installer config is fresh from git, we will replace it with our own and proceed with the install."
	echo "Applying default config template to idp-installer"
	cp ${r}/config.template ${r}/work/idp-installer-CAF/config
fi

