var gulp = require('gulp');
var wpPot = require('gulp-wp-pot');
var gulpMinify = require('gulp-minify');

function pot () {
    return gulp.src('plugin/*.php')
        .pipe(wpPot({
            domain: 'wordpress-plugin-starter',
            package: 'WordPress Plugin Starter'
        }))
        .pipe(gulp.dest('plugin/languages/wordpress-plugin-starter.pot'));
}

function minify () {

    return gulp.src(['plugin/scripts/*.js'])
        .pipe(gulpMinify({
            ignoreFiles: ['*-min.js']
        }))
        .pipe(gulp.dest('plugin/scripts'));

}

exports.minify = minify;
exports.pot = pot;
exports.default = gulp.parallel(pot, minify);
