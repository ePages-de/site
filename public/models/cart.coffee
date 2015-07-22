class Cart extends Backbone.Model

  initialize: (attributes, options) ->
    { @shopId } = options

    @lineItems = new CartLineItems [], cart: this

    @storage = new Storage("cart")
    @storage.on "update", @_loadFromStorage
    @on "update", @_dumpToStorage

  idAttribute: "cartId"

  url: ->
    url = "#{App.apiUrl}/shops/#{@shopId}/carts"
    unless @isNew()
      url += "/#{@id}"
    url

  lineItemsSubTotal: ->
    container = @get("lineItemContainer")
    return unless container

    container.lineItemsSubTotal.formatted

  update: (data) ->
    @clear()
    @set(data)
    @trigger("update")

  addLineItem: (productId) ->
    @lineItems.create {
      productId: productId
      quantity: 1
    },
    wait: true
    success: (model, response) =>
      @update(response)
      App.modal.close() # TODO: move this to the view

  changeQuantity: (lineItem, quantity) ->
    lineItem.save { quantity: quantity },
      success: (model, response) =>
        @update(response)

  removeLineItem: (lineItem) ->
    lineItem.destroy
      success: (model, response) =>
        @update(response)

  _loadFromStorage: (event) =>
    switch event.key
      when @storage.key("cart")
        @clear() and @set @storage.get("cart")
        @trigger "refresh"
      when @storage.key("lineItems")
        @lineItems.reset @storage.get("lineItems")
        @trigger "refresh"

  _dumpToStorage: =>
    @storage.set "cart", @attributes
    @storage.set "lineItems", @lineItems.map (item) -> item.attributes
