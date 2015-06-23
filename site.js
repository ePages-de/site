var _eps = _eps || {},
    corsApiUrl = "http://localhost:4567/",
    baseUrl = "developer.epages.com/api/shops/" + _eps.shopId + "/";

if( undefined === _eps.shopId) {
  throw "_eps.shopId not defined";
}

function doCORSRequest(options, printResult) {
    if (!options.data) { options.data = {}; }

    var x = new XMLHttpRequest();
    x.open(options.method, corsApiUrl + options.url);
    x.onload = x.onerror = function() {
        printResult(
            options.method + " " + options.url + "\n" +
            x.status + " " + x.statusText + "\n\n" +
            (x.responseText || "")
        );
    };
    if (/^POST/i.test(options.method)) {
        x.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
    }
    x.send(options.data);
}

function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
    results = regex.exec(location.search);
    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}

(function() {
    doCORSRequest({
        method: "GET",
        url: baseUrl + getParameterByName("url")
    }, function printResult(result) {
        console.log(result);
    });
})();
