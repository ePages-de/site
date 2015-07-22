class Actions
  _(@::).extend Backbone.Events

  constructor: (name) ->
    @storage = new Storage("actions")
    @storage.on "update", (event) =>
      action = event.key.replace(@storage.prefix, "")
      @trigger "action", action

  send: (action) ->
    randomValue = new Date().getTime()
    @storage.set action, randomValue
