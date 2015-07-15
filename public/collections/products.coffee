class Products extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId, @categoryId } = options

  model: Product

  url: ->
    url = "#{App.rootUrl}/shops/#{@shopId}/products?resultsPerPage=9"
    if @categoryId
      url += "&categoryId=#{@categoryId}"
    url

  parse: (response) ->
    response.items
