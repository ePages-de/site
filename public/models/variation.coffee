class Variation extends Backbone.Model

  initialize: ->
    @set("selected", null)

  name: ->
    @get("name")

  displayName: ->
    @get("displayName")
