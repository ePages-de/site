class Product extends Backbone.Model

  url: ->
    url = new URL(@collection.url())
    url = url.href.substr(0, url.href.indexOf("?")) # remove query string
    "#{url}/#{@id()}"

  id: ->
    @get("productId")

  name: ->
    @get("name")

  price: ->
    @get("priceInfo").price.formatted

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
        @get("variationAttributes").on "change", @updateProduct
        @set("variationItems", new VariationItems json.items)

  updateVariations: (variations) ->
    @variations = variations

  updateProduct: ->
    console.log @models.map (variation) ->
      variation.get("selected")
