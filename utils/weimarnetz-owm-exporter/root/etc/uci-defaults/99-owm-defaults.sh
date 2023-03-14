#!/bin/sh

. /lib/functions.sh 

test -f /etc/crontabs/root || touch /etc/crontabs/root
SEED="$( dd if=/dev/urandom bs=2 count=1 2>&- | hexdump | if read line; then echo 0x${line#* }; fi )"
MIN="$(( $SEED % 59 ))"
grep -q "owm.sh" /etc/crontabs/root || echo "$MIN * * * *	/usr/sbin/owm.sh" >> /etc/crontabs/root
/etc/init.d/cron restart

uci -m import ffwizard < /dev/null
uci_add ffwizard config "owm"
uci_set ffwizard owm send_olsrd_config "$(uci_get ffwizard owm send_olsrd_config '1')"
uci_commit ffwizard
