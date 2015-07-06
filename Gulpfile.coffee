gulp   = require("gulp")
util   = require("gulp-util")
wrap   = require("gulp-wrap")
concat = require("gulp-concat")
coffee = require("gulp-coffee")
series = require("stream-series")

env = process.env.NODE_ENV or "development"

dependencies =
  zepto:      "1.1.6"
  underscore: "1.8.3"
  backbone:   "1.2.1"

path =
  public:       "public/"
  models:       "public/models/"
  collections:  "public/collections/"
  views:        "public/views/"
  vendor:       "public/vendor/"
  wrapper:      "public/wrapper/"

vendorPath = (name) ->
  version = dependencies[name]
  min = if env == "production" then ".min" else ""
  path.vendor + name + "-" + version + min + ".js"

gulp.task "build", ->
  zepto =
    gulp.src(vendorPath("zepto"))
        .pipe(wrap(src: path.wrapper + "zepto.js"))

  underscore =
    gulp.src(vendorPath("underscore"))
#        .pipe(wrap(src: path.wrapper + "underscore.js"))

  backbone =
    gulp.src(vendorPath("backbone"))

  models =
    gulp.src(path.models + "*.coffee")
        .pipe(coffee(bare: true).on("error", util.log))

  collections =
    gulp.src(path.collections + "*.coffee")
        .pipe(coffee(bare: true).on("error", util.log))

  views =
    gulp.src(path.views + "*.coffee")
        .pipe(coffee(bare: true).on("error", util.log))

  app =
    gulp.src(path.public + "app.coffee")
    .pipe(coffee(bare: true).on("error", util.log))

  series(zepto, underscore, backbone, models, collections, views, app)
    .pipe(concat("site.js"))
    .pipe(wrap(src: path.wrapper + "iife.js"))
    .pipe(gulp.dest(path.public))

gulp.task "watch", ["build"], ->
  gulp.watch path.wrapper + "*.js", ["build"]
  gulp.watch path.public + "app.coffee", ["build"]
