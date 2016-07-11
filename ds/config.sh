#!/usr/bin/env bash
set -u 
set -e 
set -x

r=/vagrant/ds
dsdir="cds"
workdir="_work"
hostworkdir="$r/${workdir}"
myhost="ds.example.com"
wwwroot="/var/www/vhosts"

ds_deploy_path="DS"
ds_deploy_file="CAF.ds"

full_ds_deploy_path="${wwwroot}/${myhost}/${ds_deploy_path}"

echo -e "Preparing ds keys"
openssl req -batch -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/ssl/private/ds.example.com.key \
     -out /etc/ssl/certs/ds.example.com.crt \
     -subj /CN=ds.example.com 2>/dev/null

openssl req -x509 -nodes -days 3650 -newkey rsa:2048 \
  -keyout /etc/shibboleth/ds-key.pem \
     -out /etc/shibboleth/ds-cert.pem \
     -subj /CN=ds.example.com 2>/dev/null


mkdir -p /var/www/vhosts/${myhost}

echo -e "Setting placeholder index.html in /var/www/vhosts/${myhost}"
cp $r/index.html.template /var/www/vhosts/${myhost}/index.html
cp $r/logo.png /var/www/vhosts/${myhost}/logo.png
cp $r/topology.png /var/www/vhosts/${myhost}/topology.png

echo -e "Setting php info.php in /var/www/vhosts/${myhost}"
cp $r/info.php.template /var/www/vhosts/${myhost}/info.php

echo -e "Updating apache2 configuration"
cp $r/apache.conf /etc/apache2/sites-available/sp.conf

echo -e "Updating shibboleth SP configuration"
cp /etc/shibboleth/shibboleth2.xml /etc/shibboleth/shibboleth2.xml.orig
#cp $r/shibboleth2.xml /etc/shibboleth/shibboleth2.xml

echo -e "ensuring example.com is properly shown"
sed -i'' "s/example\.org/example\.com/" /etc/shibboleth/shibboleth2.xml

xmlstarlet ed -L \
  -i "//_:Sessions" -t attr -n consistentAddress -v true \
  -i "//_:SSO" -t attr -n ECP -v true \
  -u "//_:Sessions/@handlerSSL" -v "true" \
  -u "//_:Sessions/@cookieProps" -v "https" \
  -u "//_:Handler[@type='Status']/@acl" -v "127.0.0.1 ::1 172.16.80.1" \
  -u "//_:Handler[@type='Session']/@showAttributeValues" -v "true" \
  -u "//_:Errors/@supportContact" -v "aai-hotline@example.com" \
  -u "//_:Errors/@helpLocation"   -v "https://${myhost}/contact/" \
  -u "//_:Errors/@logoLocation"   -v "/shibboleth-sp/logo.jpg" \
  /etc/shibboleth/shibboleth2.xml 

xmlstarlet ed -L \
  -s /_:Attributes -t elem -n N \
  -i //N -t attr -n 'name' -v urn:mace:dir:attribute-def:mail \
  -i //N -t attr -n 'id'   -v mail \
  -r //N -v Attribute \
  -s /_:Attributes -t elem -n N \
  -i //N -t attr -n 'name' -v urn:oid:0.9.2342.19200300.100.1.3 \
  -i //N -t attr -n 'id'   -v mail \
  -r //N -v Attribute \
  /etc/shibboleth/attribute-map.xml

a2enmod ssl
a2ensite sp
a2enmod cgi


# cp $r/test.py /usr/lib/cgi-bin
# chmod +x /usr/lib/cgi-bin/test.py
# chown www-data /usr/lib/cgi-bin/test.py

service shibd restart
service apache2 reload

echo -e "BEGINNING CDS DEPLOYMENT AND CONFIGURATION"

echo -e "CDS Config: preparing the webserver directory"
mkdir -p ${full_ds_deploy_path}
(pushd ${hostworkdir}/${dsdir}; cp -R * ${full_ds_deploy_path}; popd)

echo -e "ensure logging directory is available"
mkdir -p /var/log/apache2

ds_config_ref="config.dist.php.template"
ds_config_dest="config.php"
ds_config_idp_ref="IDProvider.conf.dist.php.template"
ds_config_idp_dest="IDProvider.conf.php"


echo -e "copying reference config into place"
cp ${r}/${ds_config_ref} ${full_ds_deploy_path}/${ds_config_dest}

echo -e "copying reference IDP config augmentation into place"
cp ${r}/${ds_config_idp_ref} ${full_ds_deploy_path}/${ds_config_idp_dest}

echo -e "changing the WAYF file to CAF.ds for back compatibility"
mv ${full_ds_deploy_path}/WAYF ${full_ds_deploy_path}/${ds_deploy_file}

