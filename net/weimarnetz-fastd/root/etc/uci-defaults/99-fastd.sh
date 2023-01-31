#!/bin/sh 

. /lib/functions.sh 

uci -m import ffwizard < /dev/null
uci_add ffwizard vpn "fastd"

uci_remove ffwizard fastd url
uci_add_list ffwizard fastd url '"fastd.v.weimarnetz.de" port 10000'
uci_set ffwizard fastd pubkey "09f8934b3e7e684be6dc8fd0cfeeea1bf30ab701aa83ae6f916f82c6993309fe"
uci_commit ffwizard

# vim: set filetype=sh ai noet ts=4 sw=4 sts=4 :
