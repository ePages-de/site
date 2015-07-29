class Cart extends Backbone.Collection

  initialize: (models, options) ->
    { @shopId } = options

    @storage = new Storage("cart")
    @storage.on "update", @_loadFromStorage

    @on "reset update change", @_dumpToStorage

  model: Product

  save: ->
    timeout = 10 # seconds
    Backbone.sync("create", this, timeout: timeout * 1000)

  url: ->
    "#{App.apiUrl}/shops/#{@shopId}/carts"

  toJSON: ->
    lineItems = @map (model) -> model.toJSON()
    lineItems: lineItems

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
