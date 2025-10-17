import { cursor } from 'uci';

let ctx = cursor();

const fw = ubus.call("wnfirmware", "description");
let firmware = fw.description;

let client_count = 0;
const show_client_count = ctx.get("ffwizard", "prometheus", "enable_client_count");
if (show_client_count == 1) {
    const dnsmasq = ubus.call("dnsmasq", "metrics");
    client_count = dnsmasq.leases_allocated_4 - dnsmasq.leases_pruned_4;
}

const olsrlinks = ubus.call("olsrinfo", "getjsondata", {otable: "links" ,v4_port: 9090, v6_port: 9090});
const olsr_link_number = length(json(olsrlinks.jsonreq4).links);
const olsrhna = ubus.call("olsrinfo", "getjsondata", {otable: "hna" ,v4_port: 9090, v6_port: 9090});
const is_gateway = length(filter(json(olsrhna.jsonreq4).hna, x => x.destination == "0.0.0.0" && x.validityTime == 0)) != 0;

const node = ctx.get_first("ffwizard", "node", "nodenumber") || "unknown";
const profile = ctx.get("freifunk", "community", "name") || "unknown";
const community = ctx.get_first("profile_" + profile, "community", "name") || "unknown";

const lat = ctx.get_first("ffwizard", "node", "latitude") || 0;
const lon = ctx.get_first("ffwizard", "node", "longitude") || 0;

gauge("weimarnetz_info")({
        firmware:       firmware,
        node:           node,
        profile:        profile,
        community:      community,
}, 1);
gauge("weimarnetz_lat")({}, lat);
gauge("weimarnetz_lon")({}, lon);
gauge("weimarnetz_dhcp_clients")({}, client_count);
gauge("weimarnetz_olsr_links")({}, olsr_link_number);
gauge("weimarnetz_provides_internet")({}, is_gateway ?? 1 ?? 0);