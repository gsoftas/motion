//////////////////////////////////////////////////
// Gulp Dependancies & variables
//////////////////////////////////////////////////

const gulp = require('gulp');
const { exec } = require('child_process');
const purgecss = require('gulp-purgecss');
const responsive = require('gulp-responsive');
const imagemin = require('gulp-imagemin');
const gutil = require('gulp-util');
const autoprefixer = require('gulp-autoprefixer');

const imgDest = 'build/images'

//////////////////////////////////////////////////
// Gulp Task Definitions
//////////////////////////////////////////////////

gulp.task('responsive-image-handling', function () {
  gutil.log("--- Creating Responsive Images ---")

  return gulp.src('source/images/**/*.{jpg,png}', !'source/images/**/*-thumbnail.{jpg,jpeg}')
    .pipe(responsive({

      // Resize all JPG images to three different sizes: 400, 800, and 1280 and thumbnail 
      '**/*': [{
        width: 400,
        rename: { suffix: '-400px'}
      }, {
        width: 800,
        rename: { suffix: '-800px' },
      }, {
        width: 1200,
        rename: { suffix: '-1200px' },
      },
      {
        width: 640, 
        rename: { suffix: '-thumbnail' }
      },
      {
        // Compress, strip metadata, and rename original image
        rename: { suffix: '' },
      }],
    }, {
      // Global configuration for all images
      // The output quality for JPEG, WebP and TIFF output formats
      quality: 80,
      // Use progressive (interlace) scan for JPEG and PNG output
      progressive: true,
      // Strip all metadata
      withMetadata: false,
      errorOnEnlargement: false, 
      withoutEnlargement: false // Enlarge images if they are smaller than expected
    }))
    .pipe(gulp.dest( imgDest ))
    .on('error', gutil.log)
});

// Builds Middleman 

gulp.task('middleman-build', function(done) {
 gutil.log("--- Starting the Middleman Build process ---")
  
 return exec('bundle exec middleman build --clean');
  
});

// Clears unused CSS selectors. All selectors used in the React 
// files are whitelisted so they will not be purged

gulp.task('purgecss', function() {
  gutil.log("--- Purging Unused CSS ---")

  return gulp
    .src('build/stylesheets/site.css')
    .pipe(
      purgecss({
        content: ['build/**/*.html'],
        whitelist: [
          'search', 'search-box', 'has-text-centered', 
          'has-text-grey', 'strike', 'is-size-6', 
          'search-result-item', 'search-result-thumbnail', 'search-result-content', 
          'search-result-title', 'search-result-meta',
          'search-result-meta-date', 'search-result-summary',
          'search-result-content', 'search-result-content-title'
        ],       
        whitelistPatterns: [
          /search/, /search-/, /active/, 
          /has-addons/, /field/, /input/, 
          /error-messages/, /is-success/, 
          /message/, /is-size-6/
        ]
      })
    )
    .pipe(gulp.dest('build/stylesheets/'))
    .on('error', gutil.log)
});

// Autoprefixes CSS 

gulp.task('autoprefix', function(){
  gutil.log("--- Prefixing CSS ---")
  return gulp.src('build/stylesheets/site.css')
    .pipe(autoprefixer({
        browsers: ['last 2 versions'],
        cascade: false
    }))
    .pipe(gulp.dest('build/stylesheets'))
    .on('error', gutil.log)
});

// Image Optimization

gulp.task('image-optim', function(){
  gutil.log("--- Optimizating Images ---")

  return gulp
    .src('build/images/**/*.{jpg,png}')
    .pipe(imagemin(
      {
        verbose: true
      })
    )
    .pipe(gulp.dest( imgDest ))
    .on('error', gutil.log)
});

//////////////////////////////////////////////////
// Gulp Task Sequences
//////////////////////////////////////////////////

// Build Task. Bootstraps all necessary tasks.

gulp.task('build', gulp.series('middleman-build', 'responsive-image-handling', 'image-optim', 'autoprefix', 'purgecss'));


