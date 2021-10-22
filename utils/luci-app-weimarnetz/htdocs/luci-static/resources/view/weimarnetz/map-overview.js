'use strict';
'require uci';
'require view';

return view.extend({
    handleSaveApply: null,
    handleSave: null,
    handleReset: null,
    load: function () {
        return Promise.all([
            uci.load('freifunk')
        ]);
    },
    render: function (data) {
        const mapserver = uci.get('freifunk', 'community', 'mapserver');
        return E([
            E('h1', {}, _('Weimarnetz Überblick')),
            E('div', { 'class': 'span4' }, [
                E('iframe', {
                    'id': 'ifrm',
                    'src': mapserver + '/#!v:m',
                    'width': '98%',
                    'scrolling': 'yes',
                    'marginwidth': '0',
                    'marginheight': '0',
                    'frameborder': '0',
                    'style': 'height: 581px;'
                }, [])
            ])
        ]);
    }
});