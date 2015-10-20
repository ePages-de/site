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

  shortDescription: ->
    @get("shortDescription")

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

  manufacturerPrice: ->
    if @get("priceInfo").manufacturerPrice
      @get("priceInfo").manufacturerPrice.formatted

  basePrice: ->
    if @get("priceInfo").basePrice
      @get("priceInfo").basePrice.formatted

  totalPrice: ->
    @quantity() * @price()

  formattedTotalPrice: ->
    "#{ @totalPrice().toFixed(2) } €"

  shippingUrl: ->
    @collection.shippingUrl

  isAvailable: ->
    $.getJSON @url()
      .done (response) =>
        if response.forSale && response.availability != "OutStock"
          $(".epages-shop-overlay-buy-button").prop('disabled', false)

    return "disabled"

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

  customAttributesLink: ->
    if _.findWhere(@get("links"), rel: "custom-attributes")
      _.findWhere(@get("links"), rel: "custom-attributes").href

  slideshowLink: ->
    if _.findWhere(@get("links"), rel: "slideshow")
      _.findWhere(@get("links"), rel: "slideshow").href

  toJSON: ->
    @loadCustomAttributes()
    productId: @id()
    quantity: @quantity()
    shortDescription: @shortDescription()

  loadVariations: =>
    $.getJSON "#{@url()}/variations"
      .done (json) =>
        @set("variationAttributes", new VariationAttributes json.variationAttributes)
        @set("variationItems", new VariationItems json.items)

  loadCustomAttributes: =>
    if url = @customAttributesLink()
      $.getJSON url
        .done (json) =>
          if(json.items.length <= 2)
            return undefined
          $(".epages-shop-overlay-custom-attributes").html('<tr><td>Additional product information</td><td></td></tr>')
          json.items.slice(2).map (item) ->
            if item.values[0].displayValue != ""
              $(".epages-shop-overlay-custom-attributes").css("display", "initial") #if any object has a value the table is not displayed
              $(".epages-shop-overlay-custom-attributes").append("<tr><td>#{item.displayKey}</td><td>#{item.values[0].displayValue}</td></tr>")

  loadSlideshow: =>
    if url = @slideshowLink()
      $.getJSON url
        .done (json) =>
          $(".epages-shop-overlay-slideshow").empty()
          json.items.map (image) ->
            slide_image = _.findWhere(image.sizes, classifier: "Small").url
            ref_image = _.findWhere(image.sizes, classifier: "Medium").url
            if slide_image && ref_image
              $(".epages-shop-overlay-slideshow").append("<li class=\"slideshow-image\"><img src=\"#{slide_image}\" data-image=\"#{ref_image}\"></li>")

