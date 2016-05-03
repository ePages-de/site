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

  taxType: ->
    if @get("priceInfo")
      @get("priceInfo").price.taxType

  totalPrice: ->
    @quantity() * @price()

  productFormattedPrice: (selector) ->
    @get("variationPrice") || @loadLowestPrice(selector) || @formattedPrice()

  shippingUrl: ->
    if @collection
      @collection.shippingUrl
    else
      shopId = @link().match("shops/(.*)/product").slice(-1)[0]
      $.getJSON "#{App.apiUrl}/shops/#{shopId}/categories"
        .done (response) =>
          response[0].sfUrl + "/Shipping"

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

  productImage: ->
    @get("variationImage") || @largeImage()

  link: ->
    _.findWhere(@get("links"), rel: "self").href

  customAttributesLink: ->
    if _.findWhere(@get("links"), rel: "custom-attributes")
      _.findWhere(@get("links"), rel: "custom-attributes").href

  slideshowLink: ->
    if _.findWhere(@get("links"), rel: "slideshow")
      _.findWhere(@get("links"), rel: "slideshow").href

  lowestPriceLink: ->
    if _.findWhere(@get("links"), rel: "lowest-price")
      _.findWhere(@get("links"), rel: "lowest-price").href

  toJSON: ->
    productId: @id()
    quantity: @quantity()

  variationJSON: ->
    @loadCustomAttributes()
    @loadSlideshow()

    name: @name()
    productId: @id()
    variationPrice: @formattedPrice()
    quantity: @quantity()
    shortDescription: @shortDescription()
    variationImage: @largeImage()
    disabled: @isAvailable()

  loadVariations: =>
    if @variationItems() then return
    $.getJSON "#{@url()}/variations"
      .done (json) =>
        @set("variationAttributes", new VariationAttributes json.variationAttributes)
        @set("variationItems", new VariationItems json.items)

  loadCustomAttributes: =>
    if url = @customAttributesLink()
      $.getJSON url
        .done (json) =>
          @displayCustomAttributes(json.items)


  loadSlideshow: =>
    if url = @slideshowLink()
      $.getJSON url
        .done (json) =>
          $(".epages-shop-overlay-slideshow").empty()
          json.items.map (image) ->
            slide_image = _.findWhere(image.sizes, classifier: "Small").url
            ref_image = _.findWhere(image.sizes, classifier: "Large").url
            if slide_image && ref_image
              $(".epages-shop-overlay-slideshow").append("<li class=\"slideshow-image\"><img src=\"#{slide_image}\" data-image=\"#{ref_image}\"></li>")

  loadLowestPrice: (selector) =>
    if url = @lowestPriceLink()
      $.getJSON url
        .done (product) =>
          selector = if selector == "card"
          then ".epages-shop-product-link[href*='#{@id()}'] .epages-shop-product-price"
          else ".epages-shop-overlay-product-price span"
          $(selector).html(product.priceInfo.price.formatted)
    return undefined

  displayCustomAttributes: (items) ->
    displayTitle = false
    value = ""
    items.map (item) ->
      if typeof(item.values[0]) == "undefined"
        return
      if item.values[0].displayValue != ""
        displayTitle = true
        value += "<tr><th>#{item.displayKey}</th><td>"

        if item.type == 'string' && item.singleValue == false
          value += "<ul>"
          item.values.map (val) ->
            value += "<li>#{val.displayValue}</li>"
          value += "</ul>"
        else if item.type == 'url'
          value += "<a href='#{item.values[0].displayValue}' target='Download'>Download</a>"
        else
          value += "#{item.values[0].displayValue}"
        value += "</td></tr>"

    if displayTitle
      $(".epages-shop-overlay-custom-attributes h4").remove()
      $(".epages-shop-overlay-custom-attributes-table").before('<h4>Additional product information</h4>')

    $(".epages-shop-overlay-custom-attributes-table").html(value)
