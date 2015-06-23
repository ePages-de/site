// Config
var corsHost = "localhost",
    corsPort = 4567,
    staticPort = 8000,
    connect = require("connect"),
    serveStatic = require("serve-static"),
    app = connect();

// CORS proxy
var corsProxy = require("cors-anywhere");
corsProxy.createServer({
  removeHeaders: ["cookie", "cookie2"]
}).listen(corsPort, corsHost, function() {
  console.log("Running CORS proxy on http://" + corsHost + ":" + corsPort);
});

// Static index page
app.use(serveStatic(__dirname, {"index": ["index.html"]}));
app.listen(staticPort, function() {
  console.log("Running serve-static on http://localhost:" + staticPort);
});
