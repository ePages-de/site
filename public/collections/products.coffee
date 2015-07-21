class Products extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId, @categoryId, @productIds } = options
    @sort = @direction = null

  model: Product

  url: ->
    url = "#{App.apiUrl}/shops/#{@shopId}/products?resultsPerPage=12"
    if @categoryId
      url += "&categoryId=#{@categoryId}"
    if @productIds?.length > 0
      url += _.map @productIds, (productId) ->
        "&id=#{productId}"
      .join ""
    if @query
      url += "&q=" + @query
    if @sort
      url += "&sort=" + @sort
    if @direction
      url += "&direction=" + @direction
    url

  parse: (response) ->
    response.items
