class Products extends Backbone.Collection
  initialize: (models, options) ->
    { @shopId } = options

  model: Product

  url: ->
    "http://crossorigin.me/https://developer.epages.com/api/shops/#{@shopId}/products?resultsPerPage=9"

  parse: (response) ->
    response.items
