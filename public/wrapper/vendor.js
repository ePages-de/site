(function(window, document, undefined) {

// Store original globals.
var originals = {
	Zepto:     window.Zepto,
	$:         window.$,
	_:         window._,
	Backbone:  window.Backbone,
	picoModal: window.picoModal
};

<%= contents %>

// Define local variables.
var Zepto   = window.Zepto,
	$         = window.$,
	_ 		    = window._,
	Backbone  = window.Backbone,
	picoModal = window.picoModal;

// Make sure Backbone uses our Zepto and not
// just any global jQuery/Zepto.
Backbone.$ = Zepto;

// Reset globals to their original values.
window.Zepto     = originals.Zepto;
window.$         = originals.$;
window._ 		     = originals._;
window.picoModal = originals.picoModal;
