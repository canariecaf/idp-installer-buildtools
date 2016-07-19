#!/usr/bin/env bash
set -e 
set -u 

r=$PWD
workdir="work"
fullworkdir="${r}/${workdir}"


function bootstrapByDefault
{

	local GITOWNER="canariecaf"
	local GITREPO="idp-installer-CAF"
	local GITBRANCH="3.0.0-CAF"
	local GITROOT="https://github.com/${GITOWNER}/${GITREPO}"

	local CFGTEMPLATE="${r}/config.template"
	local CFGTGT="${r}/work/idp-installer-CAF/config"

	local TGT="${r}/work/${GITREPO}"

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

}
#
# default behaviour is to provision things
# This is detected outside the getopt while loop
# through the OPTIND (option indice, which when there is none, is 1)

while getopts 'u' options; do
	case "${options}" in
		u)
		 	echo "cleaning up the bootstrap directory ${r}${workdir}"
		 	rm -fr ${fullworkdir}
			;;		
		*)
			echo "unrecognized option, exiting"
			exit 1;
		;;
	esac
done

if [ "${OPTIND}" = "1" ]; then

			echo "Bootstrapping IdP into idp/work directory of ${fullworkdir}"
			mkdir -p ${fullworkdir}
			cd ${fullworkdir}
		 	bootstrapByDefault

fi
