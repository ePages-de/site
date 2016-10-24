class SingleProductView extends Backbone.View

  events:
    "change select": "updateVariations"
    "click .epages-shop-overlay-buy-button": "addLineItem"

  initialize: =>
    @listenTo @model, "change", @render

  template: _.template """
    <div class="epages-shop-overlay">
      <div class="epages-shop-overlay-box">
        <img class="epages-shop-overlay-product-image img-responsive" src="<%= image %>" />
        <ul class="epages-shop-overlay-slideshow"></ul>
      </div>
      <div class="epages-shop-overlay-box-1">
        <h2><%= name %></h2>
        <div class="epages-shop-overlay-product-details">
          <div class="epages-shop-overlay-product-price">
             <span><%= price %></span>
          </div>
          <% if (manufacturerPrice) { %>
            <div class="epages-shop-overlay-manufacturer-price">
          		<label data-i18n='manufacturer-price'></label>&nbsp;<span><%= manufacturerPrice %></span>
            </div>
          <% } %>
          <% if (basePrice) { %>
            <div class="epages-shop-overlay-base-price">
              <span><%= basePrice %></span>
            </div>
          <% } %>
          <div class="epages-shop-overlay-product-shipping">
            <span data-i18n="<% if (taxType == 'GROSS') { %>include-vat-price<% } else { %>exclude-vat-price<% } %>"></span>
            <a href="<%= shippingUrl %>" target="_blank" data-i18n='shipping'></a>
          </div>
          <div class="epages-shop-overlay-product-availability-<%= availability %>">
            <%= availabilityText %>
          </div>
          <div class="epages-shop-overlay-product-variations"></div>
          <button class="epages-shop-overlay-buy-button" data-i18n='basket-add' <%= disabled %> ></button>
        </div>
      </div>
      <div class="epages-shop-overlay-box-2">
        <% if (description) { %>
          <hr>
          <div class="epages-shop-overlay-product-description">
            <h3 data-i18n='description'></h3>
            <div class="epages-product-description">
              <%= description %>
            </div>
          </div>
        <% } %>
        <div class="epages-shop-overlay-custom-attributes">
          <table class="epages-shop-overlay-custom-attributes-table"></table>
        </div>
      </div>
    </div>
  """
  $(".slideshow-image img").live 'click', ->
    url = $(this).data("image")
    $(".epages-shop-overlay-product-image").css("opacity", "0")
    setTimeout (-> $(".epages-shop-overlay-product-image").prop('src', url).css("opacity", "1") ), 600

  render: ->
    _.once(@model.loadVariations(); @model.loadCustomAttributes(); @model.loadSlideshow())

    @$el.html @template
      name: @model.name()
      id: @model.id()
      image: @model.productImage()
      description: @model.shortDescription()
      availability: @model.availability()
      availabilityText: @model.availabilityText()
      manufacturerPrice: @model.manufacturerPrice()
      basePrice: @model.basePrice()
      price: @model.productFormattedPrice()
      disabled: @model.isAvailable()
      stockLevel: @model.stockLevel()
      shippingUrl: @model.shippingUrl()
      taxType: @model.taxType()
      variationsLink: @model.variationsLink()

    new VariationAttributeListView(
      collection: @model.variationAttributes()
      el: @$el.find(".epages-shop-overlay-product-variations")
    ).render()

    App.i18n(this)
    this

  insertAfter = (newNode, referenceNode) ->
    referenceNode.parentNode.insertBefore newNode, referenceNode.nextSibling

  restoreWarnings = ->
    setTimeout ->
      arr = [].slice.call(document.getElementsByClassName('tooltip'))
      tool = [].slice.call(document.getElementsByClassName('tooltiptext'))
      if arr.length > 0
        y = 0
        while y < arr.length
          arr[y].style.backgroundColor = '#f8f8f8'
          y++
      if tool.length > 0
        x = 0
        while x < arr.length
          tool[x].parentNode.removeChild(tool[x])
          x++
    , 5000

  addLineItem: (event) ->
    event.preventDefault()
    if !@model.attributes.priceInfo.price?
      return false
    event.target.disabled = true # disable button
    selected_value = true
    arr = [].slice.call(document.getElementsByClassName('tooltip'))
    if arr.length > 0
      i = 0
      while i < arr.length
        if arr[i].value == ''
          selected_value = false
          tooltipText = document.createElement("span")
          tooltipText.setAttribute("class", "tooltiptext")
          if localStorage.getItem('epages-shop-lang') == 'en'
            tooltipText.innerText = 'Please select a version.'
          else
            tooltipText.innerText = 'Bitte wählen Sie eine Ausführung.'
          insertAfter(tooltipText, arr[i])
          arr[i].style.backgroundColor = '#fdd'
        i++
    restoreWarnings()
    if selected_value == true
      isNew = true
      if App.cart.length > 0
        for model in App.cart.models
          if @model.attributes.productId == model.attributes.productId
            isNew = false
      if isNew
        App.cart.add(@model.clone())
      else
        for model in App.cart.models
          if @model.attributes.productId == model.attributes.productId
            model.attributes.quantity += 1
      App.cart.sync()
    event.target.disabled = false

  updateVariations: =>
    matchingVariationItem = @model.variationItems().find (item) =>
      _.all item.attributeSelection(), (selection) =>
        @model.variationAttributes().some (attribute) ->
          attribute.name() is selection.name and
            attribute.selected() is selection.value

    if matchingVariationItem
      new Product(url: matchingVariationItem.link().href)
      .fetch success: (newModel) =>
        @model.set newModel.variationJSON()
        @render()