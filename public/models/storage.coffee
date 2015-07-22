# Web Storage abstraction. Currently uses localStorage.
class Storage
  _(@::).extend Backbone.Events

  constructor: (name) ->
    @prefix = "epages-shop-#{name}-"
    @testToken = "#{@prefix}storage-test"

    @storage = @_localStorage()
    @_subscribeToStorageEvents() if @storage

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
    "#{@prefix}#{key}"

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
      if _eventIsOurs(event) and not _eventIsFeatureDetection(event)
        @trigger "update", event

  _eventIsOurs: (event) ->
    event.key.indexOf(@prefix) is 0

  _eventIsFeatureDetection: (event) ->
    event.key is @testToken
