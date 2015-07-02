module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [ 'jasmine-jquery', 'jasmine' ]
    files: [
      'public/site.js'
      'spec/**/*.coffee'
    ]
    exclude: []
    preprocessors: {
      '**/*.coffee': ['coffee']
    }
    reporters: [ 'progress' ]
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    browsers: [
      'PhantomJS'
      'Chrome'
    ]
    singleRun: false
