"use strict";

// Minimal bootloader for the SITe widget.

(function(window, document, undefined) {

  var Loader = function() {};
  Loader.prototype = {
    require: function(scripts, callback) {
      this.loadCount  = 0;
      this.totalCount = 0;
      this.callback   = callback;

      var target = document.getElementsByTagName("script")[0];

      for (var i = 0; i < scripts.length; i++) {
        var script = scripts[i];

        if (!script.unless || !script.unless()) {
          this.totalCount++;
          this.writeScript(script.url, target);
        }
      }

      if (this.totalCount === 0 && typeof this.callback == "function") {
        this.callback();
      }
    },

    loaded: function() {
      this.loadCount++;

      if (this.loadCount == this.totalCount && typeof this.callback == "function") {
        this.callback();
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
    var baseURL;
    if (window.location.hostname.match(/localhost|127\.0\.0\.1|0\.0\.0\.0/)) {
      baseURL = "http://localhost:4566";
    } else {
      baseURL = "https://site-prototype.herokuapp.com";
    }

    var loader = new Loader();
    loader.require(
      [
        {
          url: baseURL + "/vendor/underscore-1.8.3.js",
          unless: function() {
            return window._ && window._.VERSION.match(new RegExp("^1."));
          }
        },
        {
          url: baseURL + "/vendor/jquery-1.11.3.js",
          unless: function() {
            return window.jQuery && window.jQuery.fn.jquery.match(new RegExp("^1."));
          }
        },
        {
          url: baseURL + "/vendor/backbone-1.2.1.js",
          unless: function() {
            return window.Backbone && window.Backbone.VERSION.match(new RegExp("^1."));
          }
        }
      ],
      function() {
        loader.require([{ url: baseURL + "/app.js" }]);
      }
    );
  }

  if (window.addEventListener) { window.addEventListener("load", onLoad, false); }
  else if (window.attachEvent) { window.attachEvent("onload", onLoad); }

}(window, document));
