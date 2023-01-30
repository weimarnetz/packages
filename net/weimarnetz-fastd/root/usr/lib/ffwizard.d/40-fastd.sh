#!/bin/sh -x 
# shellcheck disable=SC2039

log_fastd() {
	logger -s -t ffwizard_fastd "$@"
}

setup_network() {
	local cfg="$1"
	if uci_get network "$cfg" >/dev/null; then 
		uci_remove network "$cfg"
	fi
	# remove old settings
	if uci_get network "tap0" >/dev/null; then 
		uci_remove network "tap0"
	fi
	uci_add network interface "$cfg"
	config_get type "$cfg" type "fastd"
    uci_set network "$cfg" proto "static"
    uci_set network "$cfg" auto "0"
    uci_set network "$cfg" device "tap0"
}

setup_fastd() {
    local cfg="$1"
    local secret="$2"

    if uci_get fastd "$cfg" >/dev/null; then 
		uci_remove fastd "$cfg"
	fi

    json_init
    json_load "$nodedata"
    json_get_var vpn_ip vpn_ip
    [ -n "$vpn_ip" ] || {
        log_fastd "ERR $cfg - missing vpn ip" 
        return 1
    }
    json_cleanup

    uci_add fastd fastd "vpn"
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
    uci_set fastd vpn secret '70734f206efdc91e2d973eb2c4fe943c73b9f8ed74fa6d687ca53a591a80366e'
    uci_set fastd vpn on_up "/lib/netifd/fastd-up \$INTERFACE $vpn_ip \$PEER_ADDRESS"
    uci_set fastd vpn on_down '/lib/netifd/fastd-down $INTERFACE $PEER_ADDRESS'

    uci_add fastd peer "server"                                                                      
    uci_set fastd server enabled '1'
    uci_set fastd server net 'vpn'
    uci_set fastd server key '09f8934b3e7e684be6dc8fd0cfeeea1bf30ab701aa83ae6f916f82c6993309fe'
    uci_add_list fastd server remote '77.87.48.35:10000'
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
    uci_set fastd $cfg enabled "0"
}

config_load olsrd
config_foreach remove_section Interface fastd

config_load fastd
secret="$(uci_get fastd vpn secret '')"
config_foreach disable_fastd fastd
config_foreach disable_fastd peer
config_foreach disable_fastd peer_group
uci_commit fastd

config_load ffwizard
config_foreach setup_network fastd
config_foreach setup_fastd fastd vpn $secret


uci_commit network
uci_commit olsrd
uci_commit fastd