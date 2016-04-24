#!/usr/bin/env bash
set -u 
set -e 

r=/vagrant/idp

echo "Fetching metadata from sp.example.com"
curl -ks -o /opt/shibboleth-idp/metadata/sp-metadata.xml https://sp.example.com/Shibboleth.sso/Metadata

MDP="/opt/shibboleth-idp/conf/metadata-providers.xml"
mv "${MDP}" "${MDP}.orig"
cat "${MDP}.orig" |sed \$d > "${MDP}"
cat << 'EOF' >> "${MDP}"
<MetadataProvider id="LocalSPMetadata"  xsi:type="FilesystemMetadataProvider" metadataFile="%{idp.home}/metadata/sp-metadata.xml"/>
</MetadataProvider>
EOF


apt-get install -y xmlstarlet

echo "manipulating the IdP metadata to populate with MDUI elements from ${r}/mdui.conf"
cd /opt/shibboleth-idp/metadata
mv idp-metadata.xml idp-metadata-no-mdui.xml
. $r/mdui.conf
$r/mdui.sh idp-metadata-no-mdui.xml >idp-metadata.xml

echo "placing default logo into place"
cp $r/logo.jpg /opt/jetty/jetty-base/webapps/ROOT/

echo "restarting jetty for settings to take effect"
service jetty restart

echo "IdP tweaks complete."