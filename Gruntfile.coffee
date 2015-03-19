module.exports = (grunt) ->
  grunt.initConfig {
    coffee: {
      dist: {
        files: {
          'dist/angular-feedback.js': 'src/angular-feedback.coffee'
        }
      }
      test: {
        files: {
          'test/angular-feedback.js': 'src/angular-feedback.coffee'
          'test/specs.js': 'test/specs.coffee'
        }
      }
    }
    uglify: {
      options: {
        report: 'min'
      }
      default: {
        files: {
          'dist/angular-feedback.min.js': ['dist/angular-feedback.js']
        }
      }
    }
    jasmine: {
      src: ['test/angular-feedback.js']
      options: {
        specs: 'test/specs.js'
        vendor: ['lib/jquery.js','lib/angular.js','lib/angular-mocks.js']
      }
    }
  }

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-jasmine'

  grunt.registerTask 'dist', ['coffee:dist','uglify']
  grunt.registerTask 'test', ['coffee:test','jasmine']
