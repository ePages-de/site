# Sends commands to subscribers across multiple windows
# via the `Storage` class.
class Commands

  constructor: ->
    @subscriptions = []
    @storage = new Storage("commands")
    @storage.on "update", @_dispatchCommand

  subscribe: (command, callback) ->
    @subscriptions.push
      command: command
      callback: callback

  notify: (command) ->
    subscriptions = _.where @subscriptions, command: command
    for subscription in subscriptions
      subscription.callback(command)

  send: (action) ->
    randomValue = new Date().getTime()
    @storage.set action, randomValue

  _dispatchCommand: (event) =>
    command = event.key.replace(@storage.prefix, "")
    @notify command
