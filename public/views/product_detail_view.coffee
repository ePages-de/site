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

        <hr class="epages-shop-overlay-hr" />
        <table class="epages-shop-overlay-table">
          <tr>
            <th>Price</th>
            <td>
              <span class="epages-shop-overlay-product-price"><%= price%></span>
              <span class="epages-shop-overlay-product-shipping">
                Price includes VAT, plus <a href="#">Shipping</a>.
              </span>
            </td>
          </tr>
          <tr>
          <td></td>
            <td>
              <div
                class="epages-shop-overlay-product-availability-<%= availability %>">
                <%= availabilityText %>
              </div>
              <button
                class="epages-shop-overlay-buy-button"
                <%= disabled %>>Add to basket</button>
            </td>
          </tr>
        </table>

        <hr class="epages-shop-overlay-hr" />
        <h3>Description</h3>
        <p><%= description %></p>
      </div>

    </div>

    <style type="text/css">
      .epages-shop-overlay {
        color: #333;
      }
      .epages-shop-overlay h1, .epages-shop-overlay h2, .epages-shop-overlay h3 {
        margin: 0;
      }
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
      .epages-shop-overlay-product-shipping {
        font-size: 80%;
      }
      .epages-shop-overlay-buy-button {
        margin: 10px auto;
      }
      .epages-shop-overlay-table th, .epages-shop-overlay-table td {
        vertical-align: baseline;
      }
      .epages-shop-overlay-table th {
        font-weight: normal;
        padding-right: 0.5em;
        text-align: right;
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

    new VariationAttributeListView(
      collection: @model.variationAttributes()
      el: @$el.find("table.epages-shop-overlay-table")
    ).render()

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

