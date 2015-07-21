module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [ 'jasmine' ]
    files: [
      'public/vendor/zepto-1.1.4.js'
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
      'Chrome'
    ]
    singleRun: false
