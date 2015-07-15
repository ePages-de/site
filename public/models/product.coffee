class Product extends Backbone.Model

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
      @get("url")

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

  variationItems: ->
    @get("variationItems")

  price: ->
    @get("priceInfo").price.formatted

  isAvailable: ->
    @get("forSale") && @get("availability") != "OutStock"

  smallImage: ->
    _.findWhere(@get("images"), classifier: "Small").url

  mediumImage: ->
    _.findWhere(@get("images"), classifier: "Medium").url

  largeImage: ->
    _.findWhere(@get("images"), classifier: "Large").url

  link: ->
    _.findWhere(@get("links"), rel: "self").href

  loadVariations: =>
    $.getJSON "#{@url()}/variations"
      .done (json) =>
        @set("variationAttributes", new VariationAttributes json.variationAttributes)
        @set("variationItems", new VariationItems json.items)
