class Cart extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId } = options

    @storage = new Storage("cart")
    @storage.on "update", @_loadFromStorage

    @getShippingUrl()

    @on "reset update change", @_dumpToStorage

  model: Product

  save: ->
    Backbone.sync("create", this, timeout: 10 * 1000)

  url: ->
    "#{App.apiUrl}/shops/#{@shopId}/carts"

  shippingUrl: ->
    "#{App.apiUrl}/shops/#{@shopId}/categories"

  toJSON: ->
    lineItems = @map (model) -> model.toJSON()
    lineItems: lineItems

  getShippingUrl: ->
    $.getJSON @shippingUrl()
      .done (response) =>
        @shippingUrl = response[0].sfUrl + "/Shipping"


  lineItemsSubTotal: ->
    sum = (sum, model) -> sum + model.totalPrice()
    "#{ @reduce(sum, 0).toFixed(2) } €"

  loadFromStorage: ->
    data = @storage.get("cart")
    @reset(data) if data

  _loadFromStorage: (event) =>
    if event.key is @storage.key("cart")
      @loadFromStorage()

  _dumpToStorage: =>
    @storage.set "cart", @map (product) -> product.attributes
