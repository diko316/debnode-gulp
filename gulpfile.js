'use strict';

var _ = require('lodash');
var gulp = require('gulp');
var watch = require('gulp-watch');
var concat = require('gulp-concat');
var browserify = require('browserify');
var source = require('vinyl-source-stream');
var bowerResolve = require('bower-resolve');
var browserSync = require('browser-sync').create();
var nodeResolve = require('resolve');

////////////////////////////////////////////////////
//  HELPERS
////////////////////////////////////////////////////
function eachBowerComponents(callback) {
    var fs = require('fs'),
        resolve = bowerResolve,
        basedir = './bower_components',
        files = fs.readdirSync(basedir),
        found = [],
        fl = 0;
    var c, l, id;
    
    for (c = -1, l = files.length; l--;) {
        id = files[++c];
        if (fs.statSync(basedir + '/' + id).isDirectory()) {
            found[fl++] = id;
            callback(id, resolve.fastReadSync(id));
        }
    }
    return found;
}

////////////////////////////////////////////////////
//  JS SCRIPT BUILDS
////////////////////////////////////////////////////
gulp.task('build-vendor-scripts',
    function () {
        var b = browserify();
        eachBowerComponents(
            function (id, resolved) {
                b.require(resolved, {expose: id});
            });
        b.transform('debowerify');
        return b.bundle().
                pipe(source('vendor.js')).
                pipe(gulp.dest('./public/js'));
    });

gulp.task('build-app-scripts',
    function () {
        var b = browserify(['./src/app.js']);
        eachBowerComponents(
            function (id, resolved) {
                b.external(id);
            });
        return b.bundle().
                pipe(source('app.js')).
                pipe(gulp.dest('./public/js'));
    });

gulp.task('build', [
        'build-vendor-scripts',
        'build-app-scripts'
    ]);


////////////////////////////////////////////////////
//  MAIN TASKS
////////////////////////////////////////////////////
gulp.task('watch',
    function () {
        gulp.watch('./bower_components/**/*', ['build-vendor-scripts']);
        gulp.watch('./src/**/*', ['build-app-scripts']);
    });



gulp.task('run', [
        'build',
        'watch'
    ],
    function() {
        console.log("*** Starting browser-sync");
        browserSync.init({
            server: {
                baseDir: "./public"
            },
            port: 3000,
            ghostMode: false
        });
        
        console.log("*** Observing changes");
        
        // notify and reload
        gulp.watch('./public/**/*',
            function() {
                var bs = browserSync;
                if (bs.active) {
                    bs.notify("Content updated reloading browser!!");

                    // reload browser
                    setTimeout(function () {
                        bs.reload();
                    }, 1000);

                }
            });
    });




gulp.task('default', function () {
    console.log('for later!');
});
