--[[
LuCI - Lua Configuration Interface

Copyright 2008 Steven Barth <steven@midlink.org>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

$Id$
]]--

module("luci.controller.weimarnetz.app", package.seeall)

function index()
   page = node("freifunk", "info")
   page.title    = luci.i18n.translate("Informationsseite")
   page.order    = 1
   page.target   = template("weimarnetz/infopage")
   page.setuser  = false
   page.setgroup = false

   page = node("freifunk", "map")
   page.title    = luci.i18n.translate("Karte")
   page.order    = 5
   page.target   = template("weimarnetz/map")
   page.setuser  = false
   page.setgroup = false

   page = node("admin", "weimarnetz")
   page.target = firstchild()
   page.title  = _("Weimarnetz")
   page.order  = 5
   page.index  = true

   page        = node("admin", "weimarnetz", "settings")
   page.target = cbi("weimarnetz/settings")
   page.title  = _("Weimarnetz Settings")
   page.order  = 6

   page        = node("admin", "weimarnetz", "registrator")
   page.target = template("weimarnetz/registrator")
   page.title  = _("Weimarnetz Registrator")
   page.order  = 6

   page = entry({"admin", "weimarnetz", "registrator_status"}, call("registrator_status"), nil)
   page.leaf = true

   page = entry({"admin", "weimarnetz", "registrator_heartbeat"}, post("registrator_heartbeat"), nil)
   page.leaf = true

   page = entry({"admin", "weimarnetz", "registrator_register"}, post("registrator_register"), nil)
   page.leaf = true

   page = entry({"admin", "weimarnetz", "local_nodenumber"}, call("registrator_nodenumber"), nil)
   page.leaf = true
end

function registrator_status()
  local status = luci.util.ubus("registrator", "status")
  luci.http.prepare_content("application/json")
  luci.http.write_json(status)
end

function registrator_heartbeat()
  local status = luci.util.ubus("registrator", "heartbeat")
  luci.http.prepare_content("application/json")
  luci.http.write_json(status)
end

function registrator_register()
  local status = luci.util.ubus("registrator", "register")
  luci.http.prepare_content("application/json")
  luci.http.write_json(status)
end

function registrator_nodenumber()
  local value = luci.util.ubus("uci", "get", {config = "ffwizard", section = "settings", option= "nodenumber"})
  luci.http.prepare_content("application/json")
  luci.http.write_json(value)
end

