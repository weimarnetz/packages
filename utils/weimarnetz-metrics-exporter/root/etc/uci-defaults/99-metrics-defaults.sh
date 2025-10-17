#!/bin/sh

. /lib/functions.sh 

uci -m import ffwizard < /dev/null
uci_add ffwizard metrics "prometheus"
uci_set ffwizard prometheus expose_to_public "$(uci_get ffwizard prometheus expose_to_public '1')"
uci_set ffwizard prometheus enable_client_count "$(uci_get ffwizard prometheus enable_client_count '1')"
uci_commit ffwizard
