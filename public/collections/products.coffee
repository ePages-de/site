class Products extends Backbone.Collection

  initialize: (models, options) ->
    { @widget, @categoryId } = options

  model: Product

  url: ->
    url = "https://developer.epages.com/api/shops/#{@widget.shopId}/products?resultsPerPage=9"
    if @categoryId
      url += "&categoryId=#{@categoryId}"
    url

  parse: (response) ->
    response.items
