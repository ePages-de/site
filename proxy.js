/*
 * using https://github.com/assaf/node-replay and https://github.com/nodejitsu/node-http-proxy
 * to proxy and replay requests to pm.epages.com
 */

var replay = require("replay"),
    httpProxy = require("http-proxy");

var port = 4322;

console.log("Starting node-replay proxy on port " + port);
console.log(replay.version);

httpProxy.createProxyServer({
    target: "https://pm.epages.com"
  , changeOrigin: true
}).listen(port);
