class CartLineItem extends Backbone.Model

  initialize: (attributes, options) ->
    { @shopId, @cartId } = options

  idAttribute: "lineItemId"

  url: ->
    url = "https://developer.epages.com/api/shops/#{@shopId}/carts/#{@cartId}/line-items"
    unless @isNew()
      url += "/#{@id}"
    url

  parse: (response) ->
    lineItems = response.lineItemContainer.productLineItems
    _.findWhere lineItems, productId: @get("productId")

  name: ->
    @get("name")

  thumbnailImage: ->
    _.findWhere(@get("images"), classifier: "Thumbnail").url

  quantity: ->
    @get("quantity").amount

  unit: ->
    @get("quantity").unit

  singleItemPrice: ->
    @get("singleItemPrice").formatted

  lineItemPrice: ->
    @get("lineItemPrice").formatted
