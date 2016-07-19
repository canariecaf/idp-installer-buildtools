#!/usr/bin/env bash
set -u
set -e 


r=$PWD
downloaddir="_dl"
workdir="_work"

fullworkdir="${r}/${workdir}"
fulldldir="${r}/${downloaddir}"

. ./common

function bootstrapByDefault
{

echo "Downloading embedded-discovery-service ${EDS_F}"
mkdir -p ${fulldldir}
cd ${fulldldir}
curl -JOLs http://shibboleth.net/downloads/embedded-discovery-service/latest/${EDS_F}
cd ..
mkdir -p ${fullworkdir}
cd ${fullworkdir}
echo "Unzipping embedded-discovery-service ${EDS_F}"

tar -xzf ${fulldldir}/${EDS_F}

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
		 	rm -fr ${fulldldir}
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