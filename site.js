"use strict";

var _eps = _eps || {},
    corsApiUrl = "http://localhost:4567/";

if( undefined === _eps.shopId) {
  throw "_eps.shopId not defined";
}

(function(window, document, version, callback) {
  var j, d;
  var loaded = false;
  if (!(j = window.jQuery) || j.fn.jquery.match(new RegExp("^" + version)) || callback(j, loaded)) {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src = "https://code.jquery.com/jquery-2.1.4.min.js";
    script.onload = script.onreadystatechange = function() {
      if (!loaded && (!(d = this.readyState) || d === "loaded" || d === "complete")) {
        callback((j = window.jQuery).noConflict(1), loaded = true);
        j(script).remove();
      }
    };
    (document.getElementsByTagName("head")[0] || document.documentElement).appendChild(script);
  }
})(window, document, "2.1", function($) {
  console.log("jQuery version " + $.fn.jquery);

  $("#api").submit( function(e) {
    e.preventDefault();
    var url = corsApiUrl + "//developer.epages.com/api/shops/" + _eps.shopId + "/" + $("#apiCall").val();
    console.log("Attempting to fetch " + url);
    $.getJSON(url, function(result) {
      console.log("Successfully fetched " + url);
      $("#result").html(JSON.stringify(result, null, 2));
    });
  });
});
