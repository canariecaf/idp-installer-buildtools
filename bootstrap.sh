#!/usr/bin/env bash

set -e 
set -u 

r=$PWD

echo "Starting the bootstrap process to prep things before VMs are provisioned"


serviceTarget="ldap sp idp ds"



while getopts 'u' options; do

	case "${options}" in
		u)
		 	echo "cleaning up ALL the bootstrap directories"

				for svc in ${serviceTarget}
				 do
					echo "svc:${svc}"
					workdir="${r}/${svc}"
					cd ${workdir}
					
					if [ ! -e "bootstrap.sh" ]
					 then
					 	echo "No bootstrapping required"
					 else
						./bootstrap.sh -${options}
				  	fi
				  cd .. 

				done
			;;		
		*)
			echo "unrecognized option, exiting"
			exit 1;
		;;
	esac
done

if [ "${OPTIND}" = "1" ]; then
		 	echo "Bootstrapping all services"

				for svc in ${serviceTarget}
				do
					echo "Bootstrapping: ${svc}"
					workdir="${r}/${svc}"
					cd ${workdir}

					if [ ! -e "bootstrap.sh" ]
					 then
					 	echo "No bootstrapping required"
					 else
						./bootstrap.sh 
				  	fi

					cd ..

				done
fi

echo "Done Bootstrapping"
