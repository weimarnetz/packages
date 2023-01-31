#!/bin/sh -x 
# shellcheck disable=SC2039

log_fastd() {
	logger -s -t ffwizard_fastd "$@"
}

setup_network() {
	local cfg="$1"
    log_fastd "INFO - configure network $cfg for fastd"
	if uci_get network "$cfg" >/dev/null; then 
		uci_remove network "$cfg"
	fi
	# remove old settings
	if uci_get network "tap0" >/dev/null; then 
		uci_remove network "tap0"
	fi
	uci_add network interface "$cfg"
    uci_set network "$cfg" proto "static"
    uci_set network "$cfg" auto "0"
    uci_set network "$cfg" device "tap0"
}

setup_fastd() {
    local cfg="$1"
    local secret="$2"
    local net="$3"

    if uci_get fastd "$net" >/dev/null; then 
		uci_remove fastd "$net"
	fi

    if uci_get fastd "server" >/dev/null; then 
		uci_remove fastd "server"
	fi

    json_init
    json_load "$nodedata"
    json_get_var vpn_ip vpn_ip
    log_fastd "INFO $cfg - vpn ip is $vpn_ip"
    [ -n "$vpn_ip" ] || {
        log_fastd "ERR $cfg - missing vpn ip" 
        return 1
    }
    json_cleanup

    uci_add fastd fastd "$net"
    uci_set fastd vpn enabled '1'
    uci_set fastd vpn syslog_level 'debug'
    uci_add_list fastd vpn method 'null@l2tp'
    uci_add_list fastd vpn method 'null'
    uci_set fastd vpn mode 'multitap'
    uci_add_list fastd vpn bind '0.0.0.0:10000'
    uci_set fastd vpn mtu '1280'
    uci_set fastd vpn forward '0'
    uci_set fastd vpn persist_interface '0'
    uci_set fastd vpn offload_l2tp  '0'
    uci_set fastd vpn secret "$secret"
    uci_set fastd vpn on_up "/lib/netifd/fastd-up \$INTERFACE $vpn_ip \$PEER_ADDRESS"
    uci_set fastd vpn on_down '/lib/netifd/fastd-down $INTERFACE $PEER_ADDRESS'

    uci_add fastd peer "server"                                                                      
    uci_set fastd server enabled '1'
    uci_set fastd server net "$net"
}

setup_olsr() {
	local device="$1"

	log_fastd "olsr setup $cfg"
	uci_add olsrd Interface ; iface_sec="$CONFIG_SECTION"
	uci_set olsrd "$iface_sec" interface "${device}"
	uci_set olsrd "$iface_sec" ignore "0"
	uci_set olsrd "$iface_sec" Mode "ether"
}

remove_section() {
	local cfg="$1"
    local interface_to_delete="$2"

    config_get interface "$cfg" interface

    if [ "$interface" = "$interface_to_delete" ]; then
	    uci_remove olsrd "$cfg"
    fi
}

disable_fastd() {
    local cfg="$1"
    log_fastd "INFO - disable $cfg in fastd config"
    uci_set fastd $cfg enabled "0"
}

add_vpn_remotes() {
    local value="$1"
    uci_add_list fastd server remote "$value"
}

add_vpn_peers() {
    local cfg="$1"

    if [ "$cfg" != "fastd" ]; then
        return 1
    fi

    log_fastd "add vpn peers for cfg $cfg"

    config_get pubkey "$cfg" pubkey ""
    config_get url "$cfg" url ""

    if [ -z "$pubkey" ] || [ -z "$url" ]; then
        log_fastd "WARN - no vpn peers in $cfg found"
		return 1
	fi

    uci_set fastd server key "$pubkey"
    config_list_foreach "$cfg" url add_vpn_remotes 
}

config_load olsrd
config_foreach remove_section Interface fastd

config_load fastd
secret="$(uci_get fastd vpn secret '')"
config_foreach disable_fastd fastd
config_foreach disable_fastd peer
config_foreach disable_fastd peer_group

setup_olsr "fastd"
setup_network "fastd"
setup_fastd "fastd" $secret "vpn"

config_load profile_${community}
config_foreach add_vpn_peers vpn

community_key="$(uci_get fastd server key '')"
if [ -z $community_key ]; then
    log_fastd "INFO - no community server, using default"
    config_load ffwizard
    config_foreach add_vpn_peers vpn
fi

uci_commit network
uci_commit olsrd
uci_commit fastd

/etc/init.d/fastd generate_key vpn