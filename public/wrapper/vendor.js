(function(window, document, undefined) {

// Store original globals.
var originals = {
	_:         window._,
	Backbone:  window.Backbone,
	picoModal: window.picoModal
};

<%= contents %>

// Define local variables.
var _ 		  = window._,
	Backbone  = window.Backbone.noConflict(),
	picoModal = window.picoModal;

// Reset globals to their original values.
window._ 		 = originals._;
window.picoModal = originals.picoModal;