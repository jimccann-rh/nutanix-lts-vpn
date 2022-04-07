# nutanix-lts-vpn

Quick hack for dns certs

This assume you have everything in the ovpn file, IE cert, key, ca, config

Network Manager via GUI or CLI:
nmcli connection import type openvpn file nutanix-lts-development-vpn.ovpn
nmcli connection up nutanix-lts-development-vpn
nmcli connection down nutanix-lts-development-vpn

Alternate:

sudo openvpn --config ./nutanix-lts-development-vpn.ovpn
sudo resolvectl dns tun0 10.0.0.2

