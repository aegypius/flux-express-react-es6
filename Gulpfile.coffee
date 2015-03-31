gulp       = require "gulp"
babel      = require "gulp-babel"
babel      = require "gulp-babel"
less       = require "gulp-less"
liveServer = require "gulp-live-server"
browserify = require "browserify"
uglify     = require "gulp-uglify"
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
transform  = require "vinyl-transform"
babelify   = require "babelify"
reactify   = require "reactify"

gulp.task "clean", (done)->
  del ["lib", "public"], done

gulp.task "build:lib", (done)->
  gulp.src [
      "src/**/*.js"
      "src/**/*.jsx"
    ]
    .pipe changed "lib", extension: '.js'
    .pipe debug title: "compiling ES6"
    .pipe sourcemaps.init()
    .pipe babel()
    .pipe rename extname: '.js'
    .pipe sourcemaps.write()
    .pipe gulp.dest('lib'), done

gulp.task "build:app.js", ["build:lib"], (done)->
  gulp.src [
      "lib/client.js"
      "lib/components/**/*.js"
    ]
    .pipe changed 'public'
    .pipe debug title: "compiling app.js"
    .pipe sourcemaps.init loadMaps: true
    .pipe transform (filename) ->
      browserify({entries: filename, debug: true}).bundle()
    .pipe concat "app.js"
    .pipe sourcemaps.write()
    .pipe gulp.dest 'public', done

gulp.task "build:app.css", (done)->
  gulp.src "src/**/*.less"
    .pipe changed 'public', extension: '.css'
    .pipe debug title: "compiling styles"
    .pipe sourcemaps.init()
    .pipe less(), util.log
    .pipe concat 'app.css'
    .pipe cssc()
    .pipe sourcemaps.write()
    .pipe gulp.dest('public'), done

gulp.task "build", ["build:lib", "build:app.css", "build:app.js"], (done)->
  done()

gulp.task "serve", ["build"], (done)->
  server = liveServer.new "./index"

  gulp.watch "src/**/*.js",   ["build:lib"]
  gulp.watch "src/**/*.jsx",  ["build:app.js"]
  gulp.watch "src/**/*.less", ["build:app.css"]

  gulp.watch [
    "public/app.css"
    "public/app.js"
    "public/**/*.html"
  ], server.notify

  gulp.watch "lib/**.js", server.start
  server.start(done)

gulp.task "default", (done)->
  gulp.start "serve", done
