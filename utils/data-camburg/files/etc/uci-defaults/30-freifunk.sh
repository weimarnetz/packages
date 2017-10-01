#!/bin/sh 

. /lib/functions.sh

uci -m import profile_Camburg <<EOF
config community 'profile'
	option 'name' 'Camburg'
	option 'homepage' 'http://camburg.freifunk.net'
	option 'ssid' 'camburg.freifunk.net'
	option 'mesh_network' '10.63.0.0/16'
	option 'latitude' '51.053889'
	option 'longitude' '11.7075'
EOF

uci_set freifunk community name "Camburg"
uci_set freifunk community owm_api "http://mapapi.weimarnetz.de"
uci_set freifunk community mapserver "http://map.weimarnetz.de"
uci_set freifunk community homepage "http://camburg.freifunk.net"
uci_set freifunk community registrator "http://reg.weimarnetz.de"
