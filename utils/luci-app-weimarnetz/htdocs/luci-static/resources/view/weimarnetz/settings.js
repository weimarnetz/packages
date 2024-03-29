'use strict';
'require view';
'require form';

return view.extend({
	render: function () {
		var ffwizardMap = new form.Map("ffwizard", _("Einstellungen"), _("Einstellungen fürs Weimarnetz"));
		var generalSettings = ffwizardMap.section(form.NamedSection, 'settings', 'node', _('Allgemein'), _('Allgemeine Einstellungen'));

		var s = ffwizardMap.section(form.TypedSection, "wifi", _("WLAN-Einstellungen"), _('WLAN-Namen, Mesh und Roaming konfigurieren für alle Geräte (z.B. 2,4GHz und ggf. 5GHz)'));
		var hnaSettings = ffwizardMap.section(form.TypedSection, "hna4", _("Eigene HNAs"), _('Weitere Netze ankündigen'))
		var vpnSettings = ffwizardMap.section(form.NamedSection, 'vpn', 'vpn', _('VPN'), _('Verbindungen zum VPN-Server konfigurieren'));
		var olsrSettings = ffwizardMap.section(form.NamedSection, "olsr", "olsr", _("OLSR"), _('Einstellungen für OLSR'))

		var publishEmail = generalSettings.option(form.Flag, "email2owm",
			_("Email veröffentlichen"),
			_("Soll deine Emailadresse auf unserem <a href=\"http://weimarnetz.de/uebersicht-weimarnetz/status\" target=\"_blank\">Monitoring</a> erscheinen? Die Adresse ist dort öffentlich einsehbar. Bei Problemen kann man dich kontaktieren. Sonst ist die Adresse nur auf deinem Router sichtbar."));
		publishEmail.rmempty = false;
		publishEmail.default = '0';

		var restrict = generalSettings.option(form.Flag, "restrict", _("LAN-Zugriff unterbinden"), _("Soll Zugriff auf das eigene lokale Netzwerk blockiert werden?"));
		restrict.rmempty = false;

		restrict = generalSettings.option(form.Flag, "block_wan_port", _("Zugriff auf WAN-Port sperren"), _("Mit dieser Option kann der WAN-Port (das ist der Port, über den das Internet angeschlossen wird) für den Zugriff von außen gesperrt werden. Eine Änderung erfordert aktuell einen Neustart des Routers."));
		restrict.rmempty = false;

		var vpnEnable = vpnSettings.option(form.Flag, 'enabled', _('VPN aktivieren'), _('Soll VPN überhaupt aktiviert werden?'));
		vpnEnable.rmempty = false;
		vpnEnable.default = '1';
		var vpnMode = vpnSettings.option(form.ListValue, 'mode', _('VPN-Modus'), _('Wie soll das VPN genutzt werden? Kompletten Datenverkehr über VPN transportieren oder VPN nur für Verbindungen zu anderen Geräten im Mesh nutzen'));
		vpnMode.value("all", _("Kompletten Internetverkehr über VPN leiten"));
		vpnMode.value("innercity", _("Nur für Verbindung mit der Weimarnetz-Wolke"));
		vpnMode.widget = "select";
		vpnMode.depends("enabled", '1');
		var vpnNoInternet = vpnSettings.option(form.Flag, "paranoia", _("Bei VPN-Ausfall Internet sperren"), _("Soll die Nutzung des lokalen Internetzugang verweigert werden, wenn VPN ausfällt? Ist diese Option deaktiviert wird der lokale Internetanschluss genutzt. Auch für Datenverkehr aus dem Mesh!"));
		vpnNoInternet.rmempty = false;
		vpnNoInternet.default = '1';
		vpnNoInternet.depends("enabled", '1');

		var roaming = s.option(form.Flag, "roaming", _("Roaming"), _("Soll das Roamingnetzwerk aktiv sein?"));
		roaming.rmempty = false;
		roaming.default = '1';
		var mesh = s.option(form.Flag, "olsr_mesh", _("Mesh"), _("Soll das Meshnetzwerk aktiv sein?"));
		mesh.rmempty = false;
		mesh.default = '1';
		var vap = s.option(form.Flag, "vap", _("Access Point"), _("Soll der Access Point aktiv sein?"));
		vap.rmempty = false;
		vap.default = '1';
		var ssid = s.option(form.Value, "ap_ssid", _("SSID"), _("SSID für das öffentlich zugängliche Netzwerk"));
		ssid.validate = function(section, value) {
			if (value.length > 32) {
				return _('SSID darf nicht länger als 32 Zeichen sein!');
			}
			if (value.length > 0 && !value.match(/^[a-zA-Z0-9\-\(\)\|\ \.]+$/)) {
				return _('SSID darf nur alphanumerischen Zeichen, Klammern, Bindestrich oder Leerzeichen enthalten!')
			}
			return true;
		}

		olsrSettings.addremove = true;
		var olsrService = olsrSettings.option(form.DynamicList, "service", "OLSR Service", _("Serivce, der per OLSR im Netz angekündigt werden soll. Das Format sieht so aus: '&lt;service url&gt;|&lt;protocol&gt;|&lt;Beschreibung&gt;'. Das Protokoll kann entweder tcp oder udp sein. Die URL, z.B. http://hostname:8080/service muss im Netz des Routers erreichbar sein. Die Beschreibung darf keine Umlaute enthalten."));
		olsrService.placeholder = '<service url>|<protocol>|<Beschreibung>';


		hnaSettings.addremove = true;
		hnaSettings.addbtntitle = _('Neues Netzwerk ankündigen (Name eingeben)');
		hnaSettings.option(form.Value, "netaddr", _("Netzwerkadresse"), _("Netzwerkadresse, die in OLSR angekündigt werden soll"))
		hnaSettings.option(form.Value, "netmask", _("Netzwerkmaske"), _("Netzwerkmaske, die zu dem Netzwerk gehört"))

		return ffwizardMap.render();
	},
});
