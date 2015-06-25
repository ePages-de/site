"use strict";

// Main application file for the SITe widget.

(function(window, document, undefined) {

  var containers = document.getElementsByClassName("eps-site-widget");

  for (var i = 0; i < containers.length; i++) {
    var container = containers[i];
    container.innerHTML = "<p>WIDGET</p>";
  }

}(window, document));
