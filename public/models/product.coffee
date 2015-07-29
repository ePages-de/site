class Product extends Backbone.Model

  defaults:
    quantity: 1

  variationAttributes: =>
    if @get("variationAttributes") == undefined
      @set("variationAttributes", new VariationAttributes)
    @get("variationAttributes")

  url: ->
    if @collection
      url = new URL(@collection.url())
      url = url.href.substr(0, url.href.indexOf("?")) # remove query string
      "#{url}/#{@id()}"
    else
      # override url to use proxy when neccessary
      url = new URL(@get("url"))
      apiUrl = new URL(App.apiUrl)

      url.host = apiUrl.host
      url.protocol = apiUrl.protocol
      url.toString()

  id: ->
    @get("productId")

  description: ->
    @get("description")

  availability: ->
    @get("availability")

  availabilityText: ->
    @get("availabilityText") || "Please choose your option(s)"

  name: ->
    @get("name")

  quantity: ->
    @get("quantity")

  unit: ->
    @get("priceInfo").quantity.unit

  variationItems: ->
    @get("variationItems")

  price: ->
    @get("priceInfo").price.amount

  formattedPrice: ->
    @get("priceInfo").price.formatted

  totalPrice: ->
    @quantity() * @price()

  formattedTotalPrice: ->
    "#{ @totalPrice().toFixed(2) } €"

  isAvailable: ->
    @get("forSale") && @get("availability") != "OutStock"

  thumbnailImage: ->
    _.findWhere(@get("images"), classifier: "Thumbnail").url

  smallImage: ->
    _.findWhere(@get("images"), classifier: "Small").url

  mediumImage: ->
    _.findWhere(@get("images"), classifier: "Medium").url

  largeImage: ->
    _.findWhere(@get("images"), classifier: "Large").url

  link: ->
    _.findWhere(@get("links"), rel: "self").href

  toJSON: ->
    productId: @id()
    quantity: @get("quantity")

  loadVariations: =>
    $.getJSON "#{@url()}/variations"
      .done (json) =>
        @set("variationAttributes", new VariationAttributes json.variationAttributes)
        @set("variationItems", new VariationItems json.items)
