class Products extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId, @staticCategoryId, @productIds } = options
    @sort = @direction = @query = @selectedCategoryId = null

  model: Product

  url: ->
    url = "#{App.apiUrl}/shops/#{@shopId}/products?resultsPerPage=12"
    if @staticCategoryId
      url += "&categoryId=#{@staticCategoryId}"
    else if @selectedCategoryId
      url += "&categoryId=#{@selectedCategoryId}"

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
