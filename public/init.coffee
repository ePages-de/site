$.ajaxSettings.accepts.json = null # required to work with the epages API
# TODO remove this before going live
$.ajaxSettings.headers = {
  "Authorization": "Bearer M0mPgTiGPtw5LkdCGwhel3gcGc5PqIPF",
  "Accept": "application/vnd.epages.v1+json"
}

App.start()
