class VariationAttribute extends Backbone.Model

  name: ->
    @get("name")

  selected: ->
    @get("selected")

  displayName: ->
    @get("displayName")

  values: ->
    @get("values")
