/*
 * using https://github.com/assaf/node-replay and https://github.com/nodejitsu/node-http-proxy
 * to proxy and replay requests to developer.epages.com
 */

var Replay = require("Replay"),
    httpProxy = require("http-proxy");

var port = 4322;

console.log("Starting node-replay proxy on port " + port);
console.log(Replay.version);

httpProxy.createProxyServer({
    target: "https://developer.epages.com"
  , changeOrigin: true
}).listen(port);
