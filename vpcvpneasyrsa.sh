#!/bin/bash

source <(grep = vpcbms.ini | grep -v "#")

mkdir -p $LOCATION_CERTS
#LOCATION_CERTS="../../tmp"

FILE=$LOCATION_CERTS/$VMWARE_VPN_NAME.ca.crt

if test -f "$FILE"; then
    echo "$FILE exists. NOT creating cert!"
    exit 0
fi

git clone https://github.com/OpenVPN/easy-rsa.git
cd easy-rsa
cd easyrsa3

cat > vars << EOF
set_var EASYRSA_REQ_COUNTRY     "$VMWARE_EASYRSA_REQ_COUNTRY"
set_var EASYRSA_REQ_PROVINCE    "$VMWARE_EASYRSA_REQ_PROVINCE"
set_var EASYRSA_REQ_CITY        "$VMWARE_EASYRSA_REQ_CITY"   
set_var EASYRSA_REQ_ORG         "$VMWARE_EASYRSA_REQ_ORG" 
set_var EASYRSA_REQ_EMAIL       "$VMWARE_EASYRSA_REQ_EMAIL"
set_var EASYRSA_REQ_OU          "$VMWARE_EASYRSA_REQ_OU"    
set_var EASYRSA_REQ_CN          "$VMWARE_EASYRSA_REQ_CN"     
set_var EASYRSA_BATCH           "$VMWARE_EASYRSA_BATCH"      
EOF

./easyrsa init-pki
./easyrsa build-ca nopass
./easyrsa build-server-full $VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER.vpn.prod.clientvpn.us-east-2.amazonaws.com nopass
./easyrsa build-client-full $VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT.vpn.prod.clientvpn.us-east-2.amazonaws.com nopass

#find ${easy_rsa}/keys/ -name ${now}_${ident}*.crt -o -name ${now}_${ident}*.key > /media/${now}_${ident}

#client server
for f in $(find . -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT*.crt" -o -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT*.key" -o -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER*.crt" -o -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER*.key" )
    do
        cp $f $LOCATION_CERTS

done
echo -e "\nCopied \n$(find . -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT*.crt" -o -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT*.key" -o -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER*.crt" -o -name "$VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER*.key" ) \nto $LOCATION_CERTS"

#CA
for f in $(find . -name ca.crt -o -name ca.key )
    do
        FILENAME=$(echo $f | awk -F/ '{print $(NF)}')
        cp $f $LOCATION_CERTS/$VMWARE_VPN_NAME.$FILENAME
        echo -e "\nCopied \n$(find . -name ca.crt -o -name ca.key ) \nto $LOCATION_CERTS/$VMWARE_VPN_NAME.$FILENAME"

done


cd $LOCATION_CERTS
openssl x509 -in $VMWARE_VPN_NAME.ca.crt -out $VMWARE_VPN_NAME.ca.pem -outform PEM
openssl x509 -in $VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER.vpn.prod.clientvpn.us-east-2.amazonaws.com.crt -out $VMWARE_VPN_NAME.$VMWARE_VPN_NAME_SERVER.vpn.prod.clientvpn.us-east-2.amazonaws.com.pem -outform PEM
openssl x509 -in $VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT.vpn.prod.clientvpn.us-east-2.amazonaws.com.crt -out $VMWARE_VPN_NAME.$VMWARE_VPN_NAME_CLIENT.vpn.prod.clientvpn.us-east-2.amazonaws.com.pem -outform PEM
#openssl x509 -noout -text -in ca.crt
