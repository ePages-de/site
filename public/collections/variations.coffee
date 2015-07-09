class Variations extends Backbone.Collection

  model: Variation

  parse: (response) ->
    response.variationAttributes
