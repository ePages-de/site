"use strict";

// A static file server for the SITe widget.
//
// Running on Heroku at:
//   https://site-prototype.herokuapp.com

var port = process.env.PORT || 4566;

var connect = require("connect"),
    serveStatic = require("serve-static"),
    cors = require('cors'),
    app = connect();

app.use(cors());

app.use(serveStatic(__dirname + '/public'));

app.listen(port, function() {
  console.log("Static server is running on port " + port);
});
