gulp   = require("gulp")
util   = require("gulp-util")
wrap   = require("gulp-wrap")
concat = require("gulp-concat")
coffee = require("gulp-coffee")
merge  = require("merge-stream")

env = process.env.NODE_ENV or "development"

dependencies =
  reqwest: "1.1.5"
  underscore: "1.8.3"

vendorPath = (name) ->
  version = dependencies[name]
  min = if env == "production" then ".min" else ""
  "public/vendor/" + name + "-" + version + min + ".js"

wrapperPath = (name) ->
  "public/wrapper/" + name + ".js"

gulp.task "build", ->
  reqwest =
    gulp.src(vendorPath("reqwest"))
        .pipe(wrap(src: wrapperPath("reqwest")))

  underscore =
    gulp.src(vendorPath("underscore"))
        .pipe(wrap(src: wrapperPath("underscore")))

  app =
    gulp.src("public/app.coffee")
    .pipe(coffee(bare: true).on("error", util.log))

  merge(reqwest, underscore, app)
    .pipe(concat("site.js"))
    .pipe(wrap(src: wrapperPath("iife")))
    .pipe(gulp.dest("public"))

gulp.task "watch", ["build"], ->
  gulp.watch "public/wrapper/*.js", ["build"]
  gulp.watch "public/app.coffee", ["build"]
