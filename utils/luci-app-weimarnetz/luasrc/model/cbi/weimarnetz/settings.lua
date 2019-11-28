-- Copyright 2015 Andreas Bräu <ab@andi95.de> 
-- Licensed to the public under the Apache License 2.0.                                     
                                                                                
local fs = require "nixio.fs"
local util = require "luci.util"
local uci = require "luci.model.uci".cursor()
local profiles = "/etc/config/profile_*"

m = Map("ffwizard", translate("Einstellungen fürs Weimarnetz"))
w = m:section(NamedSection, "settings", "node", nil, translate("Allgemein"))
s = m:section(TypedSection, "wifi", nil, translate("SSIDs"))
h = m:section(TypedSection, "hna4", nil, translate("Eigene HNAs"))
v = m:section(NamedSection, "vpn", "vpn", nil, translate("VPN"))
o = m:section(NamedSection, "olsr", "olsr", nil, translate("OLSR"))

publishEmail = w:option(Flag, "email2owm", translate("Email veröffentlichen"), translate("Soll deine Emailadresse auf unserem <a href=\"http://weimarnetz.de/monitoring\" target=\"_blank\">Monitoring</a> erscheinen? Die Adresse ist dort öffentlich einsehbar. Bei Problemen kann man dich kontaktieren. Sonst ist die Adresse nur auf deinem Router sichtbar."))
publishEmail.rmempty=false
publishEmail.default='0'

legacy = w:option(Flag, "legacy", translate("IBSS Kompatabilität aktivieren."), translate("Zusätzlich zum 802.11s Mesh gibt es ein IBSS (Ad-Hoc Modus) Interface für das Mesh. Notwendig zur Kommunikation mit älterer Firmware (pre brauhaus)"))
legacy.rmempty=false 
legacy.default='1'

restrict = w:option(Flag, "restrict", translate("LAN-Zugriff unterbinden"), translate("Soll Zugriff auf das eigene lokale Netzwerk blockiert werden?"))
restrict.rmempty=false 

restrict = w:option(Flag, "block_wan_port", translate("Zugriff auf WAN-Port sperren"), translate("Mit dieser Option kann der WAN-Port (das ist der Port, über den das Internet angeschlossen wird) für den Zugriff von außen gesperrt werden. Eine Änderung erfordert aktuell einen Neustart des Routers."))
restrict.rmempty=false 

vpnEnable = v:option(Flag, "enabled", translate("VPN aktivieren"))
vpnEnable.rmempty=false
vpnEnable.default='1'
vpnMode = v:option(ListValue, "mode", translate("VPN-Modus"), translate("Wie soll das VPN genutzt werden? Kompletten Datenverkehr über VPN transportieren oder VPN nur für Verbindungen zu anderen Geräten im Mesh nutzen"))
vpnMode:value("all", translate("Kompletten Internetverkehr über VPN leiten"))
vpnMode:value("innercity", translate("Nur für Verbindung mit der Weimarnetz-Wolke"))
vpnMode.widget="radio"
vpnMode:depends("enabled", true)
vpnNoInternet = v:option(Flag, "paranoia", translate("Bei VPN-Ausfall Internet sperren"), translate("Soll die Nutzung des lokalen Internetzugang verweigert werden, wenn VPN ausfällt? Ist diese Option deaktiviert wird der lokale Internetanschluss genutzt. Auch für Datenverkehr aus dem Mesh!"))
vpnNoInternet.rmempty=false
vpnNoInternet.default='1'
vpnNoInternet:depends("enabled", true)

ssid = s:option(Value, "ap_ssid", translate("SSID"), translate("SSID für das öffentlich zugängliche Netzwerk")) 
function ssid:validate(value)
        if value:len()<=32 and value:match("[0-9A-Za-z\ -\(\)]") then
                return value
        else
                return false
        end
end

o.rmempty=true
o:option(DynamicList, "service", "OLSR Service", translate("Serivce, der per OLSR im Netz angekündigt werden soll. Das Format sieht so aus: '&lt;service url&gt;|&lt;protocol&gt;|&lt;Beschreibung&gt;'. Das Protokoll kann entweder tcp oder udp sein. Die URL, z.B. http://hostname:8080/service muss im Netz des Routers erreichbar sein. Die Beschreibung darf keine Umlaute enthalten."))

h.addremove=true
h.rmempty=true
h:option(Value, "netaddr", translate("Netzwerkadresse"), translate("Netzwerkadresse, die in OLSR angekündigt werden soll"))
h:option(Value, "netmask", translate("Netzwerkmaske"), translate("Netzwerkmaske, die zu dem Netzwerk gehört"))

return m

