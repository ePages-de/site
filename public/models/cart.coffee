class Cart extends Backbone.Model

  initialize: (attributes, options) ->
    { @shopId } = options

  idAttribute: "cartId"

  url: ->
    "https://developer.epages.com/api/shops/#{@shopId}/carts"

  count: ->
    if @lineItems then @lineItems.length else 0

  isEmpty: ->
    @count() <= 0

  update: (data) ->
    console.log "TODO: UPDATE CART WITH:"
    console.log data

  addProduct: (productId) ->
    if @isNew()
      @save().done => @_addProduct(productId)
    else
      @_addProduct(productId)

  _addProduct: (productId) ->
    @_createLineItems() unless @lineItems

    attributes =
      productId: productId
      quantity: 1

    @lineItems.create attributes,
      wait: true
      success: (response) =>
        @update(response)
        App.closeModal()

  _createLineItems: ->
    @lineItems = new CartLineItems [],
      shopId: @shopId
      cartId: @id
    @listenTo @lineItems, "update", => @trigger "update"
