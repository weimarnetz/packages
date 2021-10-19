'use strict';
'require uci';
'require rpc';
'require view';

var _getRegistratorStatus = rpc.declare({
    object: 'registrator',
    method: 'status',
    params: []
});

var _sendHeartbeat = rpc.declare({
    object: 'registrator',
    method: 'heartbeat',
    params: []
});

var _sendRegister = rpc.declare({
    object: 'registrator',
    method: 'register',
    params: []
});

var _sendRegisterWithGivenNumber = rpc.declare({
    object: 'registrator',
    method: 'given_number',
    params: ['nodenumber']
});

const table = '\
<div class="table">\
<div class="tr">\
    <div class="td left">' + _('Lokale Knotennummer') + '</div>\
    <div class="td right"><span id="localNodeNumber"></span></div>\
</div>\
<div class="tr">\
    <div class="td left">' + _('Registrierte Knotennummer') + '</div>\
    <div class="td right"><span id="externalNodeNumber"></span></div>\
</div>\
<div class="tr">\
    <div class="td left">' + _('Nachricht vom Registratorclient') + '</div>\
    <div class="td right"><span id="registratorClientMessage"></span></div>\
</div>\
</div>\
';

var RPC = {
    listeners: [],
    on: function on(event, callback) {
        var pair = { event: event, callback: callback }
        this.listeners.push(pair);
        return function unsubscribe() {
            this.listeners = this.listeners.filter(function (listener) {
                return listener !== pair;
            });
        }.bind(this);
    },
    emit: function emit(event, data) {
        this.listeners.forEach(function (listener) {
            if (listener.event === event) {
                listener.callback(data);
            }
        });
    },
    getRegistratorStatus: function getRegistratorStatus() {
        _getRegistratorStatus().then(function (result) {
            this.emit('getRegistratorStatus', result);
        }.bind(this));
    },
    sendHeartbeat: function sendHeartbeat() {
        _sendHeartbeat().then(function (result) {
            this.emit('sendHeartbeat', result);
        }.bind(this));
    },
    sendRegister: function sendRegister() {
        _sendRegister().then(function (result) {
            this.emit('sendRegister', result);
        }.bind(this));
    },
    sendRegisterWithGivenNumber: function sendRegisterWithGivenNumber(nodenumber) {
        _sendRegisterWithGivenNumber(nodenumber).then(function (result) {
            this.emit('sendRegisterWithGivenNumber', result);
        }.bind(this));
    }
}

function resetNodenumber() {
    document.getElementById('registerNewNodenumber').removeAttribute('hidden');
}

function renderResult(reply) {
    var localNodeNumber = uci.get('ffwizard', 'settings', 'nodenumber');
    document.getElementById('localNodeNumber').innerHTML = localNodeNumber;
    document.getElementById('registratorClientMessage').innerHTML = reply.message;
    var externalNumberElement = document.getElementById('externalNodeNumber');
    externalNumberElement.innerHTML = reply.nodenumber;
    if (reply.success && reply.nodenumber == localNodeNumber) {
        externalNumberElement.classList.remove('error');
        externalNumberElement.classList.add('alert-message', 'success');
    } else {
        externalNumberElement.setAttribute('class', 'alert-message error');
    }
}

return view.extend({
    handleSaveApply: null,
    handleSave: null,
    handleReset: null,
    load: function () {
        return Promise.all([
            uci.load('ffwizard')
        ]);
    },
    render: function (data) {
        var body = E('div', { 'class': 'cbi-map' }, [
            E('h2', _('Registrator')),
            E('div', { 'class': 'cbi-section' }, [
                E('legend', _('Status')),
                E(table),
                E('button', {
                    'class': 'cbi-button',
                    click: function (ev) {
                        RPC.getRegistratorStatus();
                    }
                }, [_('Update Status')]),
                E('button', {
                    'class': 'cbi-button',
                    click: function (ev) {
                        RPC.sendHeartbeat();
                    }
                }, [_('Send Heartbeat')]),
                E('button', {
                    'class': 'cbi-button',
                    click: function (ev) {
                        resetNodenumber();
                    }
                }, [_('Zurücksetzen')])
            ]),
            E('br'),
            E('div', { 'id': 'registerNewNodenumber', 'class': 'cbi-section', 'hidden': true }, [
                E('legend', _('Registrieren')),
                E('div', { 'class': 'table' }, [
                    E('div', { 'class': 'tr' }, [
                        E('div', { 'class': 'td left' }, _('Nächste freie Knotennummer registrieren')),
                        E('div', { 'class': 'td right' }, [
                            E('button', {
                                'class': 'cbi-button',
                                'click': function (ev) {
                                    RPC.sendRegister();
                                }
                            }, _('Knoten registrieren'))])
                    ]),
                    E('div', { 'class': 'tr' }, [
                        E('div', { 'class': 'td left' }, _('Knotennummer selbst setzen und registrieren')),
                        E('div', { 'class': 'td right' }, [
                            E('input', { 'id': 'nodeNumberInput', 'class': 'cbi-input-text select', 'min': 1, 'max': 980, 'type': 'number' }),
                            E('button', {
                                'class': 'cbi-button',
                                'click': function (ev) {
                                    RPC.sendRegisterWithGivenNumber();
                                }
                            }, _('Knoten registrieren'))])
                    ])
                ]),
                E('div', { 'class': 'cbi-section', 'hidden': true }, [
                    E('span', { 'id': 'newnodenumber-output' })
                ]
                )
            ])
        ]
        )
        var statusContainer = E('div', { 'id': 'status' }, '');

        body.appendChild(statusContainer);
        RPC.on('getRegistratorStatus', function (reply) {
            renderResult(reply);
        });
        RPC.on('sendHeartbeat', function (reply) {
            renderResult(reply);
        });
        RPC.on('sendRegister', function (reply) {
            renderResult(reply);
        });
        RPC.on('sendRegisterWithGivenNumber', function (reply) {
            var output = document.getElementById('newnodenumber-output');

            output.innerHTML =
                '<img src="/luci-static/resources/icons/loading.gif" alt="' + _('Loading') + '" style="vertical-align:middle" /> ' +
                _('Neue Netzwerkkonfiguration wird angewendet...') + '<br/>' +
                _('Der Router ist danach unter einer neuen Adresse erreichbar und kann diese Seite nicht mehr aktualisieren. Warte ein paar Sekunden ab!') + '<br/>' +
                _('Folge dann diesem') + ' <a href="http://frei.funk/' + window.location.pathname + '">' + _('Link') + '</a>';
            if (output) {
                output.parentNode.removeAttribute('hidden');
            }
            renderResult(reply);
        });

        RPC.getRegistratorStatus();
        return body;
    }
});
