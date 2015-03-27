gulp       = require "gulp"
babel      = require "gulp-babel"
less       = require "gulp-less"
liveServer = require "gulp-live-server"
browserify = require "gulp-browserify"
sourcemaps = require "gulp-sourcemaps"
changed    = require "gulp-changed"
concat     = require "gulp-concat"
cssc       = require "gulp-css-condense"
concat     = require "gulp-concat"
rename     = require "gulp-rename"
debug      = require "gulp-debug"
util       = require "gulp-util"
del        = require "del"
path       = require "path"

gulp.task "clean", (done)->
  del ["lib", "public"], done

gulp.task "build:es6", (done)->
  gulp.src "src/**/*.js"
    .pipe changed "lib"
    .pipe(debug({title: "compiling ES6"}))
    .pipe sourcemaps.init()
    .pipe concat "index.js"
    .pipe babel()
    .pipe(sourcemaps.write('maps'))
    .pipe(gulp.dest('lib'), done)

gulp.task "build:less", (done)->
  gulp.src "src/**/*.less"
    .pipe(changed('public', extension: '.css'))
    .pipe(debug({title: "compiling styles"}))
    .pipe(sourcemaps.init())
    .pipe(less(), util.log)
    .pipe(sourcemaps.write('maps'))
    .pipe(gulp.dest('public'), done)

gulp.task "build", ["build:less", "build:es6"], (done)->
  done()

gulp.task "bundle:styles", ["build:less"], (done)->
  gulp.src [
      "public/**/*.css"
      "!public/app*.css"
    ]
    .pipe(sourcemaps.init())
    .pipe(debug({title: "bundling styles"}))
    .pipe(concat('app.min.css'))
    .pipe(cssc())
    .pipe(sourcemaps.write('maps'))
    .pipe(gulp.dest('public'), done)

gulp.task "bundle:scripts", (done)->
  done()

gulp.task "bundle", ["bundle:styles", "bundle:scripts"]

gulp.task "serve", ["build:es6", "bundle"], (done)->
  server = liveServer.new "./index"

  gulp.watch "src/**/*.js",   ["bundle:scripts"]
  gulp.watch "src/**/*.less", ["bundle:styles"]
  gulp.watch [
    "public/app.min.css"
    "public/**/*.js"
    "public/**/*.html"
  ], server.notify

  gulp.watch "lib/index.js", server.start
  server.start(done)

gulp.task "default", (done)->
  gulp.start "serve", done
