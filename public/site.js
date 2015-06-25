"use strict";

// Minimal bootloader for the SITe widget.

(function(window, document, undefined) {

  var Loader = function() {};
  Loader.prototype = {
    require: function(scripts, callback) {
      this.loadCount  = 0;
      this.totalCount = scripts.length;
      this.callback   = callback;

      var target = document.getElementsByTagName("script")[0];

      for (var i = 0; i < scripts.length; i++) {
        this.writeScript(scripts[i], target);
      }
    },

    loaded: function() {
      this.loadCount++;

      if (this.loadCount == this.totalCount && typeof this.callback == "function") {
        this.callback.call();
      }
    },

    writeScript: function(src, target) {
      var self = this,
          loaded = false,
          state;

      var tag = document.createElement("script");
      tag.src = src;

      tag.onload = tag.onreadystatechange = function() {
        if (!loaded && (!(state = this.readyState) || state === "loaded" || state === "complete")) {
          loaded = true;
          self.loaded();
        }
      };

      target.parentNode.insertBefore(tag, target);
    }
  };


  function onLoad() {

    function onReady() {
      console.log('all scripts loaded');
      console.log(Backbone);
      console.log(jQuery);
      console.log(_);
    }

    // TODO: figure out whether we’re running on localhost or heroku.
    // var baseURL = "https://site-prototype.herokuapp.com";
    var baseURL = "http://localhost:4566";

    // TODO: check whether compatible libraries are already loaded on the client page.
    var loader = new Loader();
    loader.require(
      [
        baseURL + "/vendor/underscore-1.8.3.js",
        baseURL + "/vendor/jquery-1.11.3.js",
        baseURL + "/vendor/backbone-1.2.1.js",
        baseURL + "/app.js",
      ],
      onReady
    );

  }

  if (window.addEventListener) { window.addEventListener("load", onLoad, false); }
  else if (window.attachEvent) { window.attachEvent("onload", onLoad); }

}(window, document));
