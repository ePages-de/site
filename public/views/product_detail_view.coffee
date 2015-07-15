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
      </div>
      <div class="epages-shop-overlay-box">
        <h2><%= name %></h2>
        <div class="epages-shop-overlay-product-availability-<%= availability %>">
          <%= availabilityText %>
        </div>
        <div class="epages-shop-overlay-product-price"><%= price %></div>
        <div class="epages-shop-overlay-product-shipping">
          Price includes VAT, plus <a href="#">Shipping</a>.
        </div>
        <div id="variations"></div>
        <button class="epages-shop-overlay-buy-button" <%= disabled %>>Add to basket</button>
        <p><%= description %></p>
      </div>
    </div>

    <style type="text/css">
      .epages-shop-overlay-box {
        float: left;
        width: 500px;
      }
      .epages-shop-overlay-product-availability-OnStock { color: green; }
      .epages-shop-overlay-product-availability-WarnStock { color: orange; }
      .epages-shop-overlay-product-availability-OutStock { color: red; }
      .epages-shop-overlay-product-price {
        font-weight: bold;
        font-size: 135%;
      }
      .epages-shop-variation label {
        min-width: 50px;
        display: inline-block;
      }
      .epages-shop-overlay-buy-button {
        margin: 10px auto;
      }
    </style>
  """

  render: ->
    @$el.html @template
      name: @model.name()
      id: @model.id()
      image: @model.mediumImage()
      description: @model.description()
      availability: @model.availability()
      availabilityText: @model.availabilityText()
      price: @model.price()
      shopId: "TODO" # TODO
      disabled: "disabled" if !@model.isAvailable()

    @$el.find("#variations").html(
      new VariationAttributeListView(
        collection: @model.variationAttributes()
      ).render().el)

    this

  addLineItem: (event) ->
    event.preventDefault()
    App.cart.addLineItem @model.id()

  updateVariations: =>
    matchingVariationItem = @model.variationItems().find (item) =>
      _.all item.attributeSelection(), (selection) =>
        @model.variationAttributes().some (attribute) ->
          attribute.name() == selection.name &&
          attribute.selected() == selection.value

    if matchingVariationItem
      p = new Product(url: matchingVariationItem.link().href)
      p.fetch
        success: (newModel) =>
          @model.set(newModel.toJSON())
          @render()

