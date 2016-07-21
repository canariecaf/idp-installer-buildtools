#!/usr/bin/env bash
set -x
set -e 
set -u 

r=$PWD
workdir="_work"
fullworkdir="${r}/${workdir}"

GITOWNER="canariecaf"
GITREPO="cds"
GITBRANCH="master"
GITROOT="https://github.com/${GITOWNER}/${GITREPO}"

# templates we are going to overwrite

CFGTEMPLATE="${r}/config.template"
CFGTGT="${r}/${workdir}/idp-installer-CAF/config"
TGT="${r}/${workdir}/${GITREPO}"


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
		 	echo "Bootstrapping Centralized Discovery Service into ds/work directory of ${fullworkdir}"
			# mkdir -p ${fullworkdir}
			# cd ${fullworkdir}
		 # 	echo "Cloning cds tools from Git from Branch ${GITBRANCH}"
			# git clone ${GITROOT} -b ${GITBRANCH}
fi

echo "Done Bootstrapping"
