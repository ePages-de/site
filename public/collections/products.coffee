class Products extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId, @staticCategoryId, @productIds, @resultsPerPage } = options
    @sort = @direction = @query = @selectedCategoryId = null
    @page = @pages = 1

    @getShippingUrl()

  model: Product

  url: ->
    url = "#{App.apiUrl}/shops/#{@shopId}/products?resultsPerPage=#{@resultsPerPage}"
    if @page
      url += "&page=" + @page

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

  shippingUrl: ->
    "#{App.apiUrl}/shops/#{@shopId}/categories"

  parse: (response) ->
    @pages = Math.ceil(response.results / response.resultsPerPage)
    response.items

  getShippingUrl: ->
    $.getJSON @shippingUrl()
      .done (response) =>
        @shippingUrl = response[0].sfUrl + "/Shipping"