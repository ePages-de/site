(function(window, document, undefined) {

// Store original globals.
var originals = {
	jQuery:    window.jQuery,
	$:         window.$,
	_:         window._,
	Backbone:  window.Backbone,
	picoModal: window.picoModal
};

<%= contents %>

// Define local variables.
var jQuery    = window.jQuery,
	$         = window.$,
	_ 		  = window._,
	Backbone  = window.Backbone.noConflict(),
	picoModal = window.picoModal;

// Reset globals to their original values.
window.jQuery    = originals.jQuery;
window.$         = originals.$;
window._ 		 = originals._;
window.picoModal = originals.picoModal;