require('coffee-script');

var express = require('express');

var app = module.exports = express();

require('express-namespace');

var s3Config = {
  "bucket": "foo",
  "key": "key",
  "secret": "secret"
}

app.configure(function() {
  app.set('port', 1234);
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.favicon());
  app.use(app.router);
  app.use("/", express.static(__dirname + '/assets', { maxAge: 60*60*1000 }));
});

var MediaManager = require('./api/mediamanager');

app.mediaManager = new MediaManager(s3Config);

require('./api/upload')(app);

app.listen(app.settings.port);
console.info("Express server listening on port " + app.settings.port + " in " +
            app.settings.env + " mode");
