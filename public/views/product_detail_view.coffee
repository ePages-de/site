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

        <table class="epages-shop-overlay-table">
          <tr>
            <th>Price:</th>
            <td>
              <div class="epages-shop-overlay-product-price"><%= price%></div>
              <div class="epages-shop-overlay-product-shipping">
                Price includes VAT, plus <a href="#">Shipping</a>.
              </div>
            </td>
          </tr>
          <tr>
            <td></td>
            <td>
              <div
                class="epages-shop-overlay-product-availability-<%= availability %>">
                <%= availabilityText %>
              </div>
            </td>
          </tr>
          <tr>
            <td colspan=2>
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
        color: #444;
      }
      .epages-shop-overlay h1,
      .epages-shop-overlay h2,
      .epages-shop-overlay h3 {
        color: #333;
      }
      .epages-shop-overlay h3 {
        margin: 0;
      }
      .epages-shop-overlay-box {
        float: left;
        min-width: 400px;
        max-width: 490px;
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
        width: 100%;
      }
      .epages-shop-overlay-table {
        width: 100%;
      }
      .epages-shop-overlay-buy-button[disabled=disabled],
      .epages-shop-overlay-buy-button:disabled {
        color: #ddd;
      }
      .epages-shop-overlay-table th,
      .epages-shop-overlay-table td {
        vertical-align: baseline;
        padding: 2px;
      }
      .epages-shop-overlay-table th {
        font-weight: normal;
        padding-right: 0.5em;
        text-align: left;
        color: #777;
        white-space: no-break;
        width: 1%;
      }
      .epages-shop-overlay-hr {
        border-width: 1px 0 0 0;
        border-color: #ccc;
        border-style: solid;
        margin: 1em 0;
      }
      .epages-shop-overlay p {
        margin-top: 3px;
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
    event.target.disabled = true # disable button

    addLineItem = =>
      App.cart.addLineItem @model.id()

    if App.cart.isNew()
      App.cart.save().done(addLineItem)
    else
      addLineItem()

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
