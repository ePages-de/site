"use strict";

// Minimal bootloader for the SITe widget.

(function(window, document, undefined) {

  function go() {
    var load = function(url, options) {
      var id = options.id,
          target = options.target;

      if (document.getElementById(id)) { return; }

      var scriptTag = document.createElement("script");
      scriptTag.async = true;
      scriptTag.src = url;
      scriptTag.id = id;

      target.parentNode.insertBefore(scriptTag, target);
    };

    var firstScriptTag = document.getElementsByTagName("script")[0];

    var baseURL = "https://site-prototype.herokuapp.com"

    load(baseURL + "/app.js", { id: "eps-site-app", target: firstScriptTag });
  }

  if (window.addEventListener) { window.addEventListener("load", go, false); }
  else if (window.attachEvent) { window.attachEvent("onload", go); }

}(window, document));
