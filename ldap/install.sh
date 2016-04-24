#!/usr/bin/env bash

# Exit immediately on error or undefined variable.
set -e 
set -u


# Software install
# ----------------
sudo apt-get install -y  gnutls-bin ssl-cert stunnel

#
# Configure the certificate TLS settings

CAINFO="/etc/ssl/ca.info"
sudo sh -c "echo 'cn = Example Institution' >> ${CAINFO}"
sudo sh -c "echo 'ca' >> ${CAINFO}"
sudo sh -c "echo 'cert_signing_key' >> ${CAINFO}"

LDAPINFO="/etc/ssl/ldap.info"
sudo sh -c "echo 'organization = Example Institution' >> ${LDAPINFO}"
sudo sh -c "echo 'cn = ldap.example.com' >> ${LDAPINFO}"
sudo sh -c "echo 'tls_www_server' >> ${LDAPINFO}"
sudo sh -c "echo 'encryption_key' >> ${LDAPINFO}"
sudo sh -c "echo 'signing_key' >> ${LDAPINFO}"
sudo sh -c "echo 'expiration_days = 3650' >> ${LDAPINFO}"

echo "Create the TLS CA, private keys and self-signed certificate for the LDAP TLS connection"

sudo sh -c "certtool --generate-privkey > /etc/ssl/private/cakey.pem"
sudo sh -c "certtool --generate-self-signed --load-privkey /etc/ssl/private/cakey.pem --template ${CAINFO} --outfile /etc/ssl/certs/cacert.pem"
sudo sh -c "certtool --generate-privkey --bits 2048 --outfile /etc/ssl/private/ldap_slapd_key.pem"
sudo sh -c "certtool --generate-certificate --load-privkey /etc/ssl/private/ldap_slapd_key.pem --load-ca-certificate /etc/ssl/certs/cacert.pem --load-ca-privkey /etc/ssl/private/cakey.pem --template /etc/ssl/ldap.info --outfile /etc/ssl/certs/ldap_slapd_cert.pem"

echo "adjust permissions on the cert file"
sudo sh -c "chmod 400 /etc/ssl/private/ldap_slapd_key.pem"
sudo sh -c "chmod 400 /etc/ssl/certs/ldap_slapd_cert.pem"
echo "Tweak for stunnel to write it's PID properly"
sudo sh -c "mkdir -p /var/run/stunnel"

# https://www.stunnel.org/faq.html
echo "Writing /etc/stunnel.conf and init.d start scripts"
sudo sh -c "cp /vagrant/ldap/stunnel.conf /etc/stunnel/stunnel.conf"
sudo sh -c "cp /vagrant/ldap/init.d.stunnel.template /etc/init.d/stunnel"

#
# Prepare the ldap server settings
#

debconf-set-selections <<EOF
slapd slapd/password1 password secret
slapd slapd/internal/adminpw password secret
slapd slapd/password2 password secret
slapd slapd/internal/generated_adminpw password secret
slapd slapd/domain string example.com
slapd shared/organization string example.com
EOF
DEBIAN_FRONTEND=noninteractive apt-get install -y slapd ldap-utils
ldapadd -x -D cn=admin,dc=example,dc=com -w secret -f /vagrant/ldap/default.ldif

echo "Running STunnel to more easily enable TLS on port 636"
sudo sh -c "/usr/bin/stunnel"



exit $?


