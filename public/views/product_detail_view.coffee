class ProductDetailView extends Backbone.View

  events:
    "change select": "updateVariations"
    "click .epages-shop-overlay-buy-button": "addLineItem"

  initialize: =>
    @listenTo @model, "change", @render

  template: _.template """
    <div class="epages-shop-overlay">
      <div class="epages-shop-overlay-box">
        <img class="epages-shop-overlay-product-image" src="<%= image %>" />
        <ul class="epages-shop-overlay-slideshow"></ul>
      </div>
      <div class="epages-shop-overlay-box">
        <h2><%= name %></h2>
        <div class="epages-shop-overlay-product-details">
          <% if (manufacturerPrice) { %>
            <div class="epages-shop-overlay-manufacturer-price">
              <span style="text-decoration: line-through;"><%= manufacturerPrice %></span>
            </div>
          <% } %>
          <div class="epages-shop-overlay-product-price">
             <span><%= price %></span>
          </div>
          <% if (basePrice) { %>
            <div class="epages-shop-overlay-base-price">
              <span><%= basePrice %></span>
            </div>
          <% } %>
          <div class="epages-shop-overlay-product-shipping">
            <span>Price includes VAT, plus <a href="<%= shippingUrl %>" target="_blank">Shipping</a>.</span>
          </div>
          <div class="epages-shop-overlay-product-availability-<%= availability %>">
            <%= availabilityText %>
          </div>
          <div class="epages-shop-overlay-product-variations"></div>
          <button class="epages-shop-overlay-buy-button" <%= disabled %>>Add to basket</button>
        </div>
        <% if (description) { %>
          <hr class="epages-shop-overlay-hr"/>
          <div class="epages-shop-overlay-product-description">
            <h3>Description</h3>
            <div class="epages-product-description">
              <%= description %>
            </div>
          </div>
        <% } %>
        <table class="epages-shop-overlay-custom-attributes"></table>
      </div>
    </div>
  """
  $(".slideshow-image img").live 'click', ->
    url = $(this).data("image")
    $(".epages-shop-overlay-product-image").css("opacity", "0")
    setTimeout (-> $(".epages-shop-overlay-product-image").prop('src', url).css("opacity", "1") ), 600

  render: ->
    @model.loadCustomAttributes()
    @model.loadSlideshow()
    @$el.html @template
      name: @model.name()
      id: @model.id()
      image: @model.mediumImage()
      description: @model.shortDescription()
      availability: @model.availability()
      availabilityText: @model.availabilityText()
      manufacturerPrice: @model.manufacturerPrice()
      basePrice: @model.basePrice()
      price: @model.formattedPrice()
      disabled: @model.isAvailable()
      shippingUrl: @model.shippingUrl()

    new VariationAttributeListView(
      collection: @model.variationAttributes()
      el: @$el.find(".epages-shop-overlay-product-variations")
    ).render()

    this

  addLineItem: (event) ->
    event.preventDefault()
    event.target.disabled = true # disable button

    App.cart.add(@model.clone())
    App.modal.close()

  updateVariations: =>
    matchingVariationItem = @model.variationItems().find (item) =>
      _.all item.attributeSelection(), (selection) =>
        @model.variationAttributes().some (attribute) ->
          attribute.name() is selection.name and
          attribute.selected() is selection.value

    if matchingVariationItem
      new Product(url: matchingVariationItem.link().href)
        .fetch success: (newModel) =>
          @model.set newModel.toJSON()
          @render()