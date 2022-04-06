#!/bin/bash

LOCATION_CERTS="."
VPN_NAME="nutanix-lts-development-vpn"
VPN_DOMAIN="client1.vpn.amazonaws.com"
FILE="${LOCATION_CERTS}"/"${VPN_NAME}".ovpn

if test -f "${FILE}"; then
	echo "${FILE} exists. Updating OpenVPN config file!"
else
	echo "${FILE} not found"
fi

if grep -Fxq '<cert>' "${FILE}"; then
	echo "code cert found"
else
	CLIENT_CERT=$(cat "${LOCATION_CERTS}"/"${VPN_NAME}"."${VPN_DOMAIN}".crt)
	echo $'\n<cert>' | tee -a "${LOCATION_CERTS}"/"${VPN_NAME}".ovpn
	echo "${CLIENT_CERT}" | tee -a "${LOCATION_CERTS}"/"${VPN_NAME}".ovpn
	echo $'</cert>' | tee -a "${LOCATION_CERTS}"/"${VPN_NAME}".ovpn
fi

if grep -Fxq '<key>' "${FILE}"; then
	echo "code key found"
else
	CLIENT_KEY=$(cat "${LOCATION_CERTS}"/"${VPN_NAME}"."${VPN_DOMAIN}".key)
	echo $'\n<key>' | tee -a "${LOCATION_CERTS}"/"${VPN_NAME}".ovpn
	echo "${CLIENT_KEY}" | tee -a "${LOCATION_CERTS}"/"${VPN_NAME}".ovpn
	echo $'</key>' | tee -a "${LOCATION_CERTS}"/"${VPN_NAME}".ovpn
fi

echo "openvpn config file ${FILE} is ready (example usage 'sudo openvpn --config ${FILE}')"
