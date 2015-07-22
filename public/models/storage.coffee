class Storage
  _(@::).extend Backbone.Events

  constructor: (@name) ->
    @storage = @_localStorage()
    @_subscribeToStorageEvents() if @storage

  prefix: "epages-shop"

  testToken: "#{@::prefix}-storage-test"

  set: (key, value) ->
    return unless @storage
    @storage.setItem @key(key), JSON.stringify(value)

  get: (key) ->
    return unless @storage
    JSON.parse( @storage.getItem @key(key) )

  remove: (key) ->
    return unless @storage
    @storage.removeItem @key(key)

  key: (key) ->
    "#{@prefix}-#{@name}-#{key}"

  # Returns localStorage if it’s supported by the browser.
  # Feature detection by: http://is.gd/modernizer_localstorage
  _localStorage: ->
    try
      localStorage.setItem @testToken, @testToken
      localStorage.removeItem @testToken
      localStorage
    catch

  _subscribeToStorageEvents: ->
    $(window).on "storage", (event) =>
      unless event.key is @testToken
        @trigger "update", event
