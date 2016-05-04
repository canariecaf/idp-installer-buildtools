#!/usr/bin/env bash
set -u 
set -e 


r=/vagrant/idp

IDPROOT="/opt/shibboleth-idp"

echo "Fetching metadata from sp.example.com"
MDATA="/opt/shibboleth-idp/metadata/sp-metadata.xml"
curl -ks -o ${MDATA}.orig https://sp.example.com/Shibboleth.sso/Metadata

# uncomment if you want to have this SP be part of R&S
#
# echo -e "adding RandS entity category to the SP metadata"
# sed 's/oasis:names:tc:SAML:metadata:algsupport">/oasis:names:tc:SAML:metadata:algsupport" xmlns:mdattr="urn:oasis:names:tc:SAML:metadata:attribute" xmlns:saml="urn:oasis:names:tc:SAML:2.0:assertion">\n\n<mdattr:EntityAttributes>\n<saml:Attribute Name="http:\/\/macedir.org\/entity-category" NameFormat="urn:oasis:names:tc:SAML:2.0:attrname-format:uri">\n<saml:AttributeValue>\nhttp:\/\/refeds.org\/category\/research-and-scholarship\n<\/saml:AttributeValue>\n<saml:AttributeValue>\nhttp:\/\/www.geant.net\/uri\/dataprotection-code-of-conduct\/v1\n<\/saml:AttributeValue>\n<\/saml:Attribute>\n<\/mdattr:EntityAttributes>/g' ${MDATA}.orig >${MDATA}

# comment this out for R&S tagging
echo "Metadata from sp.example.com put in place"
cp ${MDATA}.orig  ${MDATA}


echo "Appending metadata to metadata-providers.xml in idp"

MDP="/opt/shibboleth-idp/conf/metadata-providers.xml"
mv "${MDP}" "${MDP}.orig"
cat "${MDP}.orig" |sed \$d > "${MDP}"
cat << 'EOF' >> "${MDP}"
<MetadataProvider id="LocalSPMetadata"  xsi:type="FilesystemMetadataProvider" metadataFile="%{idp.home}/metadata/sp-metadata.xml"/>
</MetadataProvider>
EOF


echo "manipulating the IdP metadata to populate with MDUI elements from ${r}/mdui.conf"

apt-get install -y xmlstarlet
cd /opt/shibboleth-idp/metadata
mv idp-metadata.xml idp-metadata-no-mdui.xml
. $r/mdui.conf
$r/mdui.sh idp-metadata-no-mdui.xml >idp-metadata.xml

# future update, leaving things vanilla for now
# echo "placing default logo into place"
# cp $r/logo.jpg /opt/jetty/jetty-base/webapps/ROOT/

# adjusting the attribute-filter.xml to add sp.example.com
	echo "manipulating attribute-filter.xml to replace sp.testshib.org with sp.example.com attribute release"
AF="${IDPROOT}/conf/attribute-filter.xml"
	echo "Making backup before editting it"
cp ${AF} ${AF}.orig
	echo "Appending our release policy to the end of the attribute-filter.xml file"
head -n -1 {$AF}.orig > ${AF}
cat $r/attribute-filter-policy.xml.fragment >> ${AF}
echo "</AttributeFilterPolicyGroup>" >> ${AF}

echo "Done editting attribute-filter.xml"




echo "restarting jetty for settings to take effect (may result in FAILED statement from restart, should be ok however. "
service jetty restart

echo "Vagrant managed IdP tweaks complete."