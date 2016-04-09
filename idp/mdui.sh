#!/usr/bin/env bash
set -e 
set -u 

FILE=$1

xmlstarlet ed \
  -s '/_:EntityDescriptor/_:IDPSSODescriptor/_:Extensions' -t elem -n 'N' \
  -s '//N' -t elem -n 'DisplayName'  \
  -i '//N/DisplayName' -t attr -n 'xml:lang' -v 'en' \
  -s '//N/DisplayName' -t text -n '' -v "${DISPLAYNAME_EN:-DisplayName EN}" \
  -r '//N/DisplayName' -v 'mdui:DisplayName' \
  -s '//N' -t elem -n 'DisplayName'  \
  -i '//N/DisplayName' -t attr -n 'xml:lang' -v 'fr' \
  -s '//N/DisplayName' -t text -n '' -v "${DISPLAYNAME_FR:-DisplayName FR}" \
  -r '//N/DisplayName' -v 'mdui:DisplayName' \
  -s '//N' -t elem -n 'Description'  \
  -i '//N/Description' -t attr -n 'xml:lang' -v 'en' \
  -s '//N/Description' -t text -n '' -v "${FRSCRIPTION_EN:-Description EN}" \
  -r '//N/Description' -v 'mdui:Description' \
  -s '//N' -t elem -n 'Description'  \
  -i '//N/Description' -t attr -n 'xml:lang' -v 'fr' \
  -s '//N/Description' -t text -n '' -v "${FRSCRIPTION_FR:-Description FR}" \
  -r '//N/Description' -v 'mdui:Description' \
  -s '//N' -t elem -n 'Logo' \
  -i '//N/Logo' -t attr -n 'height' -v "${LOGO_SMALL_HEIGHT:-16}" \
  -i '//N/Logo' -t attr -n 'width'  -v "${LOGO_SMALL_WIDTH:-16}" \
  -s '//N/Logo' -t text -n '' -v "${LOGO_SMALL_URL:-http://someurl.com/logo-small.png}" \
  -r '//N/Logo' -v 'mdui:Logo' \
  -s '//N' -t elem -n 'Logo' \
  -i '//N/Logo' -t attr -n 'height' -v "${LOGO_HEIGHT:-64}" \
  -i '//N/Logo' -t attr -n 'width'  -v "${LOGO_WIDTH:-80}" \
  -s '//N/Logo' -t text -n '' -v "${LOGO_URL:-http://someurl.com/logo-big.png}" \
  -r '//N/Logo' -v 'mdui:Logo' \
  -s '//N' -t elem -n 'InformationURL' \
  -i '//N/InformationURL' -t attr -n 'xml:lang' -v 'en' \
  -s '//N/InformationURL' -t text -n '' -v "${INFORMATION_URL_EN:-http://someurl.com/en/information}" \
  -r '//N/InformationURL' -v 'mdui:InformationURL' \
  -s '//N' -t elem -n 'InformationURL' \
  -i '//N/InformationURL' -t attr -n 'xml:lang' -v 'fr' \
  -s '//N/InformationURL' -t text -n '' -v "${INFORMATION_URL_FR:-http://someurl.com/fr/information}" \
  -r '//N/InformationURL' -v 'mdui:InformationURL' \
  -s '//N' -t elem -n 'PrivacyStatementURL' \
  -i '//N/PrivacyStatementURL' -t attr -n 'xml:lang' -v 'en' \
  -s '//N/PrivacyStatementURL' -t text -n '' -v "${PRIVACY_STATEMENT_URL_EN:-http://someurl.com/en/information}" \
  -r '//N/PrivacyStatementURL' -v 'mdui:PrivacyStatementURL' \
  -s '//N' -t elem -n 'PrivacyStatementURL' \
  -i '//N/PrivacyStatementURL' -t attr -n 'xml:lang' -v 'fr' \
  -s '//N/PrivacyStatementURL' -t text -n '' -v "${PRIVACY_STATEMENT_URL_FR:-http://someurl.com/fr/information}" \
  -r '//N/PrivacyStatementURL' -v 'mdui:PrivacyStatementURL' \
  -r '//N' -v 'mdui:UIInfo' \
  $FILE