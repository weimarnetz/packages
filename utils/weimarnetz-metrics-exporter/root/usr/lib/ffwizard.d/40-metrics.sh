#!/bin/sh -x 
# shellcheck disable=SC2039

log_metrics() {
	logger -s -t ffwizard_metrics "$@"
}

setup_prometheus_exporter() {
    expose_to_public="$(uci_get ffwizard prometheus expose_to_public '0')"
    if [ "$expose_to_public" -eq 1 ]; then
        log_metrics "INFO - exposing metrics to public"
        uci_set prometheus-node-exporter-ucode main listen_interface "*"
    else
        log_metrics "INFO - exposing metrics locally only"
        uci_set prometheus-node-exporter-ucode main listen_interface "loopback"
    fi
}

setup_prometheus_exporter

uci_commit prometheus-node-exporter-ucode
