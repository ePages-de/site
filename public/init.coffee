$.ajaxSettings.accepts.json = null # required to work with the epages API

# TODO remove this before going live
$.ajaxSettings.headers =
  "Accept": "application/vnd.epages.v1+json"

App.start()
