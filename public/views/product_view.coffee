class ProductView extends Backbone.View

  initialize: (options) ->
    { @cart } = options

  className: "epages-shop-product"

  events:
    "click .epages-shop-product-link": "openProductDetails"

  template: _.template """
    <a href="<%= link %>" class="epages-shop-product-link">
      <img src="<%= image %>"/>
      <div class="epages-shop-product-name"><%= name %></div>
      <div class="epages-shop-product-price" style="font-weight: bold">
        <%= price %>
      </div>
    </a>

    <style type="text/css">
      .epages-shop-widget .epages-shop-product {
        float: left;
        width: 100px;
        margin: 10px;
        height: 200px;
      }
    </style>
  """

  render: ->
    @$el.html @template
      image: @model.smallImage()
      name:  @model.name()
      price: @model.price()
      link:  @model.link()

    this

  openProductDetails: (event) ->
    event.preventDefault()

    productDetailView = new ProductDetailView(model: @model)
    @model.loadVariations()
    productDetailView.render()

    App.modal.open(productDetailView)
