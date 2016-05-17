#!/usr/bin/env bash
set -u 
set -e 

case $1 in
  idp)
  echo "SSO call was idp"
    xmlstarlet ed -L \
      -d "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO/@*" \
      -i "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO" -t attr -n entityID -v "https://idp3.example.com/shibboleth" \
      -i "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO" -t attr -n ECP      -v "true" \
      /etc/shibboleth/shibboleth2.xml 
    ;;
  eds)
  echo "SSO call was eds"

    xmlstarlet ed -L \
      -d "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO/@*" \
      -i "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO" -t attr -n discoveryProtocol -v "SAMLDS" \
      -i "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO" -t attr -n discoveryURL      -v "https://sp.example.com/DS/WAYF" \
      -i "/_:SPConfig/_:ApplicationDefaults/_:Sessions/_:SSO" -t attr -n ECP               -v "true" \
      /etc/shibboleth/shibboleth2.xml 
      echo "done processing shibboleth2.xml"
    ;;
  *)
    echo "usage: $0 (idp|idp3|eds)"
    exit 1
esac
echo "restarting shibd, reloading apache"
service shibd restart
service apache2 reload
echo "Reload complete!"
