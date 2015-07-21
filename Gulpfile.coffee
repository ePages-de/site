gulp     = require("gulp")
util     = require("gulp-util")
wrap     = require("gulp-wrap")
concat   = require("gulp-concat")
coffee   = require("gulp-coffee")
uglify   = require("gulp-uglify")
series   = require("stream-series")
notifier = require("node-notifier")

# Set NODE_ENV=development for non-unglified JS.
env = process.env.NODE_ENV or "production"

path =
  public:       "public/"
  models:       "public/models/"
  collections:  "public/collections/"
  views:        "public/views/"
  vendor:       "public/vendor/"
  wrapper:      "public/wrapper/"


gulp.task "build", ->
  zepto      = gulp.src(path.vendor + "zepto-*.js")
  underscore = gulp.src(path.vendor + "underscore-*.js")
  backbone   = gulp.src(path.vendor + "backbone-*.js")
  picoModal  = gulp.src(path.vendor + "pico_modal-*.js")

  vendor = series(zepto, underscore, backbone, picoModal)
    .pipe(concat("site.js"))
    .pipe(wrap(src: path.wrapper + "vendor.js"))
    .on("error", util.log)

  app =
    gulp.src(path.public + "app.coffee")
        .pipe(coffee(bare: true))

  models =
    gulp.src(path.models + "*.coffee")
        .pipe(coffee(bare: true))

  collections =
    gulp.src(path.collections + "*.coffee")
        .pipe(coffee(bare: true))

  views =
    gulp.src(path.views + "*.coffee")
        .pipe(coffee(bare: true))

  init =
    gulp.src(path.public + "init.coffee")
    .pipe(wrap({ src: path.wrapper + "init.js" }, { env: env }, { variable: "data" }))
    .on("error", util.log)
    .pipe(coffee(bare: true))

  result = series(vendor, app, models, collections, views, init)
    .pipe(concat("site.js"))
    .pipe(wrap(src: path.wrapper + "app.js"))

  if env is "production"
    result = result.pipe(uglify())

  result.pipe(gulp.dest(path.public))


gulp.task "watch", ["build"], ->
  gulp.watch path.wrapper + "*.js", ["build"]
  gulp.watch path.vendor + "*.js", ["build"]
  gulp.watch path.public + "**/*.coffee", ["build"]


process.on "uncaughtException", (error) ->
  console.error(error)
  if typeof error is "object"
    notifier.notify
      message: "Error [#{error.plugin}] #{error.message}"
