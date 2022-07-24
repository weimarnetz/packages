#!/bin/sh 

. /lib/functions.sh 

uci -m import ffwizard < /dev/null
uci_add ffwizard node "buttons"

uci_commit ffwizard

# vim: set filetype=sh ai noet ts=4 sw=4 sts=4 :
