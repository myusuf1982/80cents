"use strict"

# -- DEPENDENCIES --------------------------------------------------------------
gulp    = require 'gulp'
coffee  = require 'gulp-coffee'
concat  = require 'gulp-concat'
flatten = require 'gulp-flatten'
header  = require 'gulp-header'
uglify  = require 'gulp-uglify'
gutil   = require 'gulp-util'
stylus  = require 'gulp-stylus'
yml     = require 'gulp-yml'
pkg     = require './package.json'

# -- FILES ---------------------------------------------------------------------
assets = 'www/assets/'
source =
  coffee: 'source/**/*.coffee'
  styl  : 'source/**/*.styl'
  yml   : 'source/**/*.yml'

www =
  coffee    : [ 'source/site/app.coffee'
                'source/app.proxy.coffee'
                'source/site/app.*.coffee'
                'source/site/entity/*.coffee'
                'source/site/atom/*.coffee'
                'source/site/molecule/*.coffee'
                'source/site/organism/*.coffee']
  styl      : [ 'bower_components/stylmethods/vendor.styl'
                'source/site/style/constants.styl'
                # FLEXO
                'source/site/style/flexo/flexo.styl'
                'source/site/style/flexo/flexo.page.styl'
                'source/site/style/flexo/flexo.page.*.styl']
  thirds    :
    js      : [ 'bower_components/jquery/dist/jquery.min.js'
                'bower_components/hope/hope.js']
    css     : [ 'bower_components/flexo/dist/flexo.layout.css']

admin =
  coffee    : [ 'source/admin/app.coffee'
                'source/app.proxy.coffee'
                'source/admin/app.*.coffee'
                'source/admin/entity/*.coffee'
                'source/admin/atom/*.coffee'
                'source/admin/molecule/*.coffee'
                'source/admin/organism/*.coffee']
  styl      : [ 'bower_components/stylmethods/vendor.styl'
                'source/admin/style/constants.styl'
                # ATOMS
                'source/admin/style/atoms/*.styl'
                'bower_components/atoms-icons/atoms.icons.styl'
                # FLEXO
                'source/admin/style/flexo/flexo.styl'
                'source/admin/style/flexo/flexo.page.styl'
                'source/admin/style/flexo/flexo.page.*.styl']
  yml       : [ 'source/admin/organism/*.yml']

  thirds    :
    js      : [ 'bower_components/jquery/dist/jquery.min.js'
                'bower_components/hope/hope.js'
                'bower_components/atoms/atoms.standalone.js'
                'bower_components/atoms/atoms.app.js'
                'bower_components/moment/min/moment.min.js'
                'bower_components/wysihtml5/dist/wysihtml5-0.3.0.min.js']

    css     : [ 'bower_components/flexo/dist/flexo.layout.css'
                'bower_components/atoms/atoms.app.css']

banner = [
  '/**'
  ' * <%= pkg.name %> - <%= pkg.description %>'
  ' * @version v<%= pkg.version %>'
  ' * @link    <%= pkg.homepage %>'
  ' * @author  <%= pkg.author.name %> (<%= pkg.author.site %>)'
  ' * @license <%= pkg.license %>'
  ' */'
  ''].join('\n')

# -- TASKS ---------------------------------------------------------------------
gulp.task 'thirds', ->
  gulp.src(www.thirds.js)
    .pipe(concat(pkg.name + '.dependencies.js'))
    .pipe(gulp.dest(assets + '/js'))
  gulp.src(www.thirds.css)
    .pipe(concat(pkg.name + '.dependencies.css'))
    .pipe(gulp.dest(assets + '/css'))
  gulp.src(admin.thirds.js)
    .pipe(concat(pkg.name + '.admin.dependencies.js'))
    .pipe(gulp.dest(assets + '/js'))
  gulp.src(admin.thirds.css)
    .pipe(concat(pkg.name + '.admin.dependencies.css'))
    .pipe(gulp.dest(assets + '/css'))

gulp.task 'coffee', ->
  gulp.src(www.coffee)
    .pipe(concat(pkg.name + '.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/js'))
  gulp.src(admin.coffee)
    .pipe(concat(pkg.name + '.admin.coffee'))
    .pipe(coffee().on('error', gutil.log))
    .pipe(uglify({mangle: false}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/js'))

gulp.task 'styl', ->
  gulp.src(www.styl)
    .pipe(concat(pkg.name + '.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/css'))
  gulp.src(admin.styl)
    .pipe(concat(pkg.name + '.admin.styl'))
    .pipe(stylus({compress: true, errors: true}))
    .pipe(header(banner, {pkg: pkg}))
    .pipe(gulp.dest(assets + '/css'))

gulp.task 'yml', ->
  gulp.src(admin.yml)
    .pipe(yml().on('error', gutil.log))
    .pipe(gulp.dest(assets + '/scaffold'))

gulp.task 'init', ->
  gulp.run(['thirds', 'coffee', 'styl', 'yml'])

gulp.task 'default', ->
  gulp.watch(source.coffee, ['coffee'])
  gulp.watch(source.styl, ['styl'])
  gulp.watch(source.yml, ['yml'])
