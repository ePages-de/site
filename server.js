// Config

var corsHost   = 'localhost',
    corsPort   = 4567,
    staticHost = 'localhost',
    staticPort = 8000;


// CORS proxy

var corsProxy = require('cors-anywhere');
corsProxy.createServer({
    removeHeaders: ['cookie', 'cookie2']
}).listen(corsPort, corsHost, function() {
    console.log('Running CORS proxy on http://' + corsHost + ':' + corsPort);
});


// Static index page

var http = require('http'),
    fs = require('fs');

fs.readFile('./index.html', function (err, html) {
  if (err) {
    throw err;
  }

  http.createServer(function(request, response) {
    response.writeHeader(200, { "Content-Type": "text/html" });
    response.write(html);
    response.end();
  }).listen(staticPort, staticHost, function() {
    console.log('Running static index page on http://' + staticHost + ':' + staticPort);
  });
});