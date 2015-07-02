var Browser = require('zombie');
var assert  = require('assert');

// Load the page from localhost
var browser = Browser.create();

browser.visit('http://localhost:4566/', function (error) {
  assert.ifError(error);
  browser.assert.success();
  browser.assert.text('p', 'OPEN YOUR CONSOLE');
  console.log(browser.resources.dump());
  browser.assert.text('.eps-site-widget', 'ASDF');
});
