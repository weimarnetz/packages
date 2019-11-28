--[[
LuCI - Lua Configuration Interface

Copyright 2013 Patrick Grimm <patrick@lunatiki.de>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

$Id$

]]--

local bus = require "ubus"
local string = require "string"
local sys = require "luci.sys"
local uci = require "luci.model.uci".cursor_state()
local util = require "luci.util"
local version = require "luci.version"
local webadmin = require "luci.tools.webadmin"
local status = require "luci.tools.status"
local json = require "luci.json"
local netm = require "luci.model.network"
local table = require "table"
local nixio = require "nixio"
local neightbl = require "neightbl"
local ip = require "luci.ip"


local ipairs, os, pairs, next, type, tostring, tonumber, error, print =
	ipairs, os, pairs, next, type, tostring, tonumber, error, print

--- LuCI OWM-Library
-- @cstyle	instance
module "luci.owm"

local ipairs, os, pairs, next, type, tostring, tonumber, error, print =
	ipairs, os, pairs, next, type, tostring, tonumber, error, print

function fetch_olsrd_config()
	local jsonreq4 = ""
	local jsonreq6 = ""
	local data = {}
	local IpVersion = uci:get_first("olsrd", "olsrd","IpVersion")
	if IpVersion == "4" or IpVersion == "6and4" then
		local jsonreq4 = util.exec("echo /config | nc 127.0.0.1 9090 2>/dev/null") or {}
		local jsondata4 = json.decode(jsonreq4) or {}
		--print("fetch_olsrd_config v4 "..(jsondata4['config'] and "1" or "err"))
		if jsondata4['config'] then
			data['ipv4Config'] = jsondata4['config']
		end
	end
	if IpVersion == "6" or IpVersion == "6and4" then
		local jsonreq6 = util.exec("echo /config | nc ::1 9090 2>/dev/null") or {}
		local jsondata6 = json.decode(jsonreq6) or {}
		--print("fetch_olsrd_config v6 "..(jsondata6['config'] and "1" or "err"))
		if jsondata6['config'] then
			data['ipv6Config'] = jsondata6['config']
		end
	end
	return data
end

function fetch_olsrd_links()
	local jsonreq4 = ""
	local jsonreq6 = ""
	local data = {}
	local IpVersion = uci:get_first("olsrd", "olsrd","IpVersion")
	if IpVersion == "4" or IpVersion == "6and4" then
		local jsonreq4 = util.exec("echo /links | nc 127.0.0.1 9090 2>/dev/null") or {}
		local jsondata4 = json.decode(jsonreq4) or {}
		--print("fetch_olsrd_links v4 "..(jsondata4['links'] and #jsondata4['links'] or "err"))
		local links = {}
		if jsondata4['links'] then
			links = jsondata4['links']
		end
		for i,v in ipairs(links) do
			links[i]['sourceAddr'] = v['localIP'] --owm sourceAddr
			links[i]['destAddr'] = v['remoteIP'] --owm destAddr
			hostname = nixio.getnameinfo(v['remoteIP'], "inet")
			if hostname then
				links[i]['destNodeId'] = string.gsub(hostname, "mid..", "") --owm destNodeId
			end 
		end
		data = links
	end
	if IpVersion == "6" or IpVersion == "6and4" then
		local jsonreq6 = util.exec("echo /links | nc ::1 9090 2>/dev/null") or {}
		local jsondata6 = json.decode(jsonreq6) or {}
		--print("fetch_olsrd_links v6 "..(jsondata6['links'] and #jsondata6['links'] or "err"))
		local links = {}
		if jsondata6['links'] then
			links = jsondata6['links']
		end
		for i,v in ipairs(links) do
			links[i]['sourceAddr'] = v['localIP']
			links[i]['destAddr'] = v['remoteIP']
			hostname = nixio.getnameinfo(v['remoteIP'], "inet6")
			if hostname then
				links[i]['destNodeId'] = string.gsub(hostname, "mid..", "") --owm destNodeId
			end
			data[#data+1] = links[i]
		end
	end
	return data
end

function fetch_olsrd_neighbors(interfaces)
	local jsonreq4 = ""
	local jsonreq6 = ""
	local data = {}
	local IpVersion = uci:get_first("olsrd", "olsrd","IpVersion")
	if IpVersion == "4" or IpVersion == "6and4" then
		local jsonreq4 = util.exec("echo /links | nc 127.0.0.1 9090 2>/dev/null") or {}
		local jsondata4 = json.decode(jsonreq4) or {}
		--print("fetch_olsrd_neighbors v4 "..(jsondata4['links'] and #jsondata4['links'] or "err"))
		local links = {}
		if jsondata4['links'] then
			links = jsondata4['links']
		end
		for _,v in ipairs(links) do
			local hostname = nixio.getnameinfo(v['remoteIP'], "inet")
			if hostname then
				hostname = string.gsub(hostname, "mid..", "")
				local index = #data+1
				data[index] = {}
				data[index]['id'] = hostname --owm
				data[index]['quality'] = v['linkQuality'] --owm
				data[index]['sourceAddr4'] = v['localIP'] --owm
				data[index]['destAddr4'] = v['remoteIP'] --owm
				if #interfaces ~= 0 then
					for _,iface in ipairs(interfaces) do
						if iface['ipaddr'] == v['localIP'] then
							data[index]['interface'] = iface['name'] --owm
						end
					end
				end
				data[index]['olsr_ipv4'] = v
			end
		end
	end
	if IpVersion == "6" or IpVersion == "6and4" then
		local jsonreq6 = util.exec("echo /links | nc ::1 9090 2>/dev/null") or {}
		local jsondata6 = json.decode(jsonreq6) or {}
		--print("fetch_olsrd_neighbors v6 "..(jsondata6['links'] and #jsondata6['links'] or "err"))
		local links = {}
		if jsondata6['links'] then
			links = jsondata6['links']
		end
		for _,v in ipairs(links) do
			local hostname = nixio.getnameinfo(v['remoteIP'], "inet6")
			if hostname then
				hostname = string.gsub(hostname, "mid..", "")
				local index = 0
				for i, v in ipairs(data) do
					if v.id == hostname then
						index = i
					end
				end
				if index == 0 then
					index = #data+1
					data[index] = {}
					data[index]['id'] = string.gsub(hostname, "mid..", "") --owm
					data[index]['quality'] = v['linkQuality'] --owm
					if #interfaces ~= 0 then
						for _,iface in ipairs(interfaces) do
							local name = iface['.name']
							local net = netm:get_network(name)
							local device = net and net:get_interface()
							if device and device:ip6addrs() then
								local_ip = ip.IPv6(v.localIP)
								for _, a in ipairs(device:ip6addrs()) do
									if a:host() == local_ip:host() then
										data[index]['interface'] = name
									end
								end
							end
						end
					end
				end
				data[index]['sourceAddr6'] = v['localIP'] --owm
				data[index]['destAddr6'] = v['remoteIP'] --owm
				data[index]['olsr_ipv6'] = v
			end
		end
	end
	return data
end

function fetch_olsrd()
	local data = {}
	data['links'] = fetch_olsrd_links()
	local olsrconfig = fetch_olsrd_config()
	data['ipv4Config'] = olsrconfig['ipv4Config']
	data['ipv6Config'] = olsrconfig['ipv6Config']
	return data
end

function showmac(mac)
	if not is_admin then
		mac = mac:gsub("(%S%S:%S%S):%S%S:%S%S:(%S%S:%S%S)", "%1:XX:XX:%2")
	end
	return mac
end

function get()
	local root = {}
	local ntm = netm.init()
	local wifidevs = ntm:get_wifidevs()
	local assoclist = {}
	for _, dev in ipairs(wifidevs) do
		for _, net in ipairs(dev:get_wifinets()) do
			local radio = net:get_device()
			assoclist[#assoclist+1] = {} 
			assoclist[#assoclist]['ifname'] = net:ifname()
			assoclist[#assoclist]['network'] = net:network()
			assoclist[#assoclist]['device'] = radio and radio:name() or nil
			assoclist[#assoclist]['list'] = net:assoclist()
		end
	end
	--print(json.encode(assoclist))
	root.type = 'node' --owm
	root.updateInterval = 600
	local info = nixio.sysinfo()
	local boardinfo = util.ubus("system", "board") or { }
	root.system = {
		uptime = {info.uptime},
		loadavg = info.loads,
		sysinfo = {
			boardinfo.system or "?",
			boardinfo.model or "?",
			info},
	}
	root.hostname = sys.hostname() --owm
	
	local nn = uci:get("ffwizard","settings","nodenumber")
  local registrator = util.ubus("registrator", "status") or { }
	root.weimarnetz = {
		nodenumber=nn,
    registratorstatus=registrator,
	}

	-- s system,a arch,r ram owm
	local s,a,r = info --owm
	root.hardware = boardinfo.system or "?"
	
	fff = nixio.fs.readfile('/etc/weimarnetz_release')
	
	root.firmware = {
		luciname=version.luciname,
		luciversion=version.luciversion,
		distname=boardinfo.release.distribution,
		branch=string.match(fff, "FFF_SOURCE_BRANCH=(%w*)" ),
		version=string.match(fff, "FFF_VERSION=(%w*)" ),
		distversion=boardinfo.release.version,
		description=boardinfo.release.description,
		revision=boardinfo.release.revision
	}

        local email2owm = uci:get_first("system", "weblogin", "email2owm")
        if not email2owm then
                email2owm = '0'
        end

	root.freifunk = {}
	uci:foreach("freifunk", "public", function(s)
		local pname = s[".name"]
		s['.name'] = nil
		s['.anonymous'] = nil
		s['.type'] = nil
		s['.index'] = nil
		if s['mail'] and email2owm == '1' then
			s['mail'] = string.gsub(s['mail'], "@", "./-\\.T.")
                else
                        s['mail'] = "Email hidden"
		end
		root.freifunk[pname] = s
	end)

	uci:foreach("system", "system", function(s) --owm
		root.latitude = tonumber(s.latitude) --owm
		root.longitude = tonumber(s.longitude) --owm
		root.location = s.location
	end)
	
	if not root.latitude or not root.longitude then
		root.type='node_no_loc'
	end

	local devices = {}
	uci:foreach("wireless", "wifi-device",function(s)
		devices[#devices+1] = s
		devices[#devices]['name'] = s['.name']
		devices[#devices]['.name'] = nil
		devices[#devices]['.anonymous'] = nil
		devices[#devices]['.type'] = nil
		devices[#devices]['.index'] = nil
		if s.macaddr then
			devices[#devices]['macaddr'] = showmac(s.macaddr)
		end
	end)

	local interfaces = {}
	uci:foreach("wireless", "wifi-iface",function(s)
		interfaces[#interfaces+1] = s
		interfaces[#interfaces]['.name'] = nil
		interfaces[#interfaces]['.anonymous'] = nil
		interfaces[#interfaces]['.type'] = nil
		interfaces[#interfaces]['.index'] = nil
		interfaces[#interfaces]['key'] = nil
		interfaces[#interfaces]['key1'] = nil
		interfaces[#interfaces]['key2'] = nil
		interfaces[#interfaces]['key3'] = nil
		interfaces[#interfaces]['key4'] = nil
		interfaces[#interfaces]['auth_secret'] = nil
		interfaces[#interfaces]['acct_secret'] = nil
		interfaces[#interfaces]['nasid'] = nil
		interfaces[#interfaces]['identity'] = nil
		interfaces[#interfaces]['password'] = nil
		local iwinfo = sys.wifi.getiwinfo(s.device)
		--print(json.encode(s))
		--print(json.encode(iwinfo))
		if iwinfo then
			local _, f
			for _, f in ipairs({
			"channel", "txpower", "bitrate", "signal", "noise",
			"quality", "quality_max", "mode", "ssid", "bssid", "encryption", "ifname"
			}) do
				--print(json.encode(iwinfo[f]))
				interfaces[#interfaces][f] = iwinfo[f]
			end
			if iwinfo['encryption'] then
				if iwinfo['encryption']['enabled'] then
					-- fingers off encrypted wifi interfaces, they are likely private
					table.remove(interfaces)
					return
				end
			end
		end

		assoclist_if = {}
		for _, v in ipairs(assoclist) do
			if v.network[1] == interfaces[#interfaces]['network'] and v.list then
				for assocmac, assot in pairs(v.list) do
					assoclist_if[#assoclist_if+1] = assot
					assoclist_if[#assoclist_if].mac = showmac(assocmac)
				end
			end
		end
		interfaces[#interfaces]['assoclist'] = assoclist_if
		for ii,vv in ipairs(devices) do
			if s['device'] == vv.name then
				interfaces[#interfaces]['wirelessdevice'] = vv
			end
		end
	end)

	root.interfaces = {} --owm
	uci:foreach("network", "interface",function(vif)
		if 'lo' == vif.ifname then
			return
		end
		local name = vif['.name']
		if ('wan' == name) or ('wan6' == name) then
			-- fingers off wan as this will be the private internet uplink
			return
		end
		local net = netm:get_network(name)
		local device = net and net:get_interface()
		root.interfaces[#root.interfaces+1] =  vif
		root.interfaces[#root.interfaces].name = name --owm
		root.interfaces[#root.interfaces].ifname = vif.ifname --owm
		root.interfaces[#root.interfaces].ipv4Addresses = {vif.ipaddr} --owm
		if device and device:ip6addrs() then
			local ipv6Addresses = {}
			for _, a in ipairs(device:ip6addrs()) do
				table.insert(ipv6Addresses, a:string())
			end
		end
		root.interfaces[#root.interfaces].ipv6Addresses = ipv6Addresses --owm
		root.interfaces[#root.interfaces].physicalType = 'ethernet' --owm
		root.interfaces[#root.interfaces]['.name'] = nil
		root.interfaces[#root.interfaces]['.anonymous'] = nil
		root.interfaces[#root.interfaces]['.type'] = nil
		root.interfaces[#root.interfaces]['.index'] = nil
		root.interfaces[#root.interfaces]['username'] = nil
		root.interfaces[#root.interfaces]['password'] = nil
		root.interfaces[#root.interfaces]['password'] = nil
		root.interfaces[#root.interfaces]['clientid'] = nil
		root.interfaces[#root.interfaces]['reqopts'] = nil
		root.interfaces[#root.interfaces]['pincode'] = nil
		root.interfaces[#root.interfaces]['tunnelid'] = nil
		root.interfaces[#root.interfaces]['tunnel_id'] = nil
		root.interfaces[#root.interfaces]['peer_tunnel_id'] = nil
		root.interfaces[#root.interfaces]['session_id'] = nil
		root.interfaces[#root.interfaces]['peer_session_id'] = nil
		if device and device:mac() then
			root.interfaces[#root.interfaces]['macaddr'] = device:mac()
		end
		
		wireless_add = {}
		for i,v in ipairs(interfaces) do
			if v['network'] == name then
				root.interfaces[#root.interfaces].physicalType = 'wifi' --owm
				root.interfaces[#root.interfaces].mode = v.mode
				root.interfaces[#root.interfaces].encryption = v.encryption
				root.interfaces[#root.interfaces].access = 'free'
				root.interfaces[#root.interfaces].accessNote = "everyone is welcome!"
				root.interfaces[#root.interfaces].channel = v.wirelessdevice.channel
				root.interfaces[#root.interfaces].txpower = v.wirelessdevice.txpower
				root.interfaces[#root.interfaces].bssid = v.bssid
				root.interfaces[#root.interfaces].ssid = v.ssid
				root.interfaces[#root.interfaces].antenna = v.wirelessdevice.antenna
				wireless_add[#wireless_add+1] = v --owm
			end
		end
		root.interfaces[#root.interfaces].wifi = wireless_add
	end)

	local dr4 = ip.routes({ dest_exact="0.0.0.0/0" })
	local dr6 = ip.routes({ dest_exact="::/0" })

	if dr6[1] and dr6[1].gw then
		def6 = { 
		gateway = dr6[1].gw:string(),
		dest = dr6[1].dest:string(),
		dev = dr6[1].dev,
		metr = dr6[1].metric }
	end   

	if dr4[1] and dr4[1].gw then
		def4 = { 
		gateway = dr4[1].gw:string(),
		dest = dr4[1].dest:string(),
		dev = dr4[1].dev,
		metr = dr4[1].metric }
	else
		local dr = sys.exec("ip r s")
		if dr then
			local dest, gateway, dev, metr = dr:match("^(%w+) via (%d+.%d+.%d+.%d+) dev (%w+) +metric (%d+)")
			def4 = {
				dest = dest,
				gateway = gateway,
				dev = dev,
				metr = metr
			}
		end
	end

	root.ipv4defaultGateway = def4
	root.ipv6defaultGateway = def6
	local neighbors = fetch_olsrd_neighbors(root.interfaces)
if #root.interfaces ~= 0 then
		for idx,iface in ipairs(root.interfaces) do
			local t = {}
			if iface['ifname'] and neightbl then
				t = neightbl.get(iface['ifname']) or {}
				local neightbl_get
				for ip,mac in pairs(t) do
					if not mac then
						os.execute("ping6 -q -c1 -w1 -I"..iface['ifname'].." "..ip.." 2&>1 >/dev/null")
						neightbl_get = true
					end
				end
				if neightbl_get then
					t = neightbl.get(iface['ifname']) or {}
				end
			end
			local neigh_mac = {}
			for ip,mac in pairs(t) do
				if mac and not string.find(mac, "33:33:") then
					mac = showmac(mac)
					if not neigh_mac[mac] then
						neigh_mac[mac] = {}
						neigh_mac[mac]['ip6'] = {}
					elseif not neigh_mac[mac]['ip6'] then
						neigh_mac[mac]['ip6'] = {}
					end
					neigh_mac[mac]['ip6'][#neigh_mac[mac]['ip6']+1] = ip
					for i, neigh in ipairs(neighbors) do
						if neigh['destAddr6'] == ip then
							neighbors[i]['mac'] = mac
							neighbors[i]['ifname'] = iface['ifname']
						end
					end
				end
			end
			for _, v in ipairs(assoclist) do
				if v.ifname == iface['ifname'] and v.list then
					for assocmac, assot in pairs(v.list) do
						local mac = showmac(assocmac:lower())
						if not neigh_mac[mac] then
							neigh_mac[mac] = {}
						end
						if not neigh_mac[mac]['ip4'] then
							neigh_mac[mac]['ip4'] = {}
						end
						if not neigh_mac[mac]['ip6'] then
							neigh_mac[mac]['ip6'] = {}
						end
						neigh_mac[mac]['wifi'] = assot
						for i, neigh in ipairs(neighbors) do
							for j, ip in ipairs(neigh_mac[mac]['ip4']) do
								if neigh['destAddr4'] == ip then
									neighbors[i]['mac'] = mac
									neighbors[i]['ifname'] = iface['ifname']
									neighbors[i]['wifi'] = assot
									neighbors[i]['signal'] = assot.signal
									neighbors[i]['noise'] = assot.noise
								end
							end
							for j, ip in ipairs(neigh_mac[mac]['ip6']) do
								if neigh['destAddr6'] == ip then
									neighbors[i]['mac'] = mac
									neighbors[i]['ifname'] = iface['ifname']
									neighbors[i]['wifi'] = assot
									neighbors[i]['signal'] = assot.signal
									neighbors[i]['noise'] = assot.noise
								end
							end
						end
					end
				end
			end
			root.interfaces[idx].neighbors = neigh_mac
		end
	end
	root.links = neighbors

	root.olsr = fetch_olsrd()

	root.script = 'luci-app-owm'
	
	root.api_rev = '1.0'

	return root
end

