var Replay = require("Replay"),
    httpProxy = require("http-proxy");

Replay.headers.push(/^Access-Control-Allow-Origin/);

httpProxy.createProxyServer({
    target: "https://developer.epages.com"
  , changeOrigin: true
}).listen(4322);
