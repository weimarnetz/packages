function removeLinks(text) {
    text = text.replace(/(<a([^>]+)>)/gi, "");
    return text.replace(/<\/a>/gi, "");
}

function removeSpan(text) {
    text = text.replace(/(<span.*\/span>)/gi, "");
    return text.replace(/<\/h.>/gi, "");
}

function removeHeadlines(text) {
    text = text.replace(/(<h([^>]+)>)/gi, "");
    return text.replace(/<\/h.>/gi, "");
}
function removeComments(text) {
    return text.replace(/(<\!--([^>]+)-->)/gi, "");
}

function loadNews(data, element) {
    var ul = document.getElementById(element);
    while (ul.hasChildNodes()) {
        ul.removeChild(ul.lastChild);
    }
    var nl = data.channel.item;
    for (var item in nl) {
        var entry = nl[item];
        var a = document.createElement("a");
        a.appendChild(document.createTextNode(entry.title));
        a.title = entry.title;
        a.href = entry.link;
        a.target = "_blank";
        var li = document.createElement("li");
        var pubDate = new Date(entry.pubDate);
        li.appendChild(document.createTextNode(pubDate.toLocaleDateString() + " - "));
        li.appendChild(a);
        ul.appendChild(li);
    }
    console.log(ul);
}

function loadLogo(data) {
    var logo = data.query.pages;
    var length = Object.keys(logo).length;
    if (logo["-1"] == undefined && length == 1) {
        for (id in logo) {
            myLogo = logo[id]['imageinfo'][0]['url'];
            console.log(myLogo);
            document.getElementById("logo").src = myLogo;
        }
    }
}
console.log(document.URL);