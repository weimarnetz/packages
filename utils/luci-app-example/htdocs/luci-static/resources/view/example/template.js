function ubus_call(command, argument, params) {
    var request_data = {};
    request_data.jsonrpc = "2.0";
    request_data.method = "call";
    request_data.params = [data.ubus_rpc_session, command, argument, params]
    var request_json = JSON.stringify(request_data);
    var request = new XMLHttpRequest();
    request.open("POST", ubus_url, false);
    request.setRequestHeader("Content-type", "application/json");
    request.send(request_json);
    if (request.status === 200) {
        var response = JSON.parse(request.responseText)
        if (!("error" in response) && "result" in response) {
            if (response.result.length === 2) {
                return response.result[1];
            }
        } else {
            console.log("Failed query ubus!");
        }
    }
}

function renderExampleInfo(data) {
    var target = document.getElementById('luci-app-example');

    var title = document.createElement('h3');
    title.appendChild(document.createTextNode('Example Info'));
    target.appendChild(title);


    var listContainer = document.createElement('div');
    var list = document.createElement('ul');
    var sectionsContent = '\
        <li>First Option in first section: ' + data.values.first.first_option + '</li>\
        <li>Flag in second section: ' + data.values.second.flag + '</li>\
        <li>Select in second section: ' + data.values.second.select + '</li>\
        ';
    list.innerHTML = sectionsContent;
    listContainer.append(list);

    target.appendChild(listContainer);
}
