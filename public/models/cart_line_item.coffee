class CartLineItem extends Backbone.Model

  idAttribute: "lineItemId"

  url: ->
    url = "#{App.apiUrl}/shops/#{@cart.shopId}/carts/#{@cart.id}/line-items"
    unless @isNew()
      url += "/#{@id}"
    url

  parse: (response) ->
    lineItems = response.lineItemContainer.productLineItems
    _.findWhere lineItems, productId: @get("productId")

  toJSON: ->
    productId: @get("productId")
    quantity: @get("quantity")

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

  productId: ->
    @get("productId")