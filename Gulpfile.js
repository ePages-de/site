var gulp   = require("gulp"),
    util   = require("gulp-util"),
    wrap   = require("gulp-wrap"),
    concat = require("gulp-concat"),
    coffee = require("gulp-coffee"),
    merge  = require("merge-stream");


var env = process.env.NODE_ENV || "development";

var dependencies = {
  reqwest: "1.1.5",
  underscore: "1.8.3"
};

var path = {
  public: "public/",
  wrapper: "public/wrapper/"
}

function vendorPath(name) {
  var version = dependencies[name],
      min = env === "production" ? ".min" : "";

  return "public/vendor/" + name + "-" + version + min + ".js";
}

function wrapperPath(name) {
  return "public/wrapper/" + name + ".js";
}


gulp.task("build", function() {
  var reqwest =
    gulp.src(vendorPath("reqwest"))
        .pipe(wrap({ src: wrapperPath("reqwest") }));

  var underscore =
    gulp.src(vendorPath("underscore"))
        .pipe(wrap({ src: wrapperPath("underscore") }));

  var app =
    gulp.src("public/app.coffee")
        .pipe(coffee({ bare: true }).on("error", util.log));

  return merge(reqwest, underscore, app)
    .pipe(concat("site.js"))
    .pipe(wrap({ src: wrapperPath("iife") }))
    .pipe(gulp.dest("public"));
});

gulp.task("watch", ["build"], function() {
  gulp.watch("public/wrapper/*.js", ["build"]);
  gulp.watch("public/app.coffee", ["build"]);
});
