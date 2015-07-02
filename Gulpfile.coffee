gulp   = require("gulp")
util   = require("gulp-util")
wrap   = require("gulp-wrap")
concat = require("gulp-concat")
coffee = require("gulp-coffee")
series = require("stream-series")

env = process.env.NODE_ENV or "development"

dependencies =
  reqwest:    "1.1.5"
  underscore: "1.8.3"

path =
  public:  "public/"
  vendor:  "public/vendor/"
  wrapper: "public/wrapper/"

vendorPath = (name) ->
  version = dependencies[name]
  min = if env == "production" then ".min" else ""
  path.vendor + name + "-" + version + min + ".js"

gulp.task "build", ->
  reqwest =
    gulp.src(vendorPath("reqwest"))
        .pipe(wrap(src: path.wrapper + "reqwest.js"))

  underscore =
    gulp.src(vendorPath("underscore"))
        .pipe(wrap(src: path.wrapper + "underscore.js"))

  app =
    gulp.src(path.public + "app.coffee")
    .pipe(coffee(bare: true).on("error", util.log))

  series(reqwest, underscore, app)
    .pipe(concat("site.js"))
    .pipe(wrap(src: path.wrapper + "iife.js"))
    .pipe(gulp.dest(path.public))

gulp.task "watch", ["build"], ->
  gulp.watch path.wrapper + "*.js", ["build"]
  gulp.watch path.public + "app.coffee", ["build"]
