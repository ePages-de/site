module.exports = (config) ->
  config.set
    basePath: ''
    frameworks: [ 'jasmine' ]
    files: [
      'src/**/*.coffee'
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
    ]
    singleRun: false
