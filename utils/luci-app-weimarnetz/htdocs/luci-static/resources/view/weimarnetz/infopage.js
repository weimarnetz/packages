'use strict';
'require uci';
'require view';

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
        const nodenumber = uci.get('ffwizard', 'settings', 'nodenumber');
        return E([], {}, [
            E('h1', {}, _('Weimarnetz News')),
            E('div', { 'class': 'span4' }, '<img id="logo" src="/images/logo.png" title="Weimarnetz" alt="Weimarnetz"></img>'),
            E('h2', {}, _('Aktuelle Meldungen')),
            E('<div class="row">\
                <div class="span6" id="news">\
                    <ul id="newslist">\
                        <li>\
                            ' + _('Meldungen werden geladen. Falls nicht, hast Du entweder Javascript im Browser deaktiviert oder\
                            Dir steht kein Internet zur Verfuegung.') + '\
                        </li>\
                    </ul>\
                </div>\
            </div>'),
            E('<h2>', {}, _('Aktuelle Diskussionen ')),
            E('<div class="row">\
                <div class="span6" id="discussions">\
                    <ul id="mailinglist">\
                        <li>\
                            ' + _('Diskussionen werden geladen. Falls nicht, hast Du entweder Javascript deaktiviert oder Dir steht\
                            kein Internet zur Verfuegung.') + '\
                        </li>\
                    </ul>\
                </div>\
            </div>'),
            E('h2', {}, _('Spendenaufruf')),
            E('<div class="row">\
                <div class="span6" id="funds">\
                    <ul>\
                        <li>\
                            ' + _('Informationen zu Spenden werden geladen. Falls nicht, hast Du entweder Javascript deaktiviert\
                            oder Dir steht kein Internet zur Verfuegung.') + '\
                        </li>\
                    </ul>\
                </div>\
            </div>'),
            E('script', { 'type': 'application/javascript', 'src': '/luci-static/resources/weimarnetz/infopage-functions.js' }, []),
            E('script', { 'type': 'text/javascript' }, ['\
            function loadFbNews(data) {\
                setTimeout(() => loadNews(data, "newslist"), 500);\
            }\
            \
            function loadMlNews(data) {\
                setTimeout(() => loadNews(data, "mailinglist"), 500);\
            }\
            \
            function loadLogo(data) {\
                setTimeout(() => {\
                    var logo = data.query.pages;\
                    var length = Object.keys(logo).length;\
                    if (logo["-1"] == undefined && length == 1) {\
                        for (id in logo) {\
                            myLogo = logo[id]["imageinfo"][0]["url"];\
                            document.getElementById("logo").src = myLogo;\
                        }\
                    }\
                }, 500);\
            }\
            \
            function loadFunds(data) {\
                setTimeout(() => {\
                    var funds = data.parse.text["*"];\
                    funds = removeHeadlines(funds);\
                    funds = removeSpan(funds);\
                    funds = removeLinks(funds);\
                    funds = removeComments(funds);\
                    document.getElementById("funds").innerHTML = funds;\
                }, 500);\
            }']),
            E('script', { 'type': 'application/javascript', 'src': 'https://weimarnetz.de/inc/feed/feed.php?items=6&source=fbweimarnetz&format=json&callback=loadFbNews' }, []),
            E('script', { 'type': 'application/javascript', 'src': 'https://weimarnetz.de/inc/feed/feed.php?items=6&source=mlweimarnetz&format=json&callback=loadMlNews' }, []),
            E('script', { 'type': 'application/javascript', 'src': 'https://wireless.subsignal.org/api.php?format=json&action=parse&page=Vorlage:Spendenaufruf&prop=text&callback=loadFunds' }, []),
            E('script', { 'type': 'application/javascript', 'src': 'https://wireless.subsignal.org/api.php?format=json&action=query&titles=Datei:Node' + nodenumber + '.jpg&prop=imageinfo&iiprop=url&redirects&callback=loadLogo' }, [])
        ]);
    }
});