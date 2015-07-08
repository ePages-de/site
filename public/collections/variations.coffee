class Variations extends Backbone.Collection

  initialize: (options) ->
    { @productId } = options

  model: Variation

  url: ->
    "https://developer.epages.com/api/shops/DemoShop/product/#{@productId}/variations"
