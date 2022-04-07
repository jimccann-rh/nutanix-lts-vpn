# nutanix-lts-vpn

Quick hack for dns certs so no judging code. :)

This assume you have everything in the ovpn file, IE cert, key, ca, config. You need to provide or get the ovpn file, IE client VPC VPN from AWS/IBM.

Network Manager via GUI or CLI:

nmcli connection import type openvpn file nutanix-lts-development-vpn.ovpn

nmcli connection up nutanix-lts-development-vpn

nmcli connection down nutanix-lts-development-vpn


Alternate:

sudo openvpn --config ./nutanix-lts-development-vpn.ovpn
sudo resolvectl dns tun0 10.0.0.2

