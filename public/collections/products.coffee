class Products extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId, @categoryId } = options

  model: Product

  url: ->
    url = "#{App.apiUrl}/shops/#{@shopId}/products?resultsPerPage=12"
    if @categoryId
      url += "&categoryId=#{@categoryId}"
    url

  parse: (response) ->
    response.items
