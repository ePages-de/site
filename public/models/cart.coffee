class Cart extends Backbone.Model

  initialize: (attributes, options) ->
    { @shopId } = options

  idAttribute: "cartId"

  url: ->
    "#{App.rootUrl}/shops/#{@shopId}/carts"

  count: ->
    if @lineItems then @lineItems.length else 0

  isEmpty: ->
    @count() <= 0

  update: (data) ->
    @set("grandTotal", data.lineItemContainer.grandTotal)

  addLineItem: (productId) ->
    if @isNew()
      @save().done => @addLineItem(productId)
    else
      @_addLineItem(productId)

  changeQuantity: (lineItem, quantity) ->
    lineItem.save { quantity: quantity },
      success: (model, response) =>
        @update(response)

  removeLineItem: (lineItem) ->
    lineItem.destroy
      success: (model, response) =>
        @update(response)


  _addLineItem: (productId) ->
    @_createLineItems() unless @lineItems

    attributes =
      productId: productId
      quantity: 1

    @lineItems.create attributes,
      wait: true
      success: (model, response) =>
        @update(response)
        App.closeModal()

  _createLineItems: ->
    @lineItems = new CartLineItems [],
      shopId: @shopId
      cartId: @id
    @lineItems.on "all", (event) => @trigger event
