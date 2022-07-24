'use strict';
'require view';
'require form';

return view.extend({
	render: function () {
		var ffwizardMap = new form.Map("ffwizard", _("Buttons"), _("Einstellungen fürs Hardwarebuttons"));

		var buttonSettings = ffwizardMap.section(form.NamedSection, 'buttons', 'buttons', _('Buttons'), _('Buttons konfigurieren'));

		var resetButtonMode = buttonSettings.option(form.ListValue, 'reset', _('Reset Button'), _('Was soll nach längerem Drücken auf den Reset-Button passieren?'));
		resetButtonMode.value("NOOP", _("Nichts!"));
		resetButtonMode.value("REBOOT", _("Das Gerät wird neu gestartet."));
		resetButtonMode.value("RESET", _("Das Gerät wird zurückgesetzt und neu gestartet. Alle Weimarnetzfunktionen gehen dabei verloren."));
    resetButtonMode.default = "RESET"
		resetButtonMode.widget = "select";

		return ffwizardMap.render();
	},
});
